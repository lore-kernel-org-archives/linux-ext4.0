From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/2] ext4: Delete an error message for a failed memory
 allocation in ext4_multi_mount_protect()
Date: Sat, 19 Aug 2017 13:47:40 +0200
Message-ID: <5bf432ae-398d-718c-8105-3092a240a8ef@users.sourceforge.net>
References: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:64368 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751552AbdHSLrp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 19 Aug 2017 07:47:45 -0400
In-Reply-To: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 19 Aug 2017 13:04:50 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/ext4/mmp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index eb9835638680..1ce00453f612 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -371,7 +371,6 @@ int ext4_multi_mount_protect(struct super_block *sb,
-	if (!mmpd_data) {
-		ext4_warning(sb, "not enough memory for mmpd_data");
+	if (!mmpd_data)
 		goto failed;
-	}
+
 	mmpd_data->sb = sb;
 	mmpd_data->bh = bh;
 
-- 
2.14.0
