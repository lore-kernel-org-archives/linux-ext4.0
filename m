From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 3/5] mke2fs: support creation of filesystem with quota feature
Date: Wed, 20 Jul 2011 11:40:04 -0700
Message-ID: <1311187206-30553-4-git-send-email-adityakali@google.com>
References: <1311187206-30553-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:7525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1GTSlL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 14:41:11 -0400
Received: from hpaq2.eem.corp.google.com (hpaq2.eem.corp.google.com [172.25.149.2])
	by smtp-out.google.com with ESMTP id p6KIf94k001065
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 11:41:09 -0700
In-Reply-To: <1311187206-30553-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mke2fs also creates quota inodes (userquota: inode# 3 and
groupquota: inode #4) inodes while creating a filesystem when 'quota'
feature is set.
 # To set quota feature and initialize quota inodes during mke2fs:
 $mke2fs -t ext4 -O quota /dev/ram1

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 misc/Makefile.in |   14 ++++++++------
 misc/mke2fs.8.in |    5 +++++
 misc/mke2fs.c    |   21 ++++++++++++++++++++-
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index 5f62323..2f7908c 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -219,23 +219,25 @@ mklost+found: $(MKLPF_OBJS)
 	$(Q) $(CC) $(ALL_LDFLAGS) -o mklost+found $(MKLPF_OBJS) $(LIBINTL)
 
 mke2fs: $(MKE2FS_OBJS) $(DEPLIBS) $(LIBE2P) $(DEPLIBBLKID) $(DEPLIBUUID) \
-		$(LIBEXT2FS) 
+		$(DEPLIBQUOTA) $(LIBEXT2FS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o mke2fs $(MKE2FS_OBJS) $(LIBS) $(LIBBLKID) \
-		$(LIBUUID) $(LIBEXT2FS) $(LIBE2P) $(LIBINTL)
+		$(LIBUUID) $(LIBQUOTA) $(LIBEXT2FS) $(LIBE2P) $(LIBINTL)
 
-mke2fs.static: $(MKE2FS_OBJS) $(STATIC_DEPLIBS) $(STATIC_LIBE2P) $(DEPSTATIC_LIBUUID) $(DEPSTATIC_LIBBLKID)
+mke2fs.static: $(MKE2FS_OBJS) $(STATIC_DEPLIBS) $(STATIC_LIBE2P) $(DEPSTATIC_LIBUUID) \
+		$(DEPSTATIC_LIBQUOTA) $(DEPSTATIC_LIBBLKID)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -static -o mke2fs.static $(MKE2FS_OBJS) \
 		$(STATIC_LIBS) $(STATIC_LIBE2P) $(STATIC_LIBBLKID) \
-		$(STATIC_LIBUUID) $(LIBINTL)
+		$(STATIC_LIBUUID) $(STATIC_LIBQUOTA) $(LIBINTL)
 
 mke2fs.profiled: $(PROFILED_MKE2FS_OBJS) $(PROFILED_DEPLIBS) \
-	$(PROFILED_LIBE2P) $(PROFILED_DEPLIBBLKID) $(PROFILED_DEPLIBUUID) 
+	$(PROFILED_LIBE2P) $(PROFILED_DEPLIBBLKID) $(PROFILED_DEPLIBUUID) \
+	$(PROFILED_LIBQUOTA)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o mke2fs.profiled \
 		$(PROFILED_MKE2FS_OBJS) $(PROFILED_LIBBLKID) \
-		$(PROFILED_LIBUUID) $(PROFILED_LIBE2P) $(LIBINTL) \
+		$(PROFILED_LIBUUID) $(PROFILED_LIBQUOTA) $(PROFILED_LIBE2P) $(LIBINTL) \
 		$(PROFILED_LIBS)
 
 chattr: $(CHATTR_OBJS) $(DEPLIBS_E2P)
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 0d4b046..41ed4d7 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -528,6 +528,11 @@ option).
 Filesystem can contain files that are greater than 2GB.  (Modern kernels
 set this feature automatically when a file > 2GB is created.)
 .TP
+.B quota
+Create quota inodes (inode# 3 for userquota and inode# 4 for group quota) and
+set them in the superblock. With this feature, the quotas will be enabled
+automatically when the filesystem is mounted.
+.TP
 .B resize_inode
 Reserve space so the block group descriptor table may grow in the future.
 Useful for online resizing using
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e062bda..cf9c338 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -63,6 +63,7 @@ extern int optind;
 #include "prof_err.h"
 #include "../version.h"
 #include "nls-enable.h"
+#include "quota/mkquota.h"
 
 #define STRIDE_LENGTH 8
 
@@ -829,7 +830,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
-		EXT4_FEATURE_RO_COMPAT_BIGALLOC
+		EXT4_FEATURE_RO_COMPAT_BIGALLOC|
+		EXT4_FEATURE_RO_COMPAT_QUOTA
 };
 
 
@@ -2137,6 +2139,19 @@ static void fix_cluster_bg_counts(ext2_filsys fs)
 	ext2fs_free_blocks_count_set(fs->super, EXT2FS_C2B(fs, tot_free));
 }
 
+static int create_quota_inodes(ext2_filsys fs)
+{
+	quota_ctx_t qctx;
+
+	init_quota_context(&qctx, fs, -1);
+	compute_quota(qctx, -1);
+	write_quota_inode(qctx, USRQUOTA);
+	write_quota_inode(qctx, GRPQUOTA);
+	release_quota_context(&qctx);
+
+	return;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
@@ -2466,6 +2481,10 @@ no_journal:
 	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
 				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
 		fix_cluster_bg_counts(fs);
+	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
+				       EXT4_FEATURE_RO_COMPAT_QUOTA))
+		create_quota_inodes(fs);
+
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
-- 
1.7.3.1

