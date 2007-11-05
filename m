From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] ext4/super.c: fix #ifdef's
Date: Mon, 5 Nov 2007 18:07:13 +0100
Message-ID: <20071105170713.GJ12045@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Robert P. J. Day" <rpjday@crashcourse.ca>
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59503 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757005AbXKERHh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 12:07:37 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch fixes the names of two variables in #ifdef's.

Based on a report by Robert P. J. Day.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

44e9889e6a3952ea225704b2e494d31e00f34a6b 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8031dc0..6673672 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -646,7 +646,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",debug");
 	if (test_opt(sb, OLDALLOC))
 		seq_puts(seq, ",oldalloc");
-#ifdef CONFIG_EXT4_FS_XATTR
+#ifdef CONFIG_EXT4DEV_FS_XATTR
 	if (test_opt(sb, XATTR_USER))
 		seq_puts(seq, ",user_xattr");
 	if (!test_opt(sb, XATTR_USER) &&
@@ -654,7 +654,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",nouser_xattr");
 	}
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
+#ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	if (test_opt(sb, POSIX_ACL))
 		seq_puts(seq, ",acl");
 	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
