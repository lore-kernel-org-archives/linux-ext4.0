From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: Review of ext4-online-defrag-check-for-freespace-fragmentation.patch
Date: Sat, 13 Sep 2008 18:16:42 -0400
Message-ID: <E1KedQ2-0004sG-Py@closure.thunk.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org
To: a-fujita@rs.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60467 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbYIMWQs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 18:16:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

First, some general comments about your patch series --- I would prefer
if we didn't have a double layer of ioctl's dispatch.  That is, don't
have have ext4_ioctl() do one level of case statements, only to then
call ext4_defrag_ioctl(), which dispatches on the ioctl's a second time.
It's much better to do all of the dispatching out of the top-level
ext4_ioctl() function.

Secondly, some of the ioctl numbers chosen by the defrag patches overlap
other, already existing patches.  This is something we will need to fix,
long term.  For now, folks should know that we can't count on the ioctl
numbers being stable, since we will probably need to move them.

Finally, the patch comments don't always describe all of the changes in
the patch.  For example, in the patch
"ext4-online-defrag-check-for-freespace-fragmentation.patch", the patch
contains *far* more than just code to return the free space
fragmentation.  It defines three new ioctl:

		EXT4_IOC_GROUP_INFO
		EXT4_IOC_FREE_BLOCKS_INFO
		EXT4_IOC_EXTENTS_INFO

These ioctl's are someone odd.  First of all, EXT4_IOC_GROUP_INFO only
returns two bits of information: 

	struct ext4_group_data_info {
		int s_blocks_per_group;		/* blocks per group */
		int s_inodes_per_group;		/* inodes per group */
	};

Why just those two bits?  Userspace can easily get this information by
opening the block device directly, but if you don't want to do that, why
not just return the full 1024 byte ext4 superblock?  That would be far
more generally useful, instead of just returning these two fields.

Also, the code implementing EXT4_IOC_GROUP_INFO needlessly does a
copy_from_user() before filling in the data structure (and overwriting
all of the user data copied using copy_from_user); that's not necessary,
and should be elimiated.


The second ioctl, EXT4_IOC_FREE_BLOCKS_INFO, is very strange in that it
returns the free space available in a particular block group, but
instead of passing in a block group number, instead an inode number is
passed in.  This seems very strange, and unnecessary.

(Looking at the defrag command, it appears that the defragger only tries
to defragment an inode if can find free space in the block group
associated with the inode?  That seems highly limited.  Note
particularly that with ext4's flex_bg feature, we now freely try to
allocate blocks within a flex_bg which is composed of multiple block
groups.  Also, some of the files that most badly need defragmentation
will be the larger ones that can't possibly fit in a single block
group.)


The last ioctl, EXT4_IOC_EXTENTS_INFO, duplicates the generic FIEMAP
ioctl, and most of the implementation duplicates what is found in the
ext4-fiemap patch.  If this patch had been separated into three separate
patches, one for each ioctl, it would be easier to eliminate the
EXT4_IOC_EXTENTS_INFO changes as duplicated by other code.


More generally, I'm beginning to think the best way to make progress
with the defragmentation patches is to break out the patches into
separate ioctl's, and we should merge the read-only ioctls that return
information about the filesystem first.  These ioctl's should be made as
generally useful as possible, and if they overlap ioctl's that already
exist or are planned to be merged, such as the FIBMAP or FIEMAP
interfaces, we should figure out why we can't use the pre-existing
ioctl's first.  

For example, if we change EXT4_IOC_GROUP_INFO into something which
returns the entire ext4 superblock, then in the future if the defrag
command gains the ability to take the flex_bg feature or the RAID layout
into account, we won't need to create new ioctl's to return those
filesystem parameters.


Best regards,

						- Ted

