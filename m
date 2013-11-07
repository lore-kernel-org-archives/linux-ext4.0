From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 07/11] fs/ext4: use rbtree postorder iteration helper
 instead of opencoding
Date: Thu, 7 Nov 2013 10:28:01 +0100
Message-ID: <20131107092801.GB28464@quack.suse.cz>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
 <1383788572-25938-8-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab3KGJ2F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Nov 2013 04:28:05 -0500
Content-Disposition: inline
In-Reply-To: <1383788572-25938-8-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 06-11-13 17:42:36, Cody P Schafer wrote:
> Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
> of opencoding an alternate postorder iteration that modifies the tree
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  fs/ext4/block_validity.c | 33 ++++-----------------------------
>  fs/ext4/dir.c            | 35 +++++------------------------------
>  2 files changed, 9 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
> index 3f11656..41eb9dc 100644
> --- a/fs/ext4/block_validity.c
> +++ b/fs/ext4/block_validity.c
> @@ -180,37 +180,12 @@ int ext4_setup_system_zone(struct super_block *sb)
>  /* Called when the filesystem is unmounted */
>  void ext4_release_system_zone(struct super_block *sb)
>  {
> -	struct rb_node	*n = EXT4_SB(sb)->system_blks.rb_node;
> -	struct rb_node	*parent;
> -	struct ext4_system_zone	*entry;
> +	struct ext4_system_zone	*entry, *n;
>  
> -	while (n) {
> -		/* Do the node's children first */
> -		if (n->rb_left) {
> -			n = n->rb_left;
> -			continue;
> -		}
> -		if (n->rb_right) {
> -			n = n->rb_right;
> -			continue;
> -		}
> -		/*
> -		 * The node has no children; free it, and then zero
> -		 * out parent's link to it.  Finally go to the
> -		 * beginning of the loop and try to free the parent
> -		 * node.
> -		 */
> -		parent = rb_parent(n);
> -		entry = rb_entry(n, struct ext4_system_zone, node);
> +	rbtree_postorder_for_each_entry_safe(entry, n,
> +			&EXT4_SB(sb)->system_blks, node)
>  		kmem_cache_free(ext4_system_zone_cachep, entry);
> -		if (!parent)
> -			EXT4_SB(sb)->system_blks = RB_ROOT;
> -		else if (parent->rb_left == n)
> -			parent->rb_left = NULL;
> -		else if (parent->rb_right == n)
> -			parent->rb_right = NULL;
> -		n = parent;
> -	}
> +
>  	EXT4_SB(sb)->system_blks = RB_ROOT;
>  }
>  
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 680bb33..d638c57 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -353,41 +353,16 @@ struct fname {
>   */
>  static void free_rb_tree_fname(struct rb_root *root)
>  {
> -	struct rb_node	*n = root->rb_node;
> -	struct rb_node	*parent;
> -	struct fname	*fname;
> -
> -	while (n) {
> -		/* Do the node's children first */
> -		if (n->rb_left) {
> -			n = n->rb_left;
> -			continue;
> -		}
> -		if (n->rb_right) {
> -			n = n->rb_right;
> -			continue;
> -		}
> -		/*
> -		 * The node has no children; free it, and then zero
> -		 * out parent's link to it.  Finally go to the
> -		 * beginning of the loop and try to free the parent
> -		 * node.
> -		 */
> -		parent = rb_parent(n);
> -		fname = rb_entry(n, struct fname, rb_hash);
> +	struct fname *fname, *next;
> +
> +	rbtree_postorder_for_each_entry_safe(fname, next, root, rb_hash)
>  		while (fname) {
>  			struct fname *old = fname;
>  			fname = fname->next;
>  			kfree(old);
>  		}
> -		if (!parent)
> -			*root = RB_ROOT;
> -		else if (parent->rb_left == n)
> -			parent->rb_left = NULL;
> -		else if (parent->rb_right == n)
> -			parent->rb_right = NULL;
> -		n = parent;
> -	}
> +
> +	*root = RB_ROOT;
>  }
>  
>  
> -- 
> 1.8.4.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
