Return-Path: <SRS0=NmFT=PW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:54566 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfANLAt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2019 06:00:49 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] ext4: Change debugging support help prefix from EXT4 to Ext4
Date: Mon, 14 Jan 2019 12:00:45 +0100
Message-Id: <20190114110045.10013-1-geert+renesas@glider.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All other configuration options for the ext* family of file systems use
"Ext%u" instead of "EXT%u".

Fixes: 6ba495e9259cd9a0 ("ext4: Add configurable run-time mballoc debugging")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 fs/ext4/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 031e5a82d556dbe9..06f77ca7f36ee737 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -97,7 +97,7 @@ config EXT4_FS_SECURITY
 	  extended attributes for file security labels, say N.
 
 config EXT4_DEBUG
-	bool "EXT4 debugging support"
+	bool "Ext4 debugging support"
 	depends on EXT4_FS
 	help
 	  Enables run-time debugging support for the ext4 filesystem.
-- 
2.17.1
