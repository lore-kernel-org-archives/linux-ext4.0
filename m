From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/14] ext4: Use sb_any_quota_loaded() instead of sb_any_quota_enabled()
Date: Mon, 27 Oct 2008 13:11:45 +0100
Message-ID: <12251095131095-git-send-email-jack@suse.cz>
References: <1225109512852-git-send-email-jack@suse.cz>
 <12251095123763-git-send-email-jack@suse.cz>
 <12251095124166-git-send-email-jack@suse.cz>
 <1225109512758-git-send-email-jack@suse.cz>
 <12251095122803-git-send-email-jack@suse.cz>
 <12251095124165-git-send-email-jack@suse.cz>
 <1225109513735-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1225109513735-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bdddea1..be34b66 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1139,8 +1139,7 @@ static int parse_options(char *options, struct super_block *sb,
 		case Opt_grpjquota:
 			qtype = GRPQUOTA;
 set_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    !sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR
 				       "EXT4-fs: Cannot change journaled "
@@ -1179,8 +1178,7 @@ set_qf_name:
 		case Opt_offgrpjquota:
 			qtype = GRPQUOTA;
 clear_qf_name:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_qf_names[qtype]) {
 				printk(KERN_ERR "EXT4-fs: Cannot change "
 					"journaled quota options when "
@@ -1199,8 +1197,7 @@ clear_qf_name:
 		case Opt_jqfmt_vfsv0:
 			qfmt = QFMT_VFS_V0;
 set_qf_format:
-			if ((sb_any_quota_enabled(sb) ||
-			     sb_any_quota_suspended(sb)) &&
+			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
 				printk(KERN_ERR "EXT4-fs: Cannot change "
 					"journaled quota options when "
@@ -1219,7 +1216,7 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt, GRPQUOTA);
 			break;
 		case Opt_noquota:
-			if (sb_any_quota_enabled(sb)) {
+			if (sb_any_quota_loaded(sb)) {
 				printk(KERN_ERR "EXT4-fs: Cannot change quota "
 					"options when quota turned on.\n");
 				return 0;
-- 
1.5.6

