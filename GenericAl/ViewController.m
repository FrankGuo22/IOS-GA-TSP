//
//  ViewC/Users/frankguo/Desktop/GenericAl/GenericAl.xcodeprojontroller.m
//  GenericAl
//
//  Created by Frank Guo on 4/11/15.
//  Copyright © 2015 Frank Guo. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
@interface ViewController ()

@end

@implementation ViewController
// parents for iteration
int parentsch[7000][100];
// children for iteration
int childrench[7000][100];
bool calculated;
int crossover;
// parameters from inputing field
NSMutableString *randomize;
int population;
int mutationrate;
int cityNumbers;
// check point
int hello=1;
float nowIsBest=10000000;
//over solution
int GenerationTotalTimes = 0;
int GenerationBestTimes = 0;
NSMutableArray *thisGeneration;
NSMutableArray *dataTran;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _NextButton.hidden =YES;
    _FastButton.hidden = YES;
    _End.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    // render the main page
    [self.view addGestureRecognizer:tap];
    
}

- (IBAction)End:(id)sender {
    // control the page, hide some components
    _Cross.hidden=NO;
    _Popula.hidden=NO;
    _Mutat.hidden=NO;
    _City.hidden=NO;
    _Random.hidden=NO;
    _NextButton.hidden = YES;
    _FastButton.hidden = YES;
    // reset the value of parameters
    hello=1;
    nowIsBest=10000000;
    GenerationTotalTimes=0;
    GenerationBestTimes=0;
}

- (IBAction)Start:(id)sender {
    // acquire data some user input
    NSMutableArray *sequence = [[NSMutableArray alloc] init];
    crossover = [[_Cross text] integerValue];
    mutationrate = [[_Mutat text] integerValue];
    population = [[_Popula text] integerValue];
    cityNumbers= [[_City text] integerValue];
    randomize = [_Random text];
    dataTran = [[NSMutableArray alloc] init];
    
    // generate random point on the board [0..259][0..369]
    for(int i=0; i< cityNumbers; i++){
        [dataTran addObject:[NSNumber numberWithInt:arc4random_uniform(260)]];
        [dataTran addObject:[NSNumber numberWithInt:arc4random_uniform(370)]];
    }
    
    // reder the initial route map
    for(int i=0; i< cityNumbers; i++){
        [sequence addObject:[NSNumber numberWithInt:i]];
    }
    // draw basic route
    DrawView *draw = [[DrawView alloc] initWithFrame:CGRectMake(30, 160, 260, 370) data:dataTran flow:sequence city: cityNumbers];
    draw.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:draw];
    
    
    // gain parameters from field
   
    if (population >7000)
        population = 7000;
    
    // initial sequence
    for (int i=0;i<7000;i++)
        for (int j=0;j<cityNumbers;j++)
        {
            parentsch[i][j]=j;
        }
    
    // the shuttle
    for (int k=0; k<7000;k++)
    {
        int i = 0;
        for(i=0;i<cityNumbers;i++)
        {
            int j =arc4random_uniform(cityNumbers);
            int q =parentsch[k][i];
            parentsch[k][i]=parentsch[k][j];
            parentsch[k][j]=q;
            
        }
    }
    
    // components management
    calculated = false;
    _NextButton.hidden = NO;
    _FastButton.hidden = NO;
    _End.hidden = NO;
    _Cross.hidden=YES;
    _Popula.hidden=YES;
    _Mutat.hidden=YES;
    _City.hidden=YES;
    _Random.hidden=YES;
}

