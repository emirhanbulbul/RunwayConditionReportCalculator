# The Runway Condition Report Calculator

Havalimanı pist durum raporu oluşturma uygulaması.

## Tam Açıklama
RCR (The Runway Condition Report), gözlemlenen pist yüzeyi koşulundan/koşullarından ve frenleme eyleminin pilot raporundan ilgili prosedürler kullanılarak pist durum kodunun değerlendirilmesine izin veren bir uygulamadır.

Pist yüzey koşullarını raporlamak için havalimanı işletmecileri tarafından kullanılacak yöntem, uçakların kalkış ve iniş performansını, özellikle frenleme performansını etkileyen faktörleri açıkça tanımlar.

Raporlamayı oluşturmak için havalimanı işletmecilerinin işini kolaylaştıracak bu ücretsiz uygulamayı kullanabilirsiniz. Raporlama için istenen bilgileri uygulamaya girerek sonucu görebilirsiniz. Ayrıca eski sonuçlar uygulama içerisinde kaydedilir.

## Uygulama Özellikleri
- Eski sonuçları görebilme.
- Sonucu paylaşma
- Sonucu kopyalama
- RCR raporuna uymayan değer girilince uyarı verme


## Kullanılan Teknolojiler
- Flutter/Dart
- Hive Database

## Neden Hive Database Kullandım?
Hive veritabanı, saf dart dili yazılmış olan anahtar - değer tutan hafif bir veritabanıdır. Sqlite veritabanına göre daha hızlı çalışmaktadır. Bu projede ilişkisel bir veritabanı kullanmaya gerek olmadığı için nosql teknolojisine sahip hive veritabanını bu proje için daha uygun gördüm. 

## Uygulama Ekran Görüntüleri

![merge_from_ofoct (1)](https://user-images.githubusercontent.com/14194362/140512038-47cfc792-7919-4ec5-9cc9-37cdd66a04f8.jpg)

Google Play: https://play.google.com/store/apps/details?id=com.rcr.hesaplama
