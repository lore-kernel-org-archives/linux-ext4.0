From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: add rb_tree cache to struct ext4_group_info
Date: Wed, 31 Mar 2010 22:26:45 +0800
Message-ID: <x2tac8f92701003310726uf41823efz3d2ef98f438872b6@mail.gmail.com>
References: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f195.google.com ([209.85.210.195]:59997 "EHLO
	mail-yx0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab0CaO0r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Mar 2010 10:26:47 -0400
Received: by yxe33 with SMTP id 33so86853yxe.15
        for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 07:26:46 -0700 (PDT)
In-Reply-To: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/28, jing zhang <zj.barak@gmail.com>:
> From: Jing Zhang <zj.barak@gmail.com>
>
> Date: Sun Mar 28 17:09:33     2010
>
> rb_tree cache is added to struct ext4_group_info at minor cost.
>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
>
> ---
>
> --- linux-2.6.32/fs/ext4/ext4.h	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/ext4-12.h	2010-03-28 16:47:56.000000000 +0800
> @@ -1622,6 +1622,7 @@ static inline void ext4_update_i_disksiz
>  struct ext4_group_info {
>  	unsigned long   bb_state;
>  	struct rb_root  bb_free_root;
> +	struct rb_node *bb_free_cache;
>  	ext4_grpblk_t	bb_first_free;	/* first free block */
>  	ext4_grpblk_t	bb_free;	/* total free blocks */
>  	ext4_grpblk_t	bb_fragments;	/* nr of freespace fragments */
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc-12.c	2010-03-28 16:43:08.000000000 +0800
> @@ -2548,6 +2548,8 @@ static void release_blocks_on_commit(jou
>  		count2++;
>  		ext4_lock_group(sb, entry->group);
>  		/* Take it out of per group rb tree */
> +		if (db->bb_free_cache == &entry->node)
> +			db->bb_free_cache = rb_next(&entry->node);
>  		rb_erase(&entry->node, &(db->bb_free_root));
>  		mb_free_blocks(NULL, &e4b, entry->start_blk, entry->count);
>
> @@ -3188,7 +3190,10 @@ static void ext4_mb_generate_from_freeli
>  	struct ext4_free_data *entry;
>
>  	grp = ext4_get_group_info(sb, group);
> -	n = rb_first(&(grp->bb_free_root));
> +	if (grp->bb_free_cache)
> +		n = grp->bb_free_cache;
> +	else
> +		n = rb_first(&(grp->bb_free_root));
>
>  	while (n) {
>  		entry = rb_entry(n, struct ext4_free_data, node);
> @@ -4353,6 +4358,7 @@ ext4_mb_free_metadata(handle_t *handle,
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct rb_node **n = &db->bb_free_root.rb_node, *node;
>  	struct rb_node *parent = NULL, *new_node;
> +	int left = 1;
>
>  	BUG_ON(!ext4_handle_valid(handle));
>  	BUG_ON(e4b->bd_bitmap_page == NULL);
> @@ -4369,6 +4375,8 @@ ext4_mb_free_metadata(handle_t *handle,
>  		 * blocks */
>  		page_cache_get(e4b->bd_buddy_page);
>  		page_cache_get(e4b->bd_bitmap_page);
> +		/* just for sure */
> +		db->bb_free_cache = 0;
>  	}
>  	while (*n) {
>  		parent = *n;
> @@ -4376,7 +4384,7 @@ ext4_mb_free_metadata(handle_t *handle,
>  		if (block < entry->start_blk)
>  			n = &(*n)->rb_left;
>  		else if (block >= (entry->start_blk + entry->count))
> -			n = &(*n)->rb_right;
> +			n = &(*n)->rb_right, left = 0;
>  		else {
>  			ext4_grp_locked_error(sb, e4b->bd_group, __func__,
>  					"Double free of blocks %d (%d %d)",
> @@ -4387,6 +4395,8 @@ ext4_mb_free_metadata(handle_t *handle,
>
>  	rb_link_node(new_node, parent, n);
>  	rb_insert_color(new_node, &db->bb_free_root);
> +	if (left)
> +		db->bb_free_cache = new_node;
>
>  	/* Now try to see the extent can be merged to left and right */
>  	node = rb_prev(new_node);
>



2010/3/31, Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>:
> On Sun, 28 Mar 2010 17:11:55 +0800, jing zhang <zj.barak@gmail.com> wrote:
>> From: Jing Zhang <zj.barak@gmail.com>
>>
>> Date: Sun Mar 28 17:09:33     2010
>>
>> rb_tree cache is added to struct ext4_group_info at minor cost.
>>
>
> Did we measure the cost of not doing this ? Is there a profile data that
> we can look at ?
>
> -aneesh
>

With the added cache, there is over 50% probability that the operation,
       rb_first(&(grp->bb_free_root));
can be saved, when there are multiple nodes in tree.

It seems what is added is following what is called O(1), one of the
works by Mr. Ingo Molnar, but I am not sure, and let's ask Mr. Ingo
Molnar.

          - zj
