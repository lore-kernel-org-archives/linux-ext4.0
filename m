From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: fix memory leak in ext4_ext_insert_extent
Date: Thu, 19 Jun 2008 15:54:27 +0800
Message-ID: <485A10B3.4020105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58203 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbYFSH6B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 03:58:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


In ext4_ext_insert_extent, when path is assigned by
npath, there is a memory leak and then path points to
a freed memory after the function returns becasue
npath and path point to the same memory address
and npath is freed.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/extents.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3f6be32..71a56f1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1497,6 +1497,8 @@ repeat:
 		if (le16_to_cpu(eh->eh_entries) < le16_to_cpu(eh->eh_max)) {
 			ext_debug("next leaf isnt full(%d)\n",
 				  le16_to_cpu(eh->eh_entries));
+			ext4_ext_drop_refs(path);
+			kfree(path);
 			path = npath;
 			goto repeat;
 		}
@@ -1578,7 +1580,7 @@ merge:
 	err = ext4_ext_dirty(handle, inode, path + depth);
 
 cleanup:
-	if (npath) {
+	if (npath && npath != path) {
 		ext4_ext_drop_refs(npath);
 		kfree(npath);
 	}
-- 
1.5.5.1
