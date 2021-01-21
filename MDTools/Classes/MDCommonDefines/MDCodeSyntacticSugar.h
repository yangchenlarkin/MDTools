//
//  MDCodeSyntacticSugar.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/10.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#ifndef MDCodeSyntacticSugar_h
#define MDCodeSyntacticSugar_h

#define elif else if

#define ifValueInCloseRange(min, v, max) if(MDValueInCloseRange(min, v, max))
#define ifValueInOpenRange(min, v, max) if(MDValueInOpenRange(min, v, max))
#define ifValueInLCRORange(min, v, max) if(MDValueInLCRORange(min, v, max))
#define ifValueInLORCRange(min, v, max) if(MDValueInLORCRange(min, v, max))

#define ifNotValueInCloseRange(min, v, max) if(!MDValueInCloseRange(min, v, max))
#define ifNotValueInOpenRange(min, v, max) if(!MDValueInOpenRange(min, v, max))
#define ifNotValueInLCRORange(min, v, max) if(!MDValueInLCRORange(min, v, max))
#define ifNotValueInLORCRange(min, v, max) if(!MDValueInLORCRange(min, v, max))


#define elifValueInCloseRange(min, v, max) else if(MDValueInCloseRange(min, v, max))
#define elifValueInOpenRange(min, v, max) else if(MDValueInOpenRange(min, v, max))
#define elifValueInLCRORange(min, v, max) else if(MDValueInLCRORange(min, v, max))
#define elifValueInLORCRange(min, v, max) else if(MDValueInLORCRange(min, v, max))

#define elifNotValueInCloseRange(min, v, max) else if(!MDValueInCloseRange(min, v, max))
#define elifNotValueInOpenRange(min, v, max) else if(!MDValueInOpenRange(min, v, max))
#define elifNotValueInLCRORange(min, v, max) else if(!MDValueInLCRORange(min, v, max))
#define elifNotValueInLORCRange(min, v, max) else if(!MDValueInLORCRange(min, v, max))


#define whileValueInCloseRange(min, v, max) while(MDValueInCloseRange(min, v, max))
#define whileValueInOpenRange(min, v, max) while(MDValueInOpenRange(min, v, max))
#define whileValueInLCRORange(min, v, max) while(MDValueInLCRORange(min, v, max))
#define whileValueInLORCRange(min, v, max) while(MDValueInLORCRange(min, v, max))

#define whileNotValueInCloseRange(min, v, max) while(!MDValueInCloseRange(min, v, max))
#define whileNotValueInOpenRange(min, v, max) while(!MDValueInOpenRange(min, v, max))
#define whileNotValueInLCRORange(min, v, max) while(!MDValueInLCRORange(min, v, max))
#define whileNotValueInLORCRange(min, v, max) while(!MDValueInLORCRange(min, v, max))

#define MDLogMethod NSLog(@"%s",__FUNCTION__)

#endif /* MDCodeSyntacticSugar_h */
