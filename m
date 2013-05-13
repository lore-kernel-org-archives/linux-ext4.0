From: Radek Pazdera <rpazdera@redhat.com>
Subject: [PATCH v2 2/2] mke2fs, tune2fs: Adding support for the itree flag
Date: Mon, 13 May 2013 17:43:50 +0200
Message-ID: <1368459830-3651-3-git-send-email-rpazdera@redhat.com>
References: <1368459830-3651-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab3EMQoF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 12:44:05 -0400
In-Reply-To: <1368459830-3651-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit enables the itree feature flag for the mke2fs and tune2fs.

The 'itree' feature adds an auxiliary tree that should help with indexing
directories. The tree resides on the file system along with the original
HTree (althought it is placed outside of the directory file).

It is a B+tree that contains directory entries sorted in inode order and
it is used to implement the getdents/readdir system calls. The inodes
are then returned in the optimal order, which improves the performance of
directory traversal.

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 misc/mke2fs.c  |    3 ++-
 misc/tune2fs.c |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ff759d..672bcde 100644
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
index 332aafd..a638d55 100644
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
1.7.7.6

