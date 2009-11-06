From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: [PATCH] Unify log messages in ext2
Date: Fri, 06 Nov 2009 15:53:27 +0100
Message-ID: <1257519207.19442.10.camel@zwerg>
References: <0EAA3AC5-9EB3-4547-AA50-0B601665B1C3@sun.com>
	 <1257406384-4457-1-git-send-email-bug-track@fisher-privat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36681 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754058AbZKFOxZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 09:53:25 -0500
In-Reply-To: <1257406384-4457-1-git-send-email-bug-track@fisher-privat.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Any comments for this patch?

Alexey


Am Donnerstag, den 05.11.2009, 08:33 +0100 schrieb Alexey Fisher:
> make messages produced by ext2 more unified. It should be
> easy to parse.
> 
> dmesg before patch:
> [ 4893.684892] reservations ON
> [ 4893.684896] xip option not supported
> [ 4893.684961] EXT2-fs warning: mounting ext3 filesystem as ext2
> [ 4893.684964] EXT2-fs warning: maximal mount count reached, running
> e2fsck is recommended
> [ 4893.684990] EXT II FS: 0.5b, 95/08/09, bs=1024, fs=1024, gc=2,
> bpg=8192, ipg=1280, mo=80010]
> 
> dmesg after patch:
> [ 4893.684892] EXT2-fs (loop0): reservations ON
> [ 4893.684896] EXT2-fs (loop0): xip option not supported
> [ 4893.684961] EXT2-fs (loop0): warning: mounting ext3 filesystem as
> ext2
> [ 4893.684964] EXT2-fs (loop0): warning: maximal mount count reached,
> running e2fsck is recommended
> [ 4893.684990] EXT2-fs (loop0): 0.5b, 95/08/09, bs=1024, fs=1024, gc=2,
> bpg=8192, ipg=1280, mo=80010]
> 
> Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
> Reviewed-by: Andreas Dilger <adilger@sun.com>
> ---
>  fs/ext2/ext2.h  |    2 +
>  fs/ext2/super.c |  151 +++++++++++++++++++++++++++++++------------------------
>  2 files changed, 88 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 9a8a8e2..29f65c5 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -142,6 +142,8 @@ struct dentry *ext2_get_parent(struct dentry *child);
>  /* super.c */
>  extern void ext2_error (struct super_block *, const char *, const char *, ...)
>  	__attribute__ ((format (printf, 3, 4)));
> +extern void ext2_msg(struct super_block *, const char *, const char *, ...)
> +	__attribute__ ((format (printf, 3, 4)));
>  extern void ext2_warning (struct super_block *, const char *, const char *, ...)
>  	__attribute__ ((format (printf, 3, 4)));
>  extern void ext2_update_dynamic_rev (struct super_block *sb);
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 1a9ffee..105fcd1 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -58,26 +58,38 @@ void ext2_error (struct super_block * sb, const char * function,
>  	}
>  
>  	va_start(args, fmt);
> -	printk(KERN_CRIT "EXT2-fs error (device %s): %s: ",sb->s_id, function);
> +	ext2_msg(sb, KERN_CRIT, "error %s", function);
>  	vprintk(fmt, args);
>  	printk("\n");
>  	va_end(args);
>  
>  	if (test_opt(sb, ERRORS_PANIC))
> -		panic("EXT2-fs panic from previous error\n");
> +		panic("EXT2-fs: panic from previous error\n");
>  	if (test_opt(sb, ERRORS_RO)) {
> -		printk("Remounting filesystem read-only\n");
> +		ext2_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
>  		sb->s_flags |= MS_RDONLY;
>  	}
>  }
>  
> +void ext2_msg(struct super_block *sb, const char *prefix,
> +		const char *fmt, ...)
> +{
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	printk("%sEXT2-fs (%s): ", prefix, sb->s_id);
> +	vprintk(fmt, args);
> +	printk("\n");
> +	va_end(args);
> +}
> +
>  void ext2_warning (struct super_block * sb, const char * function,
>  		   const char * fmt, ...)
>  {
>  	va_list args;
>  
>  	va_start(args, fmt);
> -	printk(KERN_WARNING "EXT2-fs warning (device %s): %s: ",
> +	printk(KERN_WARNING "EXT2-fs (%s) warning: %s: ",
>  	       sb->s_id, function);
>  	vprintk(fmt, args);
>  	printk("\n");
> @@ -420,7 +432,7 @@ static const match_table_t tokens = {
>  };
>  
>  static int parse_options (char * options,
> -			  struct ext2_sb_info *sbi)
> +			  struct ext2_sb_info *sbi, struct super_block *sb)
>  {
>  	char * p;
>  	substring_t args[MAX_OPT_ARGS];
> @@ -505,7 +517,8 @@ static int parse_options (char * options,
>  #else
>  		case Opt_user_xattr:
>  		case Opt_nouser_xattr:
> -			printk("EXT2 (no)user_xattr options not supported\n");
> +			ext2_msg(sb, KERN_INFO, "(no)user_xattr options"
> +				"not supported");
>  			break;
>  #endif
>  #ifdef CONFIG_EXT2_FS_POSIX_ACL
> @@ -518,14 +531,15 @@ static int parse_options (char * options,
>  #else
>  		case Opt_acl:
>  		case Opt_noacl:
> -			printk("EXT2 (no)acl options not supported\n");
> +			ext2_msg(sb, KERN_INFO,
> +				"(no)acl options not supported");
>  			break;
>  #endif
>  		case Opt_xip:
>  #ifdef CONFIG_EXT2_FS_XIP
>  			set_opt (sbi->s_mount_opt, XIP);
>  #else
> -			printk("EXT2 xip option not supported\n");
> +			ext2_msg(sb, KERN_INFO, "xip option not supported");
>  #endif
>  			break;
>  
> @@ -542,19 +556,18 @@ static int parse_options (char * options,
>  		case Opt_quota:
>  		case Opt_usrquota:
>  		case Opt_grpquota:
> -			printk(KERN_ERR
> -				"EXT2-fs: quota operations not supported.\n");
> -
> +			ext2_msg(sb, KERN_INFO,
> +				"quota operations not supported");
>  			break;
>  #endif
>  
>  		case Opt_reservation:
>  			set_opt(sbi->s_mount_opt, RESERVATION);
> -			printk("reservations ON\n");
> +			ext2_msg(sb, KERN_INFO, "reservations ON");
>  			break;
>  		case Opt_noreservation:
>  			clear_opt(sbi->s_mount_opt, RESERVATION);
> -			printk("reservations OFF\n");
> +			ext2_msg(sb, KERN_INFO, "reservations OFF");
>  			break;
>  		case Opt_ignore:
>  			break;
> @@ -573,34 +586,39 @@ static int ext2_setup_super (struct super_block * sb,
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
>  
>  	if (le32_to_cpu(es->s_rev_level) > EXT2_MAX_SUPP_REV) {
> -		printk ("EXT2-fs warning: revision level too high, "
> -			"forcing read-only mode\n");
> +		ext2_msg(sb, KERN_ERR,
> +			"revision level too high, forcing read-only mode");
>  		res = MS_RDONLY;
>  	}
>  	if (read_only)
>  		return res;
>  	if (!(sbi->s_mount_state & EXT2_VALID_FS))
> -		printk ("EXT2-fs warning: mounting unchecked fs, "
> -			"running e2fsck is recommended\n");
> +		ext2_msg(sb, KERN_WARNING,
> +			"warning: mounting unchecked fs, "
> +			"running e2fsck is recommended");
>  	else if ((sbi->s_mount_state & EXT2_ERROR_FS))
> -		printk ("EXT2-fs warning: mounting fs with errors, "
> -			"running e2fsck is recommended\n");
> +		ext2_msg(sb, KERN_WARNING,
> +			"warning: mounting fs with errors, "
> +			"running e2fsck is recommended");
>  	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
>  		 le16_to_cpu(es->s_mnt_count) >=
>  		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
> -		printk ("EXT2-fs warning: maximal mount count reached, "
> -			"running e2fsck is recommended\n");
> +		ext2_msg(sb, KERN_WARNING,
> +			"warning: maximal mount count reached, "
> +			"running e2fsck is recommended");
>  	else if (le32_to_cpu(es->s_checkinterval) &&
> -		(le32_to_cpu(es->s_lastcheck) + le32_to_cpu(es->s_checkinterval) <= get_seconds()))
> -		printk ("EXT2-fs warning: checktime reached, "
> -			"running e2fsck is recommended\n");
> +		(le32_to_cpu(es->s_lastcheck) +
> +			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
> +		ext2_msg(sb, KERN_WARNING,
> +			"warning: checktime reached, "
> +			"running e2fsck is recommended");
>  	if (!le16_to_cpu(es->s_max_mnt_count))
>  		es->s_max_mnt_count = cpu_to_le16(EXT2_DFL_MAX_MNT_COUNT);
>  	le16_add_cpu(&es->s_mnt_count, 1);
>  	ext2_write_super(sb);
>  	if (test_opt (sb, DEBUG))
> -		printk ("[EXT II FS %s, %s, bs=%lu, fs=%lu, gc=%lu, "
> -			"bpg=%lu, ipg=%lu, mo=%04lx]\n",
> +		ext2_msg(sb, KERN_INFO, "%s, %s, bs=%lu, fs=%lu, gc=%lu, "
> +			"bpg=%lu, ipg=%lu, mo=%04lx]",
>  			EXT2FS_VERSION, EXT2FS_DATE, sb->s_blocksize,
>  			sbi->s_frag_size,
>  			sbi->s_groups_count,
> @@ -767,7 +785,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	 */
>  	blocksize = sb_min_blocksize(sb, BLOCK_SIZE);
>  	if (!blocksize) {
> -		printk ("EXT2-fs: unable to set blocksize\n");
> +		ext2_msg(sb, KERN_ERR, "unable to set blocksize");
>  		goto failed_sbi;
>  	}
>  
> @@ -783,7 +801,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  
>  	if (!(bh = sb_bread(sb, logic_sb_block))) {
> -		printk ("EXT2-fs: unable to read superblock\n");
> +		ext2_msg(sb, KERN_ERR, "unable to read superblock");
>  		goto failed_sbi;
>  	}
>  	/*
> @@ -826,7 +844,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	
>  	set_opt(sbi->s_mount_opt, RESERVATION);
>  
> -	if (!parse_options ((char *) data, sbi))
> +	if (!parse_options((char *) data, sbi, sb))
>  		goto failed_mount;
>  
>  	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
> @@ -840,8 +858,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	    (EXT2_HAS_COMPAT_FEATURE(sb, ~0U) ||
>  	     EXT2_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
>  	     EXT2_HAS_INCOMPAT_FEATURE(sb, ~0U)))
> -		printk("EXT2-fs warning: feature flags set on rev 0 fs, "
> -		       "running e2fsck is recommended\n");
> +		ext2_msg(sb, KERN_WARNING,
> +			"warning: feature flags set on rev 0 fs, "
> +			"running e2fsck is recommended");
>  	/*
>  	 * Check feature flags regardless of the revision level, since we
>  	 * previously didn't change the revision level when setting the flags,
> @@ -849,16 +868,16 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	 */
>  	features = EXT2_HAS_INCOMPAT_FEATURE(sb, ~EXT2_FEATURE_INCOMPAT_SUPP);
>  	if (features) {
> -		printk("EXT2-fs: %s: couldn't mount because of "
> -		       "unsupported optional features (%x).\n",
> -		       sb->s_id, le32_to_cpu(features));
> +		ext2_msg(sb, KERN_ERR,	"couldn't mount because of "
> +		       "unsupported optional features (%x)",
> +			le32_to_cpu(features));
>  		goto failed_mount;
>  	}
>  	if (!(sb->s_flags & MS_RDONLY) &&
>  	    (features = EXT2_HAS_RO_COMPAT_FEATURE(sb, ~EXT2_FEATURE_RO_COMPAT_SUPP))){
> -		printk("EXT2-fs: %s: couldn't mount RDWR because of "
> -		       "unsupported optional features (%x).\n",
> -		       sb->s_id, le32_to_cpu(features));
> +		ext2_msg(sb, KERN_ERR, "couldn't mount RDWR because of "
> +		       "unsupported optional features (%x)",
> +		       le32_to_cpu(features));
>  		goto failed_mount;
>  	}
>  
> @@ -866,7 +885,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	if (ext2_use_xip(sb) && blocksize != PAGE_SIZE) {
>  		if (!silent)
> -			printk("XIP: Unsupported blocksize\n");
> +			ext2_msg(sb, KERN_ERR, "XIP: Unsupported blocksize");
>  		goto failed_mount;
>  	}
>  
> @@ -875,7 +894,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		brelse(bh);
>  
>  		if (!sb_set_blocksize(sb, blocksize)) {
> -			printk(KERN_ERR "EXT2-fs: blocksize too small for device.\n");
> +			ext2_msg(sb, KERN_ERR, "blocksize too small");
>  			goto failed_sbi;
>  		}
>  
> @@ -883,14 +902,14 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		offset = (sb_block*BLOCK_SIZE) % blocksize;
>  		bh = sb_bread(sb, logic_sb_block);
>  		if(!bh) {
> -			printk("EXT2-fs: Couldn't read superblock on "
> -			       "2nd try.\n");
> +			ext2_msg(sb, KERN_ERR, "Couldn't read superblock on "
> +			       "2nd try");
>  			goto failed_sbi;
>  		}
>  		es = (struct ext2_super_block *) (((char *)bh->b_data) + offset);
>  		sbi->s_es = es;
>  		if (es->s_magic != cpu_to_le16(EXT2_SUPER_MAGIC)) {
> -			printk ("EXT2-fs: Magic mismatch, very weird !\n");
> +			ext2_msg(sb, KERN_ERR, "Magic mismatch, very weird !");
>  			goto failed_mount;
>  		}
>  	}
> @@ -906,7 +925,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		if ((sbi->s_inode_size < EXT2_GOOD_OLD_INODE_SIZE) ||
>  		    !is_power_of_2(sbi->s_inode_size) ||
>  		    (sbi->s_inode_size > blocksize)) {
> -			printk ("EXT2-fs: unsupported inode size: %d\n",
> +			ext2_msg(sb, KERN_ERR, "unsupported inode size: %d",
>  				sbi->s_inode_size);
>  			goto failed_mount;
>  		}
> @@ -943,29 +962,29 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	if (sb->s_blocksize != bh->b_size) {
>  		if (!silent)
> -			printk ("VFS: Unsupported blocksize on dev "
> -				"%s.\n", sb->s_id);
> +			ext2_msg(sb, KERN_ERR, "VFS: Unsupported blocksize");
>  		goto failed_mount;
>  	}
>  
>  	if (sb->s_blocksize != sbi->s_frag_size) {
> -		printk ("EXT2-fs: fragsize %lu != blocksize %lu (not supported yet)\n",
> +		ext2_msg(sb, KERN_ERR,
> +			"fragsize %lu != blocksize %lu (not supported yet)",
>  			sbi->s_frag_size, sb->s_blocksize);
>  		goto failed_mount;
>  	}
>  
>  	if (sbi->s_blocks_per_group > sb->s_blocksize * 8) {
> -		printk ("EXT2-fs: #blocks per group too big: %lu\n",
> +		ext2_msg(sb, KERN_ERR, "#blocks per group too big: %lu",
>  			sbi->s_blocks_per_group);
>  		goto failed_mount;
>  	}
>  	if (sbi->s_frags_per_group > sb->s_blocksize * 8) {
> -		printk ("EXT2-fs: #fragments per group too big: %lu\n",
> +		ext2_msg(sb, KERN_ERR, "#fragments per group too big: %lu",
>  			sbi->s_frags_per_group);
>  		goto failed_mount;
>  	}
>  	if (sbi->s_inodes_per_group > sb->s_blocksize * 8) {
> -		printk ("EXT2-fs: #inodes per group too big: %lu\n",
> +		ext2_msg(sb, KERN_ERR, "#inodes per group too big: %lu",
>  			sbi->s_inodes_per_group);
>  		goto failed_mount;
>  	}
> @@ -979,13 +998,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		   EXT2_DESC_PER_BLOCK(sb);
>  	sbi->s_group_desc = kmalloc (db_count * sizeof (struct buffer_head *), GFP_KERNEL);
>  	if (sbi->s_group_desc == NULL) {
> -		printk ("EXT2-fs: not enough memory\n");
> +		ext2_msg(sb, KERN_ERR, "not enough memory");
>  		goto failed_mount;
>  	}
>  	bgl_lock_init(sbi->s_blockgroup_lock);
>  	sbi->s_debts = kcalloc(sbi->s_groups_count, sizeof(*sbi->s_debts), GFP_KERNEL);
>  	if (!sbi->s_debts) {
> -		printk ("EXT2-fs: not enough memory\n");
> +		ext2_msg(sb, KERN_ERR, "not enough memory");
>  		goto failed_mount_group_desc;
>  	}
>  	for (i = 0; i < db_count; i++) {
> @@ -994,12 +1013,13 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		if (!sbi->s_group_desc[i]) {
>  			for (j = 0; j < i; j++)
>  				brelse (sbi->s_group_desc[j]);
> -			printk ("EXT2-fs: unable to read group descriptors\n");
> +			ext2_msg(sb, KERN_ERR,
> +				"unable to read group descriptors");
>  			goto failed_mount_group_desc;
>  		}
>  	}
>  	if (!ext2_check_descriptors (sb)) {
> -		printk ("EXT2-fs: group descriptors corrupted!\n");
> +		ext2_msg(sb, KERN_ERR, "group descriptors corrupted");
>  		goto failed_mount2;
>  	}
>  	sbi->s_gdb_count = db_count;
> @@ -1032,7 +1052,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  				ext2_count_dirs(sb));
>  	}
>  	if (err) {
> -		printk(KERN_ERR "EXT2-fs: insufficient memory\n");
> +		ext2_msg(sb, KERN_ERR, "insufficient memory");
>  		goto failed_mount3;
>  	}
>  	/*
> @@ -1048,27 +1068,27 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	}
>  	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
>  		iput(root);
> -		printk(KERN_ERR "EXT2-fs: corrupt root inode, run e2fsck\n");
> +		ext2_msg(sb, KERN_ERR, "corrupt root inode, run e2fsck");
>  		goto failed_mount3;
>  	}
>  
>  	sb->s_root = d_alloc_root(root);
>  	if (!sb->s_root) {
>  		iput(root);
> -		printk(KERN_ERR "EXT2-fs: get root inode failed\n");
> +		ext2_msg(sb, KERN_ERR, "get root inode failed");
>  		ret = -ENOMEM;
>  		goto failed_mount3;
>  	}
>  	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
> -		ext2_warning(sb, __func__,
> -			"mounting ext3 filesystem as ext2");
> +		ext2_msg(sb, KERN_WARNING,
> +			"warning: mounting ext3 filesystem as ext2");
>  	ext2_setup_super (sb, es, sb->s_flags & MS_RDONLY);
>  	return 0;
>  
>  cantfind_ext2:
>  	if (!silent)
> -		printk("VFS: Can't find an ext2 filesystem on dev %s.\n",
> -		       sb->s_id);
> +		ext2_msg(sb, KERN_ERR,
> +			"VFS: Can't find an ext2 filesystem");
>  	goto failed_mount;
>  failed_mount3:
>  	percpu_counter_destroy(&sbi->s_freeblocks_counter);
> @@ -1170,7 +1190,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
>  	/*
>  	 * Allow the "check" option to be passed as a remount option.
>  	 */
> -	if (!parse_options (data, sbi)) {
> +	if (!parse_options(data, sbi, sb)) {
>  		err = -EINVAL;
>  		goto restore_opts;
>  	}
> @@ -1182,7 +1202,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
>  				    EXT2_MOUNT_XIP if not */
>  
>  	if ((ext2_use_xip(sb)) && (sb->s_blocksize != PAGE_SIZE)) {
> -		printk("XIP: Unsupported blocksize\n");
> +		ext2_msg(sb, KERN_WARNING, "XIP: Unsupported blocksize");
>  		err = -EINVAL;
>  		goto restore_opts;
>  	}
> @@ -1216,9 +1236,10 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
>  		__le32 ret = EXT2_HAS_RO_COMPAT_FEATURE(sb,
>  					       ~EXT2_FEATURE_RO_COMPAT_SUPP);
>  		if (ret) {
> -			printk("EXT2-fs: %s: couldn't remount RDWR because of "
> -			       "unsupported optional features (%x).\n",
> -			       sb->s_id, le32_to_cpu(ret));
> +			ext2_msg(sb, KERN_WARNING,
> +				"couldn't remount RDWR because of "
> +				"unsupported optional features (%x).",
> +				le32_to_cpu(ret));
>  			err = -EROFS;
>  			goto restore_opts;
>  		}


