From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: release sysfs kobject when failing to enable quotas on mount
Date: Mon, 21 Jan 2013 01:46:20 -0500
Message-ID: <1358750781-5670-1-git-send-email-tytso@mit.edu>
References: <20130121054741.GB321@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130121054741.GB321@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In addition, print the error returned from ext4_enable_quotas()

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 30651bd..0a6e9d5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4015,7 +4015,7 @@ no_journal:
 	    !(sb->s_flags & MS_RDONLY)) {
 		err = ext4_enable_quotas(sb);
 		if (err)
-			goto failed_mount7;
+			goto failed_mount8;
 	}
 #endif  /* CONFIG_QUOTA */
 
@@ -4042,6 +4042,8 @@ cantfind_ext4:
 		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
 	goto failed_mount;
 
+failed_mount8:
+	kobject_del(&sbi->s_kobj);
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
@@ -5012,9 +5014,9 @@ static int ext4_enable_quotas(struct super_block *sb)
 						DQUOT_USAGE_ENABLED);
 			if (err) {
 				ext4_warning(sb,
-					"Failed to enable quota (type=%d) "
-					"tracking. Please run e2fsck to fix.",
-					type);
+					"Failed to enable quota tracking "
+					"(type=%d, err=%d). Please run "
+					"e2fsck to fix.", type, err);
 				return err;
 			}
 		}
-- 
1.7.12.rc0.22.gcdd159b
