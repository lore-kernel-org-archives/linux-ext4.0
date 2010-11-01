From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] mke2fs: Add discard option into mke2fs.conf
Date: Mon,  1 Nov 2010 14:34:04 -0400
Message-ID: <1288636444-11068-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, adilger@dilger.ca,
	lczerner@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0KASeJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Nov 2010 14:34:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow to specify discard in mke2fs.conf. Also change the way how to
specify default value for lazy_itable_init. It is better to have all
this defaulting done in the same place so do it in definition (as we do
with discard).

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c         |    9 +++++----
 misc/mke2fs.conf.5.in |    5 +++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index f0ac741..960c837 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -83,12 +83,12 @@ int	cflag;
 int	verbose;
 int	quiet;
 int	super_only;
-int	discard = 1;
+int	discard = 1;	/* attempt  to discard device before fs creation */
 int	force;
 int	noaction;
 int	journal_size;
 int	journal_flags;
-int	lazy_itable_init;	/* use lazy inode table init */
+int	lazy_itable_init = 0;	/* do not use lazy inode table init */
 char	*bad_blocks_filename;
 __u32	fs_stride;
 
@@ -1686,8 +1686,9 @@ static void PRS(int argc, char *argv[])
 
 	blocksize = EXT2_BLOCK_SIZE(&fs_param);
 
-	lazy_itable_init = get_bool_from_profile(fs_types,
-						 "lazy_itable_init", 0);
+	lazy_itable_init = get_bool_from_profile(fs_types, "lazy_itable_init",
+						 lazy_itable_init);
+	discard = get_bool_from_profile(fs_types, "discard" , discard);
 
 	/* Get options from profile */
 	for (cpp = fs_types; *cpp; cpp++) {
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index d212947..e9913cb 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -360,6 +360,11 @@ option.  This can be used to configure the default extended options used
 by
 .BR mke2fs (8)
 on a per-filesystem type basis.
+.TP
+.I discard
+This relation is a boolean which specifies whether the
+.BR mke2fs (8)
+should attempt to discard device prior to filesystem creation.
 .SH FILES
 .TP
 .I /etc/mke2fs.conf
-- 
1.7.2.3

