From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Fri, 11 Jul 2008 14:57:47 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0807111400460.31436@diagnostix.dwd.de>
References: <20080616175408.GF3279@atrey.karlin.mff.cuni.cz>
 <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu>
 <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de>
 <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker>
 <20080710092517.GB16451@skywalker> <Pine.LNX.4.64.0807110947290.31436@diagnostix.dwd.de>
 <20080711124304.GB8154@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:45380 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYGKO5y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jul 2008 10:57:54 -0400
In-Reply-To: <20080711124304.GB8154@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 11 Jul 2008, Theodore Tso wrote:

> On Fri, Jul 11, 2008 at 09:57:47AM +0000, Holger Kiehl wrote:
>> Thanks. Reverting that patch also fixed it for me. I was able to do my
>> test however performance is down another 10% (compared to
>> ext4-patch-queue-52c8a02a8a7b7e5915b9301e9c171b4faf22b928). ext4 is getting
>> slower and slower :(
>
> How reproducible are your results?  That is, if you run the benchmarks
> multiple times, how much variance is there between different runs?
>
I always run the benchmark 3 times and then take the average. Additionally
there are two main types of test one where files are moved locally (FILE)
and another where files are send via FTP. So its 6 runs with the following
results:

     FTP        FILE
     2548.81    6569.68
     2613.05    6480.86
     2599.09    6573.62

I then took all six runs added them and diveded by six giving 4564.19 fps.
Those results where achived with a5d48915 and e2fsprogs-1.41-WIP-0707.tar.bz2.

The same was done with 52c8a02a only here I used the April 27th e2fsprogs.
There I got 5054.86 fps.

Each run takes 30 minutes and approx. 10 minutes to delete the test files
from a previous run and setup the new test files, that is approx. 4 hours
for all 6 runs. I then also always do a 2 hour test run with a lot more
files and process sending files, one for FTP and one for FILE. But I
did not mention those numbers because I always did it once. But here too
one could see the numbers going down by approx. 10%.

> If you are willing, this would be helpful.  In your ext4 patch
> repository, try out commit 179a876b.  (You can do this via
> "git checkout -b rc9-rebase 179a876b"; after doing the test you can
> switch the working directory of the ext4 patch queue back to the master
> branch via "git checkout master".)   This commit is pretty much
> identical to your previous 52c8a02a test, modulo rebasing to -rc9.
>
That is why I did another test run with ext3 which I did not mention, sorry.
Here the results:

                  ext3       ext4-patch-queue
     52c8a02a     5536.79    5054.86
     a5d48915     5587.78    4564.19

So the result of ext3 are the same while ext4-patch-queue dropped the
nearly 10%.

> If you see the same results, you could try going to the next patch,
> via "git checkout -b i-blocks-stat ef019f0a" which also has the fix so
> that stat returns a valid i_blocks field for files that have been
> freshly written when delayed allocation is enabled.  Both of these
> revisions rae before the patches that were causing corrupion were
> added to the patch queue, so it should be fine.
>
> The funny thing is looking at the various recent patches, I don't see
> how they could be affecting performance of your patches so
> significantly.  I gather afdbench is very metadata intensive, with
> lots of small files, but even so, none of these patches should make
> that kind of difference.  So that's why I'm wondering how much
> variance there is between runs of afdbench, and whether that might be
> a possible explanation.
>
>> Also the group descriptors still get corrupted.
>
> Hmm, can you send me the output of dumpe2fs before and after the
> benchmark run which corrupts the group descriptors?  And can you send
> me the output of "e2fsck -fy /dev/XXXXX >& /tmp/log", so I can see
> what got corrupted?
>
> I also note that you are using a fairly old e2fsprogs from April 27th.
> You might want to try going to the just-released e2fsprogs 1.41.0
> released yesterday, as that has some flex_bg layout changes that might
> help out performance for afdbench.
>
Where those changes already in e2fsprogs-1.41-WIP-0707.tar.bz2 release?

> Also note that with both the April
> 27th and the latest e2fsprogs 1.41.0 release, there is a mke2fs.conf
> file in misc/mke2fs.conf that should be installed in /etc/mke2fs.conf
> for best results.
>
Since I made my own src rpm, I did use the misc/mke2fs.conf in both cases.
Just checked this.

Holger

