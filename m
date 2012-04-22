From: Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] [EXT4] super.c: unused variable warning without CONFIG_QUOTA
Date: Sun, 22 Apr 2012 17:50:52 +0200
Message-ID: <1335109852-17829-1-git-send-email-eldad@fogrefinery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eldad Zack <eldad@fogrefinery.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

sb info is only checked with quota support.

fs/ext4/super.c: In function =E2=80=98parse_options=E2=80=99:
fs/ext4/super.c:1600:23: warning: unused variable =E2=80=98sbi=E2=80=99=
 [-Wunused-variable]

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 fs/ext4/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6da1935..e1fb1d5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1597,7 +1597,9 @@ static int parse_options(char *options, struct su=
per_block *sb,
 			 unsigned int *journal_ioprio,
 			 int is_remount)
 {
+#ifdef CONFIG_QUOTA
 	struct ext4_sb_info *sbi =3D EXT4_SB(sb);
+#endif
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int token;
--=20
1.7.10
