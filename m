From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [PATCH 1/2 bigalloc] e2fsprogs: remove wrong EXT2FS_C2B in check_block_end
Date: Fri, 12 Aug 2011 11:44:41 +0800
Message-ID: <CAFZ0FUXHeiU3d_6XsXLD7shzw=bW_WhLSTuh5R9BimWP=bn-_Q@mail.gmail.com>
References: <1312429682-16970-1-git-send-email-hao.bigrat@gmail.com>
	<1312429682-16970-2-git-send-email-hao.bigrat@gmail.com>
	<20110811024933.GC3625@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44855 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1HLDom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 23:44:42 -0400
Received: by qyk38 with SMTP id 38so121293qyk.19
        for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 20:44:41 -0700 (PDT)
In-Reply-To: <20110811024933.GC3625@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/8/11 Ted Ts'o <tytso@mit.edu>:
> On Thu, Aug 04, 2011 at 11:48:02AM +0800, Robin Dong wrote:
>> From: Robin Dong <sanbai@taobao.com>
>>
>> The argument "save_blocks_count" and the block bitmap has the unit o=
f cluster,
>> so it don't need EXT2FS_C2B to convert argument "i".
>>
>> This patch is based on "next" branch of e2fsprogs.
>>
>> Signed-off-by: Robin Dong <sanbai@taobao.com>
>> Cc: Ted Ts'o <tytso@mit.edu>
>
> No, I don't think this is right. =A0Regardless of whether the unit of
> the block bitmap is cluster- or block- (only while mke2fs is running,
> and only initially) based, the argument to
> ext2fs_{test,mark,unmark}_block_bitmap is always in blocks.
>
> That's why the EXT2FS_C2B is necessary.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>

Hi, Ted

Last week I did some wrecking-case to test e2fsck ("next" branch) and
find a error in it:

1. misc/mke2fs -m 0 -O
^has_journal,^resize_inode,^uninit_bg,bigalloc,extent,meta_bg,flex_bg
/dev/sda4
2. copy some file into /dev/sda4
3. set an inode's mode to zero
4. e2fsck -f /dev/sda4

it report something like:

e2fsck 1.42-WIP (02-Jul-2011)
Pass 1: Checking inodes, blocks, and sizes
Inode 314, i_blocks is 128, should be 0.  Fix<y>? yes

Pass 2: Checking directory structure
Inode 314 (/c/3) has invalid mode (00).
Clear<y>? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -529632
=46ix<y>? yes

=46ree blocks count wrong for group #1 (32267, counted=3D32268).
=46ix<y>? yes

=46ree blocks count wrong (13838736, counted=3D13838752).
=46ix<y>? yes

Illegal block number passed to ext2fs_test_block_bitmap #13874128 for
converted cluster bitmap
Padding at end of block bitmap is not set. Fix<y>? yes

Illegal block number passed to ext2fs_mark_block_bitmap #13874128 for
converted cluster bitmap
Illegal block number passed to ext2fs_mark_block_bitmap #13874144 for
converted cluster bitmap
Illegal block number passed to ext2fs_mark_block_bitmap #13874160 for
converted cluster bitmap
Illegal block number passed to ext2fs_mark_block_bitmap #13874176 for
converted cluster bitmap
Illegal block number passed to ext2fs_mark_block_bitmap #13874192 for
converted cluster bitmap
Illegal block number passed to ext2fs_mark_block_bitmap #13874208 for
converted cluster bitmap
Illegal block number passed to ext2fs_mark_block_bitmap #13874224 for
converted cluster bitmap
=2E......

my disk has just 13874128 4k-blocks, so the block number must have
some problems.
So I doubt at the check_block_end in pass5.c.
Could you please shed some light on it?


--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
