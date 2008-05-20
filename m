From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: improve some code in rb tree part of dir.c
Date: Tue, 20 May 2008 11:46:36 -0700
Message-ID: <1211309196.3644.0.camel@localhost.localdomain>
References: <48324E96.5050705@cn.fujitsu.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42754 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064AbYETSqr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 14:46:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4KIkimf020192
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 14:46:44 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4KIkgnq160626
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 14:46:42 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4KIkg6K026845
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 14:46:42 -0400
In-Reply-To: <48324E96.5050705@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-05-20 at 12:07 +0800, Shen Feng wrote:
> *remove unnecessary code in free_rb_tree_fname
> *rename free_rb_tree_fname to ext4_htree_create_dir_info
>  since it and ext4_htree_free_dir_info are a pair
> *replace kmalloc with kzalloc in ext4_htree_free_dir_info
> 
> All these make the code more readable and simple.
> PS: this patch is also suitable for ext3.
> 
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
> ---
>  fs/ext4/dir.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 2bf0331..5ed5108 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -272,7 +272,7 @@ static void free_rb_tree_fname(struct rb_root *root)
> 
>  	while (n) {
>  		/* Do the node's children first */
> -		if ((n)->rb_left) {
> +		if (n->rb_left) {
>  			n = n->rb_left;
>  			continue;
>  		}
> @@ -301,24 +301,18 @@ static void free_rb_tree_fname(struct rb_root *root)
>  			parent->rb_right = NULL;
>  		n = parent;
>  	}
> -	root->rb_node = NULL;
>  }
> 
> 
> -static struct dir_private_info *create_dir_info(loff_t pos)
> +static struct dir_private_info *ext4_htree_create_dir_info(loff_t pos)
>  {
>  	struct dir_private_info *p;
> 
> -	p = kmalloc(sizeof(struct dir_private_info), GFP_KERNEL);
> +	p = kzalloc(sizeof(struct dir_private_info), GFP_KERNEL);
>  	if (!p)
>  		return NULL;
> -	p->root.rb_node = NULL;
> -	p->curr_node = NULL;
> -	p->extra_fname = NULL;
> -	p->last_pos = 0;
>  	p->curr_hash = pos2maj_hash(pos);
>  	p->curr_minor_hash = pos2min_hash(pos);
> -	p->next_hash = 0;
>  	return p;
>  }
> 
> @@ -433,7 +427,7 @@ static int ext4_dx_readdir(struct file * filp,
>  	int	ret;
> 
>  	if (!info) {
> -		info = create_dir_info(filp->f_pos);
> +		info = ext4_htree_create_dir_info(filp->f_pos);
>  		if (!info)
>  			return -ENOMEM;
>  		filp->private_data = info;

