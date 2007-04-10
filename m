From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs - handle large setb/testb/freeb commands in debugfs
Date: Tue, 10 Apr 2007 13:43:33 -0500
Message-ID: <461BDAD5.5060900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031435AbXDJSpx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Apr 2007 14:45:53 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l3AIjqIh004132
	for <linux-ext4@vger.kernel.org>; Tue, 10 Apr 2007 14:45:52 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l3AIjqZQ007278
	for <linux-ext4@vger.kernel.org>; Tue, 10 Apr 2007 14:45:52 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l3AIjp96024016
	for <linux-ext4@vger.kernel.org>; Tue, 10 Apr 2007 14:45:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I noticed that you can't give more than a 2^31 block count to the
debugfs commands setb, clearb, or freeb.  Looks ok?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.39_ext4_hg/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.39_ext4_hg.orig/debugfs/debugfs.c
+++ e2fsprogs-1.39_ext4_hg/debugfs/debugfs.c
@@ -726,7 +726,7 @@ void do_testi(int argc, char *argv[])
 void do_freeb(int argc, char *argv[])
 {
 	blk_t block;
-	int count = 1;
+	blk_t count = 1;
 
 	if (common_block_args_process(argc, argv, &block, &count))
 		return;
@@ -745,7 +745,7 @@ void do_freeb(int argc, char *argv[])
 void do_setb(int argc, char *argv[])
 {
 	blk_t block;
-	int count = 1;
+	blk_t count = 1;
 
 	if (common_block_args_process(argc, argv, &block, &count))
 		return;
@@ -764,7 +764,7 @@ void do_setb(int argc, char *argv[])
 void do_testb(int argc, char *argv[])
 {
 	blk_t block;
-	int count = 1;
+	blk_t count = 1;
 
 	if (common_block_args_process(argc, argv, &block, &count))
 		return;
Index: e2fsprogs-1.39_ext4_hg/debugfs/util.c
===================================================================
--- e2fsprogs-1.39_ext4_hg.orig/debugfs/util.c
+++ e2fsprogs-1.39_ext4_hg/debugfs/util.c
@@ -325,7 +325,7 @@ int common_inode_args_process(int argc, 
  * This is a helper function used by do_freeb, do_setb, and do_testb
  */
 int common_block_args_process(int argc, char *argv[],
-			      blk_t *block, int *count)
+			      blk_t *block, blk_t *count)
 {
 	int	err;
 
Index: e2fsprogs-1.39_ext4_hg/debugfs/debugfs.h
===================================================================
--- e2fsprogs-1.39_ext4_hg.orig/debugfs/debugfs.h
+++ e2fsprogs-1.39_ext4_hg/debugfs/debugfs.h
@@ -41,7 +41,7 @@ extern int common_args_process(int argc,
 extern int common_inode_args_process(int argc, char *argv[],
 				     ext2_ino_t *inode, int flags);
 extern int common_block_args_process(int argc, char *argv[],
-				     blk_t *block, int *count);
+				     blk_t *block, blk_t *count);
 extern int debugfs_read_inode(ext2_ino_t ino, struct ext2_inode * inode,
 			      const char *cmd);
 extern int debugfs_read_inode_full(ext2_ino_t ino, struct ext2_inode * inode,
