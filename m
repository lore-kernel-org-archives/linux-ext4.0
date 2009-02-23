From: Karel Zak <kzak@redhat.com>
Subject: [PATCH] tune2fs: make findfs code optional
Date: Mon, 23 Feb 2009 18:38:53 +0100
Message-ID: <1235410733-4193-3-git-send-email-kzak@redhat.com>
References: <1235410733-4193-1-git-send-email-kzak@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Karel Zak <kzak@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32959 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZBWRjm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Feb 2009 12:39:42 -0500
In-Reply-To: <1235410733-4193-1-git-send-email-kzak@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add CONFIG_BUILD_FINDFS to enable/disable findfs(8) code
in tune2fs.

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 configure.in   |    2 ++
 misc/tune2fs.c |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index 83ab14d..a45ad2c 100644
--- a/configure.in
+++ b/configure.in
@@ -296,10 +296,12 @@ then
 	AC_MSG_RESULT([Disabling private blkid library])
 else
 	BLKID_CMT=
+	AC_DEFINE(CONFIG_BUILD_FINDFS)
 	AC_MSG_RESULT([Enabling private blkid library])
 fi
 ,
 BLKID_CMT=
+AC_DEFINE(CONFIG_BUILD_FINDFS)
 AC_MSG_RESULT([Enabling private blkid library by default])
 )
 AC_SUBST(BLKID_CMT)
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 887a702..f1c8ab9 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -95,7 +95,9 @@ struct blk_move {
 
 static const char *please_fsck = N_("Please run e2fsck on the filesystem.\n");
 
+#ifdef CONFIG_BUILD_FINDFS
 void do_findfs(int argc, char **argv);
+#endif
 
 static void usage(void)
 {
@@ -836,6 +838,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 	}
 }
 
+#ifdef CONFIG_BUILD_FINDFS
 void do_findfs(int argc, char **argv)
 {
 	char	*dev;
@@ -854,6 +857,7 @@ void do_findfs(int argc, char **argv)
 	puts(dev);
 	exit(0);
 }
+#endif
 
 static void parse_extended_opts(ext2_filsys fs, const char *opts)
 {
@@ -1492,8 +1496,10 @@ int main(int argc, char **argv)
 		program_name = *argv;
 	add_error_table(&et_ext2_error_table);
 
+#ifdef CONFIG_BUILD_FINDFS
 	if (strcmp(get_progname(argv[0]), "findfs") == 0)
 		do_findfs(argc, argv);
+#endif
 	if (strcmp(get_progname(argv[0]), "e2label") == 0)
 		parse_e2label_options(argc, argv);
 	else
-- 
1.6.0.6

