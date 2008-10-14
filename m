From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4] ext4: Use an rbtree for tracking blocks freed
	during transaction.
Date: Tue, 14 Oct 2008 12:17:33 +0530
Message-ID: <20081014064733.GB23970@skywalker>
References: <1223914510-25128-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081013195406.GA9332@mit.edu> <20081014031225.GC9332@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44659 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYJNGsM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 02:48:12 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9E6lVUw010664
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 17:47:31 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9E6mA9Y156400
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 17:48:10 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9E6mAJI011793
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 17:48:10 +1100
Content-Disposition: inline
In-Reply-To: <20081014031225.GC9332@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2008 at 11:12:25PM -0400, Theodore Tso wrote:
> On Mon, Oct 13, 2008 at 03:54:06PM -0400, Theodore Tso wrote:
> > So we have two choices; one is that we change ext4_mb_free_metadata()
> > to break up freed extents into block group chunks, 
> 
> Never mind.  I took a closer look and realized that
> ext4_mb_free_blocks is already breaking up extents that span multiple
> block groups.
> 
> So the only thing we need is the change to avoid merging freed extents
> that cross block groups, per my patch.  I've updated the patch queue
> with such a fix so I can better test things out.
> 
> Aneesh, can you look and see if this makes sense?

Yes the patch looks fine. Some changes I made on top of this is below
I have sent the patch -V5 with the above changes

> 
> 						- Ted
> 
> ext4: Use an rbtree for tracking blocks freed during transaction.
> 
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> With this patch we track the block freed during a transaction using
> rb tree. We also make sure contiguous blocks freed are collected
> in one rb node.
> 

.......

> 
> +/*
> + * We can merge two free data extents of the physical blocks

s/of the/only if the/

> + * are contiguous, AND the extents were freed by the same transaction, 
> + * AND the blocks are associated with the same group.
> + */
> +static int can_merge(struct ext4_free_data *entry1,
> +			struct ext4_free_data *entry2)
> +{
> +	if ((entry1->t_tid == entry2->t_tid) &&
> +	    (entry1->group == entry2->group) &&
> +	    (entry1->start_blk + entry1->count) == entry2->start_blk)
> +		return 1;
> +	return 0;
> +}
> +
......

> +++ b/fs/ext4/mballoc.h
> @@ -98,23 +98,34 @@
> 
>  static struct kmem_cache *ext4_pspace_cachep;
>  static struct kmem_cache *ext4_ac_cachep;
> +static struct kmem_cache *ext4_free_ext_cachep;
> 
>  #ifdef EXT4_BB_MAX_BLOCKS
>  #undef EXT4_BB_MAX_BLOCKS
>  #endif
>  #define EXT4_BB_MAX_BLOCKS	30
> 

We don't need the above define.

> -struct ext4_free_metadata {
> -	ext4_group_t group;
> -	unsigned short num;
> -	ext4_grpblk_t  blocks[EXT4_BB_MAX_BLOCKS];
> +struct ext4_free_data {
> +	/* this links the free block information from group_info */
> +	struct rb_node node;
> +
> +	/* this links the free block information from ext4_sb_info */
>  	struct list_head list;
> +
> +	/* group which free block extent belongs */
> +	ext4_group_t group;
> +
> +	/* free block extent */
> +	ext4_grpblk_t start_blk;
> +	ext4_grpblk_t count;
> +
> +	/* transaction which freed this extent */
> +	tid_t	t_tid;
>  };
> 
>  struct ext4_group_info {
>  	unsigned long	bb_state;
> -	unsigned long	bb_tid;
> -	struct ext4_free_metadata *bb_md_cur;
> +	struct rb_root  bb_free_root;
>  	unsigned short	bb_first_free;
>  	unsigned short	bb_free;
>  	unsigned short	bb_fragments;
