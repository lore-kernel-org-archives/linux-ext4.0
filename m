From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3] ext4: make quota as first class supported feature
Date: Tue, 8 Nov 2011 14:55:14 +0100
Message-ID: <20111108135514.GB9658@quack.suse.cz>
References: <1320372920-21308-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, tytso@mit.edu, dmonakhov@openvz.org,
	jack@suse.cz, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab1KHNzR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Nov 2011 08:55:17 -0500
Content-Disposition: inline
In-Reply-To: <1320372920-21308-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Thanks for the patch. I did a detailed review of it. I have quite some
comments but all of them are easily fixable so I think we should be mostly
ready in the next iteration.

On Thu 03-11-11 19:15:20, Aditya Kali wrote:
> +static const struct quotactl_ops ext4_new_qctl_operations = {
  ext4_new_qctl_operations is rather poor name. What if you need to create
even newer set of operations in future? So I'd rather name them by "what
they do" - so something like ext4_sysfile_qctl_operations - meaning that these
operations handle quota stored in hidden system files.

> +       .quota_on_meta  = ext4_quota_on_meta,
> +       .quota_off      = ext4_quota_off,
> +       .quota_sync     = dquot_quota_sync,
> +       .get_info       = dquot_get_dqinfo,
> +       .set_info       = dquot_set_dqinfo,
> +       .get_dqblk      = dquot_get_dqblk,
> +       .set_dqblk      = dquot_set_dqblk
..
> @@ -3610,6 +3623,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  #ifdef CONFIG_QUOTA
>  	sb->s_qcop = &ext4_qctl_operations;
>  	sb->dq_op = &ext4_quota_operations;
> +
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) {
> +		/* Use new qctl operations with quota on function that does not
> +		 * require user specified quota file path. */
> +		sb->s_qcop = &ext4_new_qctl_operations;
> +
> +		sbi->s_qf_inums[USRQUOTA] = es->s_usr_quota_inum;
> +		sbi->s_qf_inums[GRPQUOTA] = es->s_grp_quota_inum;
  You need to convert from ondisk format here - i.e. use le32_to_cpu().

> +	}
>  #endif
>  	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
>  
> @@ -3815,8 +3837,21 @@ no_journal:
>  	} else
>  		descr = "out journal";
>  
> -	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
> -		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
> +#ifdef CONFIG_QUOTA
> +	/* Enable quota usage during mount. */
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
> +	    !(sb->s_flags & MS_RDONLY)) {
> +		ext4_quota_enable(sb, USRQUOTA, QFMT_VFS_V1,
> +				  DQUOT_USAGE_ENABLED);
> +		ext4_quota_enable(sb, GRPQUOTA, QFMT_VFS_V1,
> +				  DQUOT_USAGE_ENABLED);
> +	}
  You should check the return value here and fail the mount in case turning
quotas on fails... Also you should set DQUOT_QUOTA_SYS_FILE in
sb_dqopt(sb)->flags before calling ext4_quota_enable() to indicate that
quota file is a hidden system file and generic quota code can then skip
some rather costly steps during quota handling to keep user visible and
kernel visible content in sync.


> +#endif  /* CONFIG_QUOTA */
> +
> +	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. quota=%s. "
> +		 "Opts: %s%s%s", descr,
> +		 sb_any_quota_loaded(sb) ? "on" : "off",
> +		 sbi->s_es->s_mount_opts,
>  		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
  Should info about quotas really be in the message? After all it's just
another feature and we definitely don't report all the features filesystem
has set.

> @@ -4183,6 +4218,12 @@ static int ext4_commit_super(struct super_block *sb, int sync)
>  	es->s_free_inodes_count =
>  		cpu_to_le32(percpu_counter_sum_positive(
>  				&EXT4_SB(sb)->s_freeinodes_counter));
> +#ifdef CONFIG_QUOTA
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) {
> +		es->s_usr_quota_inum = EXT4_SB(sb)->s_qf_inums[USRQUOTA];
> +		es->s_grp_quota_inum = EXT4_SB(sb)->s_qf_inums[GRPQUOTA];
> +	}
> +#endif
  Is there really need to reset these numbers? They should be stable
during the whole lifetime of a filesystem, no (modulo changes by tune2fs)?
If I'm missing something and numbers indeed can change, you should convert
them to on disk format - i.e. cpu_to_le32().

> @@ -4814,6 +4855,59 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>  	return dquot_quota_on(sb, type, format_id, path);
>  }
>  
> +static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
> +			     unsigned int flags)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct inode *qf_inode;
> +	int err;
> +
> +	if (!sbi->s_qf_inums[type])
> +		return -EPERM;
> +
> +	qf_inode = ext4_iget(sb, sbi->s_qf_inums[type]);
> +	if (IS_ERR(qf_inode)) {
> +		ext4_error(sb, "Bad quota inode # %lu", sbi->s_qf_inums[type]);
> +		return PTR_ERR(qf_inode);
> +	}
> +
> +	/*
> +	 * When we journal data on quota file, we have to flush journal to see
> +	 * all updates to the file when we bypass pagecache...
> +	 */
> +	if (sbi->s_journal &&
> +	    ext4_should_journal_data(qf_inode)) {
> +		/*
> +		 * We don't need to lock updates but journal_flush() could
> +		 * otherwise be livelocked...
> +		 */
> +		jbd2_journal_lock_updates(sbi->s_journal);
> +		err = jbd2_journal_flush(sbi->s_journal);
> +		jbd2_journal_unlock_updates(sbi->s_journal);
> +		if (err)
> +			return err;
> +	}
  Why do you have the above check? Since this function is called only for
reserved quota inodes which are hidden, ext4_should_journal_data() will
never be true for them.

> +
> +	err = dquot_enable(qf_inode, type, format_id, flags);
> +	iput(qf_inode);
> +
> +	return err;
> +}
> @@ -4837,7 +4931,12 @@ static int ext4_quota_off(struct super_block *sb, int type)
>  	ext4_journal_stop(handle);
>  
>  out:
> -	return dquot_quota_off(sb, type);
> +	/* Disable only the limits if QUOTA feature is set. */
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA))
> +		return dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
> +	else
> +		return dquot_disable(sb, type,
> +				DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
>  }
  Hmm, most of the work ext4_quota_off() does is unnecessary when quota is
handled internally - there's no need to sync the filesystem, no need to
update mtime or ctime... So I'd rather provide a new ext4_quota_off()
function in case quota feature is enabled and that would just call
dquot_disable(sb, type, DQUOT_LIMITS_ENABLED).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
