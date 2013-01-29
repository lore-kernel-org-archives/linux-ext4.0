From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] ext4: remove unnecessary NULL pointer check
Date: Mon, 28 Jan 2013 17:24:13 -0800
Message-ID: <20130129012413.GC4754@blackbox.djwong.org>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <1358496074-6228-4-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31375 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3A2BYU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 20:24:20 -0500
Content-Disposition: inline
In-Reply-To: <1358496074-6228-4-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 04:01:14PM +0800, Guo Chao wrote:
> brelse() and ext4_journal_force_commit() are both inlined and able
> to handle NULL.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>

This one looks ok too, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

PS: Does the order of the patches matter?  Or are these just four patches that
are mostly independent of each other?

--D
> ---
>  fs/ext4/namei.c |    3 +--
>  fs/ext4/super.c |    6 +-----
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index e35ea3d..f0812c0 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2110,8 +2110,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
>  journal_error:
>  	ext4_std_error(dir->i_sb, err);
>  cleanup:
> -	if (bh)
> -		brelse(bh);
> +	brelse(bh);
>  	dx_release(frames);
>  	return err;
>  }
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3d4fb81..f3acd6f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4476,16 +4476,12 @@ static void ext4_clear_journal_err(struct super_block *sb,
>  int ext4_force_commit(struct super_block *sb)
>  {
>  	journal_t *journal;
> -	int ret = 0;
>  
>  	if (sb->s_flags & MS_RDONLY)
>  		return 0;
>  
>  	journal = EXT4_SB(sb)->s_journal;
> -	if (journal)
> -		ret = ext4_journal_force_commit(journal);
> -
> -	return ret;
> +	return ext4_journal_force_commit(journal);
>  }
>  
>  static int ext4_sync_fs(struct super_block *sb, int wait)
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
