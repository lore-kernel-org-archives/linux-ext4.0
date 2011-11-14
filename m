From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libquota: log an error message if ext2fs_file_open() fails
Date: Mon, 14 Nov 2011 13:34:11 -0500
Message-ID: <1321295651-22882-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48330 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab1KNSeO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 13:34:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This also fixes a format string type compiler warning.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/quotaio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 6edb0b0..d0b5b9d 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -232,7 +232,7 @@ errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
 	log_debug("Opening quota ino=%lu, type=%d", qf_ino, type);
 	err = ext2fs_file_open(fs, qf_ino, flags, &e2_file);
 	if (err) {
-		log_err("ext2fs_file_open failed: %d", err);
+		log_err("ext2fs_file_open failed: %s", error_message(err));
 		return err;
 	}
 	h->qh_qf.e2_file = e2_file;
-- 
1.7.4.1.22.gec8e1.dirty

