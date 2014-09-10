From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 2/4] quota: add project quota support
Date: Wed, 10 Sep 2014 21:47:58 +0200
Message-ID: <20140910194758.GB10507@quack.suse.cz>
References: <CAPTn0cDP0H90R10hwgp41npFCDZGH7FT4U4K49dTyp3YLSRW-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cDP0H90R10hwgp41npFCDZGH7FT4U4K49dTyp3YLSRW-A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 10-09-14 11:54:07, Li Xi wrote:
> Adds project ID support for ext4
> 
> This patch adds a new internal field of ext4 inode to save project
> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> inheriting project ID from parent directory.
> 
> Signed-off-by: Li Xi <lixi <at> ddn.com>
> ---
> Index: linux.git/fs/ext4/ialloc.c
> ===================================================================
> --- linux.git.orig/fs/ext4/ialloc.c
> +++ linux.git/fs/ext4/ialloc.c
> @@ -756,6 +756,16 @@ struct inode *__ext4_new_inode(handle_t
>          inode->i_gid = dir->i_gid;
>      } else
>          inode_init_owner(inode, dir, mode);
> +#ifdef CONFIG_QUOTA_PROJECT
> +    if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> +        if (ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) {
> +            ei->i_projid = EXT4_I(dir)->i_projid;
> +        } else {
> +            ei->i_projid =
> +                make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
> +        }
> +    }
> +#endif
  Hum, I'd just always store the default project ID in the inode (i.e., you
can remove the feature test). Then ext4_get_projid() also doesn't have to
bother checking the feature and can just return whatever is in i_projid.

