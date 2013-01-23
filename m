From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: check incompatible mount options when mounting
 ext2/3 [V2]
Date: Wed, 23 Jan 2013 11:39:17 +0100
Message-ID: <20130123103917.GD9821@quack.suse.cz>
References: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
 <1358870878-7369-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab3AWKjT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2013 05:39:19 -0500
Content-Disposition: inline
In-Reply-To: <1358870878-7369-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 22-01-13 11:07:58, Carlos Maiolino wrote:
> This checks for incompatible mounting options when using ext4 module to mount
> ext3 or ext2 filesystems.
> 
> Sets two new flags to group ext4 mount options that are incompatible with ext2
> and ext3, and then add two functions -- check_ext2/3_incompat_mount() -- to
> check and warn/fail mount, if any of these options are being used.
> 
> I believe, some options like those expecting an argument needs to be checked
> during parsing time.
> 
> barrier mount, although it has a flag, when mounting an ext2fs, where
> barriers are not supported (afaik), should also be checked during parse
> time, otherwise the BARRIER mount flag will be set.
> 
> I didn't add all mount options I believe to need to raise a warning, just
> those with a flag set on superblock, another flags should be added after a
> discussion to reach a concensus of all ext2/3 options that should be rejected by
> ext4 mount.
  Thinking about it a bit more I'm not sure if restricting mount options is
the right thing to start with.  IMHO what we should restrict is mounting
filesystem with certain *features* as ext3/ext2. So e.g. filesystem with
EXT4_FEATURE_INCOMPAT_EXTENTS cannot be mounted as ext2 or ext3. Similarly
as currently we forbid mounting ext3 filesystem with
EXT3_FEATURE_INCOMPAT_RECOVER as ext2... This should avoid the confusion
which could arise when someone reports problems with "ext3" filesystem but
actually has some of the ext4 features enabled.

This also naturally rules out some options such as journal checksum. Then
for mount options which don't affect the disk format (and thus are
effectively usable for ext2 or ext3) we can restrict the mount options.
There are options like dioread_nolock which actually don't matter (option
is noop for non-extent based files) but I'd forbid them just to reduce the
confusion. OTOH I would accept 'barrier' option even for ext2 as that
actually fixes fsync() for it. And then there are options like
'inode_readahead' which are boundary. They make sence for all the
filesystem flavors and hardly can cause any confusion - they just allow
more tweaking. I'd be inclined to allow these but it's a case by case
discussion I guess.

								Honza

> 
> Changelog:
> 	V2 - Fail a mount instead of just warning
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/ext4/ext4.h  | 15 +++++++++++++++
>  fs/ext4/super.c | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8462eb3..9478f1d 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -995,6 +995,21 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT2_EXPLICIT_DELALLOC	0x00000001 /* User explicitly
>  						      specified delalloc */
>  
> +#define EXT4_MOUNT_INCOMPAT_EXT3	(EXT4_MOUNT_JOURNAL_CHECKSUM |		\
> +					 EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |	\
> +					 EXT4_MOUNT_DELALLOC |			\
> +					 EXT4_MOUNT_DISCARD |			\
> +					 EXT4_MOUNT_BLOCK_VALIDITY |		\
> +					 EXT4_MOUNT_DATA_ERR_ABORT |		\
> +					 EXT4_MOUNT_DIOREAD_NOLOCK)
> +
> +#define EXT4_MOUNT_INCOMPAT_EXT2	(EXT4_MOUNT_INCOMPAT_EXT3 |		\
> +					 EXT4_MOUNT_NOLOAD |			\
> +					 EXT4_MOUNT_JOURNAL_DATA |		\
> +					 EXT4_MOUNT_WRITEBACK_DATA |		\
> +					 EXT4_MOUNT_UPDATE_JOURNAL |		\
> +					 EXT4_MOUNT_ORDERED_DATA)
> +
>  #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
>  						~EXT4_MOUNT_##opt
>  #define set_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt |= \
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3d4fb81..63c529e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -83,6 +83,8 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly);
>  static void ext4_destroy_lazyinit_thread(void);
>  static void ext4_unregister_li_request(struct super_block *sb);
>  static void ext4_clear_request_list(void);
> +static inline int check_ext3_incompat_mount(struct super_block *sb);
> +static inline int check_ext2_incompat_mount(struct super_block *sb);
>  
>  #if !defined(CONFIG_EXT2_FS) && !defined(CONFIG_EXT2_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
>  static struct file_system_type ext2_fs_type = {
> @@ -3470,6 +3472,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  				 "to feature incompatibilities");
>  			goto failed_mount;
>  		}
> +		ret = check_ext2_incompat_mount(sb);
>  	}
>  
>  	if (IS_EXT3_SB(sb)) {
> @@ -3481,8 +3484,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  				 "to feature incompatibilities");
>  			goto failed_mount;
>  		}
> +		ret = check_ext3_incompat_mount(sb);
>  	}
>  
> +	if (ret == -EPERM)
> +		goto failed_mount;
> +
>  	/*
>  	 * Check feature flags regardless of the revision level, since we
>  	 * previously didn't change the revision level when setting the flags,
> @@ -5194,6 +5201,30 @@ static inline int ext2_feature_set_ok(struct super_block *sb)
>  		return 0;
>  	return 1;
>  }
> +
> +static inline int check_ext3_incompat_mount(struct super_block *sb)
> +{
> +	if (test_opt(sb, INCOMPAT_EXT3)) {
> +		printk(KERN_WARNING
> +			"EXT4-fs: Mount options incompatible with ext3\n");
> +		return -EPERM;
> +	}
> +
> +	return 0;
> +
> +}
> +
> +static inline int check_ext2_incompat_mount(struct super_block *sb)
> +{
> +	if (test_opt(sb, INCOMPAT_EXT2)) {
> +		printk(KERN_WARNING
> +			"EXT4-fs: Mount options incompatible with ext2\n");
> +		return -EPERM;
> +	}
> +
> +	return 0;
> +}
> +
>  MODULE_ALIAS("ext2");
>  #else
>  static inline void register_as_ext2(void) { }
> -- 
> 1.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
