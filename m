From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext4: enable again per-file data journaling on
 delalloc mode
Date: Mon, 30 Nov 2015 15:09:59 +0100
Message-ID: <20151130140959.GF4522@quack.suse.cz>
References: <1447810474-14840-1-git-send-email-daeho.jeong@samsung.com>
 <1447810474-14840-3-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbbK3OKB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 09:10:01 -0500
Content-Disposition: inline
In-Reply-To: <1447810474-14840-3-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-11-15 10:34:34, Daeho Jeong wrote:
> Several problems occurred when per-file data journaling is enabled on
> "delalloc" mode, so the per-file data journaling was permanently
> deactivated by commit 3d2b15826282 ("ext4: ignore
> EXT4_INODE_JOURNAL_DATA flag with delalloc"). But, those are not
> problems for only "delalloc" mode and when you execute xfstest on
> "nodelalloc" mode, same problems happen on "nodelalloc" mode. We always
> execute xfstest on "delalloc" mode, which is default mode, so we
> haven't realized problems of per-file data journaling feature. Finally,
> problems of per-file data journaling feature were fixed by commit
> 9c02ac97989d ("ext4: fix xfstest generic/269 double revoked buffer bug
> with bigalloc") and previous patchset. Now, we can re-enable the
> feature on "delalloc" mode.

Yeah, once we fix what I pointed out for patch 2/3 and we fix races with
page faults, this should be OK to do.

								Honza

> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> ---
>  fs/ext4/ext4_jbd2.h |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 9c5b49f..742b3ec 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -395,12 +395,10 @@ static inline int ext4_inode_journal_mode(struct inode *inode)
>  {
>  	if (EXT4_JOURNAL(inode) == NULL)
>  		return EXT4_INODE_WRITEBACK_DATA_MODE;	/* writeback */
> -	/* We do not support data journalling with delayed allocation */
>  	if (!S_ISREG(inode->i_mode) ||
>  	    test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
>  		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
> -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
> -	    !test_opt(inode->i_sb, DELALLOC))
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
>  		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
>  	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
>  		return EXT4_INODE_ORDERED_DATA_MODE;	/* ordered */
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
