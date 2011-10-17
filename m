From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Check extent overflow with the right range.
Date: Mon, 17 Oct 2011 16:45:28 +0800
Message-ID: <1318841128-4540-1-git-send-email-tm@tao.ma>
References: <20111017081036.GN30887@longonot.mountain>
Cc: dan.carpenter@oracle.com, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35647 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751282Ab1JQIq6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 04:46:58 -0400
In-Reply-To: <20111017081036.GN30887@longonot.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In 4fd30c033, we move the range check before we change ix to avoid the memory stamp.
But actually we should check against the EXT_MAX_INDEX, not EXT_LAST_INDEX.

So this patch revert the old patch and adds a new check before we setting ix.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
Ted, since 4fd30c033 is in your dev branch, I am fine to integrate these 2 patches to one.

 fs/ext4/extents.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2dff31e..5c48612 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -779,8 +779,8 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 		ix = curp->p_idx;
 	}
 
-	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
-		EXT4_ERROR_INODE(inode, "ix > EXT_LAST_INDEX!");
+	if (unlikely(ix > EXT_MAX_INDEX(curp->p_hdr))) {
+		EXT4_ERROR_INODE(inode, "ix > EXT_MAX_INDEX!");
 		return -EIO;
 	}
 
@@ -788,6 +788,11 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 	ext4_idx_store_pblock(ix, ptr);
 	le16_add_cpu(&curp->p_hdr->eh_entries, 1);
 
+	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
+		EXT4_ERROR_INODE(inode, "ix > EXT_LAST_INDEX!");
+		return -EIO;
+	}
+
 	err = ext4_ext_dirty(handle, inode, curp);
 	ext4_std_error(inode->i_sb, err);
 
-- 
1.6.3.3.334.g916e1.dirty

