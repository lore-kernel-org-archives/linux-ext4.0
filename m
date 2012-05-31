From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: let getattr report the right blocks in delalloc+bigalloc.
Date: Thu, 31 May 2012 12:08:50 -0500
Message-ID: <4FC7A5A2.1080704@redhat.com>
References: <1328025496-3521-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2EaSFT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 14:05:19 -0400
In-Reply-To: <1328025496-3521-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/31/12 9:58 AM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In delayed allocation, i_reserved_data_blocks now indicates
> clusters, not blocks. So report it in the right number.
> 
> This can be easily exposed by the following command:
> echo foo > blah; du -hc blah; sync; du -hc blah
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Reviewed-by: Eric Sandeen <sandeen2redhat.com>

It'd be great to get this one merged.

Thanks,
-Eric

> ---
>  fs/ext4/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index feaa82f..a5eb8c6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4200,7 +4200,8 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
>  	 * will return the blocks that include the delayed allocation
>  	 * blocks for this file.
>  	 */
> -	delalloc_blocks = EXT4_I(inode)->i_reserved_data_blocks;
> +	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
> +				EXT4_I(inode)->i_reserved_data_blocks);
>  
>  	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
>  	return 0;

