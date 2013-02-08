From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/10 v5] ext4: refine extent status tree
Date: Fri, 8 Feb 2013 16:35:00 +0100
Message-ID: <20130208153500.GA10226@quack.suse.cz>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab3BHPfN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Feb 2013 10:35:13 -0500
Content-Disposition: inline
In-Reply-To: <1360313046-9876-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 08-02-13 16:43:57, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit refines the extent status tree code.
> 
> 1) A prefix 'es_' is added to to the extent status tree structure
> members.
> 
> 2) Refactored es_remove_extent() so that __es_remove_extent() can be
> used by es_insert_extent() to remove the old extent entry(-ies) before
> inserting a new one.
> 
> 3) Rename extent_status_end() to ext4_es_end()
> 
> 4) ext4_es_can_be_merged() is define to check whether two extents can
> be merged or not.
> 
> 5) Update and clarified comments.
  Just one minor comment below. Otherwise the patch looks good (although I
admit I didn't check all the renaming changes carefully. You can add:
  Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Jan kara <jack@suse.cz>
> ---
>  fs/ext4/extents.c           |  21 +--
>  fs/ext4/extents_status.c    | 318 ++++++++++++++++++++++++--------------------
>  fs/ext4/extents_status.h    |   8 +-
>  fs/ext4/file.c              |  12 +-
>  include/trace/events/ext4.h |  40 +++---
>  5 files changed, 217 insertions(+), 182 deletions(-)
> 
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
...
> @@ -320,60 +352,39 @@ ext4_es_try_to_merge_right(struct ext4_es_tree *tree, struct extent_status *es)
>  	return es;
>  }
>  
> -static int __es_insert_extent(struct ext4_es_tree *tree, ext4_lblk_t offset,
> -			      ext4_lblk_t len)
> +static int __es_insert_extent(struct ext4_es_tree *tree,
> +			      struct extent_status *newes)
>  {
>  	struct rb_node **p = &tree->root.rb_node;
>  	struct rb_node *parent = NULL;
>  	struct extent_status *es;
> -	ext4_lblk_t end = offset + len - 1;
> -
> -	BUG_ON(end < offset);
> -	es = tree->cache_es;
> -	if (es && offset == (extent_status_end(es) + 1)) {
> -		es_debug("cached by [%u/%u)\n", es->start, es->len);
> -		es->len += len;
> -		es = ext4_es_try_to_merge_right(tree, es);
> -		goto out;
> -	} else if (es && es->start == end + 1) {
> -		es_debug("cached by [%u/%u)\n", es->start, es->len);
> -		es->start = offset;
> -		es->len += len;
> -		es = ext4_es_try_to_merge_left(tree, es);
> -		goto out;
> -	} else if (es && es->start <= offset &&
> -		   end <= extent_status_end(es)) {
> -		es_debug("cached by [%u/%u)\n", es->start, es->len);
> -		goto out;
> -	}
>  
>  	while (*p) {
>  		parent = *p;
>  		es = rb_entry(parent, struct extent_status, rb_node);
>  
> -		if (offset < es->start) {
> -			if (es->start == end + 1) {
> -				es->start = offset;
> -				es->len += len;
> +		if (newes->es_lblk < es->es_lblk) {
> +			if (ext4_es_can_be_merged(newes, es)) {
> +				es->es_lblk = newes->es_lblk;
> +				es->es_len += newes->es_len;
  This is wrong, isn't it? You cannot change es->es_lblk because that can
break ordering of elements in the tree... thinking ... ah, it's OK because
you have non-overlapping intervals. But it deserves a comment I guess.

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
