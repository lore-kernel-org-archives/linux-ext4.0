From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 3/3][e2fsprogs] Add {read,write}_blk64 to inode_io.c
Date: Mon, 03 Mar 2008 10:41:29 -0600
Message-ID: <20080303164129.5557.14237.stgit@gara>
References: <20080303164113.5557.68102.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53987 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbYCCQlc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Mar 2008 11:41:32 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m23GfVeZ013110
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 11:41:31 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23GfVTZ247278
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 11:41:31 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23GfUIQ015221
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 11:41:31 -0500
In-Reply-To: <20080303164113.5557.68102.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add {read,write}_blk64 to inode_io.c

Add 64-bit block capable routines to inode IO manager.  Since fileio.c
does not yet have 64bit support, these routines will not handle 64bit
block numbers correctly (currently working on that).

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/inode_io.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/inode_io.c b/lib/ext2fs/inode_io.c
index b5c08b9..0e23494 100644
--- a/lib/ext2fs/inode_io.c
+++ b/lib/ext2fs/inode_io.c
@@ -56,7 +56,11 @@ static errcode_t inode_write_blk(io_channel channel, unsigned long block,
 static errcode_t inode_flush(io_channel channel);
 static errcode_t inode_write_byte(io_channel channel, unsigned long offset,
 				int size, const void *data);
-
+static errcode_t inode_read_blk64(io_channel channel, 
+				unsigned long long block, int count, void *data);
+static errcode_t inode_write_blk64(io_channel channel, 
+				unsigned long long block, int count, const void *data);
+				
 static struct struct_io_manager struct_inode_manager = {
 	EXT2_ET_MAGIC_IO_MANAGER,
 	"Inode I/O Manager",
@@ -66,7 +70,11 @@ static struct struct_io_manager struct_inode_manager = {
 	inode_read_blk,
 	inode_write_blk,
 	inode_flush,
-	inode_write_byte
+	inode_write_byte,
+	NULL,
+	NULL,
+	inode_read_blk64,
+	inode_write_blk64
 };
 
 io_manager inode_io_manager = &struct_inode_manager;
@@ -197,8 +205,8 @@ static errcode_t inode_set_blksize(io_channel channel, int blksize)
 }
 
 
-static errcode_t inode_read_blk(io_channel channel, unsigned long block,
-			       int count, void *buf)
+static errcode_t inode_read_blk64(io_channel channel,
+				unsigned long long block, int count, void *buf)
 {
 	struct inode_private_data *data;
 	errcode_t	retval;
@@ -217,8 +225,14 @@ static errcode_t inode_read_blk(io_channel channel, unsigned long block,
 	return ext2fs_file_read(data->file, buf, count, 0);
 }
 
-static errcode_t inode_write_blk(io_channel channel, unsigned long block,
-				int count, const void *buf)
+static errcode_t inode_read_blk(io_channel channel, unsigned long block,
+			       int count, void *buf)
+{
+	return inode_read_blk64(channel, block, count, buf);
+}
+
+static errcode_t inode_write_blk64(io_channel channel,
+				unsigned long long block, int count, const void *buf)
 {
 	struct inode_private_data *data;
 	errcode_t	retval;
@@ -237,6 +251,12 @@ static errcode_t inode_write_blk(io_channel channel, unsigned long block,
 	return ext2fs_file_write(data->file, buf, count, 0);
 }
 
+static errcode_t inode_write_blk(io_channel channel, unsigned long block, 
+				int count, const void *buf)
+{
+	return inode_write_blk64(channel, block, count, buf);
+}
+
 static errcode_t inode_write_byte(io_channel channel, unsigned long offset,
 				 int size, const void *buf)
 {

