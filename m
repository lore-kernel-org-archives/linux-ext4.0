From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 50/74] libext2fs: support allocating uninit blocks in
 bmap2()
Date: Wed, 15 Jan 2014 17:19:51 -0500
Message-ID: <20140115221951.GA12226@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012353.30655.82545.stgit@birch.djwong.org>
 <20140111225755.GB10995@thunk.org>
 <20140115211122.GJ9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48756 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbaAOWTz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jan 2014 17:19:55 -0500
Content-Disposition: inline
In-Reply-To: <20140115211122.GJ9229@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 15, 2014 at 01:11:22PM -0800, Darrick J. Wong wrote:
> > The other thing to note about this patch is that if you want to
> > implement fallocate, ext2fs_bmap2() is really the wrong tool to use.
> > I've been working on a program for work which pre-creates a bunch of
> 
> I think that ext2fs_fallocate would be a good addition to the library.  Is your
> program far enough along to share?  fuse2fs would benefit greatly.

An ext2fs_fallocate() is way more difficult than what I've done, since
you have to deal with all sorts of corner cases where the file has
pre-existing sparse extents, which may or may not be initialized, and
making sure that it works in that case.  Allocating blocks to a file
which you know started as a zero length file is in fact much easier.
Here are the key bits from my program:

/*
 * This should eventually be cleaned up and put into libext2fs
 * This is much faster than calling ext2fs_block_alloc_stats() for each
 * block, since it requires recalculating the bg descriptor checksum
 * for every single block that you allocate.
 */
static void ext2fs_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
					   blk_t num, int inuse)
{
	int	group;

#ifndef OMIT_COM_ERR
	if (blk + num >= ext2fs_blocks_count(fs->super)) {
		com_err("ext2fs_block_alloc_stats_range", 0,
			"Illegal block range: %llu (%u) ",
			(unsigned long long) blk, num);
		return;
	}
#endif
	if (inuse == 0)
		return;
	if (inuse > 0) {
		ext2fs_mark_block_bitmap_range2(fs->block_map, blk, num);
		inuse = 1;
	} else {
		ext2fs_unmark_block_bitmap_range2(fs->block_map, blk, num);
		inuse = -1;
	}
	while (num) {
		group = ext2fs_group_of_blk2(fs, blk);
		blk64_t last_blk = ext2fs_group_last_block2(fs, group);
		blk_t n = num;

		if (blk + num > last_blk)
			n = last_blk - blk + 1;

		ext2fs_bg_free_blocks_count_set(fs, group, 
			ext2fs_bg_free_blocks_count(fs, group) -
			inuse*n/EXT2FS_CLUSTER_RATIO(fs));
		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
		ext2fs_group_desc_csum_set(fs, group);

		ext2fs_free_blocks_count_add(fs->super, -inuse * n);
		ext2fs_mark_super_dirty(fs);
		ext2fs_mark_bb_dirty(fs);
		blk += n;
		num -= n;
	}
}

/* 
 * ext2fs_allocate_tables() is not optimally allocating blocks in all
 * situations.  We need to take a look at this at some point.  For
 * now, just replace it with something simple and stupid.
 */ 
errcode_t my_allocate_tables(ext2_filsys fs)
{
	errcode_t	retval;
	dgrp_t		i;

	for (i = 0; i < fs->group_desc_count; i++) {
		retval = ext2fs_new_block2(fs, goal, NULL, &goal);
		if (retval)
			return retval;
		ext2fs_block_alloc_stats2(fs, goal, +1);
		ext2fs_block_bitmap_loc_set(fs, i, goal);
	}
	for (i = 0; i < fs->group_desc_count; i++) {
		retval = ext2fs_new_block2(fs, goal, NULL, &goal);
		if (retval)
			return retval;
		ext2fs_block_alloc_stats2(fs, goal, +1);
		ext2fs_inode_bitmap_loc_set(fs, i, goal);
	}
	for (i = 0; i < fs->group_desc_count; i++) {
		blk64_t end = ext2fs_blocks_count(fs->super) - 1;
		retval = ext2fs_get_free_blocks2(fs, goal, end,
						 fs->inode_blocks_per_group,
						 fs->block_map, &goal);
		if (retval)
			return retval;
		ext2fs_block_alloc_stats_range(fs, goal,
					       fs->inode_blocks_per_group, +1);
		ext2fs_inode_table_loc_set(fs, i, goal);
	}
	return 0;
}

/* 
 * Some of this could eventually get turned into fallocate, but that's
 * actually a much more difficult and tricking thing to implement.
 */
static errcode_t mk_hugefile(ext2_filsys fs, unsigned int num, 
			     ext2_ino_t dir, int idx, ext2_ino_t *ino)

