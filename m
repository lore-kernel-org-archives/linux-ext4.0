From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH, RFC 00/12] bigalloc patchset
Date: Mon, 21 Mar 2011 09:55:07 +0100
Message-ID: <5427513F-76B9-4315-AC17-4BF35B290B18@dilger.ca>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:51703 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1CUIzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2011 04:55:15 -0400
In-Reply-To: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-19, at 10:28 PM, Theodore Ts'o wrote:
> This is an initial patchset of the bigalloc patches to ext4.  This patch
> adds support for clustered allocation, so that each bit in the ext4
> block allocation bitmap addresses a power of two number of blocks.  For
> example, if the file system is mainly going to be storing large files in
> the 4-32 megabyte range, it might make sense to set a cluster size of 1
> megabyte.  This means that each bit in the block allocaiton bitmap would
> now address 256 4k blocks, and it means that the size of the block
> bitmaps for a 2T file system shrinks from 64 megabytes to 256k.  It also
> means that a block group addresses 32 gigabytes instead of 128
> megabytes, also shrinking the amount of file system overhead for
> metadata.
> 
> The cost is increased disk space efficiency.  Directories will consume
> 1T, as will extent tree blocks.

Presumably you mean "1M" here and not "1T"?

> (I am on the fence as to whether I
> should add complexity so that in the rare case that an inode needs more
> than 344 extents --- a highly fragmented file indeed --- and need a
> second extent tree block, we can avoid allocating any cluster and
> instead use another block from the cluster used by the inode.  The
> concern is the amount of complexity this adds to the e2fsck, not just to
> the kernel.)

It would be a shame to waste another MB of space just to allocate 4kB for the next indirect block...  I guess it isn't clear to me why the index blocks need to be treated differently from file data blocks or directory blocks in this regard, since they both can use multiple blocks from the same cluster.  Being able to use the full cluster would allow 256 * 344 = 88064 extents, or 11TB to be addressed by the cluster of index blocks, which should be plenty.

Unfortunately, the overhead of allocating a whole cluster for every index block and every directory is fairly high.  For Lustre it matters very little, since there are only a handful of directories (under 40) on the data filesystems where this would be used and the real directory tree is located on a different metadata filesystem which probably wouldn't use this feature, but for most "normal" users this overhead may become prohibitive.  That is why I've been trying to think of a way to allow sub-cluster allocations for these uses.

> To test these patches, I have used an *extremely* kludgy set of patches
> to e2fsprogs, which are attached below.  These patches need *extensive*
> revision before I would consider them clean enough suitable for
> committing into e2fsprogs, but they were sufficient for me to do the
> kernel-side changes --- mke2fs, dumpe2fs, and debugfs work.  E2fsck most
> definitely does _not_ work at this stage.
> 
> Please comment!  I do not intend for these patches to be merged during
> the 2.6.39 merge window.  I am targetting 2.6.40, 3 months from now,
> since these patches are quite extensive.

Is that before or after e2fsck support for this will be done?  I'm rather reluctant to commit anything to the kernel that doesn't have e2fsck support in a released e2fsprogs.

