#import "CronExpression.h"

@implementation CronExpression

int const COMPLETE = -1;
int const MINUTE = 0;
int const HOUR = 1;
int const DAY = 2;
int const MONTH = 3;
int const WEEKDAY = 4;
int const YEAR = 5;

-(id)init:(NSString*)schedule withFieldFactory:(FieldFactory*) fieldFactory
{
    /*$this->cronParts = explode(' ', $schedule);
     $this->fieldFactory = $fieldFactory;
     
     if (count($this->cronParts) < 5) {
        throw new InvalidArgumentException(
            $schedule . ' is not a valid CRON expression'
        );
     }
     
     foreach ($this->cronParts as $position => $part) {
        if (!$this->fieldFactory->getField($position)->validate($part)) {
            throw new InvalidArgumentException(
                'Invalid CRON field value ' . $part . ' as position ' . $position
            );
        }
     }*/
    
    self = [super init];
    if (self) {
        _fieldFactory = fieldFactory;
        cronParts = [schedule componentsSeparatedByString: @" "];
        
        if([cronParts count] < 5)
        {
            [NSException raise:@"Invalid cron expression" format:@"%@ is not a valid CRON expression", schedule];
        }
        
        // Good regex but doesn't handle ranges, letters, or named Months or days of week
        // (\*|([0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])|\*\/([0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])) (\*|([0-9]|1[0-9]|2[0-3])|\*\/([0-9]|1[0-9]|2[0-3])) (\*|([1-9]|1[0-9]|2[0-9]|3[0-1])|\*\/([1-9]|1[0-9]|2[0-9]|3[0-1])) (\*|([1-9]|1[0-2])|\*\/([1-9]|1[0-2])) (\*|([0-6])|\*\/([0-6]))
        
        [cronParts enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            if(![[_fieldFactory getField: idx] validate: (NSString*)object])
            {
                [NSException raise:@"Invalid cron part" format:@"Invalid CRON field value %@ as position %d", object, idx];
            }
        }];
    }
    
    return self;
}

+(CronExpression*) factory:(NSString*)expression :(FieldFactory*) fieldFactory
{
    /*$mappings = array(
     '@yearly' => '0 0 1 1 *',
     '@annually' => '0 0 1 1 *',
     '@monthly' => '0 0 1 * *',
     '@weekly' => '0 0 * * 0',
     '@daily' => '0 0 * * *',
     '@hourly' => '0 * * * *'
     );
     
     if (isset($mappings[$expression])) {
        $expression = $mappings[$expression];
     }
     
     return new self($expression, $fieldFactory ?: new FieldFactory());*/
    
//    NSDictionary * mappings = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
//                                                                   @"0 0 1 1 *",
//                                                                   @"0 0 1 1 *",
//                                                                   @"0 0 1 * *",
//                                                                   @"0 0 * * 0",
//                                                                   @"0 0 * * *",
//                                                                   @"0 * * * *", nil]
//                                                          forKeys:[NSArray arrayWithObjects:
//                                                                   @"@yearly",
//                                                                   @"@annually",
//                                                                   @"@monthly",
//                                                                   @"@weekly",
//                                                                   @"@daily",
//                                                                   @"@hourly", nil]];
    
    NSDictionary * mappings = @{
                               @"@yearly"   : @"0 0 1 1 *",
                               @"@annually" : @"0 0 1 1 *",
                               @"@monthly"  : @"0 0 1 * *",
                               @"@weekly"   : @"0 0 * * 0",
                               @"@daily"    : @"0 0 * * *",
                               @"@hourly"   : @"0 * * * *"
                               };
    
                                                            
    if([mappings objectForKey: expression])
    {
        expression = [mappings objectForKey: expression];
    }
    
    if(fieldFactory == nil)
    {
        fieldFactory = [[FieldFactory alloc] init];
    }
    
    return [[CronExpression alloc] init: expression withFieldFactory:fieldFactory];
}

