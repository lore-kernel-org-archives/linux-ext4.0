From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/5] ext4: don't forget to discard last block in a group
Date: Thu,  1 Mar 2012 11:16:43 +0100
Message-ID: <1330597005-751-3-git-send-email-lczerner@redhat.com>
References: <1330597005-751-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965335Ab2CAKQ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 05:16:58 -0500
In-Reply-To: <1330597005-751-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we might omit to discard the last block in the group (max)
because of off-by-one condition error. This commit fixes the condition
so we always discard the whole range if possible.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e907cf9..f20688e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4971,11 +4971,11 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 	start = (e4b.bd_info->bb_first_free > start) ?
 		e4b.bd_info->bb_first_free : start;
 
-	while (start < max) {
-		start = mb_find_next_zero_bit(bitmap, max, start);
-		if (start >= max)
+	while (start <= max) {
+		start = mb_find_next_zero_bit(bitmap, max + 1, start);
+		if (start > max)
 			break;
-		next = mb_find_next_bit(bitmap, max, start);
+		next = mb_find_next_bit(bitmap, max + 1, start);
 
 		if ((next - start) >= minblocks) {
 			ext4_trim_extent(sb, start,
-- 
1.7.4.4

