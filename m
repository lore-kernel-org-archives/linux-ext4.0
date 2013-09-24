From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] tune2fs: more respect for quota config option
Date: Tue, 24 Sep 2013 16:11:48 -0500
Message-ID: <52420014.8090901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bert DeKnuydt <Bert.Deknuydt@esat.kuleuven.be>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab3IXVM5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Sep 2013 17:12:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 44a2cca3 disabled tune2fs -O quota when the build
didn't have --enable-quota at configure time, but that
wasn't quite enough.

We need to exclude the "-Q" option as well from tune2fs
when --enable-quota isn't specified at configure time.

Otherwise, tune2fs -Q can set the quota feature, but no other
utility will touch the filesystem due to the unknown flag,
if buitl w/o --enable-quota.

So put everything related to "-Q" under #ifdef CONFIG_QUOTA;
usage output (was missing before) and option parsing.

Addresses-Red-Hat-Bugzilla: #1010709
Reported-by: Bert DeKnuydt <Bert.Deknuydt@esat.kuleuven.be>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index c38711d..ee21fa8 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -124,6 +124,9 @@ static void usage(void)
 		  "\t[-r reserved_blocks_count] [-u user] [-C mount_count] "
 		  "[-L volume_label]\n"
 		  "\t[-M last_mounted_dir] [-O [^]feature[,...]]\n"
+#ifdef CONFIG_QUOTA
+		  "\t[-Q quota_options]\n"
+#endif
 		  "\t[-E extended-option[,...]] [-T last_check_time] "
 		  "[-U UUID]\n\t[ -I new_inode_size ] device\n"), program_name);
 	exit(1);
@@ -1282,11 +1285,15 @@ static void parse_tune2fs_options(int argc, char **argv)
 	char *tmp;
 	struct group *gr;
 	struct passwd *pw;
+	char optstring[100] = "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:T:U:";
 
+#ifdef CONFIG_QUOTA
+	strcat(optstring, "Q:");
+#endif
 	open_flag = 0;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:Q:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, optstring)) != EOF)
 		switch (c) {
 		case 'c':
 			max_mount_count = strtol(optarg, &tmp, 0);
@@ -1440,11 +1447,13 @@ static void parse_tune2fs_options(int argc, char **argv)
 			features_cmd = optarg;
 			open_flag = EXT2_FLAG_RW;
 			break;
+#ifdef CONFIG_QUOTA
 		case 'Q':
 			Q_flag = 1;
 			parse_quota_opts(optarg);
 			open_flag = EXT2_FLAG_RW;
 			break;
+#endif
 		case 'r':
 			reserved_blocks = strtoul(optarg, &tmp, 0);
 			if (*tmp) {

