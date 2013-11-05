From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/8] fs/ext3: use rbtree postorder iteration helper
 instead of opencoding
Date: Tue, 5 Nov 2013 01:45:59 +0100
Message-ID: <20131105004559.GB24531@quack.suse.cz>
References: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
 <1383345566-25087-6-git-send-email-cody@linux.vnet.ibm.com>
 <20131104142638.GD8566@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab3KEAqD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Nov 2013 19:46:03 -0500
Content-Disposition: inline
In-Reply-To: <20131104142638.GD8566@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 04-11-13 15:26:38, Jan Kara wrote:
> On Fri 01-11-13 15:38:50, Cody P Schafer wrote:
> > Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
> > of opencoding an alternate postorder iteration that modifies the tree
>   Thanks. I've merged the patch into my tree.
  Hum, except that the kernel oopses with this patch. And I think the
problem is in rbtree_postorder_for_each_entry_safe(). How are those tests
for NULL supposed to work? For example if the tree is empty, 'pos' will be
NULL and you'll call rb_next_postorder(&NULL->field) which is pretty much
guaranteed to oops if 'field' doesn't have offset 0 in the structure...
	
								Honza

> > Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> > ---
> >  fs/ext3/dir.c | 36 +++++-------------------------------
> >  1 file changed, 5 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
> > index bafdd48..a331ad1 100644
> > --- a/fs/ext3/dir.c
> > +++ b/fs/ext3/dir.c
> > @@ -309,43 +309,17 @@ struct fname {
> >   */
> >  static void free_rb_tree_fname(struct rb_root *root)
> >  {
> > -	struct rb_node	*n = root->rb_node;
> > -	struct rb_node	*parent;
> > -	struct fname	*fname;
> > -
> > -	while (n) {
> > -		/* Do the node's children first */
> > -		if (n->rb_left) {
> > -			n = n->rb_left;
> > -			continue;
> > -		}
> > -		if (n->rb_right) {
> > -			n = n->rb_right;
> > -			continue;
> > -		}
> > -		/*
> > -		 * The node has no children; free it, and then zero
> > -		 * out parent's link to it.  Finally go to the
> > -		 * beginning of the loop and try to free the parent
> > -		 * node.
> > -		 */
> > -		parent = rb_parent(n);
> > -		fname = rb_entry(n, struct fname, rb_hash);
> > +	struct fname *fname, *next;
> > +
> > +	rbtree_postorder_for_each_entry_safe(fname, next, root, rb_hash)
> >  		while (fname) {
> >  			struct fname * old = fname;
> >  			fname = fname->next;
> >  			kfree (old);
> >  		}
> > -		if (!parent)
> > -			*root = RB_ROOT;
> > -		else if (parent->rb_left == n)
> > -			parent->rb_left = NULL;
> > -		else if (parent->rb_right == n)
> > -			parent->rb_right = NULL;
> > -		n = parent;
> > -	}
> > -}
> >  
> > +	*root = RB_ROOT;
> > +}
> >  
> >  static struct dir_private_info *ext3_htree_create_dir_info(struct file *filp,
> >  							   loff_t pos)
> > -- 
> > 1.8.4.2
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
