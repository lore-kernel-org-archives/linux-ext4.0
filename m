From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 06/19] ext2: replace inode uid,gid,mode init with
 helper v2
Date: Thu, 18 Feb 2010 19:49:22 +0100
Message-ID: <20100218184922.GB3364@quack.suse.cz>
References: <1266431353-8549-1-git-send-email-dmonakhov@openvz.org>
 <1266432013-9241-1-git-send-email-dmonakhov@openvz.org>
 <20100218012128.GA8897@atrey.karlin.mff.cuni.cz>
 <87vddv9ggc.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36789 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0BRStN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Feb 2010 13:49:13 -0500
Content-Disposition: inline
In-Reply-To: <87vddv9ggc.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-02-10 10:00:03, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Looks good.
Acked-by: Jan Kara <jack@suse.cz>

							Honza
> ---
>  fs/ext2/ialloc.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
> index 15387c9..2c484c6 100644
> --- a/fs/ext2/ialloc.c
> +++ b/fs/ext2/ialloc.c
> @@ -550,16 +550,12 @@ got:
>  
>  	sb->s_dirt = 1;
>  	mark_buffer_dirty(bh2);
> -	inode->i_uid = current_fsuid();
> -	if (test_opt (sb, GRPID))
> +	if (test_opt(sb, GRPID)) {
> +		inode->i_mode = mode;
> +		inode->i_uid = current_fsuid();
>  		inode->i_gid = dir->i_gid;
> -	else if (dir->i_mode & S_ISGID) {
> -		inode->i_gid = dir->i_gid;
> -		if (S_ISDIR(mode))
> -			mode |= S_ISGID;
>  	} else
> -		inode->i_gid = current_fsgid();
> -	inode->i_mode = mode;
> +		inode_init_owner(inode, dir, mode);
>  
>  	inode->i_ino = ino;
>  	inode->i_blocks = 0;
> -- 
> 1.6.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
