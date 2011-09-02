From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 10/16] ext4: Verify and calculate checksums for extent
	tree blocks
Date: Fri, 2 Sep 2011 12:02:19 -0700
Message-ID: <20110902190219.GI12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003140.31048.74275.stgit@elm3c44.beaverton.ibm.com> <26584BE9-B716-40D5-B3B4-8C5912869648@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60076 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab1IBTCl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Sep 2011 15:02:41 -0400
Content-Disposition: inline
In-Reply-To: <26584BE9-B716-40D5-B3B4-8C5912869648@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 01, 2011 at 12:40:06AM -0600, Andreas Dilger wrote:
> On 2011-08-31, at 6:31 PM, Darrick J. Wong wrote:
> > Calculate and verify the checksum for each extent tree block.  The checksum is
> > located immediately after the last ext4_extent in the block, which is typically
> > 4-8 bytes in size.
> 
> It would be more correct to write "... located in the space immediately
> following the last possible ext4_extent in the block."

Agreed.

> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > fs/ext4/ext4_extents.h |   25 ++++++++++++++++++-
> > fs/ext4/extents.c      |   64 +++++++++++++++++++++++++++++++++++++++++++++---
> > 2 files changed, 84 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> > index 095c36f..24b106a 100644
> > --- a/fs/ext4/ext4_extents.h
> > +++ b/fs/ext4/ext4_extents.h
> > @@ -62,10 +62,22 @@
> > /*
> >  * ext4_inode has i_block array (60 bytes total).
> >  * The first 12 bytes store ext4_extent_header;
> > - * the remainder stores an array of ext4_extent.
> > + * the remainder stores an array of ext4_extent,
> > + * followed by ext4_extent_tail.
> >  */
> > 
> > /*
> > + * This is the extent tail on-disk structure.
> > + * All other extent structures are 12 bytes long.  It turns out that
> > + * block_size % 12 >= 4 for all valid block sizes (1k, 2k, 4k).
> > + * Therefore, this tail structure can be crammed into the end of the block
> > + * without having to rebalance the tree.
> > + */
> > +struct ext4_extent_tail {
> > +	__le32	et_checksum;	/* crc32c(uuid+inum+extent_block) */
> > +};
> 
> Did you do any analysis of extent blocks to see whether there is enough
> space in most extents to have a larger extent tail that stores the inode
> number and generation?  This would be the same as with some directory
> blocks needing to add a directory entry to hold the checksum.

With 12-byte structures we're guaranteed 4 bytes that can be inserted without
needing to change any on-disk structures.

Most extent blocks aren't full, and provided that you decrease eh_max, you
could free up 8 more bytes for extra info.  Of course then you'd have to write
code to rebalance the extent tree whenever you find a full extent block.

It's also possible that we could simply bake i_generation into the checksum
whenever we bake in i_inum.

