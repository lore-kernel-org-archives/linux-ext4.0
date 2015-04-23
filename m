From: Chanho Park <parkch98@gmail.com>
Subject: [PATCH] ext4 crypto: remove duplicated encryption mode definitions
Date: Thu, 23 Apr 2015 17:56:16 +0900
Message-ID: <1429779376-26355-1-git-send-email-chanho61.park@samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Chanho Park <chanho61.park@samsung.com>,
	Michael Halcrow <mhalcrow@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch removes duplicated encryption modes which were already in
ext4.h. They were duplicated from commit 3edc18d and commit f542fb.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Michael Halcrow <mhalcrow@google.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 fs/ext4/ext4.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ef267ad..07378a4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1066,12 +1066,6 @@ extern void ext4_set_bits(void *bm, int cur, int len);
 /* Metadata checksum algorithm codes */
 #define EXT4_CRC32C_CHKSUM		1
 
-/* Encryption algorithms */
-#define EXT4_ENCRYPTION_MODE_INVALID		0
-#define EXT4_ENCRYPTION_MODE_AES_256_XTS	1
-#define EXT4_ENCRYPTION_MODE_AES_256_GCM	2
-#define EXT4_ENCRYPTION_MODE_AES_256_CBC	3
-
 /*
  * Structure of the super block
  */
-- 
1.9.1
