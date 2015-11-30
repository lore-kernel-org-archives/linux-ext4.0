From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: remove incorrect check for inode journal mode
 in ext4_writepages()
Date: Mon, 30 Nov 2015 15:08:08 +0100
Message-ID: <20151130140808.GE4522@quack.suse.cz>
References: <1447810474-14840-1-git-send-email-daeho.jeong@samsung.com>
 <1447810474-14840-2-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbbK3OIM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 09:08:12 -0500
Content-Disposition: inline
In-Reply-To: <1447810474-14840-2-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 18-11-15 10:34:33, Daeho Jeong wrote:
> Now, in ext4, there is only one writepages() function and it is shared
> by all the inode modes. Therefore, BUG_ON() for checking journaled
> inode mode in ext4_writepages() is not correct anymore because, if
> per-file data journaling of a file is enabled while ext4_writepages()
> is being executed, this BUG_ON() function can cause a kernel panic
> unintentionally even on "nodelalloc" mode.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> ---
>  fs/ext4/inode.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1f9458e..db24348 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2480,13 +2480,11 @@ retry:
>  		}
>  
>  		/*
> -		 * We have two constraints: We find one extent to map and we
> +		 * We have a constraint: We find one extent to map and we
>  		 * must always write out whole page (makes a difference when
>  		 * blocksize < pagesize) so that we don't block on IO when we
> -		 * try to write out the rest of the page. Journalled mode is
> -		 * not supported by delalloc.
> +		 * try to write out the rest of the page.
>  		 */

Well, it is still true that journalled mode is not supported by delalloc so
I would not delete the comment.

Actually what you do only hides the real problem - that ext4_writepages()
in non-journalled mode can be still running for an inode which is already
switched to journalled mode. In theory if we manage to dirty some pages
after the switch, non-journalled writepages *can* see them an try to write
them back which will break spectacularly. So to fix this we need something
like a writeback barrier for the inode - make sure all ext4_writepages()
calls have completed before switching aops. Now I'd hate to grow struct
ext4_inode_info only for this extra rare case so we could probably
implement the barrier on per-filesystem basis - a fs-wide per-cpu rw
semaphore acquired for reading while ext4_writepages() runs and acquired
for writing when we switch aops for some inode.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
