From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Fri, 07 Mar 2008 16:18:12 -0800
Message-ID: <1204935493.14884.81.camel@localhost.localdomain>
References: <1204931337.14884.43.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: Akira Fujita <a-fujita@rs.jp.nec.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1204931337.14884.43.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> [PATCH 1/5] ext4 online defrag header file changes
> - Header file changes used by online defrag.

> Header file changes used by online defrag.
> 

Overall I think the header changes probably should go with the patches
that need those changes, that helps explain why we need this header
changes and makes the patch compile itself. Right now this patch failed
to compile alone.

> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
> --
>  fs/ext4/Makefile                |    2 +-
>  include/linux/ext4_fs.h         |   68 +++++++++++++++++++++++++++++++++++++++
>  include/linux/ext4_fs_extents.h |   10 ++++++
>  3 files changed, 79 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
> index ac6fa8c..8028102 100644
> --- a/fs/ext4/Makefile
> +++ b/fs/ext4/Makefile
> @@ -6,7 +6,7 @@ obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o
> 
>  ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
>  		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
> -		   ext4_jbd2.o migrate.o mballoc.o
> +		   ext4_jbd2.o migrate.o mballoc.o defrag.o
> 
>  ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
>  ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
> diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
> index 893182e..03b4154 100644
> --- a/include/linux/ext4_fs.h
> +++ b/include/linux/ext4_fs.h
> @@ -95,6 +95,7 @@ struct ext4_allocation_request {
>  	unsigned long len;
>  	/* flags. see above EXT4_MB_HINT_* */
>  	unsigned long flags;
> +	long long excepted_group;
>  };
> 
>  /*
> @@ -299,6 +300,14 @@ struct ext4_new_group_data {
>  #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
>  #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
>  #define EXT4_IOC_MIGRATE		_IO('f', 7)
> +#define EXT4_IOC_FIBMAP			_IOW('f', 9, ext4_fsblk_t)
> +#define EXT4_IOC_DEFRAG		_IOW('f', 10, struct ext4_ext_defrag_data)
> +#define EXT4_IOC_GROUP_INFO	_IOW('f', 11, struct ext4_group_data_info)
> +#define EXT4_IOC_FREE_BLOCKS_INFO	_IOW('f', 12, struct ext4_extents_info)
> +#define EXT4_IOC_EXTENTS_INFO		_IOW('f', 13, struct ext4_extents_info)
> +#define EXT4_IOC_RESERVE_BLOCK		_IOW('f', 14, struct ext4_extents_info)
> +#define EXT4_IOC_MOVE_VICTIM		_IOW('f', 15, struct ext4_extents_info)
> +#define EXT4_IOC_BLOCK_RELEASE		_IO('f', 8)

These should go with the last patch in this series, where the ioctl
commands get implemented

>  /*
>   * ioctl commands in 32 bit emulation
> @@ -316,6 +325,42 @@ struct ext4_new_group_data {
>  #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
>  #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
> 

Could you add more comments about the tunables below? What they are used
for?

> +/* Used for defrag */
> +#define DEFRAG_MAX_ENT         32

This means at most 32 free space extents per block group?

> +#define DEFRAG_FORCE_TRY       1
> +#define DEFRAG_FORCE_VICTIM    2
> +#define DEFRAG_FORCE_GATHER    3
> +

And these tunables are used in the last patch in this series, so it make
sense to move there too.

> +struct ext4_extent_data {
> +	ext4_lblk_t block;		/* start logical block number */
> +	ext4_fsblk_t start;		/* start physical block number */
> +	int len;			/* blocks count */
> +};
> +

Not related to defrag, but I would like to consider this as in-core
extent structure. Maybe we should use this structure in other extents.c,
instead of sharing the same on-disk extent structure, which needs to
worry about little endian?


