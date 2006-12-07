From: akpm@osdl.org
Subject: [patch 276/354] ext4 balloc: say rb_entry not list_entry
Date: Wed, 06 Dec 2006 20:39:21 -0800
Message-ID: <200612070439.kB74dLC5030011@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hugh@veritas.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47485 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968763AbWLGElE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:41:04 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

The reservations tree is an rb_tree not a list, so it's less confusing to use
rb_entry() than list_entry() - though they're both just container_of().

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-balloc-say-rb_entry-not-list_entry fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-balloc-say-rb_entry-not-list_entry
+++ a/fs/ext4/balloc.c
@@ -165,7 +165,7 @@ restart:
 
 	printk("Block Allocation Reservation Windows Map (%s):\n", fn);
 	while (n) {
-		rsv = list_entry(n, struct ext4_reserve_window_node, rsv_node);
+		rsv = rb_entry(n, struct ext4_reserve_window_node, rsv_node);
 		if (verbose)
 			printk("reservation window 0x%p "
 			       "start:  %llu, end:  %llu\n",
@@ -966,7 +966,7 @@ static int find_next_reservable_window(
 
 		prev = rsv;
 		next = rb_next(&rsv->rsv_node);
-		rsv = list_entry(next,struct ext4_reserve_window_node,rsv_node);
+		rsv = rb_entry(next,struct ext4_reserve_window_node,rsv_node);
 
 		/*
 		 * Reached the last reservation, we can just append to the
@@ -1210,7 +1210,7 @@ static void try_to_extend_reservation(st
 	if (!next)
 		my_rsv->rsv_end += size;
 	else {
-		next_rsv = list_entry(next, struct ext4_reserve_window_node, rsv_node);
+		next_rsv = rb_entry(next, struct ext4_reserve_window_node, rsv_node);
 
 		if ((next_rsv->rsv_start - my_rsv->rsv_end - 1) >= size)
 			my_rsv->rsv_end += size;
_
