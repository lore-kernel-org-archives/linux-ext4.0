From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: add rb_tree cache to struct ext4_group_info
Date: Mon, 29 Mar 2010 21:40:28 +0800
Message-ID: <n2tac8f92701003290640r2f29fcdfr9c3bad83ac934beb@mail.gmail.com>
References: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
	 <4BAF6FB7.601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47101 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab0C2Nk3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Mar 2010 09:40:29 -0400
Received: by ywh36 with SMTP id 36so3345844ywh.4
        for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 06:40:28 -0700 (PDT)
In-Reply-To: <4BAF6FB7.601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/28, Eric Sandeen <sandeen@redhat.com>:
> jing zhang wrote:
>> From: Jing Zhang <zj.barak@gmail.com>
>>
>> Date: Sun Mar 28 17:09:33     2010
>>
>> rb_tree cache is added to struct ext4_group_info at minor cost.
>
> Please include a reason for the change in the commit message,
> so that in the future people don't have to figure out for
> themselves why a change was made.  It also helps reviewers.  :)

good advice

>
> ...
>
>> @@ -4376,7 +4384,7 @@ ext4_mb_free_metadata(handle_t *handle,
>>  		if (block < entry->start_blk)
>>  			n = &(*n)->rb_left;
>>  		else if (block >= (entry->start_blk + entry->count))
>> -			n = &(*n)->rb_right;
>> +			n = &(*n)->rb_right, left = 0;
>>  		else {
>>  			ext4_grp_locked_error(sb, e4b->bd_group, __func__,
>>  					"Double free of blocks %d (%d %d)",
>
> I think it's better if you don't use that style, but instead:

fine
      - zj
>
>  		else if (block >= (entry->start_blk + entry->count)) {
> 			n = &(*n)->rb_right;
> 			left = 0;
> 		} else {
> 			...
>

Cache of rb_tree is added to struct ext4_group_info, and is maintained
at minor cost.
Then rb_tree traversing in the function,
ext4_mb_generate_from_freelist() is accelerated.

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-12.c	2010-03-29 21:31:18.000000000 +0800
@@ -2548,6 +2548,8 @@ static void release_blocks_on_commit(jou
 		count2++;
 		ext4_lock_group(sb, entry->group);
 		/* Take it out of per group rb tree */
+		if (db->bb_free_cache == &entry->node)
+			db->bb_free_cache = rb_next(&entry->node);
 		rb_erase(&entry->node, &(db->bb_free_root));
 		mb_free_blocks(NULL, &e4b, entry->start_blk, entry->count);

@@ -3188,7 +3190,10 @@ static void ext4_mb_generate_from_freeli
 	struct ext4_free_data *entry;

 	grp = ext4_get_group_info(sb, group);
-	n = rb_first(&(grp->bb_free_root));
+	if (grp->bb_free_cache)
+		n = grp->bb_free_cache;
+	else
+		n = rb_first(&(grp->bb_free_root));

 	while (n) {
 		entry = rb_entry(n, struct ext4_free_data, node);
@@ -4353,6 +4358,7 @@ ext4_mb_free_metadata(handle_t *handle,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct rb_node **n = &db->bb_free_root.rb_node, *node;
 	struct rb_node *parent = NULL, *new_node;
+	int left = 1;

 	BUG_ON(!ext4_handle_valid(handle));
 	BUG_ON(e4b->bd_bitmap_page == NULL);
@@ -4369,15 +4375,18 @@ ext4_mb_free_metadata(handle_t *handle,
 		 * blocks */
 		page_cache_get(e4b->bd_buddy_page);
 		page_cache_get(e4b->bd_bitmap_page);
+		/* just for sure */
+		db->bb_free_cache = 0;
 	}
 	while (*n) {
 		parent = *n;
 		entry = rb_entry(parent, struct ext4_free_data, node);
 		if (block < entry->start_blk)
 			n = &(*n)->rb_left;
-		else if (block >= (entry->start_blk + entry->count))
+		else if (block >= (entry->start_blk + entry->count)) {
 			n = &(*n)->rb_right;
-		else {
+			left = 0;
+		} else {
 			ext4_grp_locked_error(sb, e4b->bd_group, __func__,
 					"Double free of blocks %d (%d %d)",
 					block, entry->start_blk, entry->count);
@@ -4387,6 +4396,8 @@ ext4_mb_free_metadata(handle_t *handle,

 	rb_link_node(new_node, parent, n);
 	rb_insert_color(new_node, &db->bb_free_root);
+	if (left)
+		db->bb_free_cache = new_node;

 	/* Now try to see the extent can be merged to left and right */
 	node = rb_prev(new_node);
