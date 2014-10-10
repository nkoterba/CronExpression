//
//  CronExpressionTest.m
//  libCronExpression
//
//  Created by c 4 on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CronExpressionTest.h"
#import "CronExpression.h"

@implementation CronExpressionTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

/**
 * @covers Cron\CronExpression::factory
 */
/*public function testFactoryRecognizesTemplates()
{
 $this->assertEquals('0 0 1 1 *', CronExpression::factory('@annually')->getExpression());
 $this->assertEquals('0 0 1 1 *', CronExpression::factory('@yearly')->getExpression());
 $this->assertEquals('0 0 * * 0', CronExpression::factory('@weekly')->getExpression());
}*/

-(void)testFactoryRecognizesTemplates
{
    CronExpression * expr = [CronExpression factory:@"@annually" :nil];
    STAssertTrue([@"0 0 1 1 *" isEqualToString:[expr getExpression:COMPLETE]], @"@annually expression does not match expected expression");
    
    CronExpression * expr2 = [CronExpression factory:@"@yearly" :nil];
    STAssertTrue([@"0 0 1 1 *" isEqualToString:[expr2 getExpression:COMPLETE]], @"@yearly expression does not match expected expression");
    
    CronExpression * expr3 = [CronExpression factory:@"@weekly" :nil];
    STAssertTrue([@"0 0 * * 0" isEqualToString:[expr3 getExpression:COMPLETE]], @"@weekly expression does not match expected expression");
}

/**
 * @covers Cron\CronExpression::__construct
 * @covers Cron\CronExpression::getExpression
 */
/*public function testParsesCronSchedule()
 {
 // '2010-09-10 12:00:00'
 $cron = CronExpression::factory('1 2-4 * 4,5,6 *___/3');
 $this->assertEquals('1', $cron->getExpression(CronExpression::MINUTE));
 $this->assertEquals('2-4', $cron->getExpression(CronExpression::HOUR));
 $this->assertEquals('*', $cron->getExpression(CronExpression::DAY));
 $this->assertEquals('4,5,6', $cron->getExpression(CronExpression::MONTH));
 $this->assertEquals('*___/3', $cron->getExpression(CronExpression::WEEKDAY));
 $this->assertEquals('1 2-4 * 4,5,6 *___/3', $cron->getExpression());
 $this->assertNull($cron->getExpression('foo'));
 
 try {
 $cron = CronExpression::factory('A 1 2 3 4');
 $this->fail('Validation exception not thrown');
 } catch (\InvalidArgumentException $e) {
 }
 }*/

/**
 * @covers Cron\CronExpression::__construct
 * @covers Cron\CronExpression::getExpression
 */
-(void) testParsesCronSchedule
{
    // '2010-09-10 12:00:00'
    NSString * cronExpr = @"1 2-4 * 4,5,6 *___/3";
    
    CronExpression * expr = [CronExpression factory:cronExpr :nil];
    
    STAssertTrue([[expr getExpression:MINUTE] isEqualToString:@"1"], @"MINUTE expression not equal");
    STAssertTrue([[expr getExpression:HOUR] isEqualToString:@"2-4"], @"HOUR expression not equal");
    STAssertTrue([[expr getExpression:DAY] isEqualToString:@"*"], @"DAY expression not equal");
    STAssertTrue([[expr getExpression:MONTH] isEqualToString:@"4,5,6"], @"MONTH expression not equal");
    STAssertTrue([[expr getExpression:WEEKDAY] isEqualToString:@"*___/3"], @"WEEKDAY expression not equal");
    STAssertTrue([[expr getExpression:COMPLETE] isEqualToString:cronExpr], @"Complete expression not equal");
    
    STAssertNil([expr getExpression:10], @"Invalid expression returns non-nil value");
    
    @try {
        expr = [CronExpression factory:@"A 1 2 3 4" :nil];
        STFail(@"Validation exception not thrown");
    } @catch (NSException *) {
        
    }
}

/**
 * @covers Cron\CronExpression::__construct
 * @covers Cron\CronExpression::setExpression
 * @covers Cron\CronExpression::setPart
 * @expectedException InvalidArgumentException
 */
/*public function testInvalidCronsWillFail()
 {
 // Only four values
 $cron = CronExpression::factory('* * * 1');
 }*/

/**
 * @covers Cron\CronExpression::setPart
 * @expectedException InvalidArgumentException
 */
/*public function testInvalidPartsWillFail()
 {
 // Only four values
 $cron = CronExpression::factory('* * * * *');
 $cron->setPart(1, 'abc');
 }*/

/**
 * Data provider for cron schedule
 *
 * @return array
 */
