From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/10 v5] ext4: track all extent status in extent
 status tree
Date: Mon, 11 Feb 2013 13:21:27 +0100
Message-ID: <20130211122127.GB5318@quack.suse.cz>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-5-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab3BKMVa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 07:21:30 -0500
Content-Disposition: inline
In-Reply-To: <1360313046-9876-5-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 08-02-13 16:44:00, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> By recording the phycisal block and status, extent status tree is able
> to track the status of every extents.  When we call _map_blocks
> functions to lookup an extent or create a new written/unwritten/delayed
> extent, this extent will be inserted into extent status tree.  The hole
> extent is inserted in ext4_ext_put_gap_in_cache().  If there is no any
> extent, we will not insert a hole extent [0, ~0] into the extent status
> tree in order to reduce the complextiy of code.
> 
> We don't load all extents from disk in alloc_inode() because it costs
> too much memory, and if a file is opened and closed frequently it will
> takes too much time to load all extent information.  So currently when
> we create/lookup an extent, this extent will be inserted into extent
> status tree.  Hence, the extent status tree may not comprehensively
> contain all of the extents found in the file.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Jan kara <jack@suse.cz>
> ---
>  fs/ext4/extents.c           |  4 +--
>  fs/ext4/extents_status.c    | 27 ++++++++++++------
>  fs/ext4/extents_status.h    |  4 +--
>  fs/ext4/file.c              |  4 +--
>  fs/ext4/inode.c             | 68 ++++++++++++++++++++++++++++-----------------
>  include/trace/events/ext4.h |  4 +--
>  6 files changed, 70 insertions(+), 41 deletions(-)
> 
...
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 5093cee..71cb75a 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -239,14 +239,15 @@ static struct extent_status *__es_tree_search(struct rb_root *root,
>   * EXT_MAX_BLOCKS if no extent is found.
>   * Delayed extent is returned via @es.
>   */
> -ext4_lblk_t ext4_es_find_extent(struct inode *inode, struct extent_status *es)
> +ext4_lblk_t ext4_es_find_delayed_extent(struct inode *inode,
> +					struct extent_status *es)
>  {
  I have to say I'm still not very happy about this function (but it's much
better than it used to be so thanks for that!). I have two suggestions for
improvement:
1) 'es' is both input and output argument where for input only es_lblk is
used. That's a bit confusing so how about making the function like:

ext4_es_find_delayed_extent(struct inode *inode, ext4_lblk_t offset,
			    struct extent_status *out);

  to separate input and output? Also you can comment that we use the 'out'
parameter instead of returning the extent_status from the tree because that
can be freed once we drop the spinlock protecting status tree.

2) The returned value is somewhat surprisingly the logical offset of the
*next* delalloc extent. It's used only in ext4_fill_fiemap_extents()
AFAICS. It would be easier to understand if the function didn't return
anything. ext4_fill_fiemap_extents() would use
ext4_es_find_delayed_extent() to find both current and next delalloc extent
(which would become the 'current' one in the next iteration). As a bonus
you would also save some iteration of the extent status tree...

>  	struct ext4_es_tree *tree = NULL;
>  	struct extent_status *es1 = NULL;
>  	struct rb_node *node;
>  	ext4_lblk_t ret = EXT_MAX_BLOCKS;
>  
> -	trace_ext4_es_find_extent_enter(inode, es->es_lblk);
> +	trace_ext4_es_find_delayed_extent_enter(inode, es->es_lblk);
>  
>  	read_lock(&EXT4_I(inode)->i_es_lock);
>  	tree = &EXT4_I(inode)->i_es_tree;
> @@ -266,21 +267,31 @@ ext4_lblk_t ext4_es_find_extent(struct inode *inode, struct extent_status *es)
>  	es1 = __es_tree_search(&tree->root, es->es_lblk);
>  
>  out:
> -	if (es1) {
> +	if (es1 && !ext4_es_is_delayed(es1)) {
> +		while ((node = rb_next(&es1->rb_node)) != NULL) {
> +			es1 = rb_entry(node, struct extent_status, rb_node);
> +			if (ext4_es_is_delayed(es1))
> +				break;
> +		}
> +	}
> +
> +	if (es1 && ext4_es_is_delayed(es1)) {
>  		tree->cache_es = es1;
>  		es->es_lblk = es1->es_lblk;
>  		es->es_len = es1->es_len;
>  		es->es_pblk = es1->es_pblk;
> -		node = rb_next(&es1->rb_node);
> -		if (node) {
> +		while ((node = rb_next(&es1->rb_node)) != NULL) {
>  			es1 = rb_entry(node, struct extent_status, rb_node);
> -			ret = es1->es_lblk;
> +			if (ext4_es_is_delayed(es1)) {
> +				ret = es1->es_lblk;
> +				break;
> +			}
>  		}
>  	}
>  
>  	read_unlock(&EXT4_I(inode)->i_es_lock);
>  
> -	trace_ext4_es_find_extent_exit(inode, es, ret);
> +	trace_ext4_es_find_delayed_extent_exit(inode, es, ret);
>  	return ret;
>  }
>  
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
