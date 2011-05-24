From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 14/19] ext3: remove unnecessary dentry_unhash on
 rmdir/rename_dir
Date: Tue, 24 May 2011 22:38:02 +0200
Message-ID: <20110524203802.GA14304@quack.suse.cz>
References: <1306267582-5347-1-git-send-email-sage@newdream.net>
 <1306267582-5347-15-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200Ab1EXUiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 16:38:07 -0400
Content-Disposition: inline
In-Reply-To: <1306267582-5347-15-git-send-email-sage@newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-05-11 13:06:17, Sage Weil wrote:
> ext3 has no problems with lingering references to unlinked directory
> inodes.
  OK, so if I understand right, dentry_unhash() has been there only so that
filesystem can detect whether (something under) removed directory is in
use? So filesystems which can happily handle unlinked but open directories
don't need it, right? If that's the case, you can add:
  Acked-by: Jan Kara <jack@suse.cz>
to this patch and also the ext2 version.

								Honza
> 
> CC: Jan Kara <jack@suse.cz>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andreas Dilger <adilger.kernel@dilger.ca>
> CC: linux-ext4@vger.kernel.org
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/ext3/namei.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index f89b1d4..32f3b86 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -2074,8 +2074,6 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
>  	struct ext3_dir_entry_2 * de;
>  	handle_t *handle;
>  
> -	dentry_unhash(dentry);
> -
>  	/* Initialize quotas before so that eventual writes go in
>  	 * separate transaction */
>  	dquot_initialize(dir);
> @@ -2298,9 +2296,6 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
>  	struct ext3_dir_entry_2 * old_de, * new_de;
>  	int retval, flush_file = 0;
>  
> -	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
> -		dentry_unhash(new_dentry);
> -
>  	dquot_initialize(old_dir);
>  	dquot_initialize(new_dir);
>  
> -- 
> 1.7.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
