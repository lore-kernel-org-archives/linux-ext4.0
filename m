From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 09/32] ext4: extended attribute value size limit is enforced by vfs
Date: Wed, 21 Jun 2017 14:21:19 -0700
Message-ID: <20170621212142.16581-9-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:33658 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbdFUVWC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 17:22:02 -0400
Received: by mail-pg0-f44.google.com with SMTP id f127so5482220pgc.0
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 14:22:02 -0700 (PDT)
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4_XATTR_MAX_LARGE_EA_SIZE definition in ext4 is currently unused.
Besides, vfs enforces its own 64k limit which makes the 1MB limit in
ext4 redundant. Remove it.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/ext4.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5d5fc0d0e2bc..2cdd6070e348 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2220,12 +2220,6 @@ struct mmpd_data {
  */
 #define EXT4_MMP_MAX_CHECK_INTERVAL	300UL
 
-/*
- * Maximum size of xattr attributes for FEATURE_INCOMPAT_EA_INODE 1Mb
- * This limit is arbitrary, but is reasonable for the xattr API.
- */
-#define EXT4_XATTR_MAX_LARGE_EA_SIZE    (1024 * 1024)