/*public function scheduleProvider()
 {
 return array(
 array('*___/2 *___/2 * * *', '2015-08-10 21:47:27', '2015-08-10 22:00:00', false),
 array('* * * * *', '2015-08-10 21:50:37', '2015-08-10 21:50:00', true),
 array('* 20,21,22 * * *', '2015-08-10 21:50:00', '2015-08-10 21:50:00', true),
 // Handles CSV values
 array('* 20,22 * * *', '2015-08-10 21:50:00', '2015-08-10 22:00:00', false),
 // CSV values can be complex
 array('* 5,21-22 * * *', '2015-08-10 21:50:00', '2015-08-10 21:50:00', true),
 array('7-9 * *___/9 * *', '2015-08-10 22:02:33', '2015-08-18 00:07:00', false),
 // Minutes 12-19, every 3 hours, every 5 days, in June, on Sunday
 array('12-19 *___/3 *___/5 6 7', '2015-08-10 22:05:51', '2016-06-05 00:12:00', false),
 // 15th minute, of the second hour, every 15 days, in January, every Friday
 array('15 2 *___/15 1 *___/5', '2015-08-10 22:10:19', '2016-01-15 02:15:00', false),
 // 15th minute, of the second hour, every 15 days, in January, Tuesday-Friday
 array('15 2 *___/15 1 2-5', '2015-08-10 22:10:19', '2016-01-15 02:15:00', false),
 array('1 * * * 7', '2015-08-10 21:47:27', '2015-08-16 00:01:00', false),
 // Test with exact times
 array('47 21 * * *', strtotime('2015-08-10 21:47:30'), '2015-08-10 21:47:00', true),
 // Test Day of the week (issue #1)
 // According cron implementation, 0|7 = sunday, 1 => monday, etc
 array('* * * * 0', strtotime('2011-06-15 23:09:00'), '2011-06-19 00:00:00', false),
 array('* * * * 7', strtotime('2011-06-15 23:09:00'), '2011-06-19 00:00:00', false),
 array('* * * * 1', strtotime('2011-06-15 23:09:00'), '2011-06-20 00:00:00', false),
 // Should return the sunday date as 7 equals 0
 array('0 0 * * MON,SUN', strtotime('2011-06-15 23:09:00'), '2011-06-19 00:00:00', false),
 array('0 0 * * 1,7', strtotime('2011-06-15 23:09:00'), '2011-06-19 00:00:00', false),
 array('0 0 * * 0-4', strtotime('2011-06-15 23:09:00'), '2011-06-16 00:00:00', false),
 array('0 0 * * 7-4', strtotime('2011-06-15 23:09:00'), '2011-06-16 00:00:00', false),
 array('0 0 * * 4-7', strtotime('2011-06-15 23:09:00'), '2011-06-16 00:00:00', false),
 array('0 0 * * 7-3', strtotime('2011-06-15 23:09:00'), '2011-06-19 00:00:00', false),
 array('0 0 * * 3-7', strtotime('2011-06-15 23:09:00'), '2011-06-16 00:00:00', false),
 array('0 0 * * 3-7', strtotime('2011-06-18 23:09:00'), '2011-06-19 00:00:00', false),
 // Test lists of values and increments of ranges (Abhoryo)
 array('0 0 * * 2-7', strtotime('2011-06-20 23:09:00'), '2011-06-21 00:00:00', false),
 array('0 0 * * 0,2-6', strtotime('2011-06-20 23:09:00'), '2011-06-21 00:00:00', false),
 array('0 0 * * 2-7', strtotime('2011-06-18 23:09:00'), '2011-06-19 00:00:00', false),
 array('0 0 * * 4-7', strtotime('2011-07-19 00:00:00'), '2011-07-21 00:00:00', false),
 // Test Day of the Week and the Day of the Month (issue #1)
 array('0 0 1 1 0', strtotime('2011-06-15 23:09:00'), '2012-01-01 00:00:00', false),
 array('0 0 1 JAN 0', strtotime('2011-06-15 23:09:00'), '2012-01-01 00:00:00', false),
 array('0 0 1 * 0', strtotime('2011-06-15 23:09:00'), '2012-01-01 00:00:00', false),
 array('0 0 L * *', strtotime('2011-07-15 00:00:00'), '2011-07-31 00:00:00', false),
 // Test the W day of the week modifier for day of the month field
 array('0 0 2W * *', strtotime('2011-07-01 00:00:00'), '2011-07-01 00:00:00', true),
 array('0 0 1W * *', strtotime('2011-05-01 00:00:00'), '2011-05-02 00:00:00', false),
 array('0 0 1W * *', strtotime('2011-07-01 00:00:00'), '2011-07-01 00:00:00', true),
 array('0 0 3W * *', strtotime('2011-07-01 00:00:00'), '2011-07-04 00:00:00', false),
 array('0 0 16W * *', strtotime('2011-07-01 00:00:00'), '2011-07-15 00:00:00', false),
 array('0 0 28W * *', strtotime('2011-07-01 00:00:00'), '2011-07-28 00:00:00', false),
 array('0 0 30W * *', strtotime('2011-07-01 00:00:00'), '2011-07-29 00:00:00', false),
 array('0 0 31W * *', strtotime('2011-07-01 00:00:00'), '2011-07-29 00:00:00', false),
 // Test the year field
 array('* * * * * 2012', strtotime('2011-05-01 00:00:00'), '2012-01-01 00:00:00', false),
 // Test the last weekday of a month
 array('* * * * 5L', strtotime('2011-07-01 00:00:00'), '2011-07-29 00:00:00', false),
 array('* * * * 6L', strtotime('2011-07-01 00:00:00'), '2011-07-30 00:00:00', false),
 array('* * * * 7L', strtotime('2011-07-01 00:00:00'), '2011-07-31 00:00:00', false),
 array('* * * * 1L', strtotime('2011-07-24 00:00:00'), '2011-07-25 00:00:00', false),
 array('* * * * TUEL', strtotime('2011-07-24 00:00:00'), '2011-07-26 00:00:00', false),
 array('* * * 1 5L', strtotime('2011-12-25 00:00:00'), '2012-01-27 00:00:00', false),
 // Test the hash symbol for the nth weekday of a given month
 array('* * * * 5#2', strtotime('2011-07-01 00:00:00'), '2011-07-08 00:00:00', false),
 array('* * * * 5#1', strtotime('2011-07-01 00:00:00'), '2011-07-01 00:00:00', true),
 array('* * * * 3#4', strtotime('2011-07-01 00:00:00'), '2011-07-27 00:00:00', false),
 );
 }*/

