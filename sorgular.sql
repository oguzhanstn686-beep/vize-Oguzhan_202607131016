-- Ödev 2, Bölüm 1: Filo soruları
-- Ad Soyad:Oğuzhan Üstün
-- Veritabanı: robot_fleet
-- Her sorgunun altına sonucu açıklayan tek cümlelik yorum yaz.

-- Soru 1: Her robotun adı, operatör adı ve operatörün telefonu (INNER JOIN)
SELECT r.name, o.operator_name, o.phone
FROM robots r
INNER JOIN operators o ON o.operator_name = r.operator_name
ORDER BY r.id;
-- Yorum: 9 satır döndü, çünkü Mars-03'ün operatörü NULL olduğu için hiçbir operatörle eşleşmedi ve sonuçtan çıktı.


-- Soru 2: Aynı liste, bütün robotlar görünsün (LEFT JOIN). 1. sorguyla karşılaştır, kim kayboldu?
SELECT r.name, o.operator_name, o.phone
FROM robots r
LEFT JOIN operators o ON o.operator_name = r.operator_name
ORDER BY r.id;
-- Yorum: 10 satır döndü, 1. sorguda kaybolan Mars-03 artık operatör adı ve telefonu NULL olarak görünüyor.


-- Soru 3: Hiç görev almamış robotların adı ve modeli
SELECT r.name, r.model
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
WHERE m.id IS NULL
ORDER BY r.id;
-- Yorum: 4 satır döndü (Kartal-02, Atlas-03, Mars-03, Kartal-04), çünkü bu robotların missions tablosunda eşleşen kaydı yok.


-- Soru 4a: JOIN ile hesaplanan toplam batarya (görevi olan robotlar)
SELECT SUM(r.battery_level) AS toplam_batarya_join
FROM robots r
INNER JOIN missions m ON m.robot_id = r.id;

-- Soru 4b: JOIN kullanmadan doğru toplam
SELECT SUM(battery_level) AS toplam_batarya_dogru
FROM robots
WHERE id IN (SELECT robot_id FROM missions);
-- Yorum (iki sonuç ve fark): JOIN'li sorgu 700, doğru sorgu 262 verdi (fark 438), çünkü JOIN sonrası her robot görev sayısı kadar satıra çoğalıyor (örneğin Atlas-01'in 82'si 3 kez toplandı) ve toplam 6 robot yerine 14 görev satırı üzerinden hesaplandı (fan-out).


-- Soru 5: Robot başına görev sayısı; count(*) ve count(m.id) yan yana
SELECT r.name,
       COUNT(*)    AS count_yildiz,
       COUNT(m.id) AS gorev_sayisi
FROM robots r
LEFT JOIN missions m ON m.robot_id = r.id
GROUP BY r.id, r.name
ORDER BY r.id;
-- Yorum (hangi robotlarda ikisi farklı?): Kartal-02, Atlas-03, Mars-03 ve Kartal-04'te count(*) 1, count(m.id) 0 çıktı, çünkü LEFT JOIN görevsiz robota NULL'lı tek bir satır ekliyor ve count(*) o satırı sayarken count(m.id) NULL'ı saymıyor.
