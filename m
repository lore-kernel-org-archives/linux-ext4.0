From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 02/12] tune2fs: do not allow disabling ea_inode feature
Date: Mon, 26 Jun 2017 06:43:38 -0700
Message-ID: <20170626134348.1240-2-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:32798 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752423AbdFZNoB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:01 -0400
Received: by mail-pg0-f42.google.com with SMTP id f127so739237pgc.0
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:01 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Disabling ea_inode feature would require inlining all the existing
xattr values that are currently stored in external inodes. This is
not always possible. Just disallow it.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 misc/tune2fs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 90746707064b..2a437b9fc7b7 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -180,7 +180,6 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
-- 
2.13.1.611.g7e3b11ae1-goog
