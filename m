From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/2] ext4: remove redundant goto tag "repeat"
Date: Thu, 30 Jun 2011 16:03:33 +0800
Message-ID: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46029 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab1F3IDp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jun 2011 04:03:45 -0400
Received: by iwn6 with SMTP id 6so1695995iwn.19
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jun 2011 01:03:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If eh->eh_entries is smaller than eh->eh_max, the routine will
go to the "repeat" and then go to "has_space" directlly ,
since argument "depth" and "eh" are not even changed.

Therefore, goto "has_space" directly and remove redundant "repeat" tag.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index eb63c7b..dc5ef91 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1758,7 +1758,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		goto merge;
 	}
 
-repeat:
 	depth = ext_depth(inode);
 	eh = path[depth].p_hdr;
 	if (le16_to_cpu(eh->eh_entries) < le16_to_cpu(eh->eh_max))
@@ -1780,7 +1779,7 @@ repeat:
 			ext_debug("next leaf isn't full(%d)\n",
 				  le16_to_cpu(eh->eh_entries));
 			path = npath;
-			goto repeat;
+			goto has_space;
 		}
 		ext_debug("next leaf has no free space(%d,%d)\n",
 			  le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
-- 
1.7.1

