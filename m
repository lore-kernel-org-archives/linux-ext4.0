From: Andreas Dilger <adilger@clusterfs.com>
Subject: [PATCH] added sanity check for xattr validation
Date: Mon, 26 Feb 2007 15:33:22 -0700
Message-ID: <20070226223322.GA30215@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jim Garlick <garlick@llnl.gov>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:33793 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbXBZWdZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Feb 2007 17:33:25 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,
the attached patch adds an extra validity test in check_ext_attr().  If
an attribute's e_value_size is zero the current code does not allocate
a region for it and as a result the e_value_offs value is not verified.
However, if e_value_offs is very large then the later call to
ext2fs_ext_attr_hash_entry() can dereference bad memory and crash e2fsck.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Jim Garlick <garlick@llnl.gov>

=========================== e_value_offs.patch ============================

Index: e2fsprogs-1.39/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass1.c	2007-02-10 15:43:36.000000000 +0530
+++ e2fsprogs-1.39/e2fsck/pass1.c	2007-02-10 15:45:36.000000000 +0530
@@ -1346,6 +1347,11 @@
 			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
 				goto clear_extattr;
 		}
+		if (entry->e_value_offs + entry->e_value_size > fs->blocksize) {
+			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
+				goto clear_extattr;
+			break;
+		}
 		if (entry->e_value_size &&
 		    region_allocate(region, entry->e_value_offs,
 				    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
=========================== e_value_offs.patch ============================

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
