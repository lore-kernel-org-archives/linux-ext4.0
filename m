From: Radek Pazdera <rpazdera@redhat.com>
Subject: [PATCH 1/3] libext2fs: Adding itree feature flag
Date: Sat,  4 May 2013 23:35:08 +0200
Message-ID: <1367703310-3842-2-git-send-email-rpazdera@redhat.com>
References: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847Ab3EDVff (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 17:35:35 -0400
In-Reply-To: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit reserves a flag for the itree read-only compatible feature.

    EXT4_FEATURE_RO_COMPAT_ITREE 0x1000

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 lib/e2p/feature.c    | 2 ++
 lib/ext2fs/ext2_fs.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 70815ef..9b15679 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -66,6 +66,8 @@ static struct feature feature_list[] = {
 			"metadata_csum"},
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_REPLICA,
 			"replica" },
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_ITREE,
+			"itree" },
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0c0bbcb..be711ce 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -739,6 +739,7 @@ struct ext2_super_block {
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
+#define EXT4_FEATURE_RO_COMPAT_ITREE		0x1000
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
-- 
1.7.11.7

