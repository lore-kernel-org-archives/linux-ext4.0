From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] logdump : Fix typos in logdump.c
Date: Sun, 8 Mar 2009 23:45:31 +0530
Message-ID: <ea11fea30903081115j649da923h4377b8bed742e79c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:21709 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZCHSPe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Mar 2009 14:15:34 -0400
Received: by wa-out-1112.google.com with SMTP id v33so754299wah.21
        for <linux-ext4@vger.kernel.org>; Sun, 08 Mar 2009 11:15:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Below patch fixes some trivial typos found during code reading


    Fix typos in logdump.c

Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 69539e2..aed8eb6 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -300,9 +300,9 @@ static int read_journal_block(const char *cmd,
struct journal_source *source,
 	}

 	if (retval)
-		com_err(cmd, retval, "while while reading journal");
+		com_err(cmd, retval, "while reading journal");
 	else if (*got != (unsigned int) size) {
-		com_err(cmd, 0, "short read (read %d, expected %d) while while
reading journal", *got, size);
+		com_err(cmd, 0, "short read (read %d, expected %d) while reading
journal", *got, size);
 		retval = -1;
 	}


Thanks -
Manish
