From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V4 6/8] Cleancache: btrfs hooks for cleancache
Date: Mon, 30 Aug 2010 15:33:03 -0700
Message-ID: <20100830223303.GA1342__3959.76535878635$1283207747$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:57041 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0H3WfK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Aug 2010 18:35:10 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V4 6/8] Cleancache: btrfs hooks for cleancache

Filesystems must explicitly enable cleancache by calling
cleancache_init_fs anytime a instance of the filesystem
is mounted and must save the returned poolid.  Btrfs
uses its own readpage which must be hooked, but all other
cleancache hooks are in the VFS layer including
the matching cleancache_flush_fs hook which must be
called on unmount.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>

Diffstat:
 extent_io.c                              |    9 +++++++++
 super.c                                  |    2 ++
 2 files changed, 11 insertions(+)

--- linux-2.6.36-rc3/fs/btrfs/super.c	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/fs/btrfs/super.c	2010-08-30 09:20:42.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
 #include <linux/slab.h>
+#include <linux/cleancache.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -479,6 +480,7 @@ static int btrfs_fill_super(struct super
 	sb->s_root = root_dentry;
 
 	save_mount_options(sb, data);
+	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
 	return 0;
 
 fail_close:
--- linux-2.6.36-rc3/fs/btrfs/extent_io.c	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/fs/btrfs/extent_io.c	2010-08-30 09:20:42.000000000 -0600
@@ -10,6 +10,7 @@
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
+#include <linux/cleancache.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "compat.h"
@@ -2027,6 +2028,13 @@ static int __extent_read_full_page(struc
 
 	set_page_extent_mapped(page);
 
+	if (!PageUptodate(page)) {
+		if (cleancache_get_page(page) == 0) {
+			BUG_ON(blocksize != PAGE_SIZE);
+			goto out;
+		}
+	}
+
 	end = page_end;
 	while (1) {
 		lock_extent(tree, start, end, GFP_NOFS);
@@ -2151,6 +2159,7 @@ static int __extent_read_full_page(struc
 		cur = cur + iosize;
 		page_offset += iosize;
 	}
+out:
 	if (!nr) {
 		if (!PageError(page))
 			SetPageUptodate(page);
