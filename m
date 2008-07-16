From: Theodore Tso <tytso@mit.edu>
Subject: Re: Suggestions for a 64bit bitmap api
Date: Wed, 16 Jul 2008 09:41:24 -0400
Message-ID: <20080716134124.GU8185@mit.edu>
References: <87y742110t.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39171 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756277AbYGPNlZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 09:41:25 -0400
Content-Disposition: inline
In-Reply-To: <87y742110t.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 02:12:02PM +0200, Goswin von Brederlow wrote:
> 
> which api would you prefer?

There is a lot of comments about my plan for 64-bit bitmaps in the pu
branch of e2fsprogs, in lib/ext2fs/gen_bitmap64.c.

Quoting from there:

/*
 * Design of 64-bit bitmaps
 *
 * In order maintain ABI compatibility with programs that don't
 * understand about 64-bit blocks/inodes,
 * ext2fs_allocate_inode_bitmap() and ext2fs_allocate_block_bitmap()
 * will create old-style bitmaps unless the application passes the
 * flag EXT2_FLAG_NEW_BITMAPS to ext2fs_open().  If this flag is
 * passed, then we know the application has been recompiled, so we can
 * use the new-style bitmaps.  If it is not passed, we have to return
 * an error if trying to open a filesystem which needs 64-bit bitmaps.
 *
 * The new bitmaps use a new set of structure magic numbers, so that
 * both the old-style and new-style interfaces can identify which
 * version of the data structure was used.  Both the old-style and
 * new-style interfaces will support either type of bitmap, although
 * of course 64-bit operation will only be possible when both the
 * new-style interface and the new-style bitmap are used.
 *
 * For example, the new bitmap interfaces will check the structure
 * magic numbers and so will be able to detect old-stype bitmap.  If
 * they see an old-style bitmap, they will pass it to the gen_bitmap.c
 * functions for handling.  The same will be true for the old
 * interfaces as well.
 *
 * The new-style interfaces will have several different back-end
 * implementations, so we can support different encodings that are
 * appropriate for different applications.  In general the default
 * should be whatever makes sense, and what the application/library
 * will use.  However, e2fsck may need specialized implementations for
 * its own uses.  For example, when doing parent directory pointer
 * loop detections in pass 3, the bitmap will *always* be sparse, so
 * e2fsck can request an encoding which is optimized for that.
 */

struct ext2fs_struct_generic_bitmap64 {
	errcode_t	magic;
	ext2_filsys 	fs;
	struct  *	bitmap_ops;
	int		flags;
	__u64		start, end;
	__u64		real_end;
	char	*	description;
	void	*	private;
	errcode_t	base_error_code;
};

struct ext2_bitmap_ops {
	int	type;
	/* Generic bmap operators */
	errcode_t (*new_bmap)(ext2_filsys fs, errcode_t magic,
			      int type, u64 start, __u64 end,
			      __u64 real_end,
			      const char * description,
			      ext2fs_generic_bitmap64 *bmap);
	void	(*free_bmap)(ext2fs_generic_bitmap64 bitmap);
	void	(*copy_bmap)(ext2fs_generic_bitmap64 src,
			     ext2fs_generic_bitmap64 *dest);
	void	(*resize_bmap)(ext2fs_generic_bitmap64 bitmap,
			       __u64 new_end,
			       __u64 new_real_end);
	/* XXX still need file operators */
	/* bit set/test operators */
	void	(*set_bmap)(ext2fs_generic_bitmap64 bitmap, __u64 arg);
	void	(*clear_bmap)(ext2fs_generic_bitmap64 bitmap, __u64 arg);
	int	(*test_bmap)(ext2fs_generic_bitmap64 bitmap, __u64 arg);
	void	(*set_bmap_range)(ext2fs_generic_bitmap64 bitmap, __u64 arg,
				  int num);
	void	(*clear_bmap_range)(ext2fs_generic_bitmap64 bitmap, __u64 arg,
				    int num);
};

extern errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
					   int type, u64 start, __u64 end,
					   __u64 real_end,
					   const char * description,
					   ext2fs_generic_bitmap64 *bmap);

extern void_t ext2fs_free_generic_bmap(ext2fs_generic_bitmap64 bmap);

extern errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap64 src,
					  ext2fs_generic_bitmap64 *dest);

extern errcode_t ext2fs_resize_generic_bmap(ext2fs_generic_bitmap bmap,
					    __u64 new_end,
					    __u64 new_real_end);

extern void ext2fs_set_generic_bmap(ext2fs_generic_bitmap64 bitmap,
				    __u64 arg);
extern void ext2fs_clear_generic_bmap(ext2fs_generic_bitmap64 bitmap,
				      __u64 arg);
extern int ext2fs_test_generic_bmap(ext2fs_generic_bitmap64 bitmap,
				    __u64 arg);
extern void ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap64 bitmap,
					  __u64 arg, int num);
extern void ext2fs_clear_generic_bmap_range(ext2fs_generic_bitmap64 bitmap,
					    __u64 arg, int num);

