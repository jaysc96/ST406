SELECT YEAR_ID, BAT_ID,
		(sum(AB)*(sum(H)+sum(BB)+sum(HBP))+sum(TB)*(sum(AB)+sum(BB)+sum(SF)+sum(HBP)))/(sum(AB)*(sum(AB)+sum(BB)+sum(SF)+sum(HBP))) as OPS,
        VARIANCE((AB*(H+BB+HBP)+TB*(AB+BB+SF+HBP))/(AB*(AB+BB+SF+HBP))) as OPS_VAR,
        sum(AB) as AT_BATS
FROM (SELECT YEAR_ID,
        BAT_ID,
        sum(case when AB_FL = 'T' then 1 else 0 end) as AB,
        sum(case when H_CD > 0 then 1 else 0 end) as H,
        sum(case when EVENT_CD = 16 then 1 else 0 end) as HBP,
        sum(case when SF_FL = 'T' then 1 else 0 end) as SF,
        sum(case when EVENT_CD = 14 then 1 else 0 end) as BB,
        sum(H_CD) as TB
FROM retrosheet.events
WHERE YEAR_ID = 2016 # <-- Select Year 
group by BAT_ID, GAME_ID
having AB > 0) year_query
group by BAT_ID
having AT_BATS > 200
order by BAT_ID;

