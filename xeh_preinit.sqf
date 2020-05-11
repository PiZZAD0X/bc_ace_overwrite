//Inital resistance before counting toward death mutiply by damageThreshold
//0 being, 0 x damageThreshold (1). Counts toward death when 0 damage is reached
// 5 being, 5 x damageThreshold (1). 5 damage must be reach before counting toward death
ace_medical_const_headResistance = 0;
ace_medical_const_bodyResistance = .5;
ace_medical_const_armsResistance = 0;
ace_medical_const_legsResistance = 0;

//Mutipler applied before calculating the total sum damage till death
// 1 being no effect
// .5 being 50% counts less toward death
// 1.5 counting 50% more toward death
ace_medical_const_headVitalMutiplier = 1;
ace_medical_const_bodyVitalMutiplier = 1;
ace_medical_const_armsVitalMutiplier = .02;
ace_medical_const_legsVitalMutiplier = .02;
