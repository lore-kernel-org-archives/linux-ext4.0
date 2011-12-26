From: Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] ext4: avoid oversized shift in ext4_fill_flex_info()
Date: Mon, 26 Dec 2011 01:36:44 -0500
Message-ID: <1324881404-3791-1-git-send-email-xi.wang@gmail.com>
Cc: linux-ext4@vger.kernel.org, Xi Wang <xi.wang@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53041 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1LZGiU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Dec 2011 01:38:20 -0500
Received: by qcqz2 with SMTP id z2so6458621qcq.19
        for <linux-ext4@vger.kernel.org>; Sun, 25 Dec 2011 22:38:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 503358ae fixed a division by zero, but groups_per_flex still
overflows due to an oversized shift, given a large s_log_groups_per_flex
like 36.  (1 << 36) is undefined in C; the result may vary depending
on the architecture, e.g., 16 on x86, thus bypassing the sanity check
(groups_per_flex < 2).

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 fs/ext4/super.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3e1329e..6deaf41 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2010,14 +2010,15 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	size_t size;
 	int i;
 
-	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
-	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
