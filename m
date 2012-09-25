From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Tue, 25 Sep 2012 20:42:52 +0800
Message-ID: <20120925124252.GA1518@gmail.com>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
 <20120919190541.GE28470@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52525 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2IYMcQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2012 08:32:16 -0400
Content-Disposition: inline
In-Reply-To: <20120919190541.GE28470@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 19, 2012 at 03:05:41PM -0400, Theodore Ts'o wrote:
> On Wed, Aug 22, 2012 at 02:05:40PM +0800, Zheng Liu wrote:
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 3e0851e..353b1fd 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -944,6 +944,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
> >  	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
> >  	INIT_LIST_HEAD(&ei->i_prealloc_list);
> >  	spin_lock_init(&ei->i_prealloc_lock);
> > +	ext4_es_init_tree(&ei->i_es_tree);
> >  	ei->i_reserved_data_blocks = 0;
> >  	ei->i_reserved_meta_blocks = 0;
> >  	ei->i_allocated_meta_blocks = 0;
> 
> This patch hunk immediately me ask, "so when does the extent_status
> tree get freed?"  And I believe the answer is that currently, since it
> only tracks delayed extents (and we're not using it for locking
> purposes), by the time we have evicted the inode and are ready to call
> ext4_clear_inode(), we should have released all of the nodes in the
> ext4_es_tree.   Is that correct?
> 
> If so, we might want to think about adding a sanity check to make sure
> that by the time we are done with the inode in ext4_evict_inode()
> (after we have forced writeback), the ext4_es_tree is empty.  Agreed?

Hi Ted,

Today I revise this patch again, and I find extent_status_tree is freed
in ext4_clear_inode().  So maybe I don't think that we need to check
this tree to be freed in ext4_evict_inode().  This change is in this
patch '[RFC][PATCH 4/8 v2] ext4: let ext4 maintain extent status tree'.
What's your opinion?

Regards,
Zheng
