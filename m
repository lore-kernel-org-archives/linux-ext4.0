From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] libext2fs: use C99 initializers for the io_manager structure
Date: Sat, 26 Jul 2014 09:48:32 -0400
Message-ID: <1406382514-8662-5-git-send-email-tytso@mit.edu>
References: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58032 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaGZNsh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 09:48:37 -0400
In-Reply-To: <1406382514-8662-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Using C99 initializers makes the code a bit more readable, and it
avoids some gcc -Wall warnings regarding missing initializers.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/dosio.c    | 17 +++++++++--------
 lib/ext2fs/inode_io.c | 24 +++++++++++-------------
 lib/ext2fs/nt_io.c    | 18 ++++++++----------
 lib/ext2fs/test_io.c  | 28 ++++++++++++++--------------
 lib/ext2fs/undo_io.c  | 26 +++++++++++++-------------
 lib/ext2fs/unix_io.c  | 28 ++++++++++++++--------------
 util/gcc-wall-cleanup |  1 -
 7 files changed, 69 insertions(+), 73 deletions(-)

diff --git a/lib/ext2fs/dosio.c b/lib/ext2fs/dosio.c
index 0defff8..d0cf269 100644
--- a/lib/ext2fs/dosio.c
+++ b/lib/ext2fs/dosio.c
@@ -62,15 +62,16 @@ static errcode_t dos_write_blk(io_channel channel, unsigned long block,
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
+
 io_manager dos_io_manager = &struct_dos_manager;
 
 /*
diff --git a/lib/ext2fs/inode_io.c b/lib/ext2fs/inode_io.c
index 8e0944e..f3d94c8 100644
--- a/lib/ext2fs/inode_io.c
+++ b/lib/ext2fs/inode_io.c
@@ -63,19 +63,17 @@ static errcode_t inode_write_blk64(io_channel channel,
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
+	.read_blk64	= inode_read_blk64,
+	.write_blk64	= inode_write_blk64
 };
 
 io_manager inode_io_manager = &struct_inode_manager;
diff --git a/lib/ext2fs/nt_io.c b/lib/ext2fs/nt_io.c
index 0f10543..f0d16ae 100644
--- a/lib/ext2fs/nt_io.c
+++ b/lib/ext2fs/nt_io.c
@@ -230,18 +230,16 @@ static errcode_t nt_write_blk(io_channel channel, unsigned long block,
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
+	.set_blksize	= nt_set_blksize,
+	.read_blk	= nt_read_blk,
+	.write_blk	= nt_write_blk,
+	.flush		= nt_flush
 };
 
-
-
 //
 // function to get API
 //
diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
index d16a358..6f0d035 100644
--- a/lib/ext2fs/test_io.c
+++ b/lib/ext2fs/test_io.c
@@ -487,20 +487,20 @@ static errcode_t test_discard(io_channel channel, unsigned long long block,
 }
 
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
-	test_discard,
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
+	.discard	= test_discard,
 };
 
 io_manager test_io_manager = &struct_test_manager;
diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 0e05c93..d6beb02 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -588,19 +588,19 @@ static errcode_t undo_get_stats(io_channel channel, io_stats *stats)
 }
 
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
-	undo_set_option,
-	undo_get_stats,
-	undo_read_blk64,
-	undo_write_blk64,
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "Undo I/O Manager",
+	.open		= undo_open,
+	.close		= undo_close,
+	.set_blksize	= undo_set_blksize,
+	.read_blk	= undo_read_blk,
+	.write_blk	= undo_write_blk,
+	.flush		= undo_flush,
+	.write_byte	= undo_write_byte,
+	.set_option	= undo_set_option,
+	.get_stats	= undo_get_stats,
+	.read_blk64	= undo_read_blk64,
+	.write_blk64	= undo_write_blk64,
 };
 
 io_manager undo_io_manager = &struct_undo_manager;
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index c3185b6..e93684e 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -923,20 +923,20 @@ unimplemented:
 }
 
 static struct struct_io_manager struct_unix_manager = {
-	EXT2_ET_MAGIC_IO_MANAGER,
-	"Unix I/O Manager",
-	unix_open,
-	unix_close,
-	unix_set_blksize,
-	unix_read_blk,
-	unix_write_blk,
-	unix_flush,
-	unix_write_byte,
-	unix_set_option,
-	unix_get_stats,
-	unix_read_blk64,
-	unix_write_blk64,
-	unix_discard,
+	.magic		= EXT2_ET_MAGIC_IO_MANAGER,
+	.name		= "Unix I/O Manager",
+	.open		= unix_open,
+	.close		= unix_close,
+	.set_blksize	= unix_set_blksize,
+	.read_blk	= unix_read_blk,
+	.write_blk	= unix_write_blk,
+	.flush		= unix_flush,
+	.write_byte	= unix_write_byte,
+	.set_option	= unix_set_option,
+	.get_stats	= unix_get_stats,
+	.read_blk64	= unix_read_blk64,
+	.write_blk64	= unix_write_blk64,
+	.discard	= unix_discard,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
diff --git a/util/gcc-wall-cleanup b/util/gcc-wall-cleanup
index 6148e46..c619526 100644
--- a/util/gcc-wall-cleanup
+++ b/util/gcc-wall-cleanup
@@ -16,7 +16,6 @@
 /In file included from/d
 /In function `.*':/d
 /zero-length format string/d
-/warning: missing initializer/d
 /warning: (near initialization for/d
 /^[ 	]*from/d
 
-- 
2.0.0

