From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] default max mount count to unused
Date: Fri, 22 Jan 2010 12:06:11 -0700
Message-ID: <AF87FDA9-09D0-421D-9459-94310206B4EB@sun.com>
References: <4B5785A5.2010505@redhat.com> <20100122012929.GA21263@thunk.org>
 <4B591D80.6010309@redhat.com> <4B7FFE9D-F110-408D-B432-7D20AEBD4689@sun.com>
 <4B59DA16.3060906@redhat.com> <2B15E63C-8EE9-4675-B659-5D1A302334C8@sun.com>
 <4B59F50C.20601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, tytso@mit.edu,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37277 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0AVTGO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jan 2010 14:06:14 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0MJ6DlE020787
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2010 11:06:13 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KWN00C00X148L00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 22 Jan 2010 11:06:13 -0800 (PST)
In-reply-to: <4B59F50C.20601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-22, at 11:57, Ric Wheeler wrote:
> On 01/22/2010 01:40 PM, Andreas Dilger wrote:
>>> Reboot time:
>>> (1) Try to mount the file system
>>> (1) on mount failure, fsck the failed file system
>>
>> Well, this is essentially what already happens with e2fsck today,  
>> though
>> it correctly checks the filesystem for errors _first_, and _then_  
>> mounts
>> the filesystem. Otherwise it isn't possible to fix the filesystem  
>> after
>> mount, and mounting a filesystem with errors is a recipe for further
>> corruption and/or a crash/reboot cycle.
>
> I think that we have to move towards an assumption that our  
> journalling code actually works - the goal should be that we can  
> *always* mount after a crash or clean reboot. That should be the  
> basic test case - pound on a file system, drop power to the storage  
> (and or server) and then on reboot, try to remount. Verification  
> would be in the QA test case to unmount and fsck to make sure our  
> journal was robust.

I think you are missing an important fact here.  While e2fsck _always_  
runs on a filesystem at boot time (or at least this is the recommended  
configuration), this initial e2fsck run is only doing a very minimal  
amount of work (i.e. it is NOT a full "e2fsck -f" run).  It checks  
that the superblock is sane, it recovers the journal, and it looks for  
error flags written to the journal and/or superblock.  If all of those  
tests pass (i.e. less than a second of work) then the e2fsck run  
passes (excluding periodic checking, which IMHO is the only issue  
under discussion here).

> Note that in a technique that I have used in the past (with  
> reiserfs) at large scale in actual deployments of hundreds of  
> thousands of file systems. It does work pretty well in practice.
>
> The key here is that any fsck can be a huge delay, pretty much  
> unacceptable in production shops, where they might have multiple  
> file systems per box.

No, there is no delay if the filesystem does not have any errors.  I  
consider the lack of ANY minimal boot-time sanity checking a serious  
problem with reiserfs and advised Hans many times to have minimal  
sanity checks at boot.

The problem is that if the kernel (or a background snapshot e2fsck)  
detects an error then the only way it can force a full check to  
correct is to do this on the next boot, by storing some information in  
the superblock.  If the filesystem is mounted at boot time without  
even a minimal check for such error flags in the superblock then the  
error may never be corrected, and in fact may cause cascading  
corruption elsewhere in the filesystem (e.g. corrupt bitmaps, bad  
indirect block pointers, etc).

If the filesystem is mounted with "errors=panic" (often done with HA  
configs to allow failover in case of node/cable/HBA errors) then any  
corruption on disk will just result in the node getting stuck in a  
reboot cycle with no automated e2fsck being run.

>>> While up and running, do a periodic check with the snapshot trick.
>>
>> Yes, this is intended to reset the periodic mount/time counter to  
>> avoid
>> the non-error boot-time check. If that is not running correctly  
>> then the
>> periodic check would still be done as a fail-safe measure.
>>
>> Cheers, Andreas
>> --
>> Andreas Dilger
>> Sr. Staff Engineer, Lustre Group
>> Sun Microsystems of Canada, Inc.
>>
>


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

