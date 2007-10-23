From: "Kalpak Shah" <kalpak@clusterfs.com>
Subject: Remove remnants of EXT2_FEATURE_RO_COMPAT_BTREE_DIR
Date: Wed, 24 Oct 2007 00:42:52 +0530
Message-ID: <2776831e0710231212s696e9e74x8e61104e13d85b0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48325 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXJWTMz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2007 15:12:55 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.180])
	by mail.clusterfs.com (Postfix) with ESMTP id A55AE4E458A
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 13:12:53 -0600 (MDT)
Received: by py-out-1112.google.com with SMTP id d32so6245351pye
        for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 12:12:53 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

EXT2_FEATURE_RO_COMPAT_BTREE_DIR is no longer used and all its
remnants should be removed. It has been replaced with
EXT2_FEATURE_COMPAT_DIR_INDEX long back.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: e2fsprogs-1.40.2/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.40.2/lib/ext2fs/ext2_fs.h
@@ -626,7 +626,6 @@ struct ext2_super_block {

 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER    0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE      0x0002
-/* #define EXT2_FEATURE_RO_COMPAT_BTREE_DIR    0x0004 not used */
 #define EXT4_FEATURE_RO_COMPAT_HUGE_FILE       0x0008
 #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM                0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK       0x0020
@@ -645,8 +644,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_SUPP       0
 #define EXT2_FEATURE_INCOMPAT_SUPP     (EXT2_FEATURE_INCOMPAT_FILETYPE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP    (EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
-                                        EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
-                                        EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
+                                        EXT2_FEATURE_RO_COMPAT_LARGE_FILE)

 /*
  * Default values for user and/or group using reserved blocks
