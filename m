From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Remove redundant unlikely()
Date: Thu, 6 Jan 2011 16:44:03 +0100
Message-ID: <20110106154403.GM4641@quack.suse.cz>
References: <1291905540-32296-1-git-send-email-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1AFPo2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jan 2011 10:44:28 -0500
Content-Disposition: inline
In-Reply-To: <1291905540-32296-1-git-send-email-tklauser@distanz.ch>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 09-12-10 15:39:00, Tobias Klauser wrote:
> IS_ERR() already implies unlikely(), so it can be omitted here.
  Thanks. Merged.

								Honza

> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  fs/ext2/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index f8aecd2..2e1d834 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -67,7 +67,7 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
>  	inode = NULL;
>  	if (ino) {
>  		inode = ext2_iget(dir->i_sb, ino);
> -		if (unlikely(IS_ERR(inode))) {
> +		if (IS_ERR(inode)) {
>  			if (PTR_ERR(inode) == -ESTALE) {
>  				ext2_error(dir->i_sb, __func__,
>  						"deleted inode referenced: %lu",
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
