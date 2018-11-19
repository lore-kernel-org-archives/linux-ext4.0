Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f178.google.com ([209.85.166.178]:39226 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbeKSTkf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2018 14:40:35 -0500
Received: by mail-it1-f178.google.com with SMTP id m15so6431653itl.4
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 01:17:33 -0800 (PST)
From: alexey.lyashkov@gmail.com
To: linux-ext4@vger.kernel.org
Cc: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: [PATCH 2/3] Fix panic with journal superblock flags printing.
Date: Mon, 19 Nov 2018 12:16:49 +0300
Message-Id: <20181119091650.81803-3-alexey.lyashkov@gmail.com>
In-Reply-To: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------2.18.0"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Lyashkov <alexey.lyashkov@gmail.com>

This is a multi-part message in MIME format.
--------------2.18.0
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Signed-off-by: Alexey Lyashkov <alexey.lyashkov@gmail.com>
---
 debugfs/logdump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


--------------2.18.0
Content-Type: text/x-patch; name="0002-Fix-panic-with-journal-superblock-flags-printing.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0002-Fix-panic-with-journal-superblock-flags-printing.patch"

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 84108a6e..c88f6f9c 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -388,9 +388,9 @@ static void dump_journal(char *cmdname, FILE *out_file,
 	if (retval)
 		return;
 
-	if (dump_super) {
+	if (dump_all || dump_super) {
 		e2p_list_journal_super(out_file, jsb_buffer,
-				       current_fs->blocksize, 0);
+				       1024, 0);
 		fputc('\n', out_file);
 	}
 

--------------2.18.0--
