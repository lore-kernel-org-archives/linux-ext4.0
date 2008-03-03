From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 2/3][e2fsprogs] Add {read,write}_blk64 to unix_io.c
Date: Mon, 03 Mar 2008 10:41:24 -0600
Message-ID: <20080303164124.5557.52087.stgit@gara>
References: <20080303164113.5557.68102.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60623 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYCCQlj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Mar 2008 11:41:39 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m23Gf0BR018493
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 11:41:00 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23GfQkv187926
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 09:41:26 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23GfOen006110
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 09:41:26 -0700
In-Reply-To: <20080303164113.5557.68102.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add {read,write}_blk64 to unix_io.c

Add 64-bit block capable routines to Unix IO manager.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/unix_io.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 8497a41..eedbcdb 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -88,7 +88,11 @@ static errcode_t unix_set_option(io_channel channel, const char *option,
 static errcode_t unix_get_stats(io_channel channel, io_stats *stats)
 ;
 static void reuse_cache(io_channel channel, struct unix_private_data *data,
-		 struct unix_cache *cache, unsigned long block);
+		 struct unix_cache *cache, unsigned long long block);
+static errcode_t unix_read_blk64(io_channel channel, unsigned long long block,
+			       int count, void *data);
+static errcode_t unix_write_blk64(io_channel channel, unsigned long long block,
+				int count, const void *data);
 
 /* __FreeBSD_kernel__ is defined by GNU/kFreeBSD - the FreeBSD kernel
  * does not know buffered block devices - everything is raw. */
@@ -114,6 +118,8 @@ static struct struct_io_manager struct_unix_manager = {
 #endif
 	unix_set_option,
 	unix_get_stats,
+	unix_read_blk64,
+	unix_write_blk64,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
@@ -140,7 +146,7 @@ static errcode_t unix_get_stats(io_channel channel, io_stats *stats)
 #ifndef NEED_BOUNCE_BUFFER
 static errcode_t raw_read_blk(io_channel channel,
 			      struct unix_private_data *data,
-			      unsigned long block,
+			      unsigned long long block,
 			      int count, void *buf)
 {
 	errcode_t	retval;
@@ -229,7 +235,7 @@ error_out:
 
 static errcode_t raw_write_blk(io_channel channel,
 			       struct unix_private_data *data,
-			       unsigned long block,
+			       unsigned long long block,
 			       int count, const void *buf)
 {
 	ssize_t		size;
@@ -318,7 +324,7 @@ static void free_cache(struct unix_private_data *data)
  * entry to that should be reused.
  */
 static struct unix_cache *find_cached_block(struct unix_private_data *data,
-					    unsigned long block,
+					    unsigned long long block,
 					    struct unix_cache **eldest)
 {
 	struct unix_cache	*cache, *unused_cache, *oldest_cache;
@@ -348,7 +354,7 @@ static struct unix_cache *find_cached_block(struct unix_private_data *data,
  * Reuse a particular cache entry for another block.
  */
 static void reuse_cache(io_channel channel, struct unix_private_data *data,
-		 struct unix_cache *cache, unsigned long block)
+		 struct unix_cache *cache, unsigned long long block)
 {
 	if (cache->dirty && cache->in_use)
 		raw_write_blk(channel, data, cache->block, 1, cache->buf);
@@ -545,7 +551,7 @@ static errcode_t unix_set_blksize(io_channel channel, int blksize)
 }
 
 
-static errcode_t unix_read_blk(io_channel channel, unsigned long block,
+static errcode_t unix_read_blk64(io_channel channel, unsigned long long block,
 			       int count, void *buf)
 {
 	struct unix_private_data *data;
@@ -610,7 +616,13 @@ static errcode_t unix_read_blk(io_channel channel, unsigned long block,
 #endif /* NO_IO_CACHE */
 }
 
-static errcode_t unix_write_blk(io_channel channel, unsigned long block,
+static errcode_t unix_read_blk(io_channel channel, unsigned long block,
+			       int count, void *buf)
+{
+	return unix_read_blk64(channel, block, count, buf);
+}
+
+static errcode_t unix_write_blk64(io_channel channel, unsigned long long block,
 				int count, const void *buf)
 {
 	struct unix_private_data *data;
@@ -662,6 +674,12 @@ static errcode_t unix_write_blk(io_channel channel, unsigned long block,
 #endif /* NO_IO_CACHE */
 }
 
+static errcode_t unix_write_blk(io_channel channel, unsigned long block,
+				int count, const void *buf)
+{
+	return unix_write_blk64(channel, block, count, buf);
+}
+
 static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 				 int size, const void *buf)
 {

