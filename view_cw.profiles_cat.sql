CREATE VIEW cw.profiles_cat AS
    SELECT * from cw.profiles WHERE type = 4 and id != 7;

SELECT * from cw.profiles_cat;