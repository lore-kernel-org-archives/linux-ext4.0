From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] rename ->open and ->close ops in struct_io_manager
Date: Thu, 16 Aug 2007 22:48:46 -0500
Message-ID: <46C51A9E.3030001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbXHQDsm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2007 23:48:42 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l7H3met1013724
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 23:48:40 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7H3meId017312
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 23:48:40 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l7H3md1X007003
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 23:48:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

glibc recently added for -D_FORTIFY_SOURCE=2 error checking
open/open64/openat/openat64 macros that verify proper use, including
checking that a mode is supplied with O_CREAT.

These macros re-#define "open," which does not play nice
when that name is used elsewhere.

Renaming open (and for symmetry, close) in struct_io_manager
seems like one way to go.  On the one hand I hate to have to
change code for this, but on the other hand it may not be worth
fighting.  Any thoughts?

Thanks,
-Eric

----

rename struct_io_manager's ->open and ->close members so that
recent glibc's redefined "open" for -D_FORTIFY_SOURCE=2 does
not clash with it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-git/debugfs/debugfs.c
===================================================================
--- e2fsprogs-git.orig/debugfs/debugfs.c
+++ e2fsprogs-git/debugfs/debugfs.c
@@ -62,7 +62,7 @@ static void open_filesystem(char *device
 			current_fs = NULL;
 			return;
 		}
-		retval = unix_io_manager->open(data_filename, 0, &data_io);
+		retval = unix_io_manager->io_open(data_filename, 0, &data_io);
 		if (retval) {
 			com_err(data_filename, 0, "while opening data source");
 			current_fs = NULL;
Index: e2fsprogs-git/e2fsck/journal.c
===================================================================
--- e2fsprogs-git.orig/e2fsck/journal.c
+++ e2fsprogs-git/e2fsck/journal.c
@@ -362,7 +362,7 @@ static errcode_t e2fsck_get_journal(e2fs
 #ifndef USE_INODE_IO
 	if (ext_journal)
 #endif
-		retval = io_ptr->open(journal_name, IO_FLAG_RW,
+		retval = io_ptr->io_open(journal_name, IO_FLAG_RW,
 				      &ctx->journal_io);
 	if (retval)
 		goto errout;
Index: e2fsprogs-git/lib/ext2fs/ext2_io.h
===================================================================
--- e2fsprogs-git.orig/lib/ext2fs/ext2_io.h
+++ e2fsprogs-git/lib/ext2fs/ext2_io.h
@@ -66,8 +66,8 @@ struct struct_io_stats {
 struct struct_io_manager {
 	errcode_t magic;
 	const char *name;
-	errcode_t (*open)(const char *name, int flags, io_channel *channel);
-	errcode_t (*close)(io_channel channel);
+	errcode_t (*io_open)(const char *name, int flags, io_channel *channel);
+	errcode_t (*io_close)(io_channel channel);
 	errcode_t (*set_blksize)(io_channel channel, int blksize);
 	errcode_t (*read_blk)(io_channel channel, unsigned long block,
 			      int count, void *data);
@@ -88,7 +88,7 @@ struct struct_io_manager {
 /*
  * Convenience functions....
  */
-#define io_channel_close(c) 		((c)->manager->close((c)))
+#define io_channel_close(c) 		((c)->manager->io_close((c)))
 #define io_channel_set_blksize(c,s)	((c)->manager->set_blksize((c),s))
 #define io_channel_read_blk(c,b,n,d)	((c)->manager->read_blk((c),b,n,d))
 #define io_channel_write_blk(c,b,n,d)	((c)->manager->write_blk((c),b,n,d))
Index: e2fsprogs-git/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-git.orig/lib/ext2fs/initialize.c
+++ e2fsprogs-git/lib/ext2fs/initialize.c
@@ -124,7 +124,7 @@ errcode_t ext2fs_initialize(const char *
 	io_flags = IO_FLAG_RW;
 	if (flags & EXT2_FLAG_EXCLUSIVE)
 		io_flags |= IO_FLAG_EXCLUSIVE;
-	retval = manager->open(name, io_flags, &fs->io);
+	retval = manager->io_open(name, io_flags, &fs->io);
 	if (retval)
 		goto cleanup;
 	fs->image_io = fs->io;
Index: e2fsprogs-git/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-git.orig/lib/ext2fs/openfs.c
+++ e2fsprogs-git/lib/ext2fs/openfs.c
@@ -119,7 +119,7 @@ errcode_t ext2fs_open2(const char *name,
 		io_flags |= IO_FLAG_RW;
 	if (flags & EXT2_FLAG_EXCLUSIVE)
 		io_flags |= IO_FLAG_EXCLUSIVE;
-	retval = manager->open(fs->device_name, io_flags, &fs->io);
+	retval = manager->io_open(fs->device_name, io_flags, &fs->io);
 	if (retval)
 		goto cleanup;
 	if (io_options && 
Index: e2fsprogs-git/lib/ext2fs/test_io.c
===================================================================
--- e2fsprogs-git.orig/lib/ext2fs/test_io.c
+++ e2fsprogs-git/lib/ext2fs/test_io.c
@@ -198,7 +198,7 @@ static errcode_t test_open(const char *n
 	memset(data, 0, sizeof(struct test_private_data));
 	data->magic = EXT2_ET_MAGIC_TEST_IO_CHANNEL;
 	if (test_io_backing_manager) {
-		retval = test_io_backing_manager->open(name, flags,
+		retval = test_io_backing_manager->io_open(name, flags,
 						       &data->real);
 		if (retval)
 			goto cleanup;
Index: e2fsprogs-git/misc/e2image.c
===================================================================
--- e2fsprogs-git.orig/misc/e2image.c
+++ e2fsprogs-git/misc/e2image.c
@@ -582,7 +582,7 @@ static void install_image(char *device, 
 		exit(1);
 	}
 
-	retval = io_ptr->open(device, IO_FLAG_RW, &io); 
+	retval = io_ptr->io_open(device, IO_FLAG_RW, &io); 
 	if (retval) {
 		com_err(device, 0, "while opening device file");
 		exit(1);
