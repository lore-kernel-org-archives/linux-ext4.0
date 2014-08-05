From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/21] libext2fs: check EA value offset
Date: Mon, 04 Aug 2014 18:05:17 -0700
Message-ID: <20140805010517.2611.2402.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40125 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHEBFW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:22 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Perform a little more sanity checking of EA value offsets so that we
don't crash while trying to load things from the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext_attr.c     |    5 +++++
 2 files changed, 8 insertions(+)


diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 2194a18..6b6d8b8 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -518,4 +518,7 @@ ec	EXT2_ET_MAGIC_EA_HANDLE,
 ec	EXT2_ET_INODE_IS_GARBAGE,
 	"Inode seems to contain garbage"
 
+ec	EXT2_ET_EA_BAD_VALUE_OFFSET,
+	"Extended attribute has an invalid value offset"
+
 	end
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index f3fba96..96530f8 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -624,6 +624,8 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 	void *ptr;
 	unsigned int remain, prefix_len;
 	errcode_t err;
+	unsigned int values_size = storage_size +
+			((char *)entries - (char *)value_start);
 
 	x = handle->attrs;
 	while (x->name)
@@ -648,6 +650,9 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 		if (entry->e_value_size > remain)
 			return EXT2_ET_EA_BAD_VALUE_SIZE;
 
+		if (entry->e_value_offs + entry->e_value_size > values_size)
+			return EXT2_ET_EA_BAD_VALUE_OFFSET;
+
 		/* e_value_block must be 0 in inode's ea */
 		if (entry->e_value_block != 0)
 			return EXT2_ET_BAD_EA_BLOCK_NUM;

