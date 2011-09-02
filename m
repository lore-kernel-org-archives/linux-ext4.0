From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 08/16] ext4: Calculate and verify checksums for inode
	bitmaps
Date: Fri, 2 Sep 2011 12:18:28 -0700
Message-ID: <20110902191828.GL12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <20110901003127.31048.13983.stgit@elm3c44.beaverton.ibm.com> <2A834E5A-F07E-4B1E-835B-FBEE3FD7A103@dilger.ca>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2A834E5A-F07E-4B1E-835B-FBEE3FD7A103@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 31, 2011 at 10:49:05PM -0600, Andreas Dilger wrote:
> On 2011-08-31, at 6:31 PM, Darrick J. Wong wrote:
> > Compute and verify the checksum of the inode bitmap; the checkum is stored in
> > the block group descriptor.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > fs/ext4/ext4.h   |    3 ++-
> > fs/ext4/ialloc.c |   33 ++++++++++++++++++++++++++++++---
> > 2 files changed, 32 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index bc7ace1..248cbd2 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -279,7 +279,8 @@ struct ext4_group_desc
> > 	__le16	bg_free_inodes_count_hi;/* Free inodes count MSB */
> > 	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
> > 	__le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
> > -	__u32	bg_reserved2[3];
> > +	__le32	bg_inode_bitmap_csum;	/* crc32c(uuid+group+ibitmap) */
> > +	__u32	bg_reserved2[2];
> > };
> 
> I would prefer if there was a 16-bit checksum for the (most common)
> 32-byte group descriptors, and this was extended to a 32-bit checksum
> for the (much less common) 64-byte+ group descriptors.  For filesystems
> that are newly formatted with the 64bit feature it makes no difference,
> but virtually all ext3/4 filesystems have only the smaller group descriptors.
> 
> Regardless of whether using half of the crc32c is better or worse than
> using crc16 for the bitmap blocks, storing _any_ checksum is better than
> storing nothing at all.  I would propose the following:

That's an interesting reframing of the argument that I hadn't considered.  I'd
fallen into the idea of needing crc32c because of its bit error guarantees (all
corruptions of odd numbers of bits and all corruptions of fewer than ...4?
bits) that I hadn't quite realized that even if crc16 can't guarantee to find
any corruption at all, it still _might_, and that's better than nothing.

Ok, let's split the 32-bit fields and use crc16 for the case of 32-byte block
group descriptors.

> struct ext4_group_desc
> {
>         __le32 bg_block_bitmap_lo;	/* Blocks bitmap block */
>         __le32 bg_inode_bitmap_lo;	/* Inodes bitmap block */
>         __le32 bg_inode_table_lo;	/* Inodes table block */
>         __le16 bg_free_blocks_count_lo;	/* Free blocks count */
>         __le16 bg_free_inodes_count_lo;	/* Free inodes count */
>         __le16 bg_used_dirs_count_lo;	/* Directories count */
>         __le16 bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
>         __le32 bg_exclude_bitmap_lo;	/* Exclude bitmap block */
>         __le16 bg_block_bitmap_csum_lo;	/* Block bitmap checksum */
> 	__le16 bg_inode_bitmap_csum_lo;	/* Inode bitmap checksum */
>         __le16 bg_itable_unused_lo;	/* Unused inodes count */
>         __le16 bg_checksum;		/* crc16(sb_uuid+group+desc) */
>         __le32 bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
>         __le32 bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
>         __le32 bg_inode_table_hi;	/* Inodes table block MSB */
>         __le16 bg_free_blocks_count_hi;	/* Free blocks count MSB */
>         __le16 bg_free_inodes_count_hi;	/* Free inodes count MSB */
>         __le16 bg_used_dirs_count_hi;	/* Directories count MSB */
>         __le16 bg_itable_unused_hi;	/* Unused inodes count MSB */
> 	__le32 bg_exclude_bitmap_hi;	/* Exclude bitmap block MSB */
> 	__le16 bg_block_bitmap_csum_hi;	/* Blocks bitmap checksum MSB */
> 	__le16 bg_inode_bitmap_csum_hi;	/* Inodes bitmap checksum MSB */
>         __le32 bg_reserved2;
> };
> 
> This is also different from your layout because it locates the block bitmap
> checksum field before the inode bitmap checksum, to more closely match the
> order of other fields in this structure.

