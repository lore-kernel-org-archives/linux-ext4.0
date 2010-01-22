From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH] default max mount count to unused
Date: Fri, 22 Jan 2010 13:57:16 -0500
Message-ID: <4B59F50C.20601@redhat.com>
References: <4B5785A5.2010505@redhat.com> <20100122012929.GA21263@thunk.org> <4B591D80.6010309@redhat.com> <4B7FFE9D-F110-408D-B432-7D20AEBD4689@sun.com> <4B59DA16.3060906@redhat.com> <2B15E63C-8EE9-4675-B659-5D1A302334C8@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, tytso@mit.edu,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab0AVS45 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2010 13:56:57 -0500
In-Reply-To: <2B15E63C-8EE9-4675-B659-5D1A302334C8@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/22/2010 01:40 PM, Andreas Dilger wrote:
> On 2010-01-22, at 10:02, Ric Wheeler wrote:
>>> I've thought for quite a while that 20 mounts is too often, but I'm
>>> reluctant to turn it off completely. I wouldn't object to increasing
>>> it to 60 or 80.
>>>
>>> At one time there was a patch that checked the state of the
>>> filesystem at mount time and only incremented only 1/5 of the time
>>> (randomly) if it was unmounted cleanly (not dirty, or not in
>>> recovery), but every time if it crashed. The reasoning was that
>>> systems which crashed are more likely to have memory corruption or
>>> software bugs, and ones that shut down cleanly are less likely to
>>> have such problems.
>>>
>>
>> I do like the snapshot idea, but also think that we need something
>> will not introduce random (potentially multi-hour or multi-day) fsck
>> runs after an otherwise clean reboot.
>>
>> If we hit this with a combination of:
>>
>> Reboot time:
>> (1) Try to mount the file system
>> (1) on mount failure, fsck the failed file system
>
> Well, this is essentially what already happens with e2fsck today, though
> it correctly checks the filesystem for errors _first_, and _then_ mounts
> the filesystem. Otherwise it isn't possible to fix the filesystem after
> mount, and mounting a filesystem with errors is a recipe for further
> corruption and/or a crash/reboot cycle.

I think that we have to move towards an assumption that our journalling code 
actually works - the goal should be that we can *always* mount after a crash or 
clean reboot. That should be the basic test case - pound on a file system, drop 
power to the storage (and or server) and then on reboot, try to remount. 
Verification would be in the QA test case to unmount and fsck to make sure our 
journal was robust.

Note that in a technique that I have used in the past (with reiserfs) at large 
scale in actual deployments of hundreds of thousands of file systems. It does 
work pretty well in practice.

The key here is that any fsck can be a huge delay, pretty much unacceptable in 
production shops, where they might have multiple file systems per box.

>
>> While up and running, do a periodic check with the snapshot trick.
>
> Yes, this is intended to reset the periodic mount/time counter to avoid
> the non-error boot-time check. If that is not running correctly then the
> periodic check would still be done as a fail-safe measure.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>

