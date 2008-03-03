From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [RFC PATCH 1/3][e2fsprogs] Add 64-bit IO manager operations to
	struct_io_manager.
Date: Mon, 03 Mar 2008 10:41:18 -0600
Message-ID: <20080303164118.5557.20139.stgit@gara>
References: <20080303164113.5557.68102.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:52916 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbYCCQlV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Mar 2008 11:41:21 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m23GfLjL008964
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 11:41:21 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23GfJdC056010
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 09:41:19 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23GfI3t000773
	for <linux-ext4@vger.kernel.org>; Mon, 3 Mar 2008 09:41:19 -0700
In-Reply-To: <20080303164113.5557.68102.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add 64-bit IO manager operations to struct_io_manager.

In order to provide 64-bit block support for IO managers an maintain
ABI compatibility with the old API, some new functions need to be
added to struct_io_manger.  Luckily, strcut_io_manager has some
reserved space that we can use to add these new functions.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2_io.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 864d1f9..e3b0b1e 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -79,7 +79,11 @@ struct struct_io_manager {
 	errcode_t (*set_option)(io_channel channel, const char *option, 
 				const char *arg);
 	errcode_t (*get_stats)(io_channel channel, io_stats *io_stats);
-	int		reserved[14];
+	errcode_t (*read_blk64)(io_channel channel, unsigned long long block,
+					int count, void *data);
+	errcode_t (*write_blk64)(io_channel channel, unsigned long long block,
+					int count, const void *data);
+	int		reserved[12];
 };
 
 #define IO_FLAG_RW		0x0001
@@ -91,7 +95,9 @@ struct struct_io_manager {
 #define io_channel_close(c) 		((c)->manager->close((c)))
 #define io_channel_set_blksize(c,s)	((c)->manager->set_blksize((c),s))
 #define io_channel_read_blk(c,b,n,d)	((c)->manager->read_blk((c),b,n,d))
+#define io_channel_read_blk64(c,b,n,d)	((c)->manager->read_blk64((c),b,n,d))
 #define io_channel_write_blk(c,b,n,d)	((c)->manager->write_blk((c),b,n,d))
+#define io_channel_write_blk64(c,b,n,d) ((c)->manager->write_blk64((c),b,n,d))
 #define io_channel_flush(c) 		((c)->manager->flush((c)))
 #define io_channel_bumpcount(c)		((c)->refcount++)
 	