/**
 * @covers Cron\CronExpression::isDue
 * @covers Cron\CronExpression::getNextRunDate
 * @covers Cron\DayOfMonthField
 * @covers Cron\DayOfWeekField
 * @covers Cron\MinutesField
 * @covers Cron\HoursField
 * @covers Cron\MonthField
 * @covers Cron\YearField
 * @covers Cron\CronExpression::getRunDate
 * @dataProvider scheduleProvider
 */
/*public function testDeterminesIfCronIsDue($schedule, $relativeTime, $nextRun, $isDue)
 {
 $relativeTimeString = is_int($relativeTime) ? date('Y-m-d H:i:s', $relativeTime) : $relativeTime;
 
 // Test next run date
 $cron = CronExpression::factory($schedule);
 if (is_string($relativeTime)) {
 $relativeTime = new \DateTime($relativeTime);
 } else if (is_int($relativeTime)) {
 $relativeTime = date('Y-m-d H:i:s', $relativeTime);
 }
 $this->assertEquals($isDue, $cron->isDue($relativeTime));
 $next = $cron->getNextRunDate($relativeTime);
 $this->assertEquals(new \DateTime($nextRun), $next);
 }*/

/**
 * @covers Cron\CronExpression::isDue
 */
/*public function testIsDueHandlesDifferentDates()
 {
 $cron = CronExpression::factory('* * * * *');
 $this->assertTrue($cron->isDue());
 $this->assertTrue($cron->isDue('now'));
 $this->assertTrue($cron->isDue(new \DateTime('now')));
 $this->assertTrue($cron->isDue(date('Y-m-d H:i')));
 }*/

/**
 * @covers Cron\CronExpression::getPreviousRunDate
 */
/*public function testCanGetPreviousRunDates()
 {
 $cron = CronExpression::factory('* * * * *');
 $next = $cron->getNextRunDate('now');
 $two = $cron->getNextRunDate('now', 1);
 $this->assertEquals($next, $cron->getPreviousRunDate($two, 1));
 
 $cron = CronExpression::factory('* *___/2 * * *');
 $next = $cron->getNextRunDate('now');
 $two = $cron->getNextRunDate('now', 1);
 $this->assertEquals($next, $cron->getPreviousRunDate($two, 1));
 
 $cron = CronExpression::factory('* * * *___/2 *');
 $next = $cron->getNextRunDate('now');
 $two = $cron->getNextRunDate('now', 1);
 $this->assertEquals($next, $cron->getPreviousRunDate($two, 1));
 }*/

/**
 * @covers Cron\CronExpression
 */
/*public function testCanIterateOverNextRuns()
 {
 $cron = CronExpression::factory('@weekly');
 $nextRun = $cron->getNextRunDate("2008-11-09 08:00:00");
 $this->assertEquals($nextRun, new \DateTime("2008-11-16 00:00:00"));
 
 // true is cast to 1
 $nextRun = $cron->getNextRunDate("2008-11-09 00:00:00", true);
 $this->assertEquals($nextRun, new \DateTime("2008-11-16 00:00:00"));
 
 // You can iterate over them
 $nextRun = $cron->getNextRunDate($cron->getNextRunDate("2008-11-09 00:00:00", 1), 1);
 $this->assertEquals($nextRun, new \DateTime("2008-11-23 00:00:00"));
 
 // You can skip more than one
 $nextRun = $cron->getNextRunDate("2008-11-09 00:00:00", 2);
 $this->assertEquals($nextRun, new \DateTime("2008-11-23 00:00:00"));
 $nextRun = $cron->getNextRunDate("2008-11-09 00:00:00", 3);
 $this->assertEquals($nextRun, new \DateTime("2008-11-30 00:00:00"));
 }*/


-(void)testGetNextRunDate
{
    NSString * cronExpr = @"0 0 1 1 *";
    
    CronExpression * expr = [CronExpression factory:cronExpr :nil];
    
    NSDate *date = [expr getNextRunDate:[NSDate date] :5];
    
    NSLog(@"DATE: %@", date);
    
    STAssertNotNil(date, @"Date was nil");
}

@end
