From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/4] ext4: add missing ext4_journal_stop()
Date: Sun, 17 Feb 2008 15:11:38 +0900
Message-ID: <20080217061137.GI3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@MIT.EDU>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:3255 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYBQGRz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:17:55 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2077834wah.23
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:17:55 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add missing ext4_journal_stop() in error handling.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Tweedie <sct@redhat.com>
Cc: adilger@clusterfs.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Theodore Tso <tytso@MIT.EDU>
---
 fs/ext4/resize.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6-rc/fs/ext4/resize.c
===================================================================
--- 2.6-rc.orig/fs/ext4/resize.c
+++ 2.6-rc/fs/ext4/resize.c
@@ -1037,6 +1037,7 @@ int ext4_group_extend(struct super_block
 		ext4_warning(sb, __FUNCTION__,
 			     "multiple resizers run on filesystem!");
 		unlock_super(sb);
+		ext4_journal_stop(handle);
 		err = -EBUSY;
 		goto exit_put;
 	}
