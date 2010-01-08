From: Michal Novotny <minovotn@redhat.com>
Subject: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT option
Date: Fri, 08 Jan 2010 10:36:50 +0100
Message-ID: <4B46FCB2.1090308@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020101060509020304080309"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab0AHJhP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jan 2010 04:37:15 -0500
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o089bFKp011197
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jan 2010 04:37:15 -0500
Received: from mig-laptop.englab.brq.redhat.com (vpn-8-135.rdu.redhat.com [10.11.8.135])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o089bDnc030901
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jan 2010 04:37:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020101060509020304080309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch extends functionality of e{2|4}fsprogs to add 
EXT2_FLAG_DIRECT flag to be passed to ext2fs_open2() function. This 
internally calls open() function with O_DIRECT and handles the memory 
alignment for both read and write operations.
In some cases direct access to devices is necessary and that was the 
main reason for this patch to be done.

The main reason why this was done is that pygrub (used by xen 
virtualization user-space package, it's a python version of grub for 
paravirtualized guests) sometimes uses outdated version of grub.conf 
file. Modifications to xen package were *not* enough because e2fsprogs 
doesn't open the files directly. That's why I added EXT2_FLAG_DIRECT 
support to make read/write operations work directly when passed. It's 
been tested with pygrub like mentioned above for read operation and it's 
working fine.

Signed-off-by: Michal Novotny <minovotn@redhat.com>

--------------020101060509020304080309
Content-Type: text/x-patch;
 name="mig-e4fsprogs-direct-read-write.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mig-e4fsprogs-direct-read-write.patch"

Author: Michal Novotny <minovotn@redhat.com>
Date:   Wed Dec 23 11:25:40 2009 +0200

    extend e{2|4}fsprogs functionality to add EXT2_FLAG_DIRECT option
    
    This patch extends functionality of e{2|4}fsprogs to add EXT2_FLAG_DIRECT
    flag to be passed to ext2fs_open2() function. This internally calls open()
    function with O_DIRECT and handles the memory alignment for both read and
    write operations.
    In some cases direct access to devices is necessary and that was the main
    reason for this patch to be done.
    
    Signed-off-by: Michal Novotny <minovotn@redhat.com>

diff -up e2fsprogs-1.41.9/lib/ext2fs/ext2fs.h.opendirect e2fsprogs-1.41.9/lib/ext2fs/ext2fs.h
--- e2fsprogs-1.41.9/lib/ext2fs/ext2fs.h.opendirect	2009-12-23 10:04:05.000000000 +0100
+++ e2fsprogs-1.41.9/lib/ext2fs/ext2fs.h	2009-12-23 10:04:05.000000000 +0100
@@ -172,6 +172,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_EXCLUSIVE		0x4000
 #define EXT2_FLAG_SOFTSUPP_FEATURES	0x8000
 #define EXT2_FLAG_NOFREE_ON_ERROR	0x10000
+#define EXT2_FLAG_DIRECT		0x20000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
diff -up e2fsprogs-1.41.9/lib/ext2fs/ext2_io.h.opendirect e2fsprogs-1.41.9/lib/ext2fs/ext2_io.h
--- e2fsprogs-1.41.9/lib/ext2fs/ext2_io.h.opendirect	2009-08-23 04:44:35.000000000 +0200
+++ e2fsprogs-1.41.9/lib/ext2fs/ext2_io.h	2009-12-23 10:04:05.000000000 +0100
@@ -29,6 +29,7 @@ typedef struct struct_io_channel *io_cha
 typedef struct struct_io_stats *io_stats;
 
 #define CHANNEL_FLAGS_WRITETHROUGH	0x01
