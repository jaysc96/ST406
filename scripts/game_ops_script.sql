SELECT YEAR_ID, GAME_ID, BAT_ID,
	AB*((H+BB+HBP)+TB*(AB+BB+SF+HBP))/(AB*(AB+BB+SF+HBP)) as OPS,
        H as HITS,
        AB as AT_BATS,
        BB as WALKS,
        HBP as HIT_BY_PITCH,
        SF as SACRIFICE_FLYS
FROM (SELECT YEAR_ID, 
		GAME_ID,
        BAT_ID,
        sum(case when AB_FL = 'T' then 1 else 0 end) as AB,
        sum(case when H_CD > 0 then 1 else 0 end) as H,
        sum(case when EVENT_CD = 16 then 1 else 0 end) as HBP,
        sum(case when SH_FL = 'T' then 1 else 0 end) as SF,
        sum(case when EVENT_CD = 14 then 1 else 0 end) as BB,
        sum(H_CD) as TB
FROM retrosheet.events
WHERE YEAR_ID = 2016 # <-- Select Year 
group by GAME_ID, BAT_ID) game_query
having AT_BATS > 0
order by BAT_ID;
