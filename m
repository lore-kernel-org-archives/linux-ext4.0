From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] teach libblkid about ext4(dev)
Date: Tue, 22 Jan 2008 17:11:11 -0600
Message-ID: <4796780F.1000603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345AbYAVXLN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2008 18:11:13 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0MNBCC4020496
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2008 18:11:12 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0MNBB4W027667
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2008 18:11:12 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m0MNBBMf028903
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2008 18:11:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Returns ext4dev for now; will need to change to ext4 at the appropriate
time I guess.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

--- 

Index: e2fsprogs-1.40.4/lib/blkid/probe.c

===================================================================
--- e2fsprogs-1.40.4.orig/lib/blkid/probe.c
+++ e2fsprogs-1.40.4/lib/blkid/probe.c
@@ -148,6 +148,38 @@ static void get_ext2_info(blkid_dev dev,
 	set_uuid(dev, es->s_uuid, 0);
 }
 
+static int probe_ext4(struct blkid_probe *probe,
+		      struct blkid_magic *id __BLKID_ATTR((unused)),
+		      unsigned char *buf)
+{
+	struct ext2_super_block *es;
+	es = (struct ext2_super_block *)buf;
+
+	/* Distinguish between jbd and ext2/3/4 fs */
+	if (blkid_le32(es->s_feature_incompat) &
+	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
+		return -BLKID_ERR_PARAM;
+
+	/* Distinguish between ext3/4 and ext2 */
+	if (!(blkid_le32(es->s_feature_compat) &
+	      EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+		return -BLKID_ERR_PARAM;
+
+	/* Distinguish between ext4 and ext3 */
+	if (!(blkid_le32(es->s_feature_ro_compat) &
+	      EXT4_FEATURES_RO_COMPAT) &&
+	    !(blkid_le32(es->s_feature_incompat) &
+	      EXT4_FEATURES_INCOMPAT))
+		return -BLKID_ERR_PARAM;
+
+	get_ext2_info(probe->dev, buf);
+
+	if ((es->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
+	    !uuid_is_null(es->s_journal_uuid))
+		set_uuid(probe->dev, es->s_journal_uuid, "EXT_JOURNAL");
+
+	return 0;
+}
 static int probe_ext3(struct blkid_probe *probe, 
 		      struct blkid_magic *id __BLKID_ATTR((unused)), 
 		      unsigned char *buf)
@@ -833,6 +865,7 @@ static struct blkid_magic type_array[] =
   { "oracleasm", 0,	32,  8, "ORCLDISK",		probe_oracleasm },
   { "ntfs",	 0,	 3,  8, "NTFS    ",		probe_ntfs },
   { "jbd",	 1,   0x38,  2, "\123\357",		probe_jbd },
+  { "ext4dev",	 1,   0x38,  2, "\123\357",		probe_ext4 },
   { "ext3",	 1,   0x38,  2, "\123\357",		probe_ext3 },
   { "ext2",	 1,   0x38,  2, "\123\357",		probe_ext2 },
   { "reiserfs",	 8,   0x34,  8, "ReIsErFs",		probe_reiserfs },
Index: e2fsprogs-1.40.4/lib/blkid/probe.h
===================================================================
--- e2fsprogs-1.40.4.orig/lib/blkid/probe.h
+++ e2fsprogs-1.40.4/lib/blkid/probe.h
@@ -88,6 +88,26 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_RECOVER		0x00000004
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x00000008
 
+#define EXT4_FEATURE_RO_COMPAT_HUGE_FILE	0x0008
+#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
+#define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
+#define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
+
+#define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
+#define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
+#define EXT4_FEATURE_INCOMPAT_MMP		0x0100
+#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+
+#define EXT4_FEATURES_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_HUGE_FILE| \
+				 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
+				 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
+				 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)
+
+#define EXT4_FEATURES_INCOMPAT	(EXT4_FEATURE_INCOMPAT_EXTENTS| \
+				 EXT4_FEATURE_INCOMPAT_64BIT| \
+				 EXT4_FEATURE_INCOMPAT_MMP| \
+				 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+
 struct xfs_super_block {
 	unsigned char	xs_magic[4];
 	__u32		xs_blocksize;
