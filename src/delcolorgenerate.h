#ifndef DELCOLORGENERATE_H
#define DELCOLORGENERATE_H

#include <QObject>
#include <QColor>

class DelColorGenerator : public QObject
{
    Q_OBJECT

public:
    DelColorGenerator(QObject *parent = nullptr);
    ~DelColorGenerator();

    Q_INVOKABLE static QList<QColor> generate(const QColor &color, bool light = true, const QColor &background = QColor(QColor::Invalid));
};


#endif // DELCOLORGENERATE_H
