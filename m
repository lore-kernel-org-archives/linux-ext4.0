From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Wed, 19 Sep 2012 15:05:41 -0400
Message-ID: <20120919190541.GE28470@thunk.org>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51590 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150Ab2ISTFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 15:05:49 -0400
Content-Disposition: inline
In-Reply-To: <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 22, 2012 at 02:05:40PM +0800, Zheng Liu wrote:
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3e0851e..353b1fd 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -944,6 +944,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
>  	INIT_LIST_HEAD(&ei->i_prealloc_list);
>  	spin_lock_init(&ei->i_prealloc_lock);
> +	ext4_es_init_tree(&ei->i_es_tree);
>  	ei->i_reserved_data_blocks = 0;
>  	ei->i_reserved_meta_blocks = 0;
>  	ei->i_allocated_meta_blocks = 0;

This patch hunk immediately me ask, "so when does the extent_status
tree get freed?"  And I believe the answer is that currently, since it
only tracks delayed extents (and we're not using it for locking
purposes), by the time we have evicted the inode and are ready to call
ext4_clear_inode(), we should have released all of the nodes in the
ext4_es_tree.   Is that correct?

If so, we might want to think about adding a sanity check to make sure
that by the time we are done with the inode in ext4_evict_inode()
(after we have forced writeback), the ext4_es_tree is empty.  Agreed?

       	       	      		      		   - Ted
