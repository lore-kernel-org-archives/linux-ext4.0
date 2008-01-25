From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] UPDATED: ignore "safe" flag differences when
 fsck compares superblocks
Date: Fri, 25 Jan 2008 12:29:58 -0600
Message-ID: <479A2AA6.1020002@redhat.com>
References: <479629DF.7090500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbYAYSaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2008 13:30:01 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0PIU0MX008381
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2008 13:30:00 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0PITxJH017896
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2008 13:29:59 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m0PITx7u022861
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jan 2008 13:29:59 -0500
In-Reply-To: <479629DF.7090500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(updated for thinko: when proper flag *is* set on both primary & backup)

Recent e2fsprogs (1.40.3 and higher) fsck compares primary superblock to 
backups, and if things differ, it forces a full check.  However, the
kernel has a penchant for updating flags the first time a feature is
used - attributes, large files, etc.

However, it only updates these on the primary sb.  This then causes
the new e2fsck behavior to trigger a full check.  I think these flags
can be safely ignored on this check; having them set on the primary
but not the backups doesn't indicate corruption; if they're wrongly
set on the primary, really no damage is done, and if the backup is
used, but it doesn't have the flags set when it should, I'm pretty sure
e2fsck can cope with that.

I'll admit the patch below is not glamorous.  Any comments, either
on the style(sic) or the intent of the patch?

Thanks,

-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.4/e2fsck/super.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/super.c
+++ e2fsprogs-1.40.4/e2fsck/super.c
@@ -814,10 +814,32 @@ int check_backup_super_block(e2fsck_t ct
 			continue;
 		}
 
-#define SUPER_DIFFERENT(x) (fs->super->x != tfs->super->x)
-		if (SUPER_DIFFERENT(s_feature_compat) ||
-		    SUPER_DIFFERENT(s_feature_incompat) ||
-		    SUPER_DIFFERENT(s_feature_ro_compat) ||
+		/*
+		 * A few flags are set on the fly by the kernel, but
+		 * only in the primary superblock.  They are safe
+	 	 * to copy even if they differ.
+	 	 */ 
+
+#define FEATURE_COMPAT_IGNORE		(EXT2_FEATURE_COMPAT_EXT_ATTR)
+#define FEATURE_RO_COMPAT_IGNORE	(EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)
+#define FEATURE_INCOMPAT_IGNORE		(EXT3_FEATURE_INCOMPAT_EXTENTS)
+
+#define SUPER_COMPAT_DIFFERENT(x)	\
+	(( fs->super->x & ~FEATURE_COMPAT_IGNORE) !=	\
+	 (tfs->super->x & ~FEATURE_COMPAT_IGNORE))
+#define SUPER_INCOMPAT_DIFFERENT(x)	\
+	(( fs->super->x & ~FEATURE_INCOMPAT_IGNORE) !=	\
+	 (tfs->super->x & ~FEATURE_INCOMPAT_IGNORE))
+#define SUPER_RO_COMPAT_DIFFERENT(x)	\
+	(( fs->super->x & ~FEATURE_RO_COMPAT_IGNORE) !=	\
+	 (tfs->super->x & ~FEATURE_RO_COMPAT_IGNORE))
+#define SUPER_DIFFERENT(x)		\
+	(fs->super->x != tfs->super->x)
+
+		if (SUPER_COMPAT_DIFFERENT(s_feature_compat) ||
+		    SUPER_INCOMPAT_DIFFERENT(s_feature_incompat) ||
+		    SUPER_RO_COMPAT_DIFFERENT(s_feature_ro_compat) ||
 		    SUPER_DIFFERENT(s_blocks_count) ||
 		    SUPER_DIFFERENT(s_inodes_count) ||
 		    memcmp(fs->super->s_uuid, tfs->super->s_uuid,
