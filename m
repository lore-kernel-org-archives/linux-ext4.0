Return-Path: <SRS0=eFe4=M4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50666 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbeJQDAg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Oct 2018 23:00:36 -0400
Date: Tue, 16 Oct 2018 15:08:40 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: fishland <fishland@aliyun.com>
Cc: adilger.kernel@dilger.ca, wang.yi59@zte.com.cn,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Song <liu.song11@zte.com.cn>
Subject: Re: [PATCH] ext4: direct return when jinode allocate failed
Message-ID: <20181016190840.GF24131@thunk.org>
References: <20181016145526.3288-1-fishland@aliyun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181016145526.3288-1-fishland@aliyun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2018 at 10:55:26PM +0800, fishland wrote:
> The jinode does not need protected by *i_lock*, we can return
> directly if memory allocation fails.
> 

I don't see anything wrong with this patch, but at the same time, I'm
not sure I see the benefit, either.  Checking for the allocation
failure is cheap, and moving it out spinlock doesn't buy much; not to
mention that the allocation failure is going to be highly uncommon.

What inspired this commit?

						- Ted



> Signed-off-by: Liu Song <liu.song11@zte.com.cn>
> Reviewed-by: Wang Yi <wang.yi59@zte.com.cn>
> ---
>  fs/ext4/inode.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d767e993591d..67ba6f062de5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4384,12 +4384,11 @@ int ext4_inode_attach_jinode(struct inode *inode)
>  		return 0;
>  
>  	jinode = jbd2_alloc_inode(GFP_KERNEL);
> +	if (!jinode)
> +		return -ENOMEM;
> +
>  	spin_lock(&inode->i_lock);
>  	if (!ei->jinode) {
> -		if (!jinode) {
> -			spin_unlock(&inode->i_lock);
> -			return -ENOMEM;
> -		}
>  		ei->jinode = jinode;
>  		jbd2_journal_init_jbd_inode(ei->jinode, inode);
>  		jinode = NULL;
> -- 
> 2.17.1
> 
