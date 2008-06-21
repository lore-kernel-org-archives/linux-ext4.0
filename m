From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH blkid] use list_for_each_safe in garbage collection
Date: Fri, 20 Jun 2008 22:32:49 -0500
Message-ID: <485C7661.5080002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYFUDcw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jun 2008 23:32:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to use list_for_each_safe in case a device gets removed
from the list during garbage collection.

Also make the manpage slightly more informative about
what the -g garbage collection option does.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs-1.41/lib/blkid/cache.c
===================================================================
--- e2fsprogs-1.41.orig/lib/blkid/cache.c
+++ e2fsprogs-1.41/lib/blkid/cache.c
@@ -154,13 +154,13 @@ void blkid_put_cache(blkid_cache cache)
 
 void blkid_gc_cache(blkid_cache cache)
 {
-	struct list_head *p;
+	struct list_head *p, *pnext;
 	struct stat st;
 
 	if (!cache)
 		return;
 
-	list_for_each(p, &cache->bic_devs) {
+	list_for_each_safe(p, pnext, &cache->bic_devs) {
 		blkid_dev dev = list_entry(p, struct blkid_struct_dev, bid_devs);
 		if (!p)
 			break;
Index: e2fsprogs-1.41/misc/blkid.8.in
===================================================================
--- e2fsprogs-1.41.orig/misc/blkid.8.in
+++ e2fsprogs-1.41/misc/blkid.8.in
@@ -61,7 +61,8 @@ scanned but not necessarily available at
 .IR /dev/null.
 .TP
 .B \-g
-Perform a garbage collection pass on the blkid cache.
+Perform a garbage collection pass on the blkid cache to remove
+devices which no longer exist.
 .TP
 .B \-h
 Display a usage message and exit.

