From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 3/4] mke2fs: add options extended option for changing
 first inode
Date: Thu, 12 Mar 2015 19:20:15 +0300
Message-ID: <20150312162015.17173.99151.stgit@buzz>
References: <20150312161341.17173.96760.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:46424 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932401AbbCLQUS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2015 12:20:18 -0400
In-Reply-To: <20150312161341.17173.96760.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All currently reserved special inodes are assigned to some features. Some of
them never been actually implemented so could be reused. But anyway there are
only few special inodes left. Index of first normal inode is already stored in
the super-block thus we can reserve more without changing disk layout.

This patch add extended option 'first_inode' for overriding default first inode
(mostly for debug purpose). Features which want special inodes above 10 could
change first_inode automatically.

Changing default first_inode is possible, but this breaks too much tests where
inode numbers are present in expected output or even hardcoded: for example in
"tst_inline_data".

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 misc/mke2fs.8.in |    8 ++++++++
 misc/mke2fs.c    |   18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index aeb5caf6e869..13f0c7a2c9d2 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -369,6 +369,14 @@ as default.
 .TP
 .BI nodiscard
 Do not attempt to discard blocks at mkfs time.
+.TP
+.BI first_inode= inode-number
+This defines first normal inode, lower inodes are reserved for internal use.
+For filesystem revision 0 this valus is fixed to 11, that is default and
+minimal value for revision 1. This could be changed at a later time with the
+.B \-I
+command-line option to
+.BR resize2fs (8).
 @QUOTA_MAN_COMMENT@.TP
 @QUOTA_MAN_COMMENT@.BI quotatype
 @QUOTA_MAN_COMMENT@Specify which quota type ('usr' or 'grp') is to be
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index ec450adf9e12..73d148206c69 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1005,6 +1005,23 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			discard = 1;
 		} else if (!strcmp(token, "nodiscard")) {
 			discard = 0;
+		} else if (!strcmp(token, "first_inode")) {
+			if (!arg) {
+				r_usage++;
+				badopt = token;
+				continue;
+			}
+			param->s_first_ino = strtoul(arg, &p, 0);
+			if (*p ||
+			    param->s_first_ino < EXT2_GOOD_OLD_FIRST_INO ||
+			    (param->s_rev_level == EXT2_GOOD_OLD_REV &&
+			     param->s_first_ino != EXT2_GOOD_OLD_FIRST_INO)) {
+				fprintf(stderr,
+					_("Invalid first_ino parameter: %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
 		} else if (!strcmp(token, "quotatype")) {
 			if (!arg) {
 				r_usage++;
@@ -1047,6 +1064,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\ttest_fs\n"
 			"\tdiscard\n"
 			"\tnodiscard\n"
+			"\tfirst_inode=<inode number>\n"
 			"\tquotatype=<usr OR grp>\n\n"),
 			badopt ? badopt : "");
 		free(buf);

