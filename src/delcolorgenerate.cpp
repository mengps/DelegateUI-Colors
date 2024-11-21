#include "delcolorgenerate.h"
#include <qdebug.h>

static const auto g_hueStep = 2; // 色相阶梯
static const auto g_saturationStep = 0.16; // 饱和度阶梯，浅色部分
static const auto g_saturationStep2 = 0.05; // 饱和度阶梯，深色部分
static const auto g_brightnessStep1 = 0.05; // 亮度阶梯，浅色部分
static const auto g_brightnessStep2 = 0.15; // 亮度阶梯，深色部分
static const auto g_lightColorCount = 5; // 浅色数量，主色上
static const auto g_darkColorCount = 4; // 深色数量，主色下

static QColor mix(const QColor &rgb1, const QColor &rgb2, int amount)
{
    qreal p = qreal(amount) / 100.0;
    const QColor rgb = QColor::fromRgbF(
        (rgb2.redF() - rgb1.redF()) * p + rgb1.redF(),
        (rgb2.greenF() - rgb1.greenF()) * p + rgb1.greenF(),
        (rgb2.blueF() - rgb1.blueF()) * p + rgb1.blueF()
    );
    return rgb;
}

static qreal getHue(const QColor &hsv, int i, bool light = false)
{
    qreal hue;
    // 根据色相不同，色相转向不同
    if (std::round(hsv.hsvHue()) >= 60 && std::round(hsv.hsvHue()) <= 240) {
        hue = light ? hsv.hsvHue() - g_hueStep * i : hsv.hsvHue() + g_hueStep * i;
    } else {
        hue = light ? hsv.hsvHue() + g_hueStep * i : hsv.hsvHue() - g_hueStep * i;
    }

    if (hue < 0) {
        hue += 360;
    } else if (hue >= 360) {
        hue -= 360;
    }

    return hue;
}

static qreal getSaturation(const QColor &hsv, int i, bool light = false)
{
    // grey color don't change saturation
    if (hsv.hsvHue() == 0 && hsv.hsvSaturation() == 0) {
        return hsv.hsvSaturation();
    }

    qreal saturation;
    if (light) {
        saturation = hsv.hsvSaturationF() - g_saturationStep * i;
    } else if (i == g_darkColorCount) {
        saturation = hsv.hsvSaturationF() + g_saturationStep;
    } else {
        saturation = hsv.hsvSaturationF() + g_saturationStep2 * i;
    }
    // 边界值修正
    if (saturation > 1) {
        saturation = 1;
    }
    // 第一格的 s 限制在 0.06-0.1 之间
    if (light && i == g_lightColorCount && saturation > 0.1) {
        saturation = 0.1;
    }
    if (saturation < 0.06) {
        saturation = 0.06;
    }

    return saturation;
}

static qreal getValue(const QColor &hsv, int i, bool light = false)
{
    qreal value;
    if (light) {
        value = hsv.valueF() + g_brightnessStep1 * i;
    } else {
        value = hsv.valueF() - g_brightnessStep2 * i;
    }
    if (value > 1) {
        value = 1;
    }

    return value;
}

DelColorGenerator::DelColorGenerator(QObject *parent)
    : QObject{parent}
{

}

DelColorGenerator::~DelColorGenerator()
{

}

QList<QColor> DelColorGenerator::generate(const QColor &color, bool light, const QColor &background)
{
    QList<QColor> patterns;
    const auto hsv = color.toHsv();
    for (auto i = g_lightColorCount; i > 0; i -= 1) {
        const auto colorString = QColor::fromHsvF(getHue(hsv, i, true) / 360.0,
                                                  getSaturation(hsv, i, true),
                                                  getValue(hsv, i, true)).name();
        patterns.append(colorString);
    }
    patterns.append(color.name());

    for (auto i = 1; i <= g_darkColorCount; i += 1) {
        const auto colorString = QColor::fromHsvF(getHue(hsv, i) / 360.0,
                                                  getSaturation(hsv, i),
                                                  getValue(hsv, i)).name();
        patterns.append(colorString);
    }

    //dark theme patterns
    if (!light) {
        static const std::list<std::tuple<int, qreal>> g_darkColorMap = {
            std::make_tuple(7, 0.15),
            std::make_tuple(6, 0.25),
            std::make_tuple(5, 0.30),
            std::make_tuple(5, 0.45),
            std::make_tuple(5, 0.65),
            std::make_tuple(5, 0.85),
            std::make_tuple(4, 0.90),
            std::make_tuple(3, 0.95),
            std::make_tuple(2, 0.97),
            std::make_tuple(1, 0.98)
        };
        QList<QColor> darkColorString;
        std::for_each(g_darkColorMap.begin(), g_darkColorMap.end(), [&patterns, &darkColorString, background](const std::tuple<int, qreal> &value){
            darkColorString.append(mix(background.isValid() ? background : QColor(20, 20, 20),
                                       patterns[std::get<0>(value)],
                                       std::get<1>(value) * 100));
        });
        return darkColorString;
    }

    return patterns;
}
