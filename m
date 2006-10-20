From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH/RFC] - make ext3 more robust in the face of filesystem
 corruption
Date: Thu, 19 Oct 2006 23:00:20 -0500
Message-ID: <453849D4.80601@redhat.com>
References: <45369869.60400@redhat.com> <20061018214022.GJ3509@schatzie.adilger.int> <4536A31F.5050604@redhat.com> <20061018222449.GK3509@schatzie.adilger.int> <4537A1FB.6030601@redhat.com> <4537FF97.2010400@redhat.com> <20061020035018.GX3509@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:31134 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1946191AbWJTEAZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Oct 2006 00:00:25 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061020035018.GX3509@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Oct 19, 2006  17:43 -0500, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> How about just tweaking the existing ext3_bread so that it lets the
>>> caller know whether or not it found an uptodate buffer?  Seems
>>> conceivable that more than just the dir code might want to do a data
>>> sanity check, based on if this is a fresh read or not.
>>>
>>> Could maybe even change the *err argument to a *retval; negative on
>>> errors, else 0 == not read (found uptodate), 1 == fresh read (not found
>>> uptodate).  Or is that too much overloading...
>> I played around with this a little bit today, and it seems to have some
>> tangible results.  A fairly unsophisticated test of running "find" over
>> my whole root filesystem 10 times :) with and without re-checking cached
>> directory entries, yielded about a 10% speedup when skipping the re-checks.
>>
>> Is this something we want to do?  Are we comfortable with only checking
>> directory entries the first time they are read from disk?
> 
> Well, we already do this on ext2 without noticable problems.  As you say,
> if we are getting memory corruption we are in for a world of hurt in other
> areas.  The only case that might be worth checking inside the loop is if
> rec_len == 0, so that we don't spin on a bad entry forever.

Sounds good, I'll whip up a patch; probably one patch first to add the checks & 
fix the corruptor tests, and follow up with one to be smarter about the checks 
in all cases.

Thanks,

-eric