Er.. I reversed the order in the structure definition just prior to publishing,
and forgot to update the wiki page.  Well I guess I'm about to update it again.
:)

> > /*
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index 9c63f27..53faffc 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -82,12 +82,18 @@ static unsigned ext4_init_inode_bitmap(struct super_block *sb,
> > 		ext4_free_inodes_set(sb, gdp, 0);
> > 		ext4_itable_unused_set(sb, gdp, 0);
> > 		memset(bh->b_data, 0xff, sb->s_blocksize);
> > +		ext4_bitmap_csum_set(sb, block_group,
> > +				     &gdp->bg_inode_bitmap_csum, bh,
> > +				     (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
> 
> The number of inodes per group is already always a multiple of 8.

Ok.  I suppose we can fix that in the lines below too.

> > 		return 0;
> > 	}
> > 
> > 	memset(bh->b_data, 0, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
> > 	ext4_mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), sb->s_blocksize * 8,
> > 			bh->b_data);
> > +	ext4_bitmap_csum_set(sb, block_group, &gdp->bg_inode_bitmap_csum, bh,
> > +			     (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
> > +	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
> > 
> > 	return EXT4_INODES_PER_GROUP(sb);
> > }
> > @@ -118,12 +124,12 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
> > 		return NULL;
> > 	}
> > 	if (bitmap_uptodate(bh))
> > -		return bh;
> > +		goto verify;
> > 
> > 	lock_buffer(bh);
> > 	if (bitmap_uptodate(bh)) {
> > 		unlock_buffer(bh);
> > -		return bh;
> > +		goto verify;
> > 	}
> > 
> > 	ext4_lock_group(sb, block_group);
> > @@ -131,6 +137,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
> > 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
> > 		set_bitmap_uptodate(bh);
> > 		set_buffer_uptodate(bh);
> > +		set_buffer_verified(bh);
> > 		ext4_unlock_group(sb, block_group);
> > 		unlock_buffer(bh);
> > 		return bh;
> > @@ -144,7 +151,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
> > 		 */
> > 		set_bitmap_uptodate(bh);
> > 		unlock_buffer(bh);
> > -		return bh;
> > +		goto verify;
> > 	}
> > 	/*
> > 	 * submit the buffer_head for read. We can
> > @@ -161,6 +168,21 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
> > 			    block_group, bitmap_blk);
> > 		return NULL;
> > 	}
> > +
> > +verify:
> > +	ext4_lock_group(sb, block_group);
> > +	if (!buffer_verified(bh) &&
> > +	    !ext4_bitmap_csum_verify(sb, block_group,
> > +				     desc->bg_inode_bitmap_csum, bh,
> > +				     (EXT4_INODES_PER_GROUP(sb) + 7) / 8)) {
> > +		ext4_unlock_group(sb, block_group);
> > +		put_bh(bh);
> > +		ext4_error(sb, "Corrupt inode bitmap - block_group = %u, "
> > +			   "inode_bitmap = %llu", block_group, bitmap_blk);
> > +		return NULL;
> 
> At some point we should add a flag like EXT4_BG_INODE_ERROR so that the
> group can be marked in error on disk, and skipped for future allocations,
> but the whole filesystem does not need to be remounted read-only.  That's
> for another patch, however.

Agreed. :)

--D

> > +	}
> > +	ext4_unlock_group(sb, block_group);
> > +	set_buffer_verified(bh);
> > 	return bh;
> > }
> > 
> > @@ -265,6 +287,8 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
> > 		ext4_used_dirs_set(sb, gdp, count);
> > 		percpu_counter_dec(&sbi->s_dirs_counter);
> > 	}
> > +	ext4_bitmap_csum_set(sb, block_group, &gdp->bg_inode_bitmap_csum,
> > +			     bitmap_bh, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
> > 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
> > 	ext4_unlock_group(sb, block_group);
> > 
> > @@ -784,6 +808,9 @@ static int ext4_claim_inode(struct super_block *sb,
> > 			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
> > 		}
> > 	}
> > +	ext4_bitmap_csum_set(sb, group, &gdp->bg_inode_bitmap_csum,
> > +			     inode_bitmap_bh,
> > +			     (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
> > 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
> > err_ret:
> > 	ext4_unlock_group(sb, group);
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
