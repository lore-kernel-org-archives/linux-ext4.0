From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext3: don't forget to discard last block in a group
Date: Thu,  1 Mar 2012 14:40:07 +0100
Message-ID: <1330609207-11755-2-git-send-email-lczerner@redhat.com>
References: <1330609207-11755-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab2CANkb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 08:40:31 -0500
In-Reply-To: <1330609207-11755-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we might omit to discard the last block in the group (max)
because of off-by-one condition error. This commit fixes the condition
so we always discard the whole range if possible.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext3/balloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index e3a8d9e..997da27 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1970,7 +1970,7 @@ static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
 	sbi = EXT3_SB(sb);
 
 	 /* Walk through the whole group */
-	while (start < max) {
+	while (start <= max) {
 		start = bitmap_search_next_usable_block(start, bitmap_bh, max);
 		if (start < 0)
 			break;
@@ -1980,7 +1980,7 @@ static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
 		 * Allocate contiguous free extents by setting bits in the
 		 * block bitmap
 		 */
-		while (next < max
+		while (next <= max
 			&& claim_block(sb_bgl_lock(sbi, group),
 					next, bitmap_bh)) {
 			next++;
-- 
1.7.4.4

