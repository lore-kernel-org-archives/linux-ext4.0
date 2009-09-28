From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] debugfs: add matching fclose
Date: Mon, 28 Sep 2009 18:51:53 +0800
Message-ID: <1254135113-28212-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f191.google.com ([209.85.222.191]:62105 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZI1Kwh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Sep 2009 06:52:37 -0400
Received: by pzk29 with SMTP id 29so2314312pzk.33
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2009 03:52:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the cmd_file is not stdin, we should close the file handle via fclose().
Thanks David Binderman to point this out.

Addresses-Novell-Bugzilla: #524526

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 debugfs/debugfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 93227e3..7f75788 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2133,6 +2133,8 @@ static int source_file(const char *cmd_file, int sci_idx)
 			exit_status++;
 		}
 	}
+	if (f != stdin)
+		fclose(f);
 	return exit_status;
 }
 
-- 
1.6.5.rc2.262.g5224f