> > +/*
> >  * This is the extent on-disk structure.
> >  * It's used at the bottom of the tree.
> >  */
> > @@ -101,6 +113,17 @@ struct ext4_extent_header {
> > 
> > #define EXT4_EXT_MAGIC		cpu_to_le16(0xf30a)
> > 
> > +#define EXT4_EXTENT_TAIL_OFFSET(hdr) \
> > +	(sizeof(struct ext4_extent_header) + \
> > +	 (sizeof(struct ext4_extent) * le16_to_cpu((hdr)->eh_max)))
> > +
> > +static inline struct ext4_extent_tail *
> > +find_ext4_extent_tail(struct ext4_extent_header *eh)
> 
> I don't really like using "find" in this function name, since it implies
> a search is needed.  Maybe a name like ext4_extent_tail_ptr()?

Ok.

--D

> > +{
> > +	return (struct ext4_extent_tail *)(((void *)eh) +
> > +					   EXT4_EXTENT_TAIL_OFFSET(eh));
> > +}
> > +
> > /*
> >  * Array of ext4_ext_path contains path to some extent.
> >  * Creation/lookup routines use it for traversal/splitting/etc.
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 4ac4303..94f09ce 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -41,11 +41,57 @@
> > #include <linux/falloc.h>
> > #include <asm/uaccess.h>
> > #include <linux/fiemap.h>
> > +#include <linux/crc32c.h>
> > #include "ext4_jbd2.h"
> > #include "ext4_extents.h"
> > 
> > #include <trace/events/ext4.h>
> > 
> > +static __le32 ext4_extent_block_csum(struct inode *inode,
> > +				     struct ext4_extent_header *eh)
> > +{
> > +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > +	__le32 inum = cpu_to_le32(inode->i_ino);
> > +	__u32 crc = 0;
> > +
> > +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return 0;
> > +
> > +	crc = crc32c_le(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
> > +	crc = crc32c_le(crc, (__u8 *)&inum, sizeof(inum));
> > +	crc = crc32c_le(crc, (__u8 *)eh, EXT4_EXTENT_TAIL_OFFSET(eh));
> > +	return cpu_to_le32(crc);
> > +}
> > +
> > +static int ext4_extent_block_csum_verify(struct inode *inode,
> > +					 struct ext4_extent_header *eh)
> > +{
> > +	struct ext4_extent_tail *et;
> > +
> > +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return 1;
> > +
> > +	et = find_ext4_extent_tail(eh);
> > +	if (et->et_checksum != ext4_extent_block_csum(inode, eh))
> > +		return 0;
> > +	return 1;
> > +}
> > +
> > +static void ext4_extent_block_csum_set(struct inode *inode,
> > +				       struct ext4_extent_header *eh)
> > +{
> > +	struct ext4_extent_tail *et;
> > +
> > +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return;
> > +
> > +	et = find_ext4_extent_tail(eh);
> > +	et->et_checksum = ext4_extent_block_csum(inode, eh);
> > +}
> > +
> > static int ext4_split_extent(handle_t *handle,
> > 				struct inode *inode,
> > 				struct ext4_ext_path *path,
> > @@ -101,6 +147,7 @@ static int ext4_ext_dirty(handle_t *handle, struct inode *inode,
> > {
> > 	int err;
> > 	if (path->p_bh) {
> > +		ext4_extent_block_csum_set(inode, ext_block_hdr(path->p_bh));
> > 		/* path points to block */
> > 		err = ext4_handle_dirty_metadata(handle, inode, path->p_bh);
> > 	} else {
> > @@ -382,6 +429,12 @@ static int __ext4_ext_check(const char *function, unsigned int line,
> > 		error_msg = "invalid extent entries";
> > 		goto corrupted;
> > 	}
> > +	/* Verify checksum on non-root extent tree nodes */
> > +	if (ext_depth(inode) != depth &&
> > +	    !ext4_extent_block_csum_verify(inode, eh)) {
> > +		error_msg = "extent tree corrupted";
> > +		goto corrupted;
> > +	}
> > 	return 0;
> > 
> > corrupted:
> > @@ -922,6 +975,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
> > 		le16_add_cpu(&neh->eh_entries, m);
> > 	}
> > 
> > +	ext4_extent_block_csum_set(inode, neh);
> > 	set_buffer_uptodate(bh);
> > 	unlock_buffer(bh);
> > 
> > @@ -1000,6 +1054,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
> > 				sizeof(struct ext4_extent_idx) * m);
> > 			le16_add_cpu(&neh->eh_entries, m);
> > 		}
> > +		ext4_extent_block_csum_set(inode, neh);
> > 		set_buffer_uptodate(bh);
> > 		unlock_buffer(bh);
> > 
> > @@ -1098,6 +1153,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
> > 	else
> > 		neh->eh_max = cpu_to_le16(ext4_ext_space_block(inode, 0));
> > 	neh->eh_magic = EXT4_EXT_MAGIC;
> > +	ext4_extent_block_csum_set(inode, neh);
> > 	set_buffer_uptodate(bh);
> > 	unlock_buffer(bh);
> > 
> > @@ -2458,10 +2514,6 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> > 		if (uninitialized && num)
> > 			ext4_ext_mark_uninitialized(ex);
> > 
> > -		err = ext4_ext_dirty(handle, inode, path + depth);
> > -		if (err)
> > -			goto out;
> > -
> > 		/*
> > 		 * If the extent was completely released,
> > 		 * we need to remove it from the leaf
> > @@ -2483,6 +2535,10 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
> > 			le16_add_cpu(&eh->eh_entries, -1);
> > 		}
> > 
> > +		err = ext4_ext_dirty(handle, inode, path + depth);
> > +		if (err)
> > +			goto out;
> > +
> > 		ext_debug("new extent: %u:%u:%llu\n", block, num,
> > 				ext4_ext_pblock(ex));
> > 		ex--;
> > 
> 
