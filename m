From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext3: Don't check quota format when there are no quota files
Date: Tue, 16 Sep 2014 22:38:25 +0200
Message-ID: <1410899905-32290-2-git-send-email-jack@suse.cz>
References: <1410899905-32290-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaIPUia (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2014 16:38:30 -0400
In-Reply-To: <1410899905-32290-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c | 7 -------
 1 file changed, 7 deletions(-)

I'm going to queue this patch unless someone objects.

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 622e88249024..2c42e739e3d1 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1354,13 +1354,6 @@ set_qf_format:
 					"not specified.");
 			return 0;
 		}
-	} else {
-		if (sbi->s_jquota_fmt) {
-			ext3_msg(sb, KERN_ERR, "error: journaled quota format "
-					"specified with no journaling "
-					"enabled.");
-			return 0;
-		}
 	}
 #endif
 	return 1;
-- 
1.8.1.4

