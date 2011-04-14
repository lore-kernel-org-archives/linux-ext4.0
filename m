From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V8 6/8] btrfs: add cleancache support
Date: Thu, 14 Apr 2011 14:18:32 -0700
Message-ID: <20110414211832.GA27796__4043.81626653976$1302816063$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
	mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx,
	linux-btrfs@
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23920 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1DNVUq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 17:20:46 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH V8 6/8] btrfs: add cleancache support

This sixth patch of eight in this cleancache series "opts-in"
cleancache for btrfs.  Filesystems must explicitly enable
cleancache by calling cleancache_init_fs anytime an instance
of the filesystem is mounted.  Btrfs uses its own readpage
which must be hooked, but all other cleancache hooks are in
the VFS layer including the matching cleancache_flush_fs hook
which must be called on unmount.

Details and a FAQ can be found in Documentation/vm/cleancache.txt

[v6-v8: no changes]
[v5: jeremy@goop.org: simplify init hook and any future fs init changes]
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik Van Riel <riel@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Nitin Gupta <ngupta@vflare.org>

---

Diffstat:
 fs/btrfs/extent_io.c                     |    9 +++++++++
 fs/btrfs/super.c                         |    2 ++
 2 files changed, 11 insertions(+)

--- linux-2.6.39-rc3/fs/btrfs/super.c	2011-04-11 18:21:51.000000000 -0600
+++ linux-2.6.39-rc3-cleancache/fs/btrfs/super.c	2011-04-13 17:10:46.357852791 -0600
@@ -39,6 +39,7 @@
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
 #include <linux/slab.h>
+#include <linux/cleancache.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -610,6 +611,7 @@ static int btrfs_fill_super(struct super
 	sb->s_root = root_dentry;
 
 	save_mount_options(sb, data);
+	cleancache_init_fs(sb);
 	return 0;
 
 fail_close:
--- linux-2.6.39-rc3/fs/btrfs/extent_io.c	2011-04-11 18:21:51.000000000 -0600
+++ linux-2.6.39-rc3-cleancache/fs/btrfs/extent_io.c	2011-04-13 17:10:46.368921914 -0600
@@ -10,6 +10,7 @@
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/pagevec.h>
+#include <linux/cleancache.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "compat.h"
@@ -1990,6 +1991,13 @@ static int __extent_read_full_page(struc
 
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
@@ -2117,6 +2125,7 @@ static int __extent_read_full_page(struc
 		cur = cur + iosize;
 		page_offset += iosize;
 	}
+out:
 	if (!nr) {
 		if (!PageError(page))
 			SetPageUptodate(page);
