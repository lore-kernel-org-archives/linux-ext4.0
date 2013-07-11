From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't show usrquota/grpquota twice in /proc/mounts
Date: Thu, 11 Jul 2013 18:55:05 -0400
Message-ID: <1373583305-29126-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We now print mount options in a generic fashion in
ext4_show_options(), so we shouldn't be explicitly printing the
{usr,grp}quota options in ext4_show_quota_options().

Without this patch, /proc/mounts can look like this:

 /dev/vdb /vdb ext4 rw,relatime,quota,usrquota,data=ordered,usrquota 0 0
                                      ^^^^^^^^              ^^^^^^^^

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8862d4d..bca26f3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1702,12 +1702,6 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
-
-	if (test_opt(sb, USRQUOTA))
-		seq_puts(seq, ",usrquota");
-
-	if (test_opt(sb, GRPQUOTA))
-		seq_puts(seq, ",grpquota");
 #endif
 }
 
-- 
1.7.12.rc0.22.gcdd159b
