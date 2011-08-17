From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: remove deprecated oldalloc
Date: Wed, 17 Aug 2011 11:44:30 +0200
Message-ID: <20110817094430.GB9959@quack.suse.cz>
References: <1313510886-28619-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab1HQJoc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 05:44:32 -0400
Content-Disposition: inline
In-Reply-To: <1313510886-28619-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-08-11 18:08:06, Lukas Czerner wrote:
> For a long time now orlov is the default block allocator in the ext3. It
> performs better than the old one and no one seems to claim otherwise so
> we can safely drop it and make oldalloc and orlov mount option
> deprecated.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
  OK, merged into my tree.

								Honza
> ---
>  Documentation/filesystems/ext3.txt |    8 ------
>  fs/ext3/ialloc.c                   |   45 ++---------------------------------
>  fs/ext3/super.c                    |    8 +++---
>  include/linux/ext3_fs.h            |    2 +-
>  4 files changed, 8 insertions(+), 55 deletions(-)
> 
> diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
> index 22f3a0e..b100adc 100644
> --- a/Documentation/filesystems/ext3.txt
> +++ b/Documentation/filesystems/ext3.txt
> @@ -73,14 +73,6 @@ nobarrier	(*)	This also requires an IO stack which can support
>  			also be used to enable or disable barriers, for
>  			consistency with other ext3 mount options.
>  
> -orlov		(*)	This enables the new Orlov block allocator. It is
> -			enabled by default.
> -
> -oldalloc		This disables the Orlov block allocator and enables
> -			the old block allocator.  Orlov should have better
> -			performance - we'd like to get some feedback if it's
> -			the contrary for you.
> -
>  user_xattr		Enables Extended User Attributes.  Additionally, you
>  			need to have extended attribute support enabled in the
>  			kernel configuration (CONFIG_EXT3_FS_XATTR).  See the
> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index bf09cbf..635bd8c 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
> @@ -178,42 +178,6 @@ error_return:
>  }
>  
>  /*
> - * There are two policies for allocating an inode.  If the new inode is
> - * a directory, then a forward search is made for a block group with both
> - * free space and a low directory-to-inode ratio; if that fails, then of
> - * the groups with above-average free space, that group with the fewest
> - * directories already is chosen.
> - *
> - * For other inodes, search forward from the parent directory\'s block
> - * group to find a free inode.
> - */
> -static int find_group_dir(struct super_block *sb, struct inode *parent)
> -{
> -	int ngroups = EXT3_SB(sb)->s_groups_count;
> -	unsigned int freei, avefreei;
> -	struct ext3_group_desc *desc, *best_desc = NULL;
> -	int group, best_group = -1;
> -
> -	freei = percpu_counter_read_positive(&EXT3_SB(sb)->s_freeinodes_counter);
> -	avefreei = freei / ngroups;
> -
> -	for (group = 0; group < ngroups; group++) {
> -		desc = ext3_get_group_desc (sb, group, NULL);
> -		if (!desc || !desc->bg_free_inodes_count)
> -			continue;
> -		if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
> -			continue;
> -		if (!best_desc ||
> -		    (le16_to_cpu(desc->bg_free_blocks_count) >
> -		     le16_to_cpu(best_desc->bg_free_blocks_count))) {
> -			best_group = group;
> -			best_desc = desc;
> -		}
> -	}
> -	return best_group;
> -}
> -
> -/*
>   * Orlov's allocator for directories.
>   *
>   * We always try to spread first-level directories.
> @@ -436,12 +400,9 @@ struct inode *ext3_new_inode(handle_t *handle, struct inode * dir,
>  
>  	sbi = EXT3_SB(sb);
>  	es = sbi->s_es;
> -	if (S_ISDIR(mode)) {
> -		if (test_opt (sb, OLDALLOC))
> -			group = find_group_dir(sb, dir);
> -		else
> -			group = find_group_orlov(sb, dir);
> -	} else
> +	if (S_ISDIR(mode))
> +		group = find_group_orlov(sb, dir);
> +	else
>  		group = find_group_other(sb, dir);
>  
>  	err = -ENOSPC;
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 7beb69a..948b358 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -652,8 +652,6 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  		seq_puts(seq, ",nouid32");
>  	if (test_opt(sb, DEBUG))
>  		seq_puts(seq, ",debug");
> -	if (test_opt(sb, OLDALLOC))
> -		seq_puts(seq, ",oldalloc");
>  #ifdef CONFIG_EXT3_FS_XATTR
>  	if (test_opt(sb, XATTR_USER))
>  		seq_puts(seq, ",user_xattr");
> @@ -1049,10 +1047,12 @@ static int parse_options (char *options, struct super_block *sb,
>  			set_opt (sbi->s_mount_opt, DEBUG);
>  			break;
>  		case Opt_oldalloc:
> -			set_opt (sbi->s_mount_opt, OLDALLOC);
> +			ext3_msg(sb, KERN_WARNING,
> +				"Ignoring deprecated oldalloc option");
>  			break;
>  		case Opt_orlov:
> -			clear_opt (sbi->s_mount_opt, OLDALLOC);
> +			ext3_msg(sb, KERN_WARNING,
> +				"Ignoring deprecated orlov option");
>  			break;
>  #ifdef CONFIG_EXT3_FS_XATTR
>  		case Opt_user_xattr:
> diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> index 67a803a..96a30b9 100644
> --- a/include/linux/ext3_fs.h
> +++ b/include/linux/ext3_fs.h
> @@ -381,7 +381,7 @@ struct ext3_inode {
>   * Mount flags
>   */
>  #define EXT3_MOUNT_CHECK		0x00001	/* Do mount-time checks */
> -#define EXT3_MOUNT_OLDALLOC		0x00002  /* Don't use the new Orlov allocator */
> +/* EXT3_MOUNT_OLDALLOC was there */
>  #define EXT3_MOUNT_GRPID		0x00004	/* Create files with directory's group */
>  #define EXT3_MOUNT_DEBUG		0x00008	/* Some debugging messages */
>  #define EXT3_MOUNT_ERRORS_CONT		0x00010	/* Continue on errors */
> -- 
> 1.7.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