+#define CHANNEL_FLAGS_DIRECT		0x02
 
 struct struct_io_channel {
 	errcode_t	magic;
@@ -88,6 +89,7 @@ struct struct_io_manager {
 
 #define IO_FLAG_RW		0x0001
 #define IO_FLAG_EXCLUSIVE	0x0002
+#define IO_FLAG_DIRECT		0x0004
 
 /*
  * Convenience functions....
diff -up e2fsprogs-1.41.9/lib/ext2fs/openfs.c.opendirect e2fsprogs-1.41.9/lib/ext2fs/openfs.c
--- e2fsprogs-1.41.9/lib/ext2fs/openfs.c.opendirect	2009-08-23 04:44:35.000000000 +0200
+++ e2fsprogs-1.41.9/lib/ext2fs/openfs.c	2009-12-23 10:04:05.000000000 +0100
@@ -121,6 +121,8 @@ errcode_t ext2fs_open2(const char *name,
 		io_flags |= IO_FLAG_RW;
 	if (flags & EXT2_FLAG_EXCLUSIVE)
 		io_flags |= IO_FLAG_EXCLUSIVE;
+	if (flags & EXT2_FLAG_DIRECT)
+		io_flags |= IO_FLAG_DIRECT;
 	retval = manager->open(fs->device_name, io_flags, &fs->io);
 	if (retval)
 		goto cleanup;
@@ -296,6 +298,7 @@ errcode_t ext2fs_open2(const char *name,
        }
 	fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
 					  EXT2_DESC_PER_BLOCK(fs->super));
+
 	retval = ext2fs_get_array(fs->desc_blocks, fs->blocksize,
 				&fs->group_desc);
 	if (retval)
diff -up e2fsprogs-1.41.9/lib/ext2fs/unix_io.c.opendirect e2fsprogs-1.41.9/lib/ext2fs/unix_io.c
--- e2fsprogs-1.41.9/lib/ext2fs/unix_io.c.opendirect	2009-08-13 03:39:57.000000000 +0200
+++ e2fsprogs-1.41.9/lib/ext2fs/unix_io.c	2009-12-23 10:16:26.000000000 +0100
@@ -17,6 +17,7 @@
 
 #define _LARGEFILE_SOURCE
 #define _LARGEFILE64_SOURCE
+#define _GNU_SOURCE
 
 #include <stdio.h>
 #include <string.h>
@@ -163,15 +164,37 @@ static errcode_t raw_read_blk(io_channel
 	ssize_t		size;
 	ext2_loff_t	location;
 	int		actual = 0;
+	int		memret;
+	void		*aligned_buffer;
+	long		pagesize;
 
 	size = (count < 0) ? -count : count * channel->block_size;
+
 	data->io_stats.bytes_read += size;
 	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
 	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
 		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
 		goto error_out;
 	}
-	actual = read(data->dev, buf, size);
+
+	if (channel->flags & CHANNEL_FLAGS_DIRECT) {
+		pagesize = sysconf(_SC_PAGE_SIZE);
+		if (pagesize < 0)
+			goto error_out;
+
+		memret = posix_memalign(&aligned_buffer, pagesize, size);
+		if (memret != 0) {
+			errno = memret;
+			goto error_out;
+		}
+		actual = read(data->dev, aligned_buffer, size);
+		if (actual > 0)
+			memcpy(buf, aligned_buffer, size);
+		free(aligned_buffer);
+	}
+	else
+		actual = read(data->dev, buf, size);
+
 	if (actual != size) {
 		if (actual < 0)
 			actual = 0;
@@ -252,6 +275,9 @@ static errcode_t raw_write_blk(io_channe
 	ext2_loff_t	location;
 	int		actual = 0;
 	errcode_t	retval;
+        int		memret;
+        void		*aligned_buffer;
+        long		pagesize;
 
 	if (count == 1)
 		size = channel->block_size;
@@ -269,7 +295,23 @@ static errcode_t raw_write_blk(io_channe
 		goto error_out;
 	}
 
-	actual = write(data->dev, buf, size);
+	if (channel->flags & CHANNEL_FLAGS_DIRECT) {
+		pagesize = sysconf(_SC_PAGE_SIZE);
+		if (pagesize < 0)
+			goto error_out;
+
+		memret = posix_memalign(&aligned_buffer, pagesize, size);
+		if (memret != 0) {
+			errno = memret;
+			goto error_out;
+		}
+		memcpy(aligned_buffer, buf, size);
+		actual = write(data->dev, aligned_buffer, size);
+		free(aligned_buffer);
+	}
+	else
+		actual = write(data->dev, buf, size);
+
 	if (actual != size) {
 		retval = EXT2_ET_SHORT_WRITE;
 		goto error_out;
@@ -443,6 +485,9 @@ static errcode_t unix_open(const char *n
 	io->write_error = 0;
 	io->refcount = 1;
 
+	if (flags & IO_FLAG_DIRECT)
+		io->flags = CHANNEL_FLAGS_DIRECT;
+
 	memset(data, 0, sizeof(struct unix_private_data));
 	data->magic = EXT2_ET_MAGIC_UNIX_IO_CHANNEL;
 	data->io_stats.num_fields = 2;
@@ -453,6 +498,8 @@ static errcode_t unix_open(const char *n
 	open_flags = (flags & IO_FLAG_RW) ? O_RDWR : O_RDONLY;
 	if (flags & IO_FLAG_EXCLUSIVE)
 		open_flags |= O_EXCL;
+        if (flags & IO_FLAG_DIRECT)
+                open_flags |= O_DIRECT;
 #ifdef HAVE_OPEN64
 	data->dev = open64(io->name, open_flags);
 #else

--------------020101060509020304080309--
