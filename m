From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/10 v5] ext4: convert unwritten extents from extent
 status tree in end_io
Date: Tue, 12 Feb 2013 13:51:59 +0100
Message-ID: <20130212125159.GD19583@quack.suse.cz>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-10-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967Ab3BLMwC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Feb 2013 07:52:02 -0500
Content-Disposition: inline
In-Reply-To: <1360313046-9876-10-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 08-02-13 16:44:05, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit tries to convert unwritten extents from extent status tree
> in end_io callback functions and ext4_ext_direct_IO.
  Why should we do this?

...
> @@ -801,3 +807,147 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
>  	tree->cache_es = NULL;
>  	return nr_shrunk;
>  }
> +
> +int ext4_es_convert_unwritten_extents(struct inode *inode, loff_t offset,
> +				      size_t size)
> +{
> +	struct ext4_es_tree *tree;
> +	struct rb_node *node;
> +	struct extent_status *es, orig_es, conv_es;
> +	ext4_lblk_t end, len1, len2;
> +	ext4_lblk_t lblk = 0, len = 0;
> +	ext4_fsblk_t block;
> +	unsigned long flags;
> +	unsigned int blkbits;
> +	int err = 0;
> +
> +	trace_ext4_es_convert_unwritten_extents(inode, offset, size);
> +	blkbits = inode->i_blkbits;
> +	lblk = offset >> blkbits;
> +	len = (EXT4_BLOCK_ALIGN(offset + size, blkbits) >> blkbits) - lblk;
> +
> +	end = lblk + len - 1;
> +	BUG_ON(end < lblk);
> +
> +	tree = &EXT4_I(inode)->i_es_tree;
> +
> +	write_lock_irqsave(&EXT4_I(inode)->i_es_lock, flags);
> +	es = __es_tree_search(&tree->root, lblk);
> +	if (!es)
> +		goto out;
> +	if (es->es_lblk > end)
> +		goto out;
> +
> +	tree->cache_es = NULL;
> +
> +	orig_es.es_lblk = es->es_lblk;
> +	orig_es.es_len = es->es_len;
> +	orig_es.es_pblk = es->es_pblk;
> +
> +	len1 = lblk > es->es_lblk ? lblk - es->es_lblk : 0;
> +	len2 = ext4_es_end(es) > end ?
> +	       ext4_es_end(es) - end : 0;
> +	if (len1 > 0)
> +		es->es_len = len1;
> +	if (len2 > 0) {
> +		if (len1 > 0) {
> +			struct extent_status newes;
> +
> +			newes.es_lblk = end + 1;
> +			newes.es_len = len2;
> +			block = ext4_es_pblock(&orig_es) +
> +				orig_es.es_len - len2;
> +			ext4_es_store_pblock(&newes, block);
> +			ext4_es_store_status(&newes, ext4_es_status(&orig_es));
> +			err = __es_insert_extent(inode, &newes);
> +			if (err) {
> +				es->es_lblk = orig_es.es_lblk;
> +				es->es_len = orig_es.es_len;
> +				es->es_pblk = orig_es.es_pblk;
> +				goto out;
> +			}
> +
> +			conv_es.es_lblk = orig_es.es_lblk + len1;
> +			conv_es.es_len = orig_es.es_len - len1 - len2;
> +			block = ext4_es_pblock(&orig_es) + len1;
> +			ext4_es_store_pblock(&conv_es, block);
> +			ext4_es_store_status(&conv_es, EXTENT_STATUS_WRITTEN);
> +			err = __es_insert_extent(inode, &conv_es);
> +			if (err) {
> +				int err2 = __es_remove_extent(inode,
> +							conv_es.es_lblk,
> +							ext4_es_end(&newes));
> +				if (err2)
> +					goto out;
> +				es->es_lblk = orig_es.es_lblk;
> +				es->es_len = orig_es.es_len;
> +				es->es_pblk = orig_es.es_pblk;
> +				goto out;
> +			}
> +		} else {
> +			es->es_lblk = end + 1;
> +			es->es_len = len2;
> +			block = ext4_es_pblock(&orig_es) +
> +				orig_es.es_len - len2;
> +			ext4_es_store_pblock(es, block);
> +
> +			conv_es.es_lblk = orig_es.es_lblk;
> +			conv_es.es_len = orig_es.es_len - len2;
> +			ext4_es_store_pblock(&conv_es,
> +					     ext4_es_pblock(&orig_es));
> +			ext4_es_store_status(&conv_es, EXTENT_STATUS_WRITTEN);
> +			err = __es_insert_extent(inode, &conv_es);
> +			if (err) {
> +				es->es_lblk = orig_es.es_lblk;
> +				es->es_len = orig_es.es_len;
> +				es->es_pblk = orig_es.es_pblk;
> +			}
> +		}
> +		goto out;
> +	}
> +
> +	if (len1 > 0) {
> +		node = rb_next(&es->rb_node);
> +		if (node)
> +			es = rb_entry(node, struct extent_status, rb_node);
> +		else
> +			es = NULL;
> +	}
> +
> +	while (es && ext4_es_end(es) <= end) {
> +		node = rb_next(&es->rb_node);
> +		ext4_es_store_status(es, EXTENT_STATUS_WRITTEN);
> +		if (!inode) {
> +			es = NULL;
> +			break;
> +		}
> +		es = rb_entry(node, struct extent_status, rb_node);
> +	}
> +
> +	if (es && es->es_lblk < end + 1) {
> +		ext4_lblk_t orig_len = es->es_len;
> +
> +		/*
> +		 * Here we first set conv_es just because of avoiding copy the
> +		 * value of es to a temporary variable.
> +		 */
> +		len1 = ext4_es_end(es) - end;
> +		conv_es.es_lblk = es->es_lblk;
> +		conv_es.es_len = es->es_len - len1;
> +		ext4_es_store_pblock(&conv_es, ext4_es_pblock(es));
> +		ext4_es_store_status(&conv_es, EXTENT_STATUS_WRITTEN);
> +
> +		es->es_lblk = end + 1;
> +		es->es_len = len1;
> +		block = ext4_es_pblock(es) + orig_len - len1;
> +		ext4_es_store_pblock(es, block);
> +
> +		err = __es_insert_extent(inode, &conv_es);
> +		if (err)
> +			goto out;
> +	}
> +
> +out:
> +	write_unlock_irqrestore(&EXT4_I(inode)->i_es_lock, flags);
> +	return err;
> +}
  Is this really needed? Why don't you just use ext4_es_insert_extent() to
insert new extent of proper type? Also the way you wrote it, we can return
(freshly written) data to the user, then reclaim the extent status from
memory and later return 0s because we read the original status from disk
(conversion hasn't still happened on disk). That would be certainly
confusing.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