-(NSDate*)getNextRunDate: (NSDate*)currentTime :(NSInteger)matchesToSkip
{
    /*$currentDate = $currentTime instanceof DateTime
     ? $currentTime
     : new DateTime($currentTime ?: 'now');
     
     $nextRun = clone $currentDate;
     $nextRun->setTime($nextRun->format('H'), $nextRun->format('i'), 0);
     $nth = (int) $nth;
     
     // Set a hard limit to bail on an impossible date
     for ($i = 0; $i < 1000; $i++) {
     
     foreach (self::$order as $position) {
        $part = $this->getExpression($position);
        if (null === $part) {
            continue;
        }
     
        $satisfied = false;
        // Get the field object used to validate this part
        $field = $this->fieldFactory->getField($position);
        // Check if this is singular or a list
        if (strpos($part, ',') === false) {
            $satisfied = $field->isSatisfiedBy($nextRun, $part);
        } else {
            foreach (array_map('trim', explode(',', $part)) as $listPart) {
                if ($field->isSatisfiedBy($nextRun, $listPart)) {
                    $satisfied = true;
                    break;
                }
            }
        }
     
        // If the field is not satisfied, then start over
        if (!$satisfied) {
            $field->increment($nextRun);
            continue 2;
        }
     }
     
     // Skip this match if needed
     if (--$nth > -1) {
        $this->fieldFactory->getField(0)->increment($nextRun);
        continue;
     }
     
        return $nextRun;
     }
     
     // @codeCoverageIgnoreStart
     throw new RuntimeException('Impossible CRON expression');
     // @codeCoverageIgnoreEnd*/
    
    /* Copied from: https://code.google.com/p/ncrontab/source/browse/src/NCrontab/CrontabSchedule.cs
    public DateTime GetNextOccurrence(DateTime baseTime, DateTime endTime)
    {
        const int nil = -1;
        
        var baseYear = baseTime.Year;
        var baseMonth = baseTime.Month;
        var baseDay = baseTime.Day;
        var baseHour = baseTime.Hour;
        var baseMinute = baseTime.Minute;
        
        var endYear = endTime.Year;
        var endMonth = endTime.Month;
        var endDay = endTime.Day;
        
        var year = baseYear;
        var month = baseMonth;
        var day = baseDay;
        var hour = baseHour;
        var minute = baseMinute + 1;
        
        //
        // Minute
        //
        
        minute = _minutes.Next(minute);
        
        if (minute == nil)
        {
            minute = _minutes.GetFirst();
            hour++;
        }
        
        //
        // Hour
        //
        
        hour = _hours.Next(hour);
        
        if (hour == nil)
        {
            minute = _minutes.GetFirst();
            hour = _hours.GetFirst();
            day++;
        }
        else if (hour > baseHour)
        {
            minute = _minutes.GetFirst();
        }
        
        //
        // Day
        //
        
        day = _days.Next(day);
        
    RetryDayMonth:
        
        if (day == nil)
        {
            minute = _minutes.GetFirst();
            hour = _hours.GetFirst();
            day = _days.GetFirst();
            month++;
        }
        else if (day > baseDay)
        {
            minute = _minutes.GetFirst();
            hour = _hours.GetFirst();
        }
        
        //
        // Month
        //
        
        month = _months.Next(month);
        
        if (month == nil)
        {
            minute = _minutes.GetFirst();
            hour = _hours.GetFirst();
            day = _days.GetFirst();
            month = _months.GetFirst();
            year++;
        }
        else if (month > baseMonth)
        {
            minute = _minutes.GetFirst();
            hour = _hours.GetFirst();
            day = _days.GetFirst();
        }
        
        //
        // The day field in a cron expression spans the entire range of days
        // in a month, which is from 1 to 31. However, the number of days in
        // a month tend to be variable depending on the month (and the year
        // in case of February). So a check is needed here to see if the
        // date is a border case. If the day happens to be beyond 28
        // (meaning that we're dealing with the suspicious range of 29-31)
        // and the date part has changed then we need to determine whether
        // the day still makes sense for the given year and month. If the
        // day is beyond the last possible value, then the day/month part
        // for the schedule is re-evaluated. So an expression like "0 0
        // 15,31 * *" will yield the following sequence starting on midnight
        // of Jan 1, 2000:
        //
        //  Jan 15, Jan 31, Feb 15, Mar 15, Apr 15, Apr 31, ...
        //
        
        var dateChanged = day != baseDay || month != baseMonth || year != baseYear;
        
        if (day > 28 && dateChanged && day > Calendar.GetDaysInMonth(year, month))
        {
            if (year >= endYear && month >= endMonth && day >= endDay)
                return endTime;
            
            day = nil;
            goto RetryDayMonth;
        }
        
        var nextTime = new DateTime(year, month, day, hour, minute, 0, 0, baseTime.Kind);
        
        if (nextTime >= endTime)
            return endTime;
        
        //
        // Day of week
        //
        
        if (_daysOfWeek.Contains((int) nextTime.DayOfWeek))
            return nextTime;
        
        return GetNextOccurrence(new DateTime(year, month, day, 23, 59, 0, 0, baseTime.Kind), endTime);
    }*/
    
    if (currentTime == nil)
        currentTime = [NSDate date];
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:currentTime];
    components.second = 0;
    
    if ([[self getExpression:MINUTE] rangeOfString:@"*"].location != NSNotFound)
        components.minute++;
    
    
    NSDate* nextRun = [calendar dateFromComponents:components];

    //
    // Crontab expression format:
    //
    // * * * * * *
    // - - - - - -
    // | | | | | +--- year (range 2000-2012, single value, comma-separated values, etc.) OPTIONAL
    // | | | | +----- day of week (0 - 6) (Sunday=0)
    // | | | +------- month (1 - 12)
    // | | +--------- day of month (1 - 31)
    // | +----------- hour (0 - 23)
    // +------------- min (0 - 59)
    //
    // Star (*) in the value field above means all legal values as in
    // braces for that column. The value column can have a * or a list
    // of elements separated by commas. An element is either a number in
    // the ranges shown above or two numbers in the range separated by a
    // hyphen (meaning an inclusive range).
    //
    // Source: http://www.adminschoice.com/docs/crontab.htm
    //
    
    int tries;
    
    // Get the minute component
    NSString* part = [self getExpression:MINUTE];
    id<FieldInterface> field = [_fieldFactory getField:MINUTE];
    
    while (![field isSatisfiedBy:nextRun byValue:part])
        nextRun = [field increment:nextRun];
    
    // Get the hour component
    part = [self getExpression:HOUR];
    field = [_fieldFactory getField:HOUR];
    
    while (![field isSatisfiedBy:nextRun byValue:part])
        nextRun = [field increment:nextRun];
    
    // Get the day of month component
    part = [self getExpression:DAY];
    field = [_fieldFactory getField:DAY];
    
    tries = 0;
    while (![field isSatisfiedBy:nextRun byValue:part] && tries++ < 40)
        nextRun = [field increment:nextRun];
    
    if (tries >= 40)
        return nil;
    
    // Get the month component
    part = [self getExpression:MONTH];
    field = [_fieldFactory getField:MONTH];
    
    tries = 0;
    while (![field isSatisfiedBy:nextRun byValue:part] && tries++ < 15)
        nextRun = [field increment:nextRun];
    
    if (tries >= 15)
        return nil;
    
    // Get the weekday component
    part = [self getExpression:WEEKDAY];
    field = [_fieldFactory getField:WEEKDAY];
    
    tries = 0;
    while (![field isSatisfiedBy:nextRun byValue:part] && tries++ < 10)
        nextRun = [field increment:nextRun];
    
    if (tries >= 10)
        return nil;
    
    // Finally check to see about year
    part = [self getExpression:YEAR];
    if (part != nil) {
        if (part )
        field = [_fieldFactory getField:YEAR];
    
        tries = 0;
        while (![field isSatisfiedBy:nextRun byValue:part] && tries++ < 1000)
            nextRun = [field increment:nextRun];
        
        if (tries >= 1000)
            return nil;
    }
        
    return nextRun;
    
        
