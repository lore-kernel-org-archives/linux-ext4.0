From: Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] ext4: fix potential integer overflow
Date: Wed, 20 Jan 2016 11:18:08 -0500
Message-ID: <1453306688-5528-1-git-send-email-wuninsu@gmail.com>
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since sizeof(ext_new_group_data) > sizeof(ext_new_flex_group_data),
integer overflow could be happened.
Therefore, need to fix integer overflow sanitization.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ad62d7a..34038e3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -198,7 +198,7 @@ static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned long flexbg_size)
 	if (flex_gd == NULL)
 		goto out3;
 
-	if (flexbg_size >= UINT_MAX / sizeof(struct ext4_new_flex_group_data))
+	if (flexbg_size >= UINT_MAX / sizeof(struct ext4_new_group_data))
 		goto out2;
 	flex_gd->count = flexbg_size;
 
-- 
1.9.1
