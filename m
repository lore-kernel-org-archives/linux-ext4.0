From: Johann Lombardi <johann@whamcloud.com>
Subject: Re: [PATCH v3] ext4: make quota as first class supported feature
Date: Fri, 4 Nov 2011 10:20:22 +0100
Message-ID: <20111104092022.GD6205@granier.hd.free.fr>
References: <1320372920-21308-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, tytso@mit.edu, dmonakhov@openvz.org,
	jack@suse.cz, linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57344 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1KDJYW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2011 05:24:22 -0400
Received: by wyh15 with SMTP id 15so2063036wyh.19
        for <linux-ext4@vger.kernel.org>; Fri, 04 Nov 2011 02:24:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1320372920-21308-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 03, 2011 at 07:15:20PM -0700, Aditya Kali wrote:
> +#ifdef CONFIG_QUOTA
> +	/* Enable quota usage during mount. */
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
> +	    !(sb->s_flags & MS_RDONLY)) {
> +		ext4_quota_enable(sb, USRQUOTA, QFMT_VFS_V1,
> +				  DQUOT_USAGE_ENABLED);
> +		ext4_quota_enable(sb, GRPQUOTA, QFMT_VFS_V1,
> +				  DQUOT_USAGE_ENABLED);

I think we should print an error message if one of the calls to ext4_quota_enable() failed. Space accounting in the quota files won't be accurate any more and e2fsck is required.

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

iput(qf_inode) is missing in this error path.

Cheers,
Johann
