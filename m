From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Mark possibly unused variable in ext4_mb_normalize_request()
Date: Mon, 19 Dec 2011 15:10:12 -0800
Message-ID: <1324336212-19700-1-git-send-email-curtw@google.com>
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55615 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1LSXKQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Dec 2011 18:10:16 -0500
Received: by eekc1 with SMTP id c1so192855eek.1
        for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 15:10:15 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The 'orig_size' local variable is only used in a call to
mb_debug().  Mark it with '__maybe_unused'.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 fs/ext4/mballoc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..7cb9a33 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2911,7 +2911,8 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	int bsbits, max;
 	ext4_lblk_t end;
-	loff_t size, orig_size, start_off;
+	loff_t size, start_off;
+	loff_t orig_size __maybe_unused;
 	ext4_lblk_t start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_prealloc_space *pa;
-- 
1.7.3.1

