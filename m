Return-Path: <SRS0=q/KL=MW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:37645 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbeJJVus (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2018 17:50:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
        Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: avoid unused variable warning
Date: Wed, 10 Oct 2018 16:27:58 +0200
Message-Id: <20181010142813.1918180-1-arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The two new variables are only used in an #ifdef, so they cause a
warning without CONFIG_QUOTA:

fs/ext4/super.c: In function 'parse_options':
fs/ext4/super.c:1977:26: error: unused variable 'grp_qf_name' [-Werror=unused-variable]
  char *p, *usr_qf_name, *grp_qf_name;
                          ^~~~~~~~~~~
fs/ext4/super.c:1977:12: error: unused variable 'usr_qf_name' [-Werror=unused-variable]
  char *p, *usr_qf_name, *grp_qf_name;

Fixes: 20cefcdc2040 ("ext4: fix use-after-free race in ext4_remount()'s error path")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext4/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e9ca8312457b..d60199510c94 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1974,7 +1974,10 @@ static int parse_options(char *options, struct super_block *sb,
 			 int is_remount)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	char *p, *usr_qf_name, *grp_qf_name;
+	char *p;
+#ifdef CONFIG_QUOTA
+	char *usr_qf_name, *grp_qf_name;
+#endif
 	substring_t args[MAX_OPT_ARGS];
 	int token;
 
-- 
2.18.0
