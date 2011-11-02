From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [BUG] e2fsprogs: mke2fs -S and e2fsck cannot recover on ext4
Date: Wed, 02 Nov 2011 17:18:57 +0900
Message-ID: <4EB0FCF1.5050509@rs.jp.nec.com>
References: <4EA9048C.8050801@rs.jp.nec.com> <4EA9B8C8.7070302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42303 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab1KBITm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Nov 2011 04:19:42 -0400
In-Reply-To: <4EA9B8C8.7070302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Eric,
(2011/10/28 5:02), Eric Sandeen wrote:
> On 10/27/11 2:13 AM, Akira Fujita wrote:
>> Hi,
>>
>> If all of the superblock and backup superblocks are corrupted,
>> mke2fs -S which reinitializes the superblock and
>> group descriptors only is a last resort to recover.
>>
>> However, on ext4, all of the files are lost with this way.
>> Because mke2fs -S for ext4 sets uninit_bg and then later e2fsck regards
>> all of block group as uninitialized one so that it can not recover
>> with bitmaps.
>>
>> Of course ext3 can recover all of the files with mke2fsk -S,
>> ext4 should be able to recover as well.
>> There is a avoidance (see #3 of the reproduce steps)
>> but an appropriate fix would be needed for e2fsck.
>>
>> * Reproduce steps and log are as follows:
>>    My e2fprogs was e2fsprogs-1.42-WIP
>>
>> 1. mkfe2s -t ext4 /dev/sdaX
>> 2. create some files on ext4
>> 3. mkfe2s -t ext4 -S -b 4096 /dev/sdaX　
>>      # This problem does not occur,
>>      # when we remove uninit_bg feature flag (-O ^uninit_bg).
> 
> It seems to me that the main bug here is that mkfs.ext4 should
> never mark blockgroups as uninit, when run with -S.  Marking
> them uninit goes against the described "not touching the inode
> table  and  the  block  and  inode bitmaps" behavior...

Thanks for comment.
Yes, I'll add the condition to mkfs.ext4 not to specify
-S and uninit_bg feature together.

Regards,
Akira FUjita

> -Eric
> 
>> 4. e2fsck /dev/sdaX
>>
>> e2fsck 1.42-WIP (16-Oct-2011)
>> Backing up journal inode block information.
>>
>> /dev/sda8 contains a file system with errors, check forced.
>> Pass 1: Checking inodes, blocks, and sizes
>> Pass 2: Checking directory structure
>> Pass 3: Checking directory connectivity
>> Root inode not allocated.  Allocate<y>? yes
>>
>> /lost+found not found.  Create<y>? yes
>>
>> Pass 4: Checking reference counts
>> Pass 5: Checking group summary information
>> Block bitmap differences:  -(8483--8486) -(33026--33027)
>> Fix<y>? yes
>>
>> Free blocks count wrong for group #0 (24286, counted=24285).
>> Fix<y>? yes
>>
>> Free blocks count wrong (1030071, counted=1030070).
>> Fix<y>? yes
>>
>> Free inodes count wrong for group #0 (8191, counted=8190).
>> Fix<y>? yes
>>
>> Directories count wrong for group #0 (1, counted=2).
>> Fix<y>? yes
>>
>> Free inodes count wrong (262143, counted=262142).
>> Fix<y>? yes
>>
>>
>> /dev/sda8: ***** FILE SYSTEM WAS MODIFIED *****
>> /dev/sda8: 2/262144 files (0.0% non-contiguous), 18506/1048576 blocks
>>
>>
>> As I reported before, e2fsck -b also can not recover with
>> backup superblock correctly.
>> # http://marc.info/?l=linux-ext4&m=131541543931429&w=2
>>
>> Is there any ideas to fix these issues?
>>
>> Regards,
>> Akira Fujita
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

The First Fundamental Software Development Group,
Platform Division, NEC Software Tohoku, Ltd.