- (IBAction)Next:(id)sender {
    //start to calculate the fitness of parents
    float fitness[7000];
    float minium = 1000000.0;
    int bestAns=0;
    int firstGe;
    if (calculated==false)
    {
        // this is the first generation
        calculated= true;
        firstGe = 7000;
        thisGeneration = [[NSMutableArray alloc] init];
    }
    else
    {
        // not the first iteration
        firstGe = population;
    }
    
    for (int k=0; k<firstGe;k++)
    {
        //calculate fitness value for each chromosome
        fitness[k]=0.0;
        for (int i=0;i<cityNumbers;i++)
        {
            fitness[k] += sqrtf(powf([[dataTran objectAtIndex:(parentsch[k][i]*2)] floatValue]-[[dataTran objectAtIndex:(parentsch[k][i+1]*2)] floatValue], 2)+powf([[dataTran objectAtIndex:(parentsch[k][i]*2+1)] floatValue]-[[dataTran objectAtIndex:(parentsch[k][i+1]*2+1)] floatValue],2));
            
        }
        fitness[k]+=sqrtf(powf([[dataTran objectAtIndex:(parentsch[k][cityNumbers-1]*2)] floatValue]-[[dataTran objectAtIndex:(parentsch[k][0]*2)] floatValue], 2)+powf([[dataTran objectAtIndex:(parentsch[k][cityNumbers-1]*2+1)] floatValue]-[[dataTran objectAtIndex:(parentsch[k][0]*2+1)] floatValue],2));
        // find the best one in this generation
        if (fitness[k]<minium)
        {
            bestAns = k;
            minium = fitness[k];
        }
    }
    
    // Draw current best answer to painting board
    // overall iteration count.
    GenerationTotalTimes++;
    
    // find the best one over all the generations
    if (minium<nowIsBest)
    {
        nowIsBest = minium;
        [thisGeneration removeAllObjects];
        for (int geIte=0;geIte<cityNumbers;geIte++)
        {
            [thisGeneration addObject:[NSNumber numberWithInt:parentsch[bestAns][geIte]]];
        }
        GenerationBestTimes=GenerationTotalTimes;
    }
    
    // render the best one
    DrawView *draw = [[DrawView alloc] initWithFrame:CGRectMake(30, 160, 260, 370) data:dataTran flow:thisGeneration city:cityNumbers];
    draw.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:draw];
    
    // update best answer
    
    _BestSolution.text=[[NSNumber numberWithFloat:nowIsBest] stringValue];
    _GeneNumber.text=[[NSNumber numberWithFloat:GenerationBestTimes] stringValue];
    
    //pick from parents, select from parents N=2 tournament selection
    // the best one keep originally in next generation
    for (int keepIte=0;keepIte<cityNumbers;keepIte++)
    {
        childrench[0][keepIte]=parentsch[bestAns][keepIte];
    }
    
    // tournment selection the select number is 5
    // find the best one from 5 random chromosome
    int tournamentSelection =5;
    for (int i=1;i<population;i++)
    {
        int tempRouteNum=0;
        int tempMinium=1000000;
        int routeValue = 0;
        for (int j =0;j<tournamentSelection;j++)
        {
            if (childrench[0][0]==childrench[0][1])
                routeValue = arc4random_uniform(7000);
            else
                routeValue = arc4random_uniform(population);
            if (fitness[routeValue] < tempMinium)
            {
                tempMinium = fitness[routeValue];
                tempRouteNum = routeValue;
            }
        }
        for (int k =0;k<cityNumbers;k++)
        {
            childrench[i][k]=parentsch[tempRouteNum][k];
        }
        
    }
    //childrench stored original chromosome for next generation, now is cross over
    //partically mapped crossover(PMX)
    if (crossover == 1)
    {
        // if the population value is odd
        int round;
        if (population%2==0)
        {
            round = population/2;
        }
        else{
            round =(population-1)/2;
        }
        // crossover between ite*2 ite*2+1
        for (int ite=1;ite<round;ite++)
        {
            int start, end;
            start=arc4random_uniform(cityNumbers);
            end = arc4random_uniform(cityNumbers);
            if (start> end)
            {
                int swap=start;
                start= end;
                end=swap;
            }
            // mapping with existing data
            int mapping1[100];
            int mapping2[100];
            for (int mapite=0;mapite<cityNumbers;mapite++)
            {
                mapping1[mapite]=-1;
                mapping2[mapite]=-1;
            }
            for (int i=start;i<=end;i++)
            {
                int item1 =childrench[2*ite][i];
                int item2 =childrench[2*ite+1][i];
                childrench[2*ite][i]=item2;
                childrench[2*ite+1][i]=item1;
                mapping1[item1]=item2;
                mapping2[item2]=item1;
            }
            // set the mapping back to chromosome
            for (int i=0;i<cityNumbers;i++)
            {
                if ((i<start) || (i>end))
                {
                    //         NSString *temp=[NSString stringWithFormat:@"%d",childrench[2*ite][i]];
                    int temp = childrench[2*ite][i];
                    int h =mapping2[temp];
                    while (mapping2[temp]!=-1)
                    {
                        temp = mapping2[temp];
                    }
                    childrench[2*ite][i]=temp;
                }
            }
            
            for (int i=0;i<cityNumbers;i++)
            {
                if ((i<start) || (i>end))
                {
                    //         NSString *temp=[NSString stringWithFormat:@"%d",childrench[2*ite][i]];
                    int temp = childrench[2*ite+1][i];
                    int h =mapping1[temp];
                    while (mapping1[temp]!=-1)
                    {
                        temp = mapping1[temp];
                    }
                    childrench[2*ite+1][i]=temp;
                }
            }
        }
    }
    // cycle crossover CX
    if (crossover == 2)
    {
        int round;
        if (population%2==0)
        {
            round = population/2;
        }
        else{
            round =(population-1)/2;
        }
        for (int cycIte=1;cycIte<round;cycIte++)
        {
            int mapping[100];
            for (int i=0;i<cityNumbers;i++)
            {
                mapping[i]=-1;
            }
            int line =arc4random_uniform(cityNumbers);
            int startPoint = parentsch[2*cycIte][line];
            int temp =parentsch[2*cycIte+1][line];
            int children1[100];
            int children2[100];
            int now=startPoint;
            mapping[line]=1;
            //find the iteration line through this route
            //sub route??
            while (temp!=startPoint)
            {
                for (int ii=0;ii<cityNumbers;ii++)
                {
                    if (parentsch[2*cycIte][ii]==temp)
                    {
                        line=ii;
                        mapping[ii]=1;
                        now =temp;
                        temp = parentsch[2*cycIte+1][ii];
                        break;
                    }
                }
            }

//            12 line
//            6  now
//            9  temp
            //follow the regulation of cyclic crossover
            
            for (int j=0;j<cityNumbers;j++)
            {
                if (mapping[j]==1)
                {
                    children1[j]=parentsch[cycIte*2][j];
                    children2[j]=parentsch[cycIte*2+1][j];
                }
                else
                {
                    children2[j]=parentsch[cycIte*2][j];
                    children1[j]=parentsch[cycIte*2+1][j];
                }
            }
            // assign the new children back to children
            
            for (int j=0;j<cityNumbers;j++)
            {
                childrench[cycIte*2][j]  = children1[j];
                childrench[cycIte*2+1][j]= children2[j];
            }
        }
    }
    if (crossover == 3)
    {
        int round;
        if (population%2==0)
        {
            round = population/2;
        }
        else{
            round =(population-1)/2;
        }
        for (int orderIte=1;orderIte<round;orderIte++)
        {
            
            // set start and end points in this crossover
            int start= arc4random_uniform(cityNumbers);
            int end = arc4random_uniform(cityNumbers);
            while (start==end)
            {
                start= arc4random_uniform(cityNumbers);
            }
            // swap if reverse
            if (start>end)
            {
                int swap = start;
                start = end;
                end =swap;
            }
            //mapping for brief check which value has been occupied
            int mapping[100];
            for (int i=0;i<cityNumbers;i++)
            {
                //put the route into child
                if ((i<=end) && (i>=start))
                {
                    mapping[parentsch[2*orderIte][i]]=1;
                    childrench[orderIte*2][i]=parentsch[2*orderIte][i];
                }
                else
                    mapping[parentsch[2*orderIte][i]]=-1;
            }
            //fill the part before subroute
            int front=0;
            for (int i=0;i<cityNumbers;i++)
            {
                if (front<start)
                {
                    if (mapping[parentsch[orderIte*2+1][i]]==1)
                        continue;
                    else
                    {
                        childrench[orderIte*2][front]=parentsch[orderIte*2+1][i];
                        mapping[parentsch[orderIte*2+1][i]]=1;
                        front++;
                        continue;
                    }
                }
                else
                    break;
            }
            //the part after subroute
            int forend=end+1;
            for (int i=0;i<cityNumbers;i++)
            {
                if (mapping[parentsch[2*orderIte+1][i]]==-1)
                {
                    childrench[orderIte*2][forend]=parentsch[2*orderIte+1][i];
                    mapping[parentsch[2*orderIte+1][i]] = 1;
                    forend++;
                }
            }
            // run another time to gain another children
            // cause ordered crossover only one child for each time
            // set start and end points in this crossover
            start= arc4random_uniform(cityNumbers);
            end = arc4random_uniform(cityNumbers);
            while (start==end)
            {
                start= arc4random_uniform(cityNumbers);
            }
            // swap if reverse
            if (start>end)
            {
                int swap = start;
                start = end;
                end =swap;
            }
            //mapping for brief check which value has been occupied
            for (int i=0;i<cityNumbers;i++)
            {
                //put the route into child
                if ((i<=end) && (i>=start))
                {
                    mapping[parentsch[2*orderIte][i]]=1;
                    childrench[orderIte*2][i]=parentsch[2*orderIte][i];
                }
                else
                    mapping[parentsch[2*orderIte][i]]=-1;
            }
            //fill the part before subroute
            front=0;
            for (int i=0;i<cityNumbers;i++)
            {
                if (front<start)
                {
                    if (mapping[parentsch[orderIte*2+1][i]]==1)
                        continue;
                    else
                    {
                        childrench[orderIte*2][front]=parentsch[orderIte*2+1][i];
                        mapping[parentsch[orderIte*2+1][i]]=1;
                        front++;
                        continue;
                    }
                }
                else
                    break;
            }
            //the part after subroute
            forend=end+1;
            for (int i=0;i<cityNumbers;i++)
            {
                if (mapping[parentsch[2*orderIte+1][i]]==-1)
                {
                    childrench[orderIte*2][forend]=parentsch[2*orderIte+1][i];
                    mapping[parentsch[2*orderIte+1][i]] = 1;
                    forend++;
                }
            }
        }
    }
    //mutation here, choose two points randomlyy as mutation points. according to the possibility
    //to decide wether or not mutate.
    for (int mutaite=1; mutaite<population;mutaite++)
    {
        int exchange1=arc4random_uniform(cityNumbers);
        int exchange2=arc4random_uniform(cityNumbers);
        int possibility = arc4random_uniform(100);
        if (mutationrate<possibility)
        {
            int temp = childrench[mutaite][exchange1];
            childrench[mutaite][exchange1] = childrench[mutaite][exchange2];
            childrench[mutaite][exchange2] = temp;
        }
    }
    // update status children become parents
    // random optioin, a new system has been set
    // I assume the default population is 7000
    if ([randomize isEqualToString: @"Y"]) {
        for (int k=population-1; k>population-1000;k--)
        {
            int i = 0;
            for(i=0;i<cityNumbers;i++)
            {
                int j =arc4random_uniform(cityNumbers);
                int q =childrench[k][i];
                childrench[k][i]=childrench[k][j];
                childrench[k][j]=q;
                
            }
        }
    }
    for (int i=0;i<population;i++)
        for (int j=0;j<cityNumbers;j++)
            parentsch[i][j]=childrench[i][j];
    
        
    
}

