From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Fix error handling on inode bitmap corruption
Date: Thu, 08 Dec 2011 14:44:48 -0600
Message-ID: <4EE121C0.5070908@redhat.com>
References: <1323376115-23881-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1LHUpP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Dec 2011 15:45:15 -0500
In-Reply-To: <1323376115-23881-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/8/11 2:28 PM, Jan Kara wrote:
> When insert_inode_locked() fails in ext4_new_inode() it most likely means inode
> bitmap got corrupted and we allocated again inode which is already in use. Also
> doing unlock_new_inode() during error recovery is wrong since the inode does
> not have I_NEW set. Fix the problem by jumping to fail: (instead of fail_drop:)
> which declares filesystem error and does not call unlock_new_inode().

This looks an awful lot like the:

[PATCH 3/6 V2] ext4: fix up error handling for insert_inode_locked

I sent a couple days ago.

Except yours is better ;)  I had overlooked the existing fail: target.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ialloc.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 00beb4f..8fb6844 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -885,8 +885,12 @@ got:
>  	if (IS_DIRSYNC(inode))
>  		ext4_handle_sync(handle);
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

