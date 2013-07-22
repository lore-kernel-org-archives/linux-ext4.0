From: "=?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?="
	<johannbg@gmail.com>
Subject: [PATCH 1/1] ext4: Fix Opts: (null)
Date: Mon, 22 Jul 2013 22:24:28 +0000
Message-ID: <1374531868-1800-1-git-send-email-johannbg@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?=
	<johannbg@fedoraproject.org>
To: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

null null null no more Opts: (null) but something that actually makes s=
ense to
human beings...

Signed-off-by: J=C3=B3hann B. Gu=C3=B0mundsson <johannbg@fedoraproject.=
org>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 85b3dd6..ef141b7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4088,8 +4088,8 @@ no_journal:
 				 "the device does not support discard");
 	}
=20
-	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
-		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
+	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s "
+		 "%s%s%s mount option(s)", descr, sbi->s_es->s_mount_opts,
 		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);
=20
 	if (es->s_error_count)
@@ -4866,7 +4866,7 @@ static int ext4_remount(struct super_block *sb, i=
nt *flags, char *data)
 	}
 #endif
=20
-	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
+	ext4_msg(sb, KERN_INFO, "re-mounted %s mount option(s)", orig_data);
 	kfree(orig_data);
 	return 0;
=20
--=20
1.8.1.4
