From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 09/15] mke2fs: check return value of e2p_os2string()
Date: Mon, 29 Nov 2010 17:55:11 +0900
Message-ID: <1291020917-8671-10-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51817 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0K2Izo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:44 -0500
Received: by mail-gw0-f46.google.com with SMTP id 20so1866691gwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:43 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2p_os2string() calls malloc() so that it can return NULL.
Check it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 misc/mke2fs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9fb5d5f..90cc206 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -554,6 +554,10 @@ static void show_stats(ext2_filsys fs)
 	printf(_("Filesystem label=%s\n"), buf);
 	fputs(_("OS type: "), stdout);
         os = e2p_os2string(fs->super->s_creator_os);
+	if (!os) {
+		fprintf(stderr, _("Couldn't allocate memory to show OS name!\n"));
+		exit(1);
+	}
 	fputs(os, stdout);
 	free(os);
 	printf("\n");
-- 
1.7.0.4

