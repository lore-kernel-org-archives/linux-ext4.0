From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 02/15 RESEND] libext2fs: fix dubious code in ext2fs_numeric_progress_init()
Date: Mon, 29 Nov 2010 17:55:04 +0900
Message-ID: <1291020917-8671-3-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45792 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0K2Iz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:29 -0500
Received: by mail-yw0-f46.google.com with SMTP id 5so1866777ywl.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:29 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks like a copy & paste problem to me.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/ext2fs/progress.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/progress.c b/lib/ext2fs/progress.c
index 5ad2a45..ec4f553 100644
--- a/lib/ext2fs/progress.c
+++ b/lib/ext2fs/progress.c
@@ -40,7 +40,7 @@ void ext2fs_numeric_progress_init(ext2_filsys fs,
 	memset(spaces, ' ', sizeof(spaces)-1);
 	spaces[sizeof(spaces)-1] = 0;
 	memset(backspaces, '\b', sizeof(backspaces)-1);
-	spaces[sizeof(backspaces)-1] = 0;
+	backspaces[sizeof(backspaces)-1] = 0;
 	progress->skip_progress = 0;
 	if (getenv("E2FSPROGS_SKIP_PROGRESS"))
 		progress->skip_progress++;
-- 
1.7.0.4

