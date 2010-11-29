From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 14/15] libext2fs: fix possible memory leak in write_journal_inode()
Date: Mon, 29 Nov 2010 17:55:16 +0900
Message-ID: <1291020917-8671-15-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51817 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0K2Iz4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:56 -0500
Received: by mail-gw0-f46.google.com with SMTP id 20so1866691gwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:56 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_zero_block2() allocates static buffer if needed so it
should be freed at last (call it again with 0 args).

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/ext2fs/mkjournal.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 9466e78..242c537 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -376,6 +376,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	ext2fs_mark_super_dirty(fs);
 
 errout:
+	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
 	ext2fs_free_mem(&buf);
 	return retval;
 }
-- 
1.7.0.4

