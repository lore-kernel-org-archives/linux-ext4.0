From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Status of META_BG?
Date: Fri, 16 Mar 2012 09:42:19 -0400
Message-ID: <4F63433B.1020904@ubuntu.com>
References: <4F620EDA.8030701@ubuntu.com> <20D13AAA-070A-4EE4-AC97-B553DC916228@dilger.ca> <4F622D18.3020805@ubuntu.com> <0A38CCE3-2F78-4B0E-9D5E-6C261EA61902@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:3936 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031249Ab2CPNmW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Mar 2012 09:42:22 -0400
In-Reply-To: <0A38CCE3-2F78-4B0E-9D5E-6C261EA61902@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/15/2012 5:06 PM, Andreas Dilger wrote:
>> To get an fs that large, you have to enable 64bit support, which also means you can pass the limit of 32k blocks per group.
>
> I'm not sure what you mean here.  Sure, there can be more than 32k
> blocks per group, but there is still only a single block bitmap per
> group so having more blocks is dependent on a larger blocksize.

Heh, I'm not sure what you mean here.  What does the block bitmap have 
to do with anything?  I thought the issue was that the size of the block 
group descriptor table exceeded the size of a block group, as a result 
of there being a huge number of block groups, limited to a size of 128 MB.

>>   Doing that should allow for a much more reasonable number of groups ( which is a good thing several reasons ), and would also solve this problem wouldn't it?
>
> Possibly in conjunction with BIGALLOC.

BIGALLOC?

>> So it puts one GD block at the start of every several block groups?
>
> One at the start of the first group, the second group, and the last
> group.

You mean one copy of the whole table?  That's not what the current code 
in e2fsprogs looks like it does to me.  openfs.c has:

> blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
>                                      dgrp_t i)
> {
>         int     bg;
>         int     has_super = 0;
>         blk64_t ret_blk;
>
>         if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
>             (i < fs->super->s_first_meta_bg))
>                 return (group_block + i + 1);
>
>         bg = EXT2_DESC_PER_BLOCK(fs->super) * i;
>         if (ext2fs_bg_has_super(fs, bg))
>                 has_super = 1;
>         ret_blk = ext2fs_group_first_block2(fs, bg) + has_super;

That appears to map the GDT block number to a block group based on how 
many group descriptors fit in a block, so there's one GDT block every 
several block groups.  The subsequent code then checks if it is being 
asked for a backup and shifts the result over by one whole block group, 
so it looks like there is exactly one backup, whose blocks are each 
stored in the block group following the one that holds the corresponding 
primary GDT block.

>>   Wouldn't that drastically slow down opening/mounting the fs since the disk has to seek to every block group?
>
> Yes, definitely.  That wasn't a concern before flex_bg arrived, since
> that seek was needed for every group's block/inode bitmap as well.

But you don't need to scan every bitmap at mount time do you?  Aren't 
they loaded on demand when the group is first accessed?  But you do need 
to scan all of the group descriptors at mount time.

> Maybe with bigalloc the number of groups is reduced, and the size
> of the groups is increased, which helps two ways.  First, fewer
> groups means fewer GD blocks, and larger groups mean more GD blocks
> can fit into the 0th and 1st groups.

That's what I was talking about.  I'm not sure what bigalloc is, but 
once you enable 64bit, that gets you the ability to have more than 32768 
blocks per group, so you have less groups and more room in them.

> Well, the "mke2fs -S" is only applying a best guess estimate of the
> metadata location using default parameters.  If the default parameters
> are not identical (e.g. flex_bg on/off, bigalloc on/off, etc) then
> "mke2fs -S" will only corrupt an already-fatally-corrupted filesystem,
> and you need to start from scratch.

That's true of mke2fs -S, but you could do the same thing, but consult 
the existing superblock to determine the parameters.  I believe that all 
parameters that affect the contents of the GDT can be found in the 
superblock.  Specifically, block size,  blocks per group, flex factor. 
Given that information, e2fsck should be able to rebuild the GDT.

