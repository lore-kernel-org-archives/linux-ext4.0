From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use an rb tree for tracking blocks freed during
	transaction.
Date: Sun, 12 Oct 2008 16:31:47 -0400
Message-ID: <20081012203147.GF12662@mit.edu>
References: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53631 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149AbYJLUb6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Oct 2008 16:31:58 -0400
Content-Disposition: inline
In-Reply-To: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 09, 2008 at 09:02:07PM +0530, Aneesh Kumar K.V wrote:
> With this patch we track the block freed during a transaction using
> rb tree. We also make sure contiguos blocks freed are collected
> in one rb node.

There seems to be a memory leak.  Over time, the number of active
objects in ext4_free_block_extents goes up.  You can check via:

	grep ext4_free_block_extents /proc/slabinfo 

I think the problem is here:

> +	/* Now try to see the extent can be merged to left and right */
> +	node = rb_prev(new_node);
> +	if (node) {
> +		entry = rb_entry(node, struct ext4_free_data, node);
> +		if (can_merge(entry, new_entry)) {
> +			new_entry->start_blk = entry->start_blk;
> +			new_entry->count += entry->count;
> +			rb_erase(node, &(db->bb_free_root));
> +			list_del(&entry->list);
>  		}
> +	}

We aren't freeing new_entry in ext4_mb_free_metadata() in the case
where the extent can be merged with an existing node in the rbtree.

      	  	     	       	       		- Ted
