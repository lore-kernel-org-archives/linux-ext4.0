From: eru@netti.fi
Subject: [PATCH] tune2fs: prevent crash if error in journal recovery
Date: Thu, 05 Oct 2017 08:25:50 +0300
Message-ID: <96fd009e4552b48cd9d4e4f776dc7d20@be409.mail.saunalahti.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:41104 "EHLO
        gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdJEFZx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2017 01:25:53 -0400
Received: from cfwo-20-2.mail.saunalahti.fi (cfwo-20.mail.saunalahti.fi [62.142.5.102])
        by gw01.mail.saunalahti.fi (Postfix) with ESMTP id A97E440088
        for <linux-ext4@vger.kernel.org>; Thu,  5 Oct 2017 08:25:51 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
        by cfwo-20-2.mail.saunalahti.fi (Postfix) with ESMTP id 23DD82007E
        for <linux-ext4@vger.kernel.org>; Thu,  5 Oct 2017 08:25:51 +0300 (EEST)
Received: from webmail.elisa.fi (wm-web17.pa.saunalahti.fi [195.197.1.110])
        by cfwo-20-2.mail.saunalahti.fi (Postfix) with ESMTP id C2ECA20077
        for <linux-ext4@vger.kernel.org>; Thu,  5 Oct 2017 08:25:50 +0300 (EEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Prevent coredump if tunefs calls ext2fs_run_ext3_journal(), and this 
then
fails for some reason while calling ext2fs_open2(). Such failure makes
the fs pointer NULL.

Signed-off-by: Erkki Ruohtula <eru@netti.fi>
---

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ecba2ea..6538032 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -3367,6 +3367,9 @@ closefs:
  #endif
  	}

-	convert_64bit(fs, feature_64bit);
-	return (ext2fs_close_free(&fs) ? 1 : 0);
+	if (fs) {
+		convert_64bit(fs, feature_64bit);
+		return (ext2fs_close_free(&fs) ? 1 : 0);
+	}
+	return 1;
  }
