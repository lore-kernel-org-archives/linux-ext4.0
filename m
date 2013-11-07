From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 09/11] fs/ext3: use rbtree postorder iteration helper
 instead of opencoding
Date: Thu, 7 Nov 2013 09:17:20 +0100
Message-ID: <20131107081720.GA28464@quack.suse.cz>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
 <1383788572-25938-10-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Andreas Dilger <adilger.kernel@dilger.ca>,
	LKML <linux-kernel@vger.kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1383788572-25938-10-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 06-11-13 17:42:38, Cody P Schafer wrote:
> Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
> of opencoding an alternate postorder iteration that modifies the tree
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
  OK, since this patch now depends on rbtree_postorder... fix, I'll just
give you my:

Acked-by: Jan Kara <jack@suse.cz>

and you can merge it with other patches in the series.

								Honza
> ---
>  fs/ext3/dir.c | 36 +++++-------------------------------
>  1 file changed, 5 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
> index bafdd48..a331ad1 100644
> --- a/fs/ext3/dir.c
> +++ b/fs/ext3/dir.c
> @@ -309,43 +309,17 @@ struct fname {
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
>  			struct fname * old = fname;
>  			fname = fname->next;
>  			kfree (old);
>  		}
> -		if (!parent)
> -			*root = RB_ROOT;
> -		else if (parent->rb_left == n)
> -			parent->rb_left = NULL;
> -		else if (parent->rb_right == n)
> -			parent->rb_right = NULL;
> -		n = parent;
> -	}
> -}
>  
> +	*root = RB_ROOT;
> +}
>  
>  static struct dir_private_info *ext3_htree_create_dir_info(struct file *filp,
>  							   loff_t pos)
> -- 
> 1.8.4.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
