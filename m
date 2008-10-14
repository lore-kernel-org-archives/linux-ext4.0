From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: C99 initializers for struct_io_manager
Date: Tue, 14 Oct 2008 12:38:47 -0500
Message-ID: <48F4D927.3020509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYJNRiu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Oct 2008 13:38:50 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9EHcnm0017653
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 13:38:49 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9EHcmB8006163
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 13:38:48 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9EHclWW000839
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 13:38:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

C99 initializers make it easier to see what's going on, and make
cscope databases for example simpler to search.  Can we use them
in e2fsprogs, or are there still ancient-compiler-compatibility
issues?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/ext2fs/dosio.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/dosio.c
+++ e2fsprogs/lib/ext2fs/dosio.c
@@ -58,14 +58,14 @@ static errcode_t dos_write_blk(io_channe
 static errcode_t dos_flush(io_channel channel);
 
 static struct struct_io_manager struct_dos_manager = {
-        EXT2_ET_MAGIC_IO_MANAGER,
-        "DOS I/O Manager",
-        dos_open,
-        dos_close,
-        dos_set_blksize,
-        dos_read_blk,
-        dos_write_blk,
-        dos_flush
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "DOS I/O Manager",
+	.open		= dos_open,
+	.close		= dos_close,
+	.set_blksize	= dos_set_blksize,
+	.read_blk	= dos_read_blk,
+	.write_blk	= dos_write_blk,
+	.flush		= dos_flush
 };
 io_manager dos_io_manager = &struct_dos_manager;
 
Index: e2fsprogs/lib/ext2fs/inode_io.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/inode_io.c
+++ e2fsprogs/lib/ext2fs/inode_io.c
@@ -62,19 +62,19 @@ static errcode_t inode_write_blk64(io_ch
 				unsigned long long block, int count, const void *data);
 
 static struct struct_io_manager struct_inode_manager = {
-	EXT2_ET_MAGIC_IO_MANAGER,
-	"Inode I/O Manager",
-	inode_open,
-	inode_close,
-	inode_set_blksize,
-	inode_read_blk,
-	inode_write_blk,
-	inode_flush,
-	inode_write_byte,
-	NULL,
-	NULL,
-	inode_read_blk64,
-	inode_write_blk64
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "Inode I/O Manager",
+	.open		= inode_open,
+	.close		= inode_close,
+	.set_blksize	= inode_set_blksize,
+	.read_blk	= inode_read_blk,
+	.write_blk	= inode_write_blk,
+	.flush		= inode_flush,
+	.write_byte	= inode_write_byte,
+	.set_option	= NULL,
+	.get_stats	= NULL,
+	.read_blk64	= inode_read_blk64,
+	.write_blk64	= inode_write_blk64
 };
 
 io_manager inode_io_manager = &struct_inode_manager;
Index: e2fsprogs/lib/ext2fs/nt_io.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/nt_io.c
+++ e2fsprogs/lib/ext2fs/nt_io.c
@@ -230,14 +230,14 @@ static errcode_t nt_write_blk(io_channel
 static errcode_t nt_flush(io_channel channel);
 
 static struct struct_io_manager struct_nt_manager = {
-	EXT2_ET_MAGIC_IO_MANAGER,
-	"NT I/O Manager",
-	nt_open,
-	nt_close,
-	nt_set_blksize,
-	nt_read_blk,
-	nt_write_blk,
-	nt_flush
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "NT I/O Manager",
+	.open		= nt_open,
+	.close		= nt_close,
+	.set_blksize 	= nt_set_blksize,
+	.read_blk	= nt_read_blk,
+	.write_blk	= nt_write_blk,
+	.flush		= nt_flush
 };
 
 
Index: e2fsprogs/lib/ext2fs/test_io.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/test_io.c
+++ e2fsprogs/lib/ext2fs/test_io.c
@@ -76,19 +76,19 @@ static errcode_t test_get_stats(io_chann
 
 
 static struct struct_io_manager struct_test_manager = {
-	EXT2_ET_MAGIC_IO_MANAGER,
-	"Test I/O Manager",
-	test_open,
-	test_close,
-	test_set_blksize,
-	test_read_blk,
-	test_write_blk,
-	test_flush,
-	test_write_byte,
-	test_set_option,
-	test_get_stats,
-	test_read_blk64,
-	test_write_blk64,
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "Test I/O Manager",
+	.open		= test_open,
+	.close		= test_close,
+	.set_blksize	= test_set_blksize,
+	.read_blk	= test_read_blk,
+	.write_blk	= test_write_blk,
+	.flush		= test_flush,
+	.write_byte	= test_write_byte,
+	.set_option	= test_set_option,
+	.get_stats	= test_get_stats,
+	.read_blk64	= test_read_blk64,
+	.write_blk64	= test_write_blk64,
 };
 
 io_manager test_io_manager = &struct_test_manager;
Index: e2fsprogs/lib/ext2fs/undo_io.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/undo_io.c
+++ e2fsprogs/lib/ext2fs/undo_io.c
@@ -84,16 +84,16 @@ static errcode_t undo_set_option(io_chan
 				 const char *arg);
 
 static struct struct_io_manager struct_undo_manager = {
-	EXT2_ET_MAGIC_IO_MANAGER,
-	"Undo I/O Manager",
-	undo_open,
-	undo_close,
-	undo_set_blksize,
-	undo_read_blk,
-	undo_write_blk,
-	undo_flush,
-	undo_write_byte,
-	undo_set_option
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "Undo I/O Manager",
+	.open		= undo_open,
+	.close		= undo_close,
+	.set_blksize	= undo_set_blksize,
+	.read_blk	= undo_read_blk,
+	.write_blk	= undo_write_blk,
+	.flush		= undo_flush,
+	.write_byte	= undo_write_byte,
+	.set_option	= undo_set_option
 };
 
 io_manager undo_io_manager = &struct_undo_manager;
Index: e2fsprogs/lib/ext2fs/unix_io.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/unix_io.c
+++ e2fsprogs/lib/ext2fs/unix_io.c
@@ -113,23 +113,23 @@ static errcode_t unix_write_blk64(io_cha
 #endif
 
 static struct struct_io_manager struct_unix_manager = {
-	EXT2_ET_MAGIC_IO_MANAGER,
-	"Unix I/O Manager",
-	unix_open,
-	unix_close,
-	unix_set_blksize,
-	unix_read_blk,
-	unix_write_blk,
-	unix_flush,
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "Unix I/O Manager",
+	.open		= unix_open,
+	.close		= unix_close,
+	.set_blksize	= unix_set_blksize,
+	.read_blk	= unix_read_blk,
+	.write_blk	= unix_write_blk,
+	.flush		= unix_flush,
 #ifdef NEED_BOUNCE_BUFFER
-	0,
+	.write_byte	= 0,
 #else
-	unix_write_byte,
+	.write_byte	= unix_write_byte,
 #endif
-	unix_set_option,
-	unix_get_stats,
-	unix_read_blk64,
-	unix_write_blk64,
+	.set_option	= unix_set_option,
+	.get_stats	= unix_get_stats,
+	.read_blk64	= unix_read_blk64,
+	.write_blk64	= unix_write_blk64,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;

