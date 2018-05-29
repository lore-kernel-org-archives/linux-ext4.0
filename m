From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: [PATCH] ext4: prefer strlcpy to strncpy
Date: Mon, 28 May 2018 23:21:53 -0700
Message-ID: <1527574913-10561-1-git-send-email-nick.desaulniers@gmail.com>
Cc: Nick Desaulniers <nick.desaulniers@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixes a stringop-truncation warning from gcc-8.

Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eb104e8..d47c85f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -323,11 +323,11 @@ static void __save_error_info(struct super_block *sb, const char *func,
 		return;
 	es->s_state |= cpu_to_le16(EXT4_ERROR_FS);
 	es->s_last_error_time = cpu_to_le32(get_seconds());
-	strncpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
+	strlcpy(es->s_last_error_func, func, sizeof(es->s_last_error_func));
 	es->s_last_error_line = cpu_to_le32(line);
 	if (!es->s_first_error_time) {
 		es->s_first_error_time = es->s_last_error_time;
-		strncpy(es->s_first_error_func, func,
+		strlcpy(es->s_first_error_func, func,
 			sizeof(es->s_first_error_func));
 		es->s_first_error_line = cpu_to_le32(line);
 		es->s_first_error_ino = es->s_last_error_ino;
-- 
2.7.4
