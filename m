From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: fix possible non-initialized variable on
 htree_dirblock_to_tree()
Date: Tue, 2 Oct 2012 15:55:52 +0200
Message-ID: <20121002135552.GF22777@quack.suse.cz>
References: <1349121055-8168-1-git-send-email-cmaiolino@redhat.com>
 <1349121055-8168-2-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab2JBNzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Oct 2012 09:55:53 -0400
Content-Disposition: inline
In-Reply-To: <1349121055-8168-2-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 01-10-12 16:50:54, Carlos Maiolino wrote:
> This is a backport of ext4 commit 90b0a9732 which fixes a possible
> non-initialized variable on htree_dirblock_to_tree().
> Ext3 has the same non initialized variable, but, in any case it will be
> initialized by ext3_get_blocks_handle(), which will avoid the bug to be
> triggered, but, the non-initialized variable by htree_dirblock_to_tree() is
> still a bug.
  This is a good cleanup. I've taken that into my tree.

								Honza

> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/ext3/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 8f4fdda..7f6c938 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -559,7 +559,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
>  {
>  	struct buffer_head *bh;
>  	struct ext3_dir_entry_2 *de, *top;
> -	int err, count = 0;
> +	int err = 0, count = 0;
>  
>  	dxtrace(printk("In htree dirblock_to_tree: block %d\n", block));
>  	if (!(bh = ext3_bread (NULL, dir, block, 0, &err)))
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
