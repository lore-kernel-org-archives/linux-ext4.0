From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix return value of ext4_do_update_inode
Date: Sun, 28 Sep 2014 21:46:53 -0500
Message-ID: <5428C81D.1060808@redhat.com>
References: <1411955914-550-1-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Li Xi <pkuelelixi@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger@dilger.ca, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbaI2CrB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Sep 2014 22:47:01 -0400
In-Reply-To: <1411955914-550-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/28/14 8:58 PM, Li Xi wrote:
> When ext4_do_update_inode() gets error from ext4_inode_blocks_set(),
> error number should be returned.

How strange, it has been missing this error return ever since the
original commit in 2008.  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Li Xi <lixi@ddn.com>
> ---
>  fs/ext4/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d5dd7d4..03ddfd7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4204,7 +4204,8 @@ static int ext4_do_update_inode(handle_t *handle,
>  	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
>  	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
>  
> -	if (ext4_inode_blocks_set(handle, raw_inode, ei)) {
> +	err = ext4_inode_blocks_set(handle, raw_inode, ei);
> +	if (err) {
>  		spin_unlock(&ei->i_raw_lock);
>  		goto out_brelse;
>  	}
> 

