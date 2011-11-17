From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/2] [PATCH] ext4: avoid calculating free inodes twice in find_group_orlov()
Date: Thu, 17 Nov 2011 15:20:25 +0800
Message-ID: <1321514425-14937-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1KQHSo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 02:18:44 -0500
Received: by iage36 with SMTP id e36so1726592iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 23:18:44 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_free_inodes_count() shouldn't be called twice in here

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ialloc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00beb4f..1d81bfc 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -477,8 +477,7 @@ fallback_retry:
 	for (i = 0; i < ngroups; i++) {
 		grp = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc(sb, grp, NULL);
-		if (desc && ext4_free_inodes_count(sb, desc) &&
-		    ext4_free_inodes_count(sb, desc) >= avefreei) {
+		if (desc && ext4_free_inodes_count(sb, desc) >= avefreei) {
 			*group = grp;
 			return 0;
 		}
-- 
1.7.4.1