- (IBAction)Fast:(id)sender {
    for (int fastite=0;fastite<50;fastite++)
    {
        //start to calculate the fitness of parents
        float fitness[7000];
        float minium = 1000000.0;
        int bestAns=0;
        int firstGe;
        if (calculated==false)
        {
            // this is the first generation
            calculated= true;
            firstGe = 7000;
            thisGeneration = [[NSMutableArray alloc] init];
        }
        else
        {
            // not the first iteration
            firstGe = population;
        }
        
        for (int k=0; k<firstGe;k++)
        {
            //calculate fitness value for each chromosome
            fitness[k]=0.0;
            for (int i=0;i<cityNumbers;i++)
            {
                fitness[k] += sqrtf(powf([[dataTran objectAtIndex:(parentsch[k][i]*2)] floatValue]-[[dataTran objectAtIndex:(parentsch[k][i+1]*2)] floatValue], 2)+powf([[dataTran objectAtIndex:(parentsch[k][i]*2+1)] floatValue]-[[dataTran objectAtIndex:(parentsch[k][i+1]*2+1)] floatValue],2));
                
            }
            fitness[k]+=sqrtf(powf([[dataTran objectAtIndex:(parentsch[k][cityNumbers-1]*2)] floatValue]-[[dataTran objectAtIndex:(parentsch[k][0]*2)] floatValue], 2)+powf([[dataTran objectAtIndex:(parentsch[k][cityNumbers-1]*2+1)] floatValue]-[[dataTran objectAtIndex:(parentsch[k][0]*2+1)] floatValue],2));
            // find the best one in this generation
            if (fitness[k]<minium)
            {
                bestAns = k;
                minium = fitness[k];
            }
        }
        
        // Draw current best answer to painting board
        // overall iteration count.
        GenerationTotalTimes++;
        
        // find the best one over all the generations
        if (minium<nowIsBest)
        {
            nowIsBest = minium;
            [thisGeneration removeAllObjects];
            for (int geIte=0;geIte<cityNumbers;geIte++)
            {
                [thisGeneration addObject:[NSNumber numberWithInt:parentsch[bestAns][geIte]]];
            }
            GenerationBestTimes=GenerationTotalTimes;
        }
        
        // render the best one
        DrawView *draw = [[DrawView alloc] initWithFrame:CGRectMake(30, 160, 260, 370) data:dataTran flow:thisGeneration city:cityNumbers];
        draw.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:draw];
        
        // update best answer
        
        _BestSolution.text=[[NSNumber numberWithFloat:nowIsBest] stringValue];
        _GeneNumber.text=[[NSNumber numberWithFloat:GenerationBestTimes] stringValue];
        
        //pick from parents, select from parents N=2 tournament selection
        // the best one keep originally in next generation
        for (int keepIte=0;keepIte<cityNumbers;keepIte++)
        {
            childrench[0][keepIte]=parentsch[bestAns][keepIte];
        }
        
        // tournment selection the select number is 5
        // find the best one from 5 random chromosome
        int tournamentSelection =5;
        for (int i=1;i<population;i++)
        {
            int tempRouteNum=0;
            int tempMinium=1000000;
            int routeValue = 0;
            for (int j =0;j<tournamentSelection;j++)
            {
                if (childrench[0][0]==childrench[0][1])
                    routeValue = arc4random_uniform(7000);
                else
                    routeValue = arc4random_uniform(population);
                if (fitness[routeValue] < tempMinium)
                {
                    tempMinium = fitness[routeValue];
                    tempRouteNum = routeValue;
                }
            }
            for (int k =0;k<cityNumbers;k++)
            {
                childrench[i][k]=parentsch[tempRouteNum][k];
            }
            
        }
        //childrench stored original chromosome for next generation, now is cross over
        //partically mapped crossover(PMX)
        if (crossover == 1)
        {
            // if the population value is odd
            int round;
            if (population%2==0)
            {
                round = population/2;
            }
            else{
                round =(population-1)/2;
            }
            // crossover between ite*2 ite*2+1
            for (int ite=1;ite<round;ite++)
            {
                int start, end;
                start=arc4random_uniform(cityNumbers);
                end = arc4random_uniform(cityNumbers);
                if (start> end)
                {
                    int swap=start;
                    start= end;
                    end=swap;
                }
                // mapping with existing data
                int mapping1[100];
                int mapping2[100];
                for (int mapite=0;mapite<cityNumbers;mapite++)
                {
                    mapping1[mapite]=-1;
                    mapping2[mapite]=-1;
                }
                for (int i=start;i<=end;i++)
                {
                    int item1 =childrench[2*ite][i];
                    int item2 =childrench[2*ite+1][i];
                    childrench[2*ite][i]=item2;
                    childrench[2*ite+1][i]=item1;
                    mapping1[item1]=item2;
                    mapping2[item2]=item1;
                }
                // set the mapping back to chromosome
                for (int i=0;i<cityNumbers;i++)
                {
                    if ((i<start) || (i>end))
                    {
                        //         NSString *temp=[NSString stringWithFormat:@"%d",childrench[2*ite][i]];
                        int temp = childrench[2*ite][i];
                        int h =mapping2[temp];
                        while (mapping2[temp]!=-1)
                        {
                            temp = mapping2[temp];
                        }
                        childrench[2*ite][i]=temp;
                    }
                }
                
                for (int i=0;i<cityNumbers;i++)
                {
                    if ((i<start) || (i>end))
                    {
                        //         NSString *temp=[NSString stringWithFormat:@"%d",childrench[2*ite][i]];
                        int temp = childrench[2*ite+1][i];
                        int h =mapping1[temp];
                        while (mapping1[temp]!=-1)
                        {
                            temp = mapping1[temp];
                        }
                        childrench[2*ite+1][i]=temp;
                    }
                }
            }
        }
        // cycle crossover CX
        if (crossover == 2)
        {
            int round;
            if (population%2==0)
            {
                round = population/2;
            }
            else{
                round =(population-1)/2;
            }
            for (int cycIte=1;cycIte<round;cycIte++)
            {
                int mapping[100];
                for (int i=0;i<cityNumbers;i++)
                {
                    mapping[i]=-1;
                }
                int line =arc4random_uniform(cityNumbers);
                int startPoint = parentsch[2*cycIte][line];
                int temp =parentsch[2*cycIte+1][line];
                int children1[100];
                int children2[100];
                int now=startPoint;
                mapping[line]=1;
                //find the iteration line through this route
                //sub route??
                while (temp!=startPoint)
                {
                    for (int ii=0;ii<cityNumbers;ii++)
                    {
                        if (parentsch[2*cycIte][ii]==temp)
                        {
                            line=ii;
                            mapping[ii]=1;
                            now =temp;
                            temp = parentsch[2*cycIte+1][ii];
                            break;
                        }
                    }
                }
                
                //            12 line
                //            6  now
                //            9  temp
                //follow the regulation of cyclic crossover
                
                for (int j=0;j<cityNumbers;j++)
                {
                    if (mapping[j]==1)
                    {
                        children1[j]=parentsch[cycIte*2][j];
                        children2[j]=parentsch[cycIte*2+1][j];
                    }
                    else
                    {
                        children2[j]=parentsch[cycIte*2][j];
                        children1[j]=parentsch[cycIte*2+1][j];
                    }
                }
                // assign the new children back to children
                
                for (int j=0;j<cityNumbers;j++)
                {
                    childrench[cycIte*2][j]  = children1[j];
                    childrench[cycIte*2+1][j]= children2[j];
                }
            }
        }
        if (crossover == 3)
        {
            int round;
            if (population%2==0)
            {
                round = population/2;
            }
            else{
                round =(population-1)/2;
            }
            for (int orderIte=1;orderIte<round;orderIte++)
            {
                
                // set start and end points in this crossover
                int start= arc4random_uniform(cityNumbers);
                int end = arc4random_uniform(cityNumbers);
                while (start==end)
                {
                    start= arc4random_uniform(cityNumbers);
                }
                // swap if reverse
                if (start>end)
                {
                    int swap = start;
                    start = end;
                    end =swap;
                }
                //mapping for brief check which value has been occupied
                int mapping[100];
                for (int i=0;i<cityNumbers;i++)
                {
                    //put the route into child
                    if ((i<=end) && (i>=start))
                    {
                        mapping[parentsch[2*orderIte][i]]=1;
                        childrench[orderIte*2][i]=parentsch[2*orderIte][i];
                    }
                    else
                        mapping[parentsch[2*orderIte][i]]=-1;
                }
                //fill the part before subroute
                int front=0;
                for (int i=0;i<cityNumbers;i++)
                {
                    if (front<start)
                    {
                        if (mapping[parentsch[orderIte*2+1][i]]==1)
                            continue;
                        else
                        {
                            childrench[orderIte*2][front]=parentsch[orderIte*2+1][i];
                            mapping[parentsch[orderIte*2+1][i]]=1;
                            front++;
                            continue;
                        }
                    }
                    else
                        break;
                }
                //the part after subroute
                int forend=end+1;
                for (int i=0;i<cityNumbers;i++)
                {
                    if (mapping[parentsch[2*orderIte+1][i]]==-1)
                    {
                        childrench[orderIte*2][forend]=parentsch[2*orderIte+1][i];
                        mapping[parentsch[2*orderIte+1][i]] = 1;
                        forend++;
                    }
                }
                // run another time to gain another children
                // cause ordered crossover only one child for each time
                // set start and end points in this crossover
                start= arc4random_uniform(cityNumbers);
                end = arc4random_uniform(cityNumbers);
                while (start==end)
                {
                    start= arc4random_uniform(cityNumbers);
                }
                // swap if reverse
                if (start>end)
                {
                    int swap = start;
                    start = end;
                    end =swap;
                }
                //mapping for brief check which value has been occupied
                for (int i=0;i<cityNumbers;i++)
                {
                    //put the route into child
                    if ((i<=end) && (i>=start))
                    {
                        mapping[parentsch[2*orderIte][i]]=1;
                        childrench[orderIte*2][i]=parentsch[2*orderIte][i];
                    }
                    else
                        mapping[parentsch[2*orderIte][i]]=-1;
                }
                //fill the part before subroute
                front=0;
                for (int i=0;i<cityNumbers;i++)
                {
                    if (front<start)
                    {
                        if (mapping[parentsch[orderIte*2+1][i]]==1)
                            continue;
                        else
                        {
                            childrench[orderIte*2][front]=parentsch[orderIte*2+1][i];
                            mapping[parentsch[orderIte*2+1][i]]=1;
                            front++;
                            continue;
                        }
                    }
                    else
                        break;
                }
                //the part after subroute
                forend=end+1;
                for (int i=0;i<cityNumbers;i++)
                {
                    if (mapping[parentsch[2*orderIte+1][i]]==-1)
                    {
                        childrench[orderIte*2][forend]=parentsch[2*orderIte+1][i];
                        mapping[parentsch[2*orderIte+1][i]] = 1;
                        forend++;
                    }
                }
            }
        }
        //mutation here, choose two points randomlyy as mutation points. according to the possibility
        //to decide wether or not mutate.
        for (int mutaite=1; mutaite<population;mutaite++)
        {
            int exchange1=arc4random_uniform(cityNumbers);
            int exchange2=arc4random_uniform(cityNumbers);
            int possibility = arc4random_uniform(100);
            if (mutationrate<possibility)
            {
                int temp = childrench[mutaite][exchange1];
                childrench[mutaite][exchange1] = childrench[mutaite][exchange2];
                childrench[mutaite][exchange2] = temp;
            }
        }
        // update status children become parents
        // random optioin, a new system has been set
        // I assume the default population is 7000
        if ([randomize isEqualToString: @"Y"]) {
            for (int k=population-1; k>population-1000;k--)
            {
                int i = 0;
                for(i=0;i<cityNumbers;i++)
                {
                    int j =arc4random_uniform(cityNumbers);
                    int q =childrench[k][i];
                    childrench[k][i]=childrench[k][j];
                    childrench[k][j]=q;
                    
                }
            }
        }
        // the replace between children and parents, for next generation
        for (int i=0;i<population;i++)
            for (int j=0;j<cityNumbers;j++)
                parentsch[i][j]=childrench[i][j];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// to resign keyboard for text field input
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_Cross resignFirstResponder];
    [_Mutat resignFirstResponder];
    [_Popula resignFirstResponder];
    [_Random resignFirstResponder];
    [_City resignFirstResponder];
    return YES;
}

-(void)dismissKeyboard {
    [_Cross resignFirstResponder];
    [_Mutat resignFirstResponder];
    [_Popula resignFirstResponder];
    [_Random resignFirstResponder];
    [_City resignFirstResponder];
}

@end
