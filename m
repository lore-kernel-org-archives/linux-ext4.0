From: Radek Pazdera <rpazdera@redhat.com>
Subject: [PATCH 3/3] mke2fs, tune2fs: Adding support for the itree flag
Date: Sat,  4 May 2013 23:35:10 +0200
Message-ID: <1367703310-3842-4-git-send-email-rpazdera@redhat.com>
References: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab3EDVfj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 17:35:39 -0400
In-Reply-To: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit enables the itree feature flag for the mke2fs and tune2fs.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 misc/mke2fs.c  | 3 ++-
 misc/tune2fs.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bbf477a..4bc11b0 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -914,7 +914,8 @@ static __u32 ok_features[3] = {
 #ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA|
 #endif
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
+		EXT4_FEATURE_RO_COMPAT_ITREE
 };
 
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 66fbc54..b9173fc 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -148,7 +148,8 @@ static __u32 ok_features[3] = {
 #ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
 #endif
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
+		EXT4_FEATURE_RO_COMPAT_ITREE
 };
 
 static __u32 clear_ok_features[3] = {
@@ -169,7 +170,8 @@ static __u32 clear_ok_features[3] = {
 #ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
 #endif
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
+		EXT4_FEATURE_RO_COMPAT_ITREE
 };
 
 /*
-- 
1.7.11.7

