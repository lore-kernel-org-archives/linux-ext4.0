From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/25] e2fsprogs: Fix some error cleanup path bugs
Date: Fri, 16 Sep 2011 15:49:28 -0500
Message-ID: <1316206180-6375-14-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46748 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In inode_open(), if the allocation of &io fails, we go to cleanup
and dereference io to test io->name, which is a bug.

Similarly in undo_open()  if allocation of &data fails, we
go to cleanup and dereference data to test data->real.

In the test_open() case we explicitly set retval to the only
possible error return from ext2fs_get_mem(), so remove that
for tidiness.

The other changes just make make earlier returns go through
the error goto for consistency.

In many cases we returned directly from the first error, but
"goto cleanup" etc for every subsequent error.  In some
cases this leads to "impossible" tests such as:

	if (ptr)
		ext2fs_free_mem(&ptr)

on paths where ptr cannot be null because we would have
returned directly earlier, and Coverity flags this.

This isn't really indicative of an error in most cases, but
I think it can be clearer to always exit through the error goto
if it's used later in the function.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/dblist.c   |    2 +-
 lib/ext2fs/inode.c    |    6 ++++--
 lib/ext2fs/inode_io.c |    2 +-
 lib/ext2fs/test_io.c  |    6 ++----
 lib/ext2fs/undo_io.c  |    4 ++--
 lib/ext2fs/unix_io.c  |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/ext2fs/dblist.c b/lib/ext2fs/dblist.c
index c0a3dfe..ead8c7a 100644
--- a/lib/ext2fs/dblist.c
+++ b/lib/ext2fs/dblist.c
@@ -73,7 +73,7 @@ static errcode_t make_dblist(ext2_filsys fs, ext2_ino_t size,
 
 	retval = ext2fs_get_mem(sizeof(struct ext2_struct_dblist), &dblist);
 	if (retval)
-		return retval;
+		goto cleanup;
 	memset(dblist, 0, sizeof(struct ext2_struct_dblist));
 
 	dblist->magic = EXT2_ET_MAGIC_DBLIST;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 829e032..7889a9f 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -671,8 +671,10 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 
 	if (length > (int) sizeof(struct ext2_inode_large)) {
 		w_inode = malloc(length);
-		if (!w_inode)
-			return ENOMEM;
+		if (!w_inode) {
+			retval = ENOMEM;
+			goto errout;
+		}
 	} else
 		w_inode = &temp_inode;
 	memset(w_inode, 0, length);
diff --git a/lib/ext2fs/inode_io.c b/lib/ext2fs/inode_io.c
index b3e7ce5..ced3244 100644
--- a/lib/ext2fs/inode_io.c
+++ b/lib/ext2fs/inode_io.c
@@ -163,7 +163,7 @@ static errcode_t inode_open(const char *name, int flags, io_channel *channel)
 	return 0;
 
 cleanup:
-	if (io->name)
+	if (io && io->name)
 		ext2fs_free_mem(&io->name);
 	if (data)
 		ext2fs_free_mem(&data);
diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
index 7da1ee6..1a6d6c2 100644
--- a/lib/ext2fs/test_io.c
+++ b/lib/ext2fs/test_io.c
@@ -190,14 +190,12 @@ static errcode_t test_open(const char *name, int flags, io_channel *channel)
 		return EXT2_ET_BAD_DEVICE_NAME;
 	retval = ext2fs_get_mem(sizeof(struct struct_io_channel), &io);
 	if (retval)
-		return retval;
+		goto cleanup;
 	memset(io, 0, sizeof(struct struct_io_channel));
 	io->magic = EXT2_ET_MAGIC_IO_CHANNEL;
 	retval = ext2fs_get_mem(sizeof(struct test_private_data), &data);
-	if (retval) {
-		retval = EXT2_ET_NO_MEMORY;
+	if (retval)
 		goto cleanup;
-	}
 	io->manager = test_io_manager;
 	retval = ext2fs_get_mem(strlen(name)+1, &io->name);
 	if (retval)
diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index da1cf45..df55abf 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -357,7 +357,7 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 		return EXT2_ET_BAD_DEVICE_NAME;
 	retval = ext2fs_get_mem(sizeof(struct struct_io_channel), &io);
 	if (retval)
-		return retval;
+		goto cleanup;
 	memset(io, 0, sizeof(struct struct_io_channel));
 	io->magic = EXT2_ET_MAGIC_IO_CHANNEL;
 	retval = ext2fs_get_mem(sizeof(struct undo_private_data), &data);
@@ -407,7 +407,7 @@ static errcode_t undo_open(const char *name, int flags, io_channel *channel)
 	return 0;
 
 cleanup:
-	if (data->real)
+	if (data && data->real)
 		io_channel_close(data->real);
 	if (data)
 		ext2fs_free_mem(&data);
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index ecddfa6..7eb32f4 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -453,7 +453,7 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
 		return EXT2_ET_BAD_DEVICE_NAME;
 	retval = ext2fs_get_mem(sizeof(struct struct_io_channel), &io);
 	if (retval)
-		return retval;
+		goto cleanup;
 	memset(io, 0, sizeof(struct struct_io_channel));
 	io->magic = EXT2_ET_MAGIC_IO_CHANNEL;
 	retval = ext2fs_get_mem(sizeof(struct unix_private_data), &data);
-- 
1.7.4.1

