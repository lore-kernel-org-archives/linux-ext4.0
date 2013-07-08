From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: allocate inode table wholly within group
Date: Mon, 08 Jul 2013 13:34:03 -0500
Message-ID: <51DB061B.3020400@redhat.com>
References: <51D3269B.5080608@redhat.com> <20130707155316.GB11993@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab3GHSeF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jul 2013 14:34:05 -0400
In-Reply-To: <20130707155316.GB11993@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/7/13 10:53 AM, Theodore Ts'o wrote:
> On Tue, Jul 02, 2013 at 03:14:35PM -0400, Eric Sandeen wrote:
>> Building e2fsprogs 1.42.8 on ppc, I got this:
>>
>> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
>>
>> Because during the resize step it did this:
>>
>> Itable move group 1 block 1030->1092 (diff 62)
>>
>> but during e2fsck it found:
>>
>> /tmp/e2fsprogs-tmp.uiFhgP: Inode table for group 1 is not in group.  (block 1092)
>>
>> i.e. from dumpe2fs we can see:
>>
>> Group 1: (Blocks 1025-1110)
>>   Backup superblock at 1025, Group descriptors at 1026-1026
>>   Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
>>   Inode table at 1092-1123 (+67)
>>                       ^^^^ beyond end of block group
> 
> There seems to be something wrong here.  The test file system was
> created like this:
> 
>   mke2fs -t ext2 -O ^resize_inode -b 1024 -g 1024 -qF /tmp/foo.img 64M
> 
> The file system hence should have 64 block groups, and dumpe2fs before
> the resize looks like this on an x86 system:
> 
> Group 1: (Blocks 1025-2048)
>   Backup superblock at 1025, Group descriptors at 1026-1027
>   Block bitmap at 1028 (+3), Inode bitmap at 1029 (+4)
>   Inode table at 1030-1061 (+5)
> 
> ... and after:
> 
> Group 1: (Blocks 1025-2048)
>   Backup superblock at 1025, Group descriptors at 1026-1089
>   Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
>   Inode table at 1092-1123 (+67)
> 
> Note the range of block group #1: 1025-2048, whereas on the PPC,
> apparently the range is quite different: Group 1: (Blocks 1025-1110)
> 
> So there's something else going really wrong here....

I don't think so - that's only after the shrink, right?

However, I understand your confusion.  The test is not at all obvious
about what it's doing:

> test_description="ext2 1024 blocksize with small block groups"
> FEATURES="-t ext2 -O ^resize_inode -b 1024 -g 1024"
> SIZE_1=64M
> SIZE_2=2G
> LOG=$test_name.log
> E2FSCK=../e2fsck/e2fsck
> 
> 
> . $cmd_dir/scripts/resize_test

Um, ok, so we "resize test" with those parameters.

Looking at that script, which sadly has no comments, it invokes
a resize to $SIZE_2 (2G) first, but then does something different:

# grep RESIZE tests/scripts/resize_test | grep -v echo
if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 $TMPFILE $SIZE_2 >> $LOG 2>&1
if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1
if ! $RESIZE2FS $RESIZE2FS_OPTS -d 31 -M $TMPFILE $SIZE_2 >> $LOG 2>&1

so it does 4 resizes; the last 3 are using "-M" which says "go to the
minimum size."   Which is a weird thing to do when also specifying
an actual size:

# grep "\-M" tests/r_1024_small_bg.log 
../resize/resize2fs -d 31 -M /tmp/e2fsprogs-tmp.LoNby5 2G
../resize/resize2fs -d 31 -M /tmp/e2fsprogs-tmp.LoNby5 2G
../resize/resize2fs -d 31 -M /tmp/e2fsprogs-tmp.LoNby5 2G

But the 2G is ignored.... so it's re-resizing to minimum sizes.  On x86:

# grep -w "resize\|is now" tests/r_1024_small_bg.log 
../resize/resize2fs -d 31 /tmp/e2fsprogs-tmp.LoNby5 2G
The filesystem on /tmp/e2fsprogs-tmp.LoNby5 is now 2097152 blocks long.
../resize/resize2fs -d 31 -M /tmp/e2fsprogs-tmp.LoNby5 2G
The filesystem on /tmp/e2fsprogs-tmp.LoNby5 is now 1174 blocks long.
../resize/resize2fs -d 31 -M /tmp/e2fsprogs-tmp.LoNby5 2G
The filesystem on /tmp/e2fsprogs-tmp.LoNby5 is now 1002 blocks long.

on the failing PPC build:

# grep -w "resize\|is now" tests/r_1024_small_bg.log 
../resize/resize2fs -d 31 /tmp/e2fsprogs-tmp.4KTO7a 2G
The filesystem on /tmp/e2fsprogs-tmp.4KTO7a is now 2097152 blocks long.
../resize/resize2fs -d 31 -M /tmp/e2fsprogs-tmp.4KTO7a 2G
The filesystem on /tmp/e2fsprogs-tmp.4KTO7a is now 1247 blocks long.
../resize/resize2fs -d 31 -M /tmp/e2fsprogs-tmp.4KTO7a 2G
The filesystem on /tmp/e2fsprogs-tmp.4KTO7a is now 1121 blocks long.

so they're both shrinking quite a bit.  But I think due to the vagaries
of the initial filesystem population, the test is behaving differently
and just happening to hit this corner case.

On the last failing run, the minimum size happens to be calculated
at 1121 blocks; with debug printfs:

> ../resize/resize2fs -d 31 -M /tmp/e2fsprogs-tmp.gB4G7E 2G
> resize2fs 1.42.8 (20-Jun-2013)
> forcing to min size 1121
> Resizing the filesystem on /tmp/e2fsprogs-tmp.gB4G7E to 1121 (1k) blocks.

But what's weird is that in this resize run it didn't actually
move the inode table; that was done in a prior minimization run,
and in this case it seems to have simply shrunk past the existing
inode table end.  Argh.  Still looking.

-Eric

