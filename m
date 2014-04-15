From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Date: Tue, 15 Apr 2014 14:13:59 -0500
Message-ID: <534D84F7.30003@redhat.com>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu> <20140413220016.GD8122@thunk.org> <alpine.LFD.2.00.1404151749490.2146@localhost.localdomain> <534D5B2D.70408@redhat.com> <20140415184442.GC4456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaDOTOD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 15:14:03 -0400
In-Reply-To: <20140415184442.GC4456@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/15/14, 1:44 PM, Theodore Ts'o wrote:
> On Tue, Apr 15, 2014 at 11:15:41AM -0500, Eric Sandeen wrote:
>>
>> I tend to agree, better to fix the kernel than to add a knob to turn it
>> off.  And fsx changes can happen a lot quicker than kernel changes.  [1]
>>
>> And if it's really unsafe, and you really want to add a knob, I'd at least
>> default it to off until it's non-corrupting, and add a message that
>> this tunable will go away as soon as it's stable, so you'll have no
>> qualms about quickly deprecating it...
> 
> Yeah, I went back and forth on this.  One of there reasons why I added
> a kernel knob is that *I* can make the kernel change a lot faster than
> it would be to tweak all of the various xfstests program to globally
> disable certain operations in fsx, fstress, etc.
> 
> I also had a sneaking suspicion that we might have a similar issue
> with the INSERT RANGE patches which are coming down the pike, and so
> having a general way of also being able INSERT RANGE if to be able to
> quickly determine whether a potential bug was caused by INSERT RANGE
> or some other pending changes might also be useful.
> 
> I freely admit it is a bit of a hack, though.  Does the hack smell
> less bad if we wrap it in CONFIG_EXT4FS_DEBUG?
> 
>> [1] it'd be nifty to make an env. var in xfstests which can globally
>> disable certain fsx operations across all tests which run fsx...
> 
> Yes, although as I mentioned above, it would be really nice if it
> worked across all of the various tests, and not just be limited to
> fsx, or even just fsx and fstress.

Well, for tests which are specific to collapse range, it'd be trivial
to add a "collapse" group, and exclude it.

For generic stress tests which happen to do collapse range, it'd take
a bit more.  But that'd probably still be the generic solution.

XFS got bitten too, there were collapse range problems.  But the fixes
are already in the pipe AFAIK.

-Eric

> 					- Ted
> 
> 
> 

