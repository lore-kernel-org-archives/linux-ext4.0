From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 6/9][e2fsprogs] Add 64-bit ext_attr interface.
Date: Fri, 09 May 2008 11:40:05 -0500
Message-ID: <20080509164005.15484.23414.stgit@gara>
References: <20080509163928.15484.22146.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:47340 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618AbYEIQjj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 12:39:39 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m49GabYf006724
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 12:36:37 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m49Gdb3I093178
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m49GdaT7027823
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 10:39:37 -0600
In-Reply-To: <20080509163928.15484.22146.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit ext_attr interface.

Add ext2fs_read_ext_attr2(), ext2fs_write_ext_attr2() and
ext2fs_adjust_ea_refcount2() that take blk64_t as an input.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h   |    7 +++++++
 lib/ext2fs/ext_attr.c |   31 ++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 80ccfd9..f578c19 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -811,11 +811,18 @@ extern errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir);
 extern __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry,
 					void *data);
 extern errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf);
+extern errcode_t ext2fs_read_ext_attr2(ext2_filsys fs, blk64_t block,
+				       void *buf);
 extern errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block,
 				       void *buf);
+extern errcode_t ext2fs_write_ext_attr2(ext2_filsys fs, blk64_t block,
+				       void *buf);
 extern errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 					   char *block_buf,
 					   int adjust, __u32 *newcount);
+extern errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
+					   char *block_buf,
+					   int adjust, __u32 *newcount);
 
 /* extent.c */
 extern errcode_t ext2fs_extent_header_verify(void *ptr, int size);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 3d208ec..395d4c7 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -60,11 +60,11 @@ __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry, void *data)
 #undef NAME_HASH_SHIFT
 #undef VALUE_HASH_SHIFT
 
-errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf)
+errcode_t ext2fs_read_ext_attr2(ext2_filsys fs, blk64_t block, void *buf)
 {
 	errcode_t	retval;
 
- 	retval = io_channel_read_blk(fs->io, block, 1, buf);
+	retval = io_channel_read_blk64(fs->io, block, 1, buf);
 	if (retval)
 		return retval;
 #ifdef WORDS_BIGENDIAN
@@ -73,7 +73,12 @@ errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf)
 	return 0;
 }
 
-errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block, void *inbuf)
+errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf)
+{
+	return ext2fs_read_ext_attr2(fs, block, buf);
+}
+
+errcode_t ext2fs_write_ext_attr2(ext2_filsys fs, blk64_t block, void *inbuf)
 {
 	errcode_t	retval;
 	char		*write_buf;
@@ -88,7 +93,7 @@ errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block, void *inbuf)
 #else
 	write_buf = (char *) inbuf;
 #endif
- 	retval = io_channel_write_blk(fs->io, block, 1, write_buf);
+	retval = io_channel_write_blk64(fs->io, block, 1, write_buf);
 	if (buf)
 		ext2fs_free_mem(&buf);
 	if (!retval)
@@ -96,10 +101,15 @@ errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block, void *inbuf)
 	return retval;
 }
 
+errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block, void *inbuf)
+{
+	return ext2fs_write_ext_attr2(fs, block, inbuf);
+}
+
 /*
  * This function adjusts the reference count of the EA block.
  */
-errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
+errcode_t ext2fs_adjust_ea_refcount2(ext2_filsys fs, blk64_t blk,
 				    char *block_buf, int adjust,
 				    __u32 *newcount)
 {
@@ -118,7 +128,7 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 		block_buf = buf;
 	}
 
-	retval = ext2fs_read_ext_attr(fs, blk, block_buf);
+	retval = ext2fs_read_ext_attr2(fs, blk, block_buf);
 	if (retval)
 		goto errout;
 
@@ -127,7 +137,7 @@ errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
 	if (newcount)
 		*newcount = header->h_refcount;
 
-	retval = ext2fs_write_ext_attr(fs, blk, block_buf);
+	retval = ext2fs_write_ext_attr2(fs, blk, block_buf);
 	if (retval)
 		goto errout;
 
@@ -136,3 +146,10 @@ errout:
 		ext2fs_free_mem(&buf);
 	return retval;
 }
+
+errcode_t ext2fs_adjust_ea_refcount(ext2_filsys fs, blk_t blk,
+					char *block_buf, int adjust,
+					__u32 *newcount)
+{
+	return ext2fs_adjust_ea_refcount(fs, blk, block_buf, adjust, newcount);
+}

