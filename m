From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 0/10] ext4 online defrag (ver 0.5)
Date: Thu, 21 Jun 2007 10:51:10 +0900
Message-ID: <20070621105110t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62404 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXFUBvM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 21:51:12 -0400
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l5L1pApD014639
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:51:10 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l5L1pA616782 for linux-ext4@vger.kernel.org; Thu, 21 Jun 2007 10:51:10 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l5L1p9O02335 for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:51:09 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070621.105108.87500836 for <linux-ext4@vger.kernel.org>
	; Thu, 21 Jun 2007 10:51:08 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I have updated my online defrag patchset for addition of a new function.
This function is defragmentation for free space.
If filesytem has insufficient contiguous free blocks, defrag tries to move
other files to make sufficient space and reallocates the contiguous blocks
for the target file.

This function can be used in the following fashion:
# e4defrag -f filename [blockno]

For create contiguous free blocks, reallocate target file to
the block group to which its inode belongs.
If set "blockno", defrag tries to move other files (except target file)
to indicated physical block offset, otherwise defrag tries to move them to 
the next block group to which its inode belongs.

Maximum of the target file size is same as capable maximum
size of one block group.

This time I add 6 ioctls for new function 
and they are used in order of the following.

Additional ioctl: 
- EXT4_IOC_GROUP_INFO
- EXT4_IOC_FREE_BLOCKS_INFO
- EXT4_IOC_EXTENTS_INFO
- EXT4_IOC_MOVE_VICTIM
- EXT4_IOC_RESERVE_BLOCK
- EXT4_IOC_BLOCK_RELEASE

1). Get s_blocks_per_group and s_inodes_per_group of target file.
(EXT4_IOC_GROUP_INFO)

In userspace, calculate block group number to which target file belongs with
the result of "1".

2). Get free blocks information of the target block group.
(EXT4_IOC_FREE_BLOCKS_INFO)
Read block bitmap of target block group then set
free block distribution to ext4_extents_info structure
as extents array. Finally return it to userspace.

3). Get all extents information of indicated inode number.
(EXT4_IOC_EXTENTS_INFO)
Set extents information of indicated inode number
to ext4_extent_info structure then return it to userspace. 

In userspace, call ioctl(EXT4_IOC_EXTENTS_INFO) for all of inodes
in the target group and calculate the combination of extents
which should be moved to other block group with the results of 2) and 3).
Its size will be same as target file's.

4). Move combination of extents from the target block group
to other block group to make free contiguous area in the target block group.
(EXT4_IOC_MOVE_VICTIM)

5). Reserve freed blocks of the target block group.
(EXT4_IOC_RESERVE_BLOCK)

6). Reallocate target file to reserved contiguous blocks with ext4_ext_defrag().
(EXT4_IOC_DEFRAG)

Current status:
These patches are at the experimental stage so they have issues and
items to improve. But these are worth enough to examine my trial.

Dependencies:
My patches depend on the following Alex's patches of the multi-block
allocation for Linux 2.6.19-rc6.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

Outstanding issues:
Nothing for the moment.

Items to improve:
- Optimize the depth of extent tree and the number of leaf nodes
  after defragmentation.
- The blocks on the temporary inode are moved to the original inode
  by a page in the current implementation.  I have to tune
  the pages unit for the performance.
- Update the base kernel version when Alex's multi-block allocation patch
  is updated. 

Next steps:
- Make carry out movement of data as atomic transaction.
- Reduce the defrag influence upon other process with fadvice().


Summary of patches:
*These patches apply on top of Alex's patches.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

[PATCH 1/10] Allocate new contiguous blocks with Alex's mballoc
- Search contiguous free blocks and allocate them for the temporary
  inode with Alex's multi-block allocation.

[PATCH 2/10] Move the file data to the new blocks
- Move the blocks on the temporary inode to the original inode
  by a page.

[PATCH 3/10] Get block group information
- Get s_blocks_per_group and s_inodes_per_group of target filesystem.

[PATCH 4/10] Get free blocks distribution of the target block group
- Get free blocks distribution of the target block group to know
  how many free blocks it has.

[PATCH 5/10] Get all extents information of indicated inode number
- Get all extents information of indicated inode number to calculate
the combination of extents which should be moved to other block group.

[PATCH 6/10] Move files from target block group to other block group
- To make contiguous free blocks, move files from the target block group
  to other block group. 

[PATCH 7/10] Reserve freed blocks
- Reserve the free blocks in the target area, not to be
  used by other process

[PATCH 8/10] Release reserved blocks
- Release reserved blocks if defrag failed.

[PATCH 9/10] Fix bugs in multi-block allocation and locality-group
- Move lg_list to s_locality_dirty in ext4_lg_sync_single_group()
  to flush all of dirty inodes.
- Fix ext4_mb_new_blocks() to return err value when defrag failed.

[PATCH 10/10] Online defrag command
- The defrag command.  Usage is as follows:
  o Put the multiple files closer together.
    # e4defrag -r directory-name
  o Defrag for free space fragmentation.
    # e4defrag -f file-name
  o Defrag for a single file.
    # e4defrag file-name
  o Defrag for all files on ext4.
    # e4defrag device-name

Any comments from reviews or tests are very welcome.

Cheers, Takashi
