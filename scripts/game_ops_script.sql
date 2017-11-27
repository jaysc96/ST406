SELECT YEAR_ID, GAME_DATE, BAT_ID,
		(AB*(H+BB+HBP)+TB*(AB+BB+SF+HBP))/(AB*(AB+BB+SF+HBP)) as OPS,
        H as HITS,
        AB as AT_BATS,
        BB as WALKS,
        HBP as HIT_BY_PITCH,
        SF as SACRIFICE_FLYS,
        SINGLES,
        DOUBLES,
        TRIPLES,
        HOME_RUNS,
        RBIS,
        STRIKEOUTS
FROM (SELECT 
      	YEAR_ID, 
		substring(GAME_ID,8,4) as GAME_DATE,
        BAT_ID,
        sum(case when AB_FL = 'T' then 1 else 0 end) as AB,
        sum(case when H_CD > 0 then 1 else 0 end) as H,
        sum(case when EVENT_CD = 16 then 1 else 0 end) as HBP,
        sum(case when SF_FL = 'T' then 1 else 0 end) as SF,
        sum(case when EVENT_CD = 14 then 1 else 0 end) as BB,
        sum(H_CD) as TB,
        sum(case when EVENT_CD = 20 then 1 else 0 end) as SINGLES,
        sum(case when EVENT_CD = 21 then 1 else 0 end) as DOUBLES,
        sum(case when EVENT_CD = 22 then 1 else 0 end) as TRIPLES,
        sum(case when EVENT_CD = 23 then 1 else 0 end) as HOME_RUNS,
        sum(RBI_CT) as RBIS,
        sum(case when BATTEDBALL_CD = 'F' then 1 else 0 end) as FLYBALLS,
        sum(case when BATTEDBALL_CD = 'L' then 1 else 0 end) as LINEDRIVES,
        sum(case when BATTEDBALL_CD = 'P' then 1 else 0 end) as POPUPS,
        sum(case when BATTEDBALL_CD = 'G' then 1 else 0 end) as GROUNDBALLS,
        sum(case when EVENT_CD = 3 then 1 else 0 end) as STRIKEOUTS
	FROM retrosheet.events
	WHERE YEAR_ID > 2012 AND YEAR_ID != 2016 # <-- Select Year 
	group by GAME_ID, BAT_ID) game_query
having AT_BATS > 0
order by YEAR_ID,BAT_ID;