From: Junichi Uekawa <uekawa@google.com>
Subject: [PATCH] ext4: fix warning message to output correct type.
Date: Fri, 13 Jul 2018 18:15:47 +0900
Message-ID: <20180713091547.231108-1-uekawa@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Junichi Uekawa <uekawa@google.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Output the warning message before we clobber type and be -1 all the time.
The error message would now be

[    1.519791] EXT4-fs warning (device vdb): ext4_enable_quotas:5402:
Failed to enable quota tracking (type=0, err=-3). Please run e2fsck to fix.

Signed-off-by: Junichi Uekawa <uekawa@google.com>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ba2396a7bd04..1b90f619663c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5670,13 +5670,13 @@ static int ext4_enable_quotas(struct super_block *sb)
 				DQUOT_USAGE_ENABLED |
 				(quota_mopt[type] ? DQUOT_LIMITS_ENABLED : 0));
 			if (err) {
-				for (type--; type >= 0; type--)
-					dquot_quota_off(sb, type);
-
 				ext4_warning(sb,
 					"Failed to enable quota tracking "
 					"(type=%d, err=%d). Please run "
 					"e2fsck to fix.", type, err);
+				for (type--; type >= 0; type--)
+					dquot_quota_off(sb, type);
+
 				return err;
 			}
 		}
-- 
2.18.0.203.gfac676dfb9-goog
