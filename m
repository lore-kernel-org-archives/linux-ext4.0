From: liuziloong@gmail.com
Subject: [PATCH] ext4 crypto: remove duplicate header file
Date: Thu, 16 Jul 2015 15:58:41 +0800
Message-ID: <1437033521-3138-1-git-send-email-liuziloong@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"zilong.liu" <liuziloong@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, mhalcrow@google.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: "zilong.liu" <liuziloong@gmail.com>

Remove key.h which is included twice in crypto_fname.c

Signed-off-by: zilong.liu <liuziloong@gmail.com>
---
 fs/ext4/crypto_fname.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
index 7dc4eb5..4c11768 100644
--- a/fs/ext4/crypto_fname.c
+++ b/fs/ext4/crypto_fname.c
@@ -19,7 +19,6 @@
 #include <linux/gfp.h>
 #include <linux/kernel.h>
 #include <linux/key.h>
-#include <linux/key.h>
 #include <linux/list.h>
 #include <linux/mempool.h>
 #include <linux/random.h>
-- 
1.7.9.5
