From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2 V2] e2fsprogs: turn off enforced fsck intervals by default
Date: Thu, 17 Feb 2011 15:55:15 -0600
Message-ID: <4D5D9943.70901@redhat.com>
References: <4D5C1380.2020602@redhat.com> <4D5C1409.1030203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab1BQVzR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Feb 2011 16:55:17 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1HLtHcV028541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Feb 2011 16:55:17 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1HLtFkI024589
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Feb 2011 16:55:16 -0500
In-Reply-To: <4D5C1409.1030203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The forced fsck often comes at unexpected and inopportune moments,
and even enterprise customers are often caught by surprise when 
this happens.  Because a filesystem with an error condition will 
be marked as requiring fsck anyway, I submit that the time-based 
and mount-based checks are not particularly useful, and that 
administrators can schedule fscks on their own time, or tune2fs 
the enforced intervals if they so choose.  This patch disables the 
intervals by default, and I've added a new mkfs.conf option to 
turn on the old behavior of random, unexpected, time-consuming
fscks at boot time.  ;)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 7c38975..1d2927c 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -46,19 +46,6 @@
 #endif /* defined(__linux__)   && defined(EXT2_OS_LINUX) */
 
 /*
- * Note we override the kernel include file's idea of what the default
- * check interval (never) should be.  It's a good idea to check at
- * least *occasionally*, specially since servers will never rarely get
- * to reboot, since Linux is so robust these days.  :-)
- *
- * 180 days (six months) seems like a good value.
- */
-#ifdef EXT2_DFL_CHECKINTERVAL
-#undef EXT2_DFL_CHECKINTERVAL
-#endif
-#define EXT2_DFL_CHECKINTERVAL (86400L * 180L)
-
-/*
  * Calculate the number of GDT blocks to reserve for online filesystem growth.
  * The absolute maximum number of GDT blocks we can reserve is determined by
  * the number of block pointers that can fit into a single block.
@@ -155,7 +142,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
 	set_field(s_log_frag_size, 0); /* default fragsize: 1024 bytes */
 	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
-	set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
+	set_field(s_max_mnt_count, 0);
 	set_field(s_errors, EXT2_ERRORS_DEFAULT);
 	set_field(s_feature_compat, 0);
 	set_field(s_feature_incompat, 0);
@@ -189,7 +176,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 		super->s_inode_size = EXT2_GOOD_OLD_INODE_SIZE;
 	}
 
-	set_field(s_checkinterval, EXT2_DFL_CHECKINTERVAL);
+	set_field(s_checkinterval, 0);
 	super->s_mkfs_time = super->s_lastcheck = fs->now ? fs->now : time(NULL);
 
 	super->s_creator_os = CREATOR_OS;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0ba4a4c..2910e6e 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2105,13 +2105,31 @@ int main (int argc, char *argv[])
 	uuid_generate((unsigned char *) fs->super->s_hash_seed);
 
 	/*
-	 * Add "jitter" to the superblock's check interval so that we
-	 * don't check all the filesystems at the same time.  We use a
-	 * kludgy hack of using the UUID to derive a random jitter value.
+	 * Periodic checks can be enabled/disabled via config file.
+	 * Note we override the kernel include file's idea of what the default
+	 * check interval (never) should be.  It's a good idea to check at
+	 * least *occasionally*, specially since servers will never rarely get
+	 * to reboot, since Linux is so robust these days.  :-)
+	 *
+	 * 180 days (six months) seems like a good value.
 	 */
-	for (i = 0, val = 0 ; i < sizeof(fs->super->s_uuid); i++)
-		val += fs->super->s_uuid[i];
-	fs->super->s_max_mnt_count += val % EXT2_DFL_MAX_MNT_COUNT;
+#ifdef EXT2_DFL_CHECKINTERVAL
+#undef EXT2_DFL_CHECKINTERVAL
+#endif
+#define EXT2_DFL_CHECKINTERVAL (86400L * 180L)
+
+	if (get_bool_from_profile(fs_types, "enable_periodic_fsck", 0)) {
+		fs->super->s_checkinterval = EXT2_DFL_CHECKINTERVAL;
+		fs->super->s_max_mnt_count = EXT2_DFL_MAX_MNT_COUNT;
+		/*
+		 * Add "jitter" to the superblock's check interval so that we
+		 * don't check all the filesystems at the same time.  We use a
+		 * kludgy hack of using the UUID to derive a random jitter value
+		 */
+		for (i = 0, val = 0 ; i < sizeof(fs->super->s_uuid); i++)
+			val += fs->super->s_uuid[i];
+		fs->super->s_max_mnt_count += val % EXT2_DFL_MAX_MNT_COUNT;
+	}
 
 	/*
 	 * Override the creator OS, if applicable
diff --git a/misc/mke2fs.conf b/misc/mke2fs.conf
index a7dd1c7..a96251e 100644
--- a/misc/mke2fs.conf
+++ b/misc/mke2fs.conf
@@ -1,5 +1,6 @@
 [defaults]
 	base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
+	enable_periodic_fsck = 0
 	blocksize = 4096
 	inode_size = 256
 	inode_ratio = 16384
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index e9913cb..1e777cd 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -107,6 +107,17 @@ command-line option
 to 
 .BR mke2fs (8).
 .TP
+.I enable_periodic_fsck
+This relation specifies whether periodic filesystem checks should be
+enforced at boot time.  If enabled, checks will be forced every
+180 days, or after a random number of mounts.  These values may
+be changed later via the
+.B -i
+and
+.B -c
+command-line options to
+.BR tune2fs (8).
+.TP
 .I force_undo
 This relation, if set to a boolean value of true, forces
 .B mke2fs

