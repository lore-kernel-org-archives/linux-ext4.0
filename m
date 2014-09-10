From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 3/4] quota: add project quota support
Date: Wed, 10 Sep 2014 22:02:32 +0200
Message-ID: <20140910200232.GC10507@quack.suse.cz>
References: <CAPTn0cB4xNr69eb2cv7yUP-SLHm0dGxhM=VUT9E0nQ8+VQ3SXQ@mail.gmail.com>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaIJUCf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2014 16:02:35 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cB4xNr69eb2cv7yUP-SLHm0dGxhM=VUT9E0nQ8+VQ3SXQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 10-09-14 11:54:31, Li Xi wrote:
> Adds project quota support for ext4
> 
> This patch adds mount options for enabling/disabling project quota
> accounting and enforcement. A new specific inode is also used for
> project quota accounting.
> 
> Signed-off-by: Li Xi <lixi <at> ddn.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> Index: linux.git/fs/ext4/ext4.h
> ===================================================================
> --- linux.git.orig/fs/ext4/ext4.h
> +++ linux.git/fs/ext4/ext4.h
> @@ -217,6 +217,7 @@ struct ext4_io_submit {
>  #define EXT4_UNDEL_DIR_INO     6    /* Undelete directory inode */
>  #define EXT4_RESIZE_INO         7    /* Reserved group descriptors inode */
>  #define EXT4_JOURNAL_INO     8    /* Journal inode */
> +#define EXT4_PRJ_QUOTA_INO     9    /* Project quota inode */
> 
>  /* First non-reserved inode for old ext4 filesystems */
>  #define EXT4_GOOD_OLD_FIRST_INO    11
> @@ -993,6 +994,7 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_DIOREAD_NOLOCK    0x400000 /* Enable support for
> dio read nolocking */
>  #define EXT4_MOUNT_JOURNAL_CHECKSUM    0x800000 /* Journal checksums */
>  #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT    0x1000000 /* Journal Async Commit */
> +#define EXT4_MOUNT_PRJQUOTA        0x4000000 /* Project quota support */
  Why didn't you take the first available 0x2000000?


>  #define EXT4_MOUNT_DELALLOC        0x8000000 /* Delalloc support */
>  #define EXT4_MOUNT_DATA_ERR_ABORT    0x10000000 /* Abort on file data write */
>  #define EXT4_MOUNT_BLOCK_VALIDITY    0x20000000 /* Block validity checking */
> @@ -1168,7 +1170,8 @@ struct ext4_super_block {
>      __le32    s_grp_quota_inum;    /* inode for tracking group quota */
>      __le32    s_overhead_clusters;    /* overhead blocks/clusters in fs */
>      __le32    s_backup_bgs[2];    /* groups with sparse_super2 SBs */
> -    __le32    s_reserved[106];    /* Padding to the end of the block */
> +    __le32    s_prj_quota_inum;    /* inode for tracking project quota */
> +    __le32    s_reserved[105];    /* Padding to the end of the block */
>      __le32    s_checksum;        /* crc32c(superblock) */
>  };
> 
> @@ -1372,6 +1375,7 @@ static inline int ext4_valid_inum(struct
>          ino == EXT4_BOOT_LOADER_INO ||
>          ino == EXT4_JOURNAL_INO ||
>          ino == EXT4_RESIZE_INO ||
> +        ino == EXT4_PRJ_QUOTA_INO ||
>          (ino >= EXT4_FIRST_INO(sb) &&
>           ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
>  }
> Index: linux.git/fs/ext4/super.c
> ===================================================================
> --- linux.git.orig/fs/ext4/super.c
> +++ linux.git/fs/ext4/super.c
> @@ -1048,8 +1048,8 @@ static int bdev_try_to_free_page(struct
>  }
> 
>  #ifdef CONFIG_QUOTA
> -#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
> -#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
> +static char *quotatypes[] = INITQFNAMES;
> +#define QTYPE2NAME(t) (quotatypes[t])
> 
>  static int ext4_write_dquot(struct dquot *dquot);
>  static int ext4_acquire_dquot(struct dquot *dquot);
> @@ -1162,10 +1162,11 @@ enum {
>      Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
>      Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
>      Opt_data_err_abort, Opt_data_err_ignore,
> -    Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
> +    Opt_usrjquota, Opt_grpjquota, Opt_prjjquota,
> +    Opt_offusrjquota, Opt_offgrpjquota, Opt_offprjjquota,
>      Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
>      Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
> -    Opt_usrquota, Opt_grpquota, Opt_i_version,
> +    Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version,
>      Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
>      Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
>      Opt_inode_readahead_blks, Opt_journal_ioprio,
> @@ -1216,6 +1217,8 @@ static const match_table_t tokens = {
>      {Opt_usrjquota, "usrjquota=%s"},
>      {Opt_offgrpjquota, "grpjquota="},
>      {Opt_grpjquota, "grpjquota=%s"},
> +    {Opt_offprjjquota, "prjjquota="},
> +    {Opt_prjjquota, "prjjquota=%s"},
>      {Opt_jqfmt_vfsold, "jqfmt=vfsold"},
>      {Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
>      {Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
> @@ -1223,6 +1226,7 @@ static const match_table_t tokens = {
>      {Opt_noquota, "noquota"},
>      {Opt_quota, "quota"},
>      {Opt_usrquota, "usrquota"},
> +    {Opt_prjquota, "prjquota"},
>      {Opt_barrier, "barrier=%u"},
>      {Opt_barrier, "barrier"},
>      {Opt_nobarrier, "nobarrier"},
> @@ -1435,6 +1439,12 @@ static const struct mount_opts {
>                              MOPT_SET | MOPT_Q},
>      {Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
>                              MOPT_SET | MOPT_Q},
> +#ifdef CONFIG_QUOTA_PROJECT
> +    {Opt_prjquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
> +                            MOPT_SET | MOPT_Q},
> +#else
> +    {Opt_prjquota, 0, MOPT_NOSUPPORT},
> +#endif
>      {Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
>                 EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
>      {Opt_usrjquota, 0, MOPT_Q},
> @@ -1463,10 +1473,14 @@ static int handle_mount_opt(struct super
>          return set_qf_name(sb, USRQUOTA, &args[0]);
>      else if (token == Opt_grpjquota)
>          return set_qf_name(sb, GRPQUOTA, &args[0]);
> +    else if (token == Opt_prjjquota)
> +        return set_qf_name(sb, PRJQUOTA, &args[0]);
>      else if (token == Opt_offusrjquota)
>          return clear_qf_name(sb, USRQUOTA);
>      else if (token == Opt_offgrpjquota)
>          return clear_qf_name(sb, GRPQUOTA);
> +    else if (token == Opt_offprjjquota)
> +        return clear_qf_name(sb, PRJQUOTA);
>  #endif
>      switch (token) {
>      case Opt_noacl:
> @@ -1692,19 +1706,28 @@ static int parse_options(char *options,
>      }
>  #ifdef CONFIG_QUOTA
>      if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
> -        (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
> +        (test_opt(sb, USRQUOTA) ||
> +         test_opt(sb, GRPQUOTA) ||
> +         test_opt(sb, PRJQUOTA))) {
>          ext4_msg(sb, KERN_ERR, "Cannot set quota options when QUOTA "
>               "feature is enabled");
>          return 0;
>      }
> -    if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
> +    if (sbi->s_qf_names[USRQUOTA] ||
> +        sbi->s_qf_names[GRPQUOTA] ||
> +        sbi->s_qf_names[PRJQUOTA]) {
>          if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
>              clear_opt(sb, USRQUOTA);
> 
>          if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
>              clear_opt(sb, GRPQUOTA);
> 
> -        if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
> +        if (test_opt(sb, PRJQUOTA) && sbi->s_qf_names[PRJQUOTA])
> +            clear_opt(sb, PRJQUOTA);
> +
> +        if (test_opt(sb, GRPQUOTA) ||
> +            test_opt(sb, USRQUOTA) ||
> +            test_opt(sb, PRJQUOTA)) {
>              ext4_msg(sb, KERN_ERR, "old and new quota "
>                      "format mixing");
>              return 0;
> @@ -1765,6 +1788,9 @@ static inline void ext4_show_quota_optio
> 
>      if (sbi->s_qf_names[GRPQUOTA])
>          seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
> +
> +    if (sbi->s_qf_names[PRJQUOTA])
> +        seq_printf(seq, ",prjjquota=%s", sbi->s_qf_names[PRJQUOTA]);
>  #endif
>  }
> 
> @@ -2793,6 +2819,15 @@ static int ext4_feature_set_ok(struct su
>          return 0;
>      }
>  #endif  /* CONFIG_QUOTA */
> +#ifndef CONFIG_QUOTA_PROJECT
> +    if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +        !readonly) {
> +        ext4_msg(sb, KERN_ERR,
> +             "Filesystem with quota feature cannot be mounted RDWR "
> +             "without CONFIG_QUOTA_PROJECT");
> +        return 0;
> +    }
> +#endif
>      return 1;
>  }
> 
> @@ -5011,6 +5046,48 @@ restore_opts:
>      return err;
>  }
> 
> +#ifdef CONFIG_QUOTA_PROJECT
> +static int ext4_statfs_project(struct super_block *sb,
> +                   kprojid_t projid, struct kstatfs *buf)
> +{
  I'd say statfs() implementation logically belongs to the previous patch.
But I don't have a strong opinion here.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
