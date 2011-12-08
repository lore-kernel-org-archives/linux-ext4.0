From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: Fix error handling on inode bitmap corruption
Date: Thu, 08 Dec 2011 14:46:09 -0600
Message-ID: <4EE12211.3000604@redhat.com>
References: <1323376115-23881-1-git-send-email-jack@suse.cz> <1323376115-23881-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1LHUqf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Dec 2011 15:46:35 -0500
In-Reply-To: <1323376115-23881-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/8/11 2:28 PM, Jan Kara wrote:
> When insert_inode_locked() fails in ext3_new_inode() it most likely
> means inode bitmap got corrupted and we allocated again inode which
> is already in use. Also doing unlock_new_inode() during error recovery
> is wrong since inode does not have I_NEW set. Fix the problem by jumping
> to fail: (instead of fail_drop:) which declares filesystem error and
> does not call unlock_new_inode().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I think ext2 could use the same treatment.

BTW, though, have you recently started seeing the issue?  We have
people hitting this when resuming after suspend; it seems likely
that the bitmap did get corrupted though, based on some other
things seen in similar bugs.

-Eric

> ---
>  fs/ext3/ialloc.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index 5c866e0..adae962 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
> @@ -525,8 +525,12 @@ got:
>  	if (IS_DIRSYNC(inode))
>  		handle->h_sync = 1;
>  	if (insert_inode_locked(inode) < 0) {
> -		err = -EINVAL;
> -		goto fail_drop;
> +		/*
> +		 * Likely a bitmap corruption causing inode to be allocated
> +		 * twice.
> +		 */
> +		err = -EIO;
> +		goto fail;
>  	}
>  	spin_lock(&sbi->s_next_gen_lock);
>  	inode->i_generation = sbi->s_next_generation++;

