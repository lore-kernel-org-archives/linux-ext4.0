From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Use le32_to_cpu for ext4_extent_idx.ei_block in ext4_ext_search_left.
Date: Fri,  7 Oct 2011 23:30:28 +0800
Message-ID: <1318001428-3108-3-git-send-email-tm@tao.ma>
References: <1318001428-3108-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49289 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753044Ab1JGPco (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Oct 2011 11:32:44 -0400
In-Reply-To: <1318001428-3108-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

ext4_extent_idx.e_block is __le32, so use le32_to_cpu when using them
in ext4_ext_search_left.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/extents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 37a1b4d..dee73d2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1235,9 +1235,9 @@ static int ext4_ext_search_left(struct inode *inode,
 			if (unlikely(ix != EXT_FIRST_INDEX(path[depth].p_hdr))) {
 				EXT4_ERROR_INODE(inode,
 				  "ix (%d) != EXT_FIRST_INDEX (%d) (depth %d)!",
-				  ix != NULL ? ix->ei_block : 0,
+				  ix != NULL ? le32_to_cpu(ix->ei_block) : 0,
 				  EXT_FIRST_INDEX(path[depth].p_hdr) != NULL ?
-				    EXT_FIRST_INDEX(path[depth].p_hdr)->ei_block : 0,
+				  le32_to_cpu(EXT_FIRST_INDEX(path[depth].p_hdr)->ei_block) : 0,
 				  depth);
 				return -EIO;
 			}
-- 
1.7.1