>      dquot_initialize(inode);
> 
>      if (!goal)
> Index: linux.git/fs/ext4/ext4.h
> ===================================================================
> --- linux.git.orig/fs/ext4/ext4.h
> +++ linux.git/fs/ext4/ext4.h
> @@ -386,16 +386,18 @@ struct flex_groups {
>  #define EXT4_EA_INODE_FL            0x00200000 /* Inode used for large EA */
>  #define EXT4_EOFBLOCKS_FL        0x00400000 /* Blocks allocated beyond EOF */
>  #define EXT4_INLINE_DATA_FL        0x10000000 /* Inode has inline data. */
> +#define EXT4_PROJINHERIT_FL        0x20000000 /* Create with parents projid */
  Why not use the next available flag - 0x00800000?


>  #define EXT4_RESERVED_FL        0x80000000 /* reserved for ext4 lib */
> 
> -#define EXT4_FL_USER_VISIBLE        0x004BDFFF /* User visible flags */
> -#define EXT4_FL_USER_MODIFIABLE        0x004380FF /* User modifiable flags */
> +#define EXT4_FL_USER_VISIBLE        0x204BDFFF /* User visible flags */
> +#define EXT4_FL_USER_MODIFIABLE        0x204380FF /* User modifiable flags */
> 
>  /* Flags that should be inherited by new inodes from their parent. */
>  #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
>                 EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
>                 EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
> -               EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
> +               EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
> +               EXT4_PROJINHERIT_FL)
> 
>  /* Flags that are appropriate for regular files (all but dir-specific ones). */
>  #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
> @@ -443,6 +445,7 @@ enum {
>      EXT4_INODE_EA_INODE    = 21,    /* Inode used for large EA */
>      EXT4_INODE_EOFBLOCKS    = 22,    /* Blocks allocated beyond EOF */
>      EXT4_INODE_INLINE_DATA    = 28,    /* Data in inode. */
> +    EXT4_INODE_PROJINHERIT    = 29,    /* Create with parents projid */
  This will need updating as well.


>      EXT4_INODE_RESERVED    = 31,    /* reserved for ext4 lib */
>  };
> 
> @@ -695,6 +698,7 @@ struct ext4_inode {
>      __le32  i_crtime;       /* File Creation time */
>      __le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
>      __le32  i_version_hi;    /* high 32 bits for 64-bit version */
> +    __le32  i_projid;    /* Project ID */
>  };
> 
>  struct move_extent {
> @@ -943,6 +947,9 @@ struct ext4_inode_info {
> 
>      /* Precomputed uuid+inum+igen checksum for seeding inode checksums */
>      __u32 i_csum_seed;
> +#ifdef CONFIG_QUOTA_PROJECT
> +    kprojid_t i_projid;
> +#endif
>  };
> 
>  /*
> @@ -1525,6 +1532,7 @@ static inline void ext4_clear_state_flag
>   * GDT_CSUM bits are mutually exclusive.
>   */
>  #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM    0x0400
> +#define EXT4_FEATURE_RO_COMPAT_PROJECT        0x1000 /* Project quota */
  Why not use the next bit available - i.e. 0x0800?


>  #define EXT4_FEATURE_INCOMPAT_COMPRESSION    0x0001
>  #define EXT4_FEATURE_INCOMPAT_FILETYPE        0x0002
> @@ -1574,7 +1582,8 @@ static inline void ext4_clear_state_flag
>                       EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
>                       EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
>                       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
> -                     EXT4_FEATURE_RO_COMPAT_QUOTA)
> +                     EXT4_FEATURE_RO_COMPAT_QUOTA |\
> +                     EXT4_FEATURE_RO_COMPAT_PROJECT)
> 
>  /*
>   * Default values for user and/or group using reserved blocks
> @@ -1582,6 +1591,11 @@ static inline void ext4_clear_state_flag
>  #define    EXT4_DEF_RESUID        0
>  #define    EXT4_DEF_RESGID        0
> 
> +/*
> + * Default project ID
> + */
> +#define    EXT4_DEF_PROJID        0
> +
>  #define EXT4_DEF_INODE_READAHEAD_BLKS    32
> 
>  /*
> @@ -2133,6 +2147,9 @@ extern int ext4_zero_partial_blocks(hand
>                   loff_t lstart, loff_t lend);
>  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
>  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
> +#ifdef CONFIG_QUOTA_PROJECT
> +extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
> +#endif
>  extern void ext4_da_update_reserve_space(struct inode *inode,
>                      int used, int quota_claim);
> 
> Index: linux.git/fs/ext4/inode.c
> ===================================================================
> --- linux.git.orig/fs/ext4/inode.c
> +++ linux.git/fs/ext4/inode.c
> @@ -4026,6 +4026,47 @@ static inline void ext4_iget_extra_inode
>          EXT4_I(inode)->i_inline_off = 0;
>  }
> 
> +#ifdef CONFIG_QUOTA_PROJECT
> +static int ext4_inode_projid_get(struct inode *inode, struct ext4_inode *raw,
> +                 struct ext4_inode_info *ei, projid_t *projid)
> +{
> +    BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +            EXT4_FEATURE_RO_COMPAT_PROJECT));
> +
> +    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +        EXT4_FITS_IN_INODE(raw, ei, i_projid)) {
> +        *projid = (projid_t)le32_to_cpu(raw->i_projid);
> +        return 0;
> +    }
> +    return -EFBIG;
> +}
  Maybe you should just return the default project ID for inodes that
cannot store one?

> +
> +static int ext4_inode_projid_set(struct inode *inode, struct ext4_inode *raw,
> +                 struct ext4_inode_info *ei, projid_t projid)
> +{
> +    BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +            EXT4_FEATURE_RO_COMPAT_PROJECT));
> +
> +    if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> +        EXT4_FITS_IN_INODE(raw, ei, i_projid)) {
> +        raw->i_projid = cpu_to_le32(projid);
> +        return 0;
> +    }
> +    return -EFBIG;
> +}
  The test whether project ID fits into an inode should be done when
userspace tries to set project ID for the inode in the ioctl. Thus when
we are trying to write the inode and projid doesn't fit into the inode, we
know projid is the default one and we can just avoid storing it.
ext4_inode_projid_get() will then properly interpret this as the default
projid. This way we can make project ids work reasonably for filesystems
where inode needn't have enough space.

> +int ext4_get_projid(struct inode *inode, kprojid_t *projid)
> +{
> +    if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +            EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> +        return -ENOTSUPP;
> +    }
> +
> +    *projid = EXT4_I(inode)->i_projid;
> +    return 0;
> +}
> +#endif
> +
...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
