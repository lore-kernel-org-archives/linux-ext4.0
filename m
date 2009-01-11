From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ext4: fix unhandled ext4_free_data allocation failure
Date: Sun, 11 Jan 2009 11:03:53 +0900
Message-ID: <20090111020352.GA4285@localhost.localdomain>
References: <20081223104016.GC7217@localhost.localdomain> <20081223142915.GA23303@unused.rdu.redhat.com> <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Theodore Tso <tytso@mit.edu>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:46354 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZAKCEG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Jan 2009 21:04:06 -0500
Content-Disposition: inline
In-Reply-To: <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_mb_free_blocks() ext4_free_data allocation failure
is not handled. This error handling cannot be simple error return because
ext4_mb_free_blocks() cannot fail.

This patch add __GFP_NOFAIL to gfp mask for the allocation.

Cc: Theodore Tso <tytso@mit.edu>
Cc: adilger@sun.com
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 fs/ext4/mballoc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: 2.6-git/fs/ext4/mballoc.c
===================================================================
--- 2.6-git.orig/fs/ext4/mballoc.c
+++ 2.6-git/fs/ext4/mballoc.c
@@ -4885,7 +4885,8 @@ do_more:
 		 * blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed
 		 */
-		new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
+		new_entry  = kmem_cache_alloc(ext4_free_ext_cachep,
+						GFP_NOFS | __GFP_NOFAIL);
 		new_entry->start_blk = bit;
 		new_entry->group  = block_group;
 		new_entry->count = count;
