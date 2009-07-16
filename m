From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Performance regressions in 2.6.30-rc7?
Date: Thu, 16 Jul 2009 10:36:14 -0400
Message-ID: <x49iqhspue9.fsf@segfault.boston.devel.redhat.com>
References: <20090604112109.GC2859@duck.suse.cz>
	<1244142795.5731.31.camel@marge.simson.net>
	<20090609103208.GB9235@duck.suse.cz> <20090609184818.GD9556@think>
	<20090610091211.GA13692@duck.suse.cz>
	<x4963f3rb4t.fsf@segfault.boston.devel.redhat.com>
	<20090715104319.GC25458@duck.suse.cz>
	<x4963du3vyp.fsf@segfault.boston.devel.redhat.com>
	<20090715145849.GE25458@duck.suse.cz>
	<20090715175028.GE22826@atrey.karlin.mff.cuni.cz>
	<20090715185452.GG22826@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Mike Galbraith <efault@gmx.de>,
	Diego Calleja <diegocg@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57869 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbZGPOg7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 10:36:59 -0400
In-Reply-To: <20090715185452.GG22826@atrey.karlin.mff.cuni.cz> (Jan Kara's
	message of "Wed, 15 Jul 2009 20:54:52 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

>> > On Wed 15-07-09 09:41:02, Jeff Moyer wrote:
>> > > Jan Kara <jack@suse.cz> writes:
>> > > 
>> > > > On Wed 10-06-09 18:12:50, Jeff Moyer wrote:
>> > > >> Jan Kara <jack@suse.cz> writes:
>> > > >> 
>> > > >> > On Tue 09-06-09 14:48:18, Chris Mason wrote:
>> > > >> >> On Tue, Jun 09, 2009 at 12:32:08PM +0200, Jan Kara wrote:
>> > > >> >> > On Thu 04-06-09 21:13:15, Mike Galbraith wrote:
>> > > >> >> > > On Thu, 2009-06-04 at 13:21 +0200, Jan Kara wrote:
>> > > >> >> > > 
>> > > >> >> > > > > Sequential Writes
>> > > >> >> > > > > 2.6.30-smp-ordered            6000  65536  32   50.16 508.9%    31.996    45595.78   0.64965  0.02402    10
>> > > >> >> > > > > 2.6.29.4-smp-ordered          6000  65536  32   52.70 543.2%    33.658    23794.92   0.71754  0.00836    10
>> > > >> >> > > > > 
>> > > >> >> > > > > 2.6.30-smp-writeback          6000  65536  32   47.82 525.4%    35.003    32588.84   0.56192  0.02298     9
>> > > >> >> > > > > 2.6.29.4-smp-writeback        6000  65536  32   52.52 467.6%    32.397    12972.78   0.53580  0.00522    11
>> > > >> >> > > > > 
>> > > >> >> > > > > 2.6.30-smp-ordered            6000  65536  16   56.08 254.9%    15.463    33000.68   0.39687  0.00521    22
>> > > >> >> > > > > 2.6.29.4-smp-ordered          6000  65536  16   62.40 308.4%    14.701    13455.02   0.13125  0.00208    20
>> > > >> >> > > > > 
>> > > >> >> > > > > 2.6.30-smp-writeback          6000  65536  16   51.90 281.4%    17.098    12869.85   0.36771  0.00104    18
>> > > >> >> > > > > 2.6.29.4-smp-writeback        6000  65536  16   60.53 272.6%    14.977     8637.08   0.21146  0.00000    22
>> > > >> >> > > > > 
>> > > >> >> > > > > 2.6.30-smp-ordered            6000  65536   8   51.09 113.4%     8.700    14856.55   0.06771  0.00417    45
>> > > >> >> > > > > 2.6.29.4-smp-ordered          6000  65536   8   56.13 130.6%     8.098     8400.45   0.03958  0.00000    43
>> > > >> >> > > > > 
>> > > >> >> > > > > 2.6.30-smp-writeback          6000  65536   8   50.19 131.7%     8.680    16821.04   0.11979  0.00208    38
>> > > >> >> > > > > 2.6.29.4-smp-writeback        6000  65536   8   54.90 130.7%     8.244     4925.48   0.10000  0.00000    42
>> > > >> >> > > >   It really seems write has some problems... There's consistently lower
>> > > >> >> > > > throughput and it also seems some writes take really long. I'll try to
>> > > >> >> > > > reproduce it here.
>> > > >> >> > > 
>> > > >> >> > > Looked "pretty solid" to me.  I haven't observed enough to ~trust.
>> > > >> >> >   OK, I did a few runs of tiobench here and I can confirm that I see about
>> > > >> >> > 6% performance regression in Sequential Write throughput between 2.6.29
>> > > >> >> > and 2.6.30-rc8. I'll try to find what's causing it.
>> > > >> >> 
>> > > >> >> My first guess would be the WRITE_SYNC style changes.  Is the regression
>> > > >> >> still there with noop?
>> > > >> >   Thanks for the hint. I was guessing that as well. And experiments show
>> > > >> > it's definitely connected. To be more precise with the data:
>> > > >> > The test machine is 2 CPU, 2 GB ram, simple lowend SATA disk. Tiobench run
>> > > >> > with:
>> > > >> > tiobench/tiobench.pl -b 65536 -t 16 -t 8 -d /local/scratch -s 4096
>> > > >> >   which means 4GB testfile, writes happen in 64k chunks, test done with 16
>> > > >> > and 8 threads. /local/scratch is a separate partition always cleaned and
>> > > >> > umounted + mounted before each test. The results are (always 3 runs):
>> > > >> >     2.6.29+CFQ:           Avg    StdDev
>> > > >> > 8   38.01 40.26 39.69 ->  39.32  0.955092
>> > > >> > 16  40.09 38.18 40.05 ->  39.44  0.891104
>> > > >> >
>> > > >> >     2.6.30-rc8+CFQ:
>> > > >> > 8   36.67 36.81 38.20 ->  37.23  0.69062
>> > > >> > 16  37.45 36.47 37.46 ->  37.13  0.464351
>> > > >> >
>> > > >> >     2.6.29+NOOP:
>> > > >> > 8   38.67 38.66 37.55 ->  38.29  0.525632
>> > > >> > 16  39.59 39.15 39.19 ->  39.31  0.198662
>> > > >> >
>> > > >> >     2.6.30-rc8+NOOP:
>> > > >> > 8   38.31 38.47 38.16 ->  38.31  0.126579
>> > > >> > 16  39.08 39.25 39.13 ->  39.15  0.0713364
>> > > >> 
>> > > >> I ran the same test on a bigger system: 8GB ram (so I used a 16GB size
>> > > >> for the test) and a 4 disk stripe hanging off of a CCISS controller.
>> > > >> All the runs used ext3 in data=ordered mode and CFQ as the I/O scheduler.
>> > > >> 
>> > > >>      2.6.29.3-140.fc11       Avg       StdDev
>> > > >>  8   158.72 152.72 148.24    153.227   5.25834
>> > > >> 16   176.06 174.91 176.27    175.747   0.73214
>> > > >> 
>> > > >>      2.6.30-rc7
>> > > >>  8   147.89 144.57 144.99    145.817   1.8078
>> > > >> 16   121.37 119.56 111.85    117.593   5.05553
>> > > >> 
>> > > >> Jan, let me know if you want any help tracking this down.
>> > > >   OK, so I've found time to follow-up on this. I've checked that
>> > > > congestion_wait fixes Jens sent recently didn't change anything. Also I've
>> > > > verified that backing out WRITE_SYNC related changes didn't help. Finally,
>> > > > I've verified that when I back out all the changes that went to CFQ between
>> > > > 2.6.29 and 2.6.30 and the WRITE_SYNC changes, then the performance is back
>> > > > to original values.
>> > > >   Jens / Jeff, what to do next? I can try to bisect through CFQ changes but
>> > > > that's going to be rather tedious and the result is uncertain since I
>> > > > expect performance to jump up and down as various changes took place. So
>> > > > I'd rather spend my time with something that has a higher chance to
>> > > > succeed...
>> > > >
>> > > 
>> > > Looking through the changelogs, I most suspect this:
>> > > 
>> > > commit 2f5cb7381b737e24c8046fd4aeab571fb71315f5
>> > > Author: Jens Axboe <jens.axboe@oracle.com>
>> > > Date:   Tue Apr 7 08:51:19 2009 +0200
>> > > 
>> > >     cfq-iosched: change dispatch logic to deal with single requests at
>> > >     the time
>> > >     
>> > > We had one other regression that bisected to this change, though I don't
>> > > claim to fully understand why just yet.  Take a look at this bug:
>> > >   http://bugzilla.kernel.org/show_bug.cgi?id=13401
>> > > 
>> > > Try Jens' test patch posted there:
>> > >   http://bugzilla.kernel.org/attachment.cgi?id=21650
>> > > 
>> > > and let us know how that fares.
>> >   It seems that with this test patch, the throughput is somewhere between
>> > 2.6.29 and 2.6.30.  I'm now repeating runs more times to get more
>> > statistical reliability because with 3 runs I did so far it's somewhere on
>> > the boundary of statistical meaningfulness...
>>   OK, I did 7 runs from each test with 8 tiobench threads only. The
>> results are:
>>   kernel           avg        99%-reliability-interval
>>   2.6.29           39.797143  0.860581
>>   2.6.30-rc8       37.441429  0.632984
>>   2.6.30-rc8+patch 37.538571  0.872624
>> 
>>   Where the 99%-reliability-interval is the interval in which "real
>> throughput" lies with 99% reliability (I did some studying of t-tests on
>> Wikipedia ;).
>>   So a conclusion is that Jens's test patch didn't change anything. I
>> guess I'll now try your patch from the referenced bug.
>   And to conclude, the numbers with your patch are:
> 2.6.30-rc8+Jeff's patch 37.934286 0.710417
>   So again no luck :(.
>
> 								Honza

OK, looking back at the blktrace data I collected, we see[1]:

Total (cciss_c0d1):         2.6.29                  2.6.30-rc7
-------------------------------------------------------------------
Writes Queued:         8,531K,   34,126MiB  |   8,526K,   34,104MiB 
Write Dispatches:    556,256,   34,126MiB   | 294,809,   34,105MiB  <===
Writes Requeued:           0                |       0               
Writes Completed:    556,256,   34,126MiB   | 294,809,   34,105MiB  
Write Merges:          7,975K,   31,901MiB  |   8,231K,   32,924MiB 
--------------------------------------------------------------------
IO unplugs:          1,253,337              | 7,346,184             <===
Timer unplugs:         1,462                |       3               

Hmmm...

commit b029195dda0129b427c6e579a3bb3ae752da3a93
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Apr 7 11:38:31 2009 +0200

    cfq-iosched: don't let idling interfere with plugging
    
    When CFQ is waiting for a new request from a process, currently it'll
    immediately restart queuing when it sees such a request. This doesn't
    work very well with streamed IO, since we then end up splitting IO
    that would otherwise have been merged nicely. For a simple dd test,
    this causes 10x as many requests to be issued as we should have.
    Normally this goes unnoticed due to the low overhead of requests
    at the device side, but some hardware is very sensitive to request
    sizes and there it can cause big slow downs.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

There were a couple of subsequent fixups to this commit:

commit d6ceb25e8d8bccf826848c2621a50d02c0a7f4ae
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Apr 14 14:18:16 2009 +0200

    cfq-iosched: don't delay queue kick for a merged request

commit 2d870722965211de072bb36b446a4df99dae07e1
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Wed Apr 15 12:12:46 2009 +0200

    cfq-iosched: tweak kick logic a bit more


So I guess that's where we need to start looking.

Cheers,
Jeff


[1] Full summary information:

2.6.29
------
Total (cciss_c0d1):
 Reads Queued:     523,572,   33,678MiB  Writes Queued:       8,531K,   34,126MiB
 Read Dispatches:  522,478,   33,678MiB  Write Dispatches:  556,256,   34,126MiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:  522,478,   33,678MiB  Writes Completed:  556,256,   34,126MiB
 Read Merges:        1,094,   67,512KiB  Write Merges:        7,975K,   31,901MiB
 IO unplugs:      1,253,337              Timer unplugs:       1,462

Throughput (R/W): 41,033KiB/s / 41,580KiB/s
Events (cciss_c0d1): 29,950,651 entries
Skips: 0 forward (0 -   0.0%)


2.6.30-rc7
----------
Total (cciss_c0d1):
 Reads Queued:     522,929,   33,625MiB  Writes Queued:       8,526K,   34,104MiB 
 Read Dispatches:  522,401,   33,625MiB  Write Dispatches:  294,809,   34,105MiB  
 Reads Requeued:         0               Writes Requeued:         0               
 Reads Completed:  522,401,   33,625MiB  Writes Completed:  294,809,   34,105MiB  
 Read Merges:          528,   24,216KiB  Write Merges:        8,231K,   32,924MiB 
 IO unplugs:      7,346,184              Timer unplugs:           3               

Throughput (R/W): 49,136KiB/s / 49,836KiB/s
Events (cciss_c0d1): 33,001,207 entries
Skips: 0 forward (0 -   0.0%)
