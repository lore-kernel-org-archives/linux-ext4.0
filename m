From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 02/02] ext2: reserve INCOMPAT_LARGEDIR feature flag
Date: Tue, 6 Dec 2011 17:16:00 -0700
Message-ID: <512B3CCF-26FD-4DFB-BA22-2D6664E03BE5@whamcloud.com>
References: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Liang Zhen <liang@whamcloud.com>, Tao Ma <tm@tao.ma>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52020 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1LGAQE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 19:16:04 -0500
Received: by ghbz2 with SMTP id z2so44785ghb.19
        for <linux-ext4@vger.kernel.org>; Tue, 06 Dec 2011 16:16:03 -0800 (PST)
In-Reply-To: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reserve the EXT4_FEATURE_INCOMPAT_LARGEDIR feature flag for use by
directories larger than 2GB in size, or with more than 2-level htree.
This allows directories to exceed the following size limits:

             best case       typical case     worst case
blocksize    8-byte name     64-byte name     255-byte name
=========    ============    ============     =============
 1024        768k entries    168k entries     36k entries
 4096        50M entries     10.9M entries    2.9M entries
16384        3.2B entries    713M entries     195M entries

The 2GB size limit could be handled by an RO_COMPAT feature (as was
done with LARGE_FILE) since it only affects the use of i_size_high,
but the 2-level htree limit is hard coded into the kernel code by
the use of frame->at[2] allowing only 2 levels of index.

Since it is impossible that a directory larger than 2GB would be
created without a 3-level htree for blocksize 4096, a single
INCOMPAT flag is used for both of these cases.

Signed-off-by: Liang Zhen <liang@whamcloud.com>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/ext2_fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 6cf47f9..154356a 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -720,6 +720,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
 #define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x2000 /* data in inode */
+#define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
-- 
1.7.2