> 							- Ted
> 
> Theodore Ts'o (12):
> ext4: read-only support for bigalloc file systems
> ext4: enforce bigalloc restrictions (e.g., no online resizing, etc.)
> ext4: Convert instances of EXT4_BLOCKS_PER_GROUP to
>   EXT4_CLUSTERS_PER_GROUP
> ext4: Remove block bitmap initialization in ext4_new_inode()
> ext4: factor out block group accounting into functions
> ext4: split out ext4_free_blocks_after_init()
> ext4: bigalloc changes to block bitmap initialization functions
> ext4: Convert block group-relative offsets to use clusters
> ext4: teach ext4_ext_map_blocks() about the bigalloc feature
> ext4: teach ext4_statfs() to deal with clusters if bigalloc is
>   enabled
> ext4: tune mballoc's default group prealloc size for bigalloc file
>   systems
> ext4: enable mounting bigalloc as read/write
> 
> fs/ext4/balloc.c  |  268 +++++++++++++++++++++++++++++++++--------------------
> fs/ext4/ext4.h    |   47 ++++++++--
> fs/ext4/extents.c |  132 +++++++++++++++++++++++---
> fs/ext4/ialloc.c  |   37 --------
> fs/ext4/inode.c   |    7 ++
> fs/ext4/ioctl.c   |   33 ++++++-
> fs/ext4/mballoc.c |   49 ++++++----
> fs/ext4/mballoc.h |    3 +-
> fs/ext4/super.c   |  100 ++++++++++++++++----
> 9 files changed, 472 insertions(+), 204 deletions(-)
> 
> -- 
> 1.7.3.1
> 
> ------------------- e2fsprogs patches follow below
> 
> diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
> index b0aa84c..cfbdfd6 100644
> --- a/lib/ext2fs/bmap64.h
> +++ b/lib/ext2fs/bmap64.h
> @@ -31,6 +31,10 @@ struct ext2fs_struct_generic_bitmap {
> 	 ((bmap)->magic == EXT2_ET_MAGIC_BLOCK_BITMAP64) || \
> 	 ((bmap)->magic == EXT2_ET_MAGIC_INODE_BITMAP64))
> 
> +/* Bitmap flags */
> +
> +#define EXT2_BMFLAG_CLUSTER 0x0001
> +
> struct ext2_bitmap_ops {
> 	int	type;
> 	/* Generic bmap operators */
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index a89e33b..0970506 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -228,9 +228,13 @@ struct ext2_dx_countlimit {
> 
> #define EXT2_BLOCKS_PER_GROUP(s)	(EXT2_SB(s)->s_blocks_per_group)
> #define EXT2_INODES_PER_GROUP(s)	(EXT2_SB(s)->s_inodes_per_group)
> +#define EXT2_CLUSTERS_PER_GROUP(s)	(EXT2_SB(s)->s_clusters_per_group)
> #define EXT2_INODES_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s)/EXT2_INODE_SIZE(s))
> /* limits imposed by 16-bit value gd_free_{blocks,inode}_count */
> -#define EXT2_MAX_BLOCKS_PER_GROUP(s)	((1 << 16) - 8)
> +#define EXT2_MAX_BLOCKS_PER_GROUP(s)	(((1 << 16) - 8) *	\
> +					 (EXT2_CLUSTER_SIZE(s) / \
> +					  EXT2_BLOCK_SIZE(s)))
> +#define EXT2_MAX_CLUSTERS_PER_GROUP(s)	((1 << 16) - 8)
> #define EXT2_MAX_INODES_PER_GROUP(s)	((1 << 16) - EXT2_INODES_PER_BLOCK(s))
> #ifdef __KERNEL__
> #define EXT2_DESC_PER_BLOCK(s)		(EXT2_SB(s)->s_desc_per_block)
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index d3eb31d..a065e87 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -207,7 +207,7 @@ struct struct_ext2_filsys {
> 	char *				device_name;
> 	struct ext2_super_block	* 	super;
> 	unsigned int			blocksize;
> -	int				clustersize;
> +	int				cluster_ratio;
> 	dgrp_t				group_desc_count;
> 	unsigned long			desc_blocks;
> 	struct opaque_ext2_group_desc *	group_desc;
> @@ -232,7 +232,8 @@ struct struct_ext2_filsys {
> 	/*
> 	 * Reserved for future expansion
> 	 */
> -	__u32				reserved[7];
> +	__u32				clustersize;
> +	__u32				reserved[6];
> 
> 	/*
> 	 * Reserved for the use of the calling application.
> @@ -553,7 +554,8 @@ typedef struct ext2_icount *ext2_icount_t;
> 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
> 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
> 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
> -					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
> +					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
> +					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
> 
> /*
> * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
> diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> index df095ac..60321df 100644
> --- a/lib/ext2fs/gen_bitmap64.c
> +++ b/lib/ext2fs/gen_bitmap64.c
> @@ -559,3 +559,85 @@ int ext2fs_warn_bitmap32(ext2fs_generic_bitmap bitmap, const char *func)
> 			"called %s with 64-bit bitmap", func);
> #endif
> }
> +
> +errcode_t ext2fs_allocate_cluster_bitmap(ext2_filsys fs,
> +					 const char *descr,
> +					 ext2fs_block_bitmap *ret)
> +{
> +	__u64		start, end, real_end;
> +	errcode_t	retval;
> +
> +	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> +
> +	if (!(fs->flags & EXT2_FLAG_64BITS))
> +		return EXT2_ET_CANT_USE_LEGACY_BITMAPS;
> +		
> +	fs->write_bitmaps = ext2fs_write_bitmaps;
> +
> +	start = (fs->super->s_first_data_block >>
> +		 EXT2_CLUSTER_SIZE_BITS(fs->super));
> +	end = (ext2fs_blocks_count(fs->super) - 1) / fs->cluster_ratio;
> +	real_end = ((__u64) EXT2_CLUSTERS_PER_GROUP(fs->super)
> +		    * (__u64) fs->group_desc_count)-1 + start;
> +
> +	retval = ext2fs_alloc_generic_bmap(fs,
> +					   EXT2_ET_MAGIC_BLOCK_BITMAP64,
> +					   EXT2FS_BMAP64_BITARRAY,
> +					   start, end, real_end, descr, ret);
> +	if (retval)
> +		return retval;
> +
> +	(*ret)->flags = EXT2_BMFLAG_CLUSTER;
> +
> +	printf("Returning 0...\n");
> +	return 0;
> +}
> +
> +int ext2fs_is_cluster_bitmap(ext2fs_block_bitmap bm)
> +{
> +	if (EXT2FS_IS_32_BITMAP(bm))
> +		return 0;
> +
> +	return (bm->flags & EXT2_BMFLAG_CLUSTER);
> +}
> +
> +errcode_t ext2fs_convert_to_cluster_bitmap(ext2_filsys fs,
> +					  ext2fs_block_bitmap bmap,
> +					  ext2fs_block_bitmap *ret)
> +{
> +	ext2fs_block_bitmap	cmap;
> +	errcode_t		retval;
> +	blk64_t			i, j, b_end, c_end;
> +	int			n;
> +
> +	retval = ext2fs_allocate_cluster_bitmap(fs, "converted cluster bitmap",
> +						ret);
> +	if (retval)
> +		return retval;
> +
> +	cmap = *ret;
> +	i = bmap->start;
> +	b_end = bmap->end;
> +	bmap->end = bmap->real_end;
> +	j = cmap->start;
> +	c_end = cmap->end;
> +	cmap->end = cmap->real_end;
> +	n = 0;
> +	while (i < bmap->real_end) {
> +		if (ext2fs_test_block_bitmap2(bmap, i)) {
> +			ext2fs_mark_block_bitmap2(cmap, j);
> +			i += fs->cluster_ratio - n;
> +			j++;
> +			n = 0;
> +			continue;
> +		}
> +		i++; n++;
> +		if (n >= fs->cluster_ratio) {
> +			j++;
> +			n = 0;
> +		}
> +	}
> +	bmap->end = b_end;
> +	cmap->end = c_end;
> +	return 0;
> +}
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index e1f229b..00a8b38 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -94,6 +94,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
> 	blk_t		numblocks;
> 	int		rsv_gdt;
> 	int		csum_flag;
> +	int		bigalloc_flag;
> 	int		io_flags;
> 	char		*buf = 0;
> 	char		c;
> @@ -134,12 +135,25 @@ errcode_t ext2fs_initialize(const char *name, int flags,
> 
> #define set_field(field, default) (super->field = param->field ? \
> 				   param->field : (default))
> +#define assign_field(field)	(super->field = param->field)
> 
> 	super->s_magic = EXT2_SUPER_MAGIC;
> 	super->s_state = EXT2_VALID_FS;
> 
> -	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
> -	set_field(s_log_cluster_size, 0);
> +	bigalloc_flag = EXT2_HAS_RO_COMPAT_FEATURE(param,
> +				   EXT4_FEATURE_RO_COMPAT_BIGALLOC);
> +
> +	assign_field(s_log_block_size);
> +
> +	if (bigalloc_flag) {
> +		set_field(s_log_cluster_size, super->s_log_block_size+4);
> +		if (super->s_log_block_size > super->s_log_cluster_size) {
> +			retval = EXT2_ET_INVALID_ARGUMENT;
> +			goto cleanup;
> +		}
> +	} else
> +		super->s_log_cluster_size = super->s_log_block_size;
> +
> 	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
> 	set_field(s_max_mnt_count, 0);
> 	set_field(s_errors, EXT2_ERRORS_DEFAULT);
> @@ -183,14 +197,36 @@ errcode_t ext2fs_initialize(const char *name, int flags,
> 
> 	fs->blocksize = EXT2_BLOCK_SIZE(super);
> 	fs->clustersize = EXT2_CLUSTER_SIZE(super);
> +	fs->cluster_ratio = fs->clustersize / fs->blocksize;
> +
> +	if (bigalloc_flag) {
> +		if (param->s_blocks_per_group &&
> +		    param->s_clusters_per_group &&
> +		    ((param->s_clusters_per_group * fs->cluster_ratio) !=
> +		     param->s_blocks_per_group)) {
> +			retval = EXT2_ET_INVALID_ARGUMENT;
> +			goto cleanup;
> +		}
> +		if (param->s_clusters_per_group)
> +			assign_field(s_clusters_per_group);
> +		else if (param->s_blocks_per_group)
> +			super->s_clusters_per_group = 
> +				param->s_blocks_per_group / fs->cluster_ratio;
> +		else
> +			super->s_clusters_per_group = fs->blocksize * 8;
> +		if (super->s_clusters_per_group > EXT2_MAX_CLUSTERS_PER_GROUP(super))
> +			super->s_blocks_per_group = EXT2_MAX_CLUSTERS_PER_GROUP(super);
> +		super->s_blocks_per_group = super->s_clusters_per_group;
> +		super->s_blocks_per_group *= fs->cluster_ratio;
> +	} else {
> +		set_field(s_blocks_per_group, fs->blocksize * 8);
> +		if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(super))
> +			super->s_blocks_per_group = EXT2_MAX_BLOCKS_PER_GROUP(super);
> +		super->s_clusters_per_group = super->s_blocks_per_group;
> +	}
> 
> -	/* default: (fs->blocksize*8) blocks/group, up to 2^16 (GDT limit) */
> -	set_field(s_blocks_per_group, fs->blocksize * 8);
> -	if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(super))
> -		super->s_blocks_per_group = EXT2_MAX_BLOCKS_PER_GROUP(super);
> -	super->s_clusters_per_group = super->s_blocks_per_group;
> -
> -	ext2fs_blocks_count_set(super, ext2fs_blocks_count(param));
> +	ext2fs_blocks_count_set(super, ext2fs_blocks_count(param) &
> +				~((blk64_t) fs->cluster_ratio - 1));
> 	ext2fs_r_blocks_count_set(super, ext2fs_r_blocks_count(param));
> 	if (ext2fs_r_blocks_count(super) >= ext2fs_blocks_count(param)) {
> 		retval = EXT2_ET_INVALID_ARGUMENT;
> @@ -246,7 +282,7 @@ retry:
> 	 */
> 	ipg = ext2fs_div_ceil(super->s_inodes_count, fs->group_desc_count);
> 	if (ipg > fs->blocksize * 8) {
> -		if (super->s_blocks_per_group >= 256) {
> +		if (!bigalloc_flag && super->s_blocks_per_group >= 256) {
> 			/* Try again with slightly different parameters */
> 			super->s_blocks_per_group -= 8;
> 			ext2fs_blocks_count_set(super,
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 90abed1..8b37852 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -251,6 +251,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
> 		goto cleanup;
> 	}
> 	fs->clustersize = EXT2_CLUSTER_SIZE(fs->super);
> +	fs->cluster_ratio = fs->clustersize / fs->blocksize;
> 	fs->inode_blocks_per_group = ((EXT2_INODES_PER_GROUP(fs->super) *
> 				       EXT2_INODE_SIZE(fs->super) +
> 				       EXT2_BLOCK_SIZE(fs->super) - 1) /
> diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
> index 3031b7d..aeea997 100644
> --- a/lib/ext2fs/rw_bitmaps.c
> +++ b/lib/ext2fs/rw_bitmaps.c
> @@ -51,7 +51,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
> 
> 	inode_nbytes = block_nbytes = 0;
> 	if (do_block) {
> -		block_nbytes = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
> +		block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
> 		retval = ext2fs_get_memalign(fs->blocksize, fs->blocksize,
> 					     &block_buf);
> 		if (retval)
> @@ -85,7 +85,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
> 			/* Force bitmap padding for the last group */
> 			nbits = ((ext2fs_blocks_count(fs->super)
> 				  - (__u64) fs->super->s_first_data_block)
> -				 % (__u64) EXT2_BLOCKS_PER_GROUP(fs->super));
> +				 % (__u64) EXT2_CLUSTERS_PER_GROUP(fs->super));
> 			if (nbits)
> 				for (j = nbits; j < fs->blocksize * 8; j++)
> 					ext2fs_set_bit(j, block_buf);
> @@ -141,7 +141,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
> 	char *block_bitmap = 0, *inode_bitmap = 0;
> 	char *buf;
> 	errcode_t retval;
> -	int block_nbytes = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
> +	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
> 	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
> 	int csum_flag = 0;
> 	int do_image = fs->flags & EXT2_FLAG_IMAGE_FILE;
> @@ -219,7 +219,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
> 		}
> 		blk = (fs->image_header->offset_blockmap /
> 		       fs->blocksize);
> -		blk_cnt = (blk64_t)EXT2_BLOCKS_PER_GROUP(fs->super) *
> +		blk_cnt = (blk64_t)EXT2_CLUSTERS_PER_GROUP(fs->super) *
> 			fs->group_desc_count;
> 		while (block_nbytes > 0) {
> 			retval = io_channel_read_blk64(fs->image_io, blk++,
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index c01ffe5..d3f617a 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -71,25 +71,26 @@ static void print_range(unsigned long long a, unsigned long long b)
> 		printf("%llu-%llu", a, b);
> }
> 
> -static void print_free (unsigned long group, char * bitmap,
> -			unsigned long nbytes, unsigned long offset)
> +static void print_free(unsigned long group, char * bitmap,
> +		       unsigned long nbytes, unsigned long offset, int ratio)
> {
> 	int p = 0;
> 	unsigned long i;
> 	unsigned long j;
> 
> +	offset /= ratio;
> 	offset += group * nbytes;
> 	for (i = 0; i < nbytes; i++)
> 		if (!in_use (bitmap, i))
> 		{
> 			if (p)
> 				printf (", ");
> -			print_number(i + offset);
> +			print_number((i + offset) * ratio);
> 			for (j = i; j < nbytes && !in_use (bitmap, j); j++)
> 				;
> 			if (--j != i) {
> 				fputc('-', stdout);
> -				print_number(j + offset);
> +				print_number((j + offset) * ratio);
> 				i = j;
> 			}
> 			p = 1;
> @@ -153,7 +154,7 @@ static void list_desc (ext2_filsys fs)
> 	blk64_t		blk_itr = fs->super->s_first_data_block;
> 	ext2_ino_t	ino_itr = 1;
> 
> -	block_nbytes = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
> +	block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
> 	inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
> 
> 	if (fs->block_map)
> @@ -238,18 +239,19 @@ static void list_desc (ext2_filsys fs)
> 			fputs(_("  Free blocks: "), stdout);
> 			ext2fs_get_block_bitmap_range2(fs->block_map,
> 				 blk_itr, block_nbytes << 3, block_bitmap);
> -			print_free (i, block_bitmap,
> -				    fs->super->s_blocks_per_group,
> -				    fs->super->s_first_data_block);
> +			print_free(i, block_bitmap,
> +				   fs->super->s_clusters_per_group,
> +				   fs->super->s_first_data_block,
> +				   fs->cluster_ratio);
> 			fputc('\n', stdout);
> -			blk_itr += fs->super->s_blocks_per_group;
> +			blk_itr += fs->super->s_clusters_per_group;
> 		}
> 		if (inode_bitmap) {
> 			fputs(_("  Free inodes: "), stdout);
> 			ext2fs_get_inode_bitmap_range2(fs->inode_map,
> 				 ino_itr, inode_nbytes << 3, inode_bitmap);
> -			print_free (i, inode_bitmap,
> -				    fs->super->s_inodes_per_group, 1);
> +			print_free(i, inode_bitmap,
> +				   fs->super->s_inodes_per_group, 1, 1);
> 			fputc('\n', stdout);
> 			ino_itr += fs->super->s_inodes_per_group;
> 		}
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 9798b88..079638f 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -815,7 +815,8 @@ static __u32 ok_features[3] = {
> 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
> 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
> 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
> -		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
> +		EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
> +		EXT4_FEATURE_RO_COMPAT_BIGALLOC
> };
> 
> 
> @@ -1252,7 +1253,7 @@ profile_error:
> 	}
> 
> 	while ((c = getopt (argc, argv,
> -		    "b:cf:g:G:i:jl:m:no:qr:s:t:vE:FI:J:KL:M:N:O:R:ST:U:V")) != EOF) {
> +		    "b:cg:i:jl:m:no:qr:s:t:vC:E:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
> 		switch (c) {
> 		case 'b':
> 			blocksize = strtol(optarg, &tmp, 0);
> @@ -1275,17 +1276,17 @@ profile_error:
> 		case 'c':	/* Check for bad blocks */
> 			cflag++;
> 			break;
> -		case 'f':
> +		case 'C':
> 			size = strtoul(optarg, &tmp, 0);
> -			if (size < EXT2_MIN_BLOCK_SIZE ||
> -			    size > EXT2_MAX_BLOCK_SIZE || *tmp) {
> +			if (size < EXT2_MIN_CLUSTER_SIZE ||
> +			    size > EXT2_MAX_CLUSTER_SIZE || *tmp) {
> 				com_err(program_name, 0,
> 					_("invalid fragment size - %s"),
> 					optarg);
> 				exit(1);
> 			}
> -			fprintf(stderr, _("Warning: fragments not supported.  "
> -			       "Ignoring -f option\n"));
> +			fs_param.s_log_cluster_size =
> +				int_log2(size >> EXT2_MIN_CLUSTER_LOG_SIZE);
> 			break;
> 		case 'g':
> 			fs_param.s_blocks_per_group = strtoul(optarg, &tmp, 0);
> @@ -1515,8 +1516,6 @@ profile_error:
> 		check_plausibility(device_name);
> 	check_mount(device_name, force, _("filesystem"));
> 
> -	fs_param.s_log_cluster_size = fs_param.s_log_block_size;
> -
> 	/* Determine the size of the device (if possible) */
> 	if (noaction && fs_blocks_count) {
> 		dev_size = fs_blocks_count;
> @@ -1752,16 +1751,24 @@ profile_error:
> 		}
> 	}
> 
> +	fs_param.s_log_block_size =
> +		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);
> +	if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC) {
> +		if (fs_param.s_log_cluster_size == 0)
> +			fs_param.s_log_cluster_size =
> +				fs_param.s_log_block_size + 4;
> +	} else
> +		fs_param.s_log_cluster_size = fs_param.s_log_block_size;
> +
> 	if (inode_ratio == 0) {
> 		inode_ratio = get_int_from_profile(fs_types, "inode_ratio",
> 						   8192);
> 		if (inode_ratio < blocksize)
> 			inode_ratio = blocksize;
> +		if (inode_ratio < EXT2_CLUSTER_SIZE(&fs_param))
> +			inode_ratio = EXT2_CLUSTER_SIZE(&fs_param);
> 	}
> 
> -	fs_param.s_log_cluster_size = fs_param.s_log_block_size =
> -		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);
> -
> #ifdef HAVE_BLKID_PROBE_GET_TOPOLOGY
> 	retval = get_device_geometry(device_name, &fs_param, psector_size);
> 	if (retval < 0) {
> @@ -2049,6 +2056,33 @@ static int mke2fs_discard_device(ext2_filsys fs)
> 	return retval;
> }
> 
> +static fix_cluster_bg_counts(ext2_filsys fs)
> +{
> +	blk64_t	cluster, num_clusters, tot_free;
> +	int	grp_free, num_free, group, num;
> +
> +	num_clusters = ext2fs_blocks_count(fs->super) / fs->cluster_ratio;
> +	tot_free = num_free = num = group = grp_free = 0;
> +	for (cluster = fs->super->s_first_data_block / fs->cluster_ratio;
> +	     cluster < num_clusters; cluster++) {
> +		if (!ext2fs_test_block_bitmap2(fs->block_map, cluster)) {
> +			grp_free++;
> +			tot_free++;
> +		}
> +		num++;
> +		if ((num == fs->super->s_clusters_per_group) ||
> +		    (cluster == num_clusters-1)) {
> +			printf("Group %d has free #: %d\n", group, grp_free);
> +			ext2fs_bg_free_blocks_count_set(fs, group, grp_free);
> +			ext2fs_group_desc_csum_set(fs, group);
> +			num = 0;
> +			grp_free = 0;
> +			group++;
> +		}
> +	}
> +	ext2fs_free_blocks_count_set(fs->super, tot_free);
> +}
> +
> int main (int argc, char *argv[])
> {
> 	errcode_t	retval = 0;
> @@ -2367,6 +2401,17 @@ int main (int argc, char *argv[])
> 	}
> no_journal:
> 
> +	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
> +				       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> +		ext2fs_block_bitmap cluster_map;
> +
> +		retval = ext2fs_convert_to_cluster_bitmap(fs, fs->block_map,
> +							 &cluster_map);
> +		ext2fs_free_block_bitmap(fs->block_map);
> +		fs->block_map = cluster_map;
> +		fix_cluster_bg_counts(fs);
> +	}
> +
> 	if (!quiet)
> 		printf(_("Writing superblocks and "
> 		       "filesystem accounting information: "));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