> +struct ext4_ext_defrag_data {
> +	ext4_lblk_t start_offset;	/* start offset to defrag in blocks */
> +	ext4_lblk_t defrag_size;	/* size of defrag in blocks */
> +	ext4_fsblk_t goal;		/* block offset for allocation */
> +	int flag;			/* free space mode flag */
> +	struct ext4_extent_data ext;
> +};
> +
> +struct ext4_group_data_info {
> +	int s_blocks_per_group;		/* blocks per group */
> +	int s_inodes_per_group;		/* inodes per group */
> +};
> +
> +struct ext4_extents_info {
> +	unsigned long long ino;		/* inode number */
> +	int max_entries;		/* maximum extents count */
> +	int entries;			/* extent number/count */
> +	ext4_lblk_t f_offset;		/* file offset */
> +	ext4_grpblk_t g_offset;		/* group offset */
> +	ext4_fsblk_t goal;		/* block offset for allocation */
> +	struct ext4_extent_data ext[DEFRAG_MAX_ENT];
> +};
> +
> +#define EXT4_TRANS_META_BLOCKS 4 /* bitmap + group desc + sb + inode */
> 
>  /*
>   *  Mount options
> @@ -991,6 +1036,17 @@ extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
>  extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
>  extern void ext4_init_block_alloc_info(struct inode *);
>  extern void ext4_rsv_window_add(struct super_block *sb, struct ext4_reserve_window_node *rsv);
> +extern void try_to_extend_reservation(struct ext4_reserve_window_node *,
> +					struct super_block *, int);
> +extern int alloc_new_reservation(struct ext4_reserve_window_node *,
> +				ext4_grpblk_t, struct super_block *,
> +				ext4_group_t, struct buffer_head *);
> +extern ext4_grpblk_t bitmap_search_next_usable_block(ext4_grpblk_t,
> +				struct buffer_head *, ext4_grpblk_t);
> +extern int rsv_is_empty(struct ext4_reserve_window *rsv);
> +extern int goal_in_my_reservation(struct ext4_reserve_window *rsv,
> +				ext4_grpblk_t grp_goal, ext4_group_t group,
> +				struct super_block *sb);
> 
Later I found out why you need to export those functions, but I think
this is not used with mballoc. I will comment later.

>  /* dir.c */
>  extern int ext4_check_dir_entry(const char *, struct inode *,
> @@ -1000,6 +1056,7 @@ extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
>  				    __u32 minor_hash,
>  				    struct ext4_dir_entry_2 *dirent);
>  extern void ext4_htree_free_dir_info(struct dir_private_info *p);
> +extern sector_t ext4_bmap(struct address_space *mapping, sector_t block);
> 
>  /* fsync.c */
>  extern int ext4_sync_file (struct file *, struct dentry *, int);
> @@ -1061,6 +1118,8 @@ extern int ext4_writepage_trans_blocks(struct inode *);
>  extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
>  		struct address_space *mapping, loff_t from);
>  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
> +extern int ext4_get_block(struct inode *inode, sector_t iblock,
> +		struct buffer_head *bh_result, int create);
> 
>  /* ioctl.c */
>  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
> @@ -1109,6 +1168,14 @@ extern void ext4_inode_bitmap_set(struct super_block *sb,
>  				  struct ext4_group_desc *bg, ext4_fsblk_t blk);
>  extern void ext4_inode_table_set(struct super_block *sb,
>  				 struct ext4_group_desc *bg, ext4_fsblk_t blk);
> +/* extents.c */
> +extern handle_t *ext4_ext_journal_restart(handle_t *handle, int needed);
> +/* defrag.c */
> +extern int ext4_defrag(struct file *filp, ext4_lblk_t block_start,
> +			ext4_lblk_t defrag_size, ext4_fsblk_t goal,
> +			int flag, struct ext4_extent_data *ext);
> +extern int ext4_defrag_ioctl(struct inode *, struct file *, unsigned int,
> +				unsigned long);
> 
>  static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
>  {
> @@ -1226,6 +1293,7 @@ extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
>  			sector_t block, unsigned long max_blocks,
>  			struct buffer_head *bh, int create,
>  			int extend_disksize);
> +extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start);
>  #endif	/* __KERNEL__ */
> 
>  #endif	/* _LINUX_EXT4_FS_H */
> diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
> index 1285c58..6fb42b1 100644
> --- a/include/linux/ext4_fs_extents.h
> +++ b/include/linux/ext4_fs_extents.h
> @@ -228,5 +228,15 @@ extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
>  extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
>  						ext4_lblk_t *, ext4_fsblk_t *);
>  extern void ext4_ext_drop_refs(struct ext4_ext_path *);
> +extern ext4_fsblk_t ext_pblock(struct ext4_extent *ex);
> +extern void ext4_ext_drop_refs(struct ext4_ext_path *path);
> +extern ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
> +					struct ext4_ext_path *path,
> +					ext4_lblk_t block);
> +extern int ext4_ext_insert_extent_defrag(handle_t *handle, struct inode *inode,
> +					struct ext4_ext_path *path,
> +					struct ext4_extent *newext, int defrag);
> +extern ext4_lblk_t ext4_ext_next_allocated_block(struct ext4_ext_path *path);
> +
>  #endif /* _LINUX_EXT4_EXTENTS */
> 
> 

