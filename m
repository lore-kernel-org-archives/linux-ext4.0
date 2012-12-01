From: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] fs:ext4:hash.c: reduce one "if" comparison
Date: Sat,  1 Dec 2012 23:33:41 +0000
Message-ID: <1354404821-6781-1-git-send-email-dinggnu@gmail.com>
Cc: Cong Ding <dinggnu@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

it is unnecessary to check i<4 after the loop. just do it before the break.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/ext4/hash.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index fa8e491..3d586f0 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -155,11 +155,11 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 	/* Check to see if the seed is all zero's */
 	if (hinfo->seed) {
 		for (i = 0; i < 4; i++) {
-			if (hinfo->seed[i])
+			if (hinfo->seed[i]) {
+				memcpy(buf, hinfo->seed, sizeof(buf));
 				break;
+			}
 		}
-		if (i < 4)
-			memcpy(buf, hinfo->seed, sizeof(buf));
 	}
 
 	switch (hinfo->hash_version) {
-- 
1.7.4.5
