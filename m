From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Performance regressions in 2.6.30-rc7?
Date: Wed, 10 Jun 2009 18:12:50 -0400
Message-ID: <x4963f3rb4t.fsf@segfault.boston.devel.redhat.com>
References: <200905282249.28592.diegocg@gmail.com>
	<20090529210718.bef7a9c1.akpm@linux-foundation.org>
	<200905301851.47708.diegocg@gmail.com>
	<20090603195806.GA9571@atrey.karlin.mff.cuni.cz>
	<1244100382.7131.12.camel@marge.simson.net>
	<20090604112109.GC2859@duck.suse.cz>
	<1244142795.5731.31.camel@marge.simson.net>
	<20090609103208.GB9235@duck.suse.cz> <20090609184818.GD9556@think>
	<20090610091211.GA13692@duck.suse.cz>
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
Received: from mx2.redhat.com ([66.187.237.31]:34186 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZFJWNH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2009 18:13:07 -0400
In-Reply-To: <20090610091211.GA13692@duck.suse.cz> (Jan Kara's message of
	"Wed, 10 Jun 2009 11:12:11 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Tue 09-06-09 14:48:18, Chris Mason wrote:
>> On Tue, Jun 09, 2009 at 12:32:08PM +0200, Jan Kara wrote:
>> > On Thu 04-06-09 21:13:15, Mike Galbraith wrote:
>> > > On Thu, 2009-06-04 at 13:21 +0200, Jan Kara wrote:
>> > > 
>> > > > > Sequential Writes
>> > > > > 2.6.30-smp-ordered            6000  65536  32   50.16 508.9%    31.996    45595.78   0.64965  0.02402    10
>> > > > > 2.6.29.4-smp-ordered          6000  65536  32   52.70 543.2%    33.658    23794.92   0.71754  0.00836    10
>> > > > > 
>> > > > > 2.6.30-smp-writeback          6000  65536  32   47.82 525.4%    35.003    32588.84   0.56192  0.02298     9
>> > > > > 2.6.29.4-smp-writeback        6000  65536  32   52.52 467.6%    32.397    12972.78   0.53580  0.00522    11
>> > > > > 
>> > > > > 2.6.30-smp-ordered            6000  65536  16   56.08 254.9%    15.463    33000.68   0.39687  0.00521    22
>> > > > > 2.6.29.4-smp-ordered          6000  65536  16   62.40 308.4%    14.701    13455.02   0.13125  0.00208    20
>> > > > > 
>> > > > > 2.6.30-smp-writeback          6000  65536  16   51.90 281.4%    17.098    12869.85   0.36771  0.00104    18
>> > > > > 2.6.29.4-smp-writeback        6000  65536  16   60.53 272.6%    14.977     8637.08   0.21146  0.00000    22
>> > > > > 
>> > > > > 2.6.30-smp-ordered            6000  65536   8   51.09 113.4%     8.700    14856.55   0.06771  0.00417    45
>> > > > > 2.6.29.4-smp-ordered          6000  65536   8   56.13 130.6%     8.098     8400.45   0.03958  0.00000    43
>> > > > > 
>> > > > > 2.6.30-smp-writeback          6000  65536   8   50.19 131.7%     8.680    16821.04   0.11979  0.00208    38
>> > > > > 2.6.29.4-smp-writeback        6000  65536   8   54.90 130.7%     8.244     4925.48   0.10000  0.00000    42
>> > > >   It really seems write has some problems... There's consistently lower
>> > > > throughput and it also seems some writes take really long. I'll try to
>> > > > reproduce it here.
>> > > 
>> > > Looked "pretty solid" to me.  I haven't observed enough to ~trust.
>> >   OK, I did a few runs of tiobench here and I can confirm that I see about
>> > 6% performance regression in Sequential Write throughput between 2.6.29
>> > and 2.6.30-rc8. I'll try to find what's causing it.
>> 
>> My first guess would be the WRITE_SYNC style changes.  Is the regression
>> still there with noop?
>   Thanks for the hint. I was guessing that as well. And experiments show
> it's definitely connected. To be more precise with the data:
> The test machine is 2 CPU, 2 GB ram, simple lowend SATA disk. Tiobench run
> with:
> tiobench/tiobench.pl -b 65536 -t 16 -t 8 -d /local/scratch -s 4096
>   which means 4GB testfile, writes happen in 64k chunks, test done with 16
> and 8 threads. /local/scratch is a separate partition always cleaned and
> umounted + mounted before each test. The results are (always 3 runs):
>     2.6.29+CFQ:           Avg    StdDev
> 8   38.01 40.26 39.69 ->  39.32  0.955092
> 16  40.09 38.18 40.05 ->  39.44  0.891104
>
>     2.6.30-rc8+CFQ:
> 8   36.67 36.81 38.20 ->  37.23  0.69062
> 16  37.45 36.47 37.46 ->  37.13  0.464351
>
>     2.6.29+NOOP:
> 8   38.67 38.66 37.55 ->  38.29  0.525632
> 16  39.59 39.15 39.19 ->  39.31  0.198662
>
>     2.6.30-rc8+NOOP:
> 8   38.31 38.47 38.16 ->  38.31  0.126579
> 16  39.08 39.25 39.13 ->  39.15  0.0713364

I ran the same test on a bigger system: 8GB ram (so I used a 16GB size
for the test) and a 4 disk stripe hanging off of a CCISS controller.
All the runs used ext3 in data=ordered mode and CFQ as the I/O scheduler.

     2.6.29.3-140.fc11       Avg       StdDev
 8   158.72 152.72 148.24    153.227   5.25834
16   176.06 174.91 176.27    175.747   0.73214

     2.6.30-rc7
 8   147.89 144.57 144.99    145.817   1.8078
16   121.37 119.56 111.85    117.593   5.05553

Jan, let me know if you want any help tracking this down.

Cheers,
Jeff