//    [NSException raise:@"Invalid Argument" format:@"Impossible CRON expression"];
//    return nil;
}

-(NSString*)getExpression: (int)part
{
    /*if (null === $part) {
        return implode(' ', $this->cronParts);
     } else if (array_key_exists($part, $this->cronParts)) {
        return $this->cronParts[$part];
     }
     
     return null;*/
    
    if (part == COMPLETE)
        return [cronParts componentsJoinedByString:@" "];
    else if (part >= 0 && part < [cronParts count])
        return [cronParts objectAtIndex:part];
             
    return nil;
}

-(BOOL)isDue: (NSDate*)currentTime
{
    /*if (null === $currentTime || 'now' === $currentTime) {
        $currentDate = date('Y-m-d H:i');
        $currentTime = strtotime($currentDate);
     } else if ($currentTime instanceof DateTime) {
        $currentDate = $currentTime->format('Y-m-d H:i');
        $currentTime = strtotime($currentDate);
     } else {
        $currentTime = new DateTime($currentTime);
        $currentTime->setTime($currentTime->format('H'), $currentTime->format('i'), 0);
        $currentDate = $currentTime->format('Y-m-d H:i');
        $currentTime = $currentTime->getTimeStamp();
     }
     
     return $this->getNextRunDate($currentDate)->getTimestamp() == $currentTime;*/

    
    return YES;
}


@end
