From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Tue, 24 Feb 2009 15:41:08 -0700
Message-ID: <20090224224108.GQ3199@webber.adilger.int>
References: <20090218154310.GH3600@mini-me.lan>
 <20090224085931.GA25657@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60519 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZBXWld (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 17:41:33 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1OMfR2O028450
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 14:41:28 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFL00300CZPU700@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 24 Feb 2009 14:41:27 -0800 (PST)
In-reply-to: <20090224085931.GA25657@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote something like the following (didnt' get original email):
> @@ -122,6 +122,9 @@ struct ext4_inode_info {
>  	struct list_head i_prealloc_list;
>  	spinlock_t i_prealloc_lock;
> 
> +	/* ialloc */
> +	ext4_group_t	i_last_alloc_group;

Even better would be to store i_last_alloc_inode.  In the past Eric
has demonstrated workloads that are allocating lots of inodes exhibit
O(n^2) behaviour because the entire group bitmap is searched from the
start each time, and that can cumulatively be very slow.  Having the
directory start searching from the most recently allocated inode would
make this O(n), and would not significantly alter behaviour.

If the inode is newly read from disk this would be initialized to 0,
or the inode number of the directory.  If it was recently creating
files it should be the previously allocated inode.  The only issue
is with inodes being repeatedly created and deleted in the same
directory, in which case we could reset this at delete time to be

    max(first inode in group, directory inode)

so that the same inodes keep being reused by the directory.  This could
be limited to clearing last_alloc_inode if the inode being freed is in
the parent group.

Hmm, it seems something like this is already done in find_group_orlov().
More discussion there.

> @@ -170,10 +172,23 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
> +	if (flex_size >= 4) {
> +		block_group &= ~(flex_size-1);
> +		if (S_ISREG(inode->i_mode))
> +			block_group++;
> +	}

The usage of "4" in several places to threshold flexbg size is also
confusing to me.

> +	bg_start = (block_group * EXT4_BLOCKS_PER_GROUP(inode->i_sb)) +
>  		le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_first_data_block);
>  	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;

Similar to the above proposal, Eric and I discussed storing the most
recently selected (flex) group in the superblock would avoid repeated
group scanning for allocations in separate directories.

> @@ -446,12 +481,21 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
> +	if (flex_size < 4)
> +		flex_size = 1;
> +	else {

Generally CodingStyle has { } around the first "if" clause if they are
around the "else" clause.

> @@ -460,71 +504,85 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
> +	if (S_ISDIR(mode) &&
> +	    ((parent == sb->s_root->d_inode) ||
> +	     (EXT4_I(parent)->i_flags & EXT4_TOPDIR_FL))) {
> 
>  		get_random_bytes(&grp, sizeof(grp));
>  		parent_group = (unsigned)grp % ngroups;
>  		for (i = 0; i < ngroups; i++) {
> +			g = (parent_group + i) % ngroups;
> +			get_orlov_stats(sb, g, flex_size, &stats);

Two notes here -
- get_random_bytes() is actually a fairly CPU-intensive operation, though
  I'm not sure it is significant in this context
- more importantly, scanning ALL groups in a very large filesystem to find
  an optimal group.  Large filesystems can have upwards of 60-100k groups
  to scan, and even with flexbg it seems that get_orlov_stats() is not
  using the flex_group[] stats in the common case where flex_size is the
  same as the flexbg size, but recalculating these for every allocation.

> +			if (!stats.free_inodes)
>  				continue;
> +			if (stats.used_dirs >= best_ndir)
>  				continue;
> +			if (stats.free_inodes < avefreei)
>  				continue;
> +			if (stats.free_blocks < avefreeb)
>  				continue;
> +			grp = g;
>  			ret = 0;
> +			best_ndir = stats.used_dirs;

Based on the above, it would be preferable to settle for a "local"
optimal group after scanning N successful candidates, then checking
the "most recently selected" group saved in the superblock if it is
still better than the local optimum.  Of course it should continue to
scan all groups if there are no suitable groups yet found.

Since the starting group is random, this will avoid being stuck in
a bad local minimum, while avoiding an exhaustive search when there
are a lot of groups.

> +	min_inodes = avefreei - inodes_per_group*flex_size / 4;
> +	min_blocks = avefreeb - EXT4_BLOCKS_PER_GROUP(sb)*flex_size / 4;

style - "inodes_per_group * flex_size / 4"

>  static int find_group_other(struct super_block *sb, struct inode *parent,
> +			    ext4_group_t *group, int mode)
>  {
> +	/*
> +	 * If we are doing flex_bg style allocation, try to put
> +	 * special inodes in the first block group; start files and
> +	 * directories at the 2nd block group in the flex_bg.
> +	 */
> +	if (flex_size >= 4) {
> +		int ret, retry = 0;
> +
> +	try_again:
> +		i = (parent_group & ~(flex_size-1));
> +		last = i+flex_size;

Can you please use a better variable name than "i", "grp", or
"new_group" or similar?

> +		while (i < last) {
> +			desc = ext4_get_group_desc(sb, i, NULL);
> +			if (desc && ext4_free_inodes_count(sb, desc)) {
> +				*group = i;
> +				return 0;
> +			}
> +			i++;
> +		}
> +		if (!retry && EXT4_I(parent)->i_last_alloc_group != ~0) {
> +			retry = 1;
> +			parent_group = EXT4_I(parent)->i_last_alloc_group;
> +			goto try_again;
> +		}

It would seem that using i_last_alloc_group FIRST (if set) would be better
than always checking all groups in the flexbg.  Either i_last_alloc_group
is in the same flex group as parent_group (so no harm done) or a previous
allocation wasn't able to find any free inode in that flex group and it
had to do a more expensive search elsewhere.

All that needs to be changed is to possibly reset i_last_alloc_group
to be parent_group when there is a file unlinked from the directory,
though this wouldn't be great for huge directories since any unlink
would cause a full scan.

Hmm, maybe checking ONLY the parent group for free inodes, then the
i_last_alloc_group, then remaining groups in the flex group, then
all remaining groups is the best ordering.  It allows inodes to be
clustered if there is space in the parent group (whether due to freeing
inodes in this directory or others), but avoids a potentially lengthy
scan for each inode (which might be noticable if there are 64 or 128
groups per flexbg).



Another possibility is if the starting goal inode was based on the group
a majority of dirent inode numbers in the same directory leaf.  This would
require deferring inode number selection until the dirent is about to be
inserted (i.e. delalloc for inodes) by moving the inode selection into
ext4_add_entry().  Combining this with a hash->inode range mapping
(as I've proposed in the past, range size based on the directory size)
would improve the htree->inode ordering and would also improve performance
for large directories.

It might not be a bad idea to separate the inode selection from the
inode initialization anyway, as ext4_new_inode() is pretty huge already,
and I can't see anything except the i_ino setting and insert_inode_hash()
that is use the inode number.  That means it should be possible to defer
the inode selection to ext4_add_entry() and ext4_dx_add_entry() once the
leaf block is found.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

