From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/74] libext2fs: tweak inline data error wording
Date: Tue, 10 Dec 2013 17:19:03 -0800
Message-ID: <20131211011903.30655.6045.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25918 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3LKBTI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:19:08 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tweak the wording to be a little less ambiguous, since 'block' can be
a noun or a verb.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_err.et.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 9cc1bd1..2486321 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -480,6 +480,6 @@ ec	EXT2_ET_BLOCK_BITMAP_CSUM_INVALID,
 	"Block bitmap checksum does not match bitmap"
 
 ec	EXT2_ET_INLINE_DATA_CANT_ITERATE,
-	"Cannot block iterate on an inode containing inline data"
+	"Cannot iterate data blocks of an inode containing inline data"
 
 	end

