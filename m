From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH v2] replaced BUG() with return -EIO from ext4_ext_get_blocks
Date: Sat, 12 Dec 2009 23:00:56 +0200
Message-ID: <1260651656-13805-1-git-send-email-surbhi.palande@canonical.com>
References: <4B22A572.5010201@redhat.com>
Cc: sandeen@redhat.com, fmayhar@google.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:39748 "HELO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751952AbZLMB1c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Dec 2009 20:27:32 -0500
In-Reply-To: <4B22A572.5010201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes the upstream bug# 14286. When the address of an extent
corresponding to a valid block is corrupted, a -EIO should be reported instead
of a BUG(). This situation would not normally not occur. If however it does,
then the system should not panic directly but  depending on the mount time options
appropriate action should be taken. If the mount options so permit, the I/O
should be gracefully aborted by returning a -EIO.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
 fs/ext4/extents.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3a7928f..d59aa12 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3189,8 +3189,17 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 * consistent leaf must not be empty;
 	 * this situation is possible, though, _during_ tree modification;
 	 * this is why assert can't be put in ext4_ext_find_extent()
+	 *
+	 * We don't want to panic in this case, try and abort I/O gracefully
 	 */
-	BUG_ON(path[depth].p_ext == NULL && depth != 0);
+	if (path[depth].p_ext == NULL && depth != 0) {
+		err = -EIO;
+		ext4_error(inode->i_sb, __func__,
+				"bad extent address "
+				"inode: %lu, iblock: %d, depth: %d",
+				inode->i_ino, iblock, depth);
+		goto out2;
+	}
 	eh = path[depth].p_hdr;
 
 	ex = path[depth].p_ext;
-- 
1.6.3.3