{
	errcode_t		retval;
	blk64_t			lblk, blk, bend;
	__u64			size;
	unsigned int		i;
	struct ext2_inode	inode;
	ext2_extent_handle_t	handle;
	char			fn[32];

	retval = ext2fs_new_inode(fs, 0, LINUX_S_IFREG, NULL, ino);
	if (retval)
		return retval;

	memset(&inode, 0, sizeof(struct ext2_inode));
	inode.i_mode = LINUX_S_IFREG | 0600;
	ext2fs_iblk_set(fs, &inode, num / EXT2FS_CLUSTER_RATIO(fs));
	size = (__u64) num * fs->blocksize;
	inode.i_size = size & 0xffffffff;
	inode.i_size_high = (size >> 32);
	inode.i_links_count = 1;

	retval = ext2fs_write_new_inode(fs, *ino, &inode);
	if (retval)
		return retval;

	ext2fs_inode_alloc_stats2(fs, *ino, +1, 0);

	retval = ext2fs_extent_open2(fs, *ino, &inode, &handle);
	if (retval)
		return retval;

	{
		struct ext2_inode t;

		ext2fs_read_inode(fs, *ino, &t);
		printf("eo: i_size_high: %lu size: %llu\n", t.i_size_high,
		       EXT2_I_SIZE(&t));
	}
	lblk = 0;
	while (num) {
		blk64_t pblk, end;
		blk_t n = num;

		retval =  ext2fs_find_first_zero_block_bitmap2(fs->block_map,
			goal, ext2fs_blocks_count(fs->super) - 1, &end);
		if (retval)
			return ENOSPC;
		goal = end;

		retval =  ext2fs_find_first_set_block_bitmap2(fs->block_map, goal,
			       ext2fs_blocks_count(fs->super) - 1, &bend);
		if (bend == ENOENT)
			bend = ext2fs_blocks_count(fs->super);
		if (bend - goal < num)
			n = bend - goal;
		printf("goal %llu bend %llu num %u n %u\n", goal, bend, num, n);
		pblk = goal;
		num -= n;
		goal += n;
		ext2fs_block_alloc_stats_range(fs, pblk, n, +1);

		while (n) {
			blk_t l = n;
			struct ext2fs_extent newextent;

	{
		struct ext2_inode t;

		ext2fs_read_inode(fs, *ino, &t);
		printf("i_size_high: %lu size: %llu\n", t.i_size_high,
		       EXT2_I_SIZE(&t));
	}

			if (l > EXT_INIT_MAX_LEN)
				l = EXT_INIT_MAX_LEN;

			newextent.e_len = l;
			newextent.e_pblk = pblk;
			newextent.e_lblk = lblk;
			newextent.e_flags = 0;

			printf("inserting extent: %llu %llu %u\n", lblk, pblk, l);
			retval = ext2fs_extent_insert(handle,
					EXT2_EXTENT_INSERT_AFTER, &newextent);
			if (retval)
				return retval;
			pblk += l;
			lblk += l;
			n -= l;
		}
	}

	{
		struct ext2_inode t;

		ext2fs_read_inode(fs, *ino, &t);
		printf("i_size_high: %lu size: %llu\n", t.i_size_high,
		       EXT2_I_SIZE(&t));
	}
	sprintf(fn, "hugefile%05d", idx);
retry:
	retval = ext2fs_link(fs, dir, fn, *ino, EXT2_FT_REG_FILE);
	if (retval == EXT2_ET_DIR_NO_SPACE) {
		retval = ext2fs_expand_dir(fs, dir);
		if (retval)
			goto errout;
		goto retry;
	}

	if (retval)
		goto errout;

errout:
	if (handle)
		ext2fs_extent_free(handle);

	return retval;
}

Note that this requires some of the test patches I've been sending
out, since it uses ext2fs_find_first_{set,zero}_block_bitmap2().

There are also some bugs in the versions which I sent out; I'm working
on fixing them....

> That said, I've also found a couple of bugs in the extent code by implementing
> fallocate in such a stupid way. :)  It turns out that if (a) we need to split
> an extent into three pieces (say we write to a block in the middle of an
> unwritten extent and don't want to convert the whole extent) and (b) either of
> the extent_insert calls requires us to split the extent block and (c) we ENOSPC
> while trying to allocate a new extent block, we don't put the extent tree back
> the way it was before the split, and all the blocks after that point are lost.

Well, I found a bug in extfs_extent_insert() which showed up when I
tried to implement the block allocation in an intelligent way.  :-)
I'll send out that bug fix a bit.


> I will send patches to avoid this corruption by checking for enough space soon.
> I think your local git tree has patches in it that aren't on kernel.org yet, so
> I'll hold off until I see them show up.

Yeah, some of those patches still need some clean up, so I haven't
pushed my maint branch to kernel.org yet.

But anyway, the above code will give you an idea where I'm going ---
this is **way** faster than trying to allocate blocks using the
set_bmap() function.  :-)

						- Ted
