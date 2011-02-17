From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2 V2] e2fsprogs: enable user namespace xattrs by default
Date: Thu, 17 Feb 2011 15:56:17 -0600
Message-ID: <4D5D9981.1020300@redhat.com>
References: <4D5C1380.2020602@redhat.com> <4D5C15C6.5000802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab1BQV4T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Feb 2011 16:56:19 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1HLuJdu028779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Feb 2011 16:56:19 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1HLuHBI010919
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Feb 2011 16:56:18 -0500
In-Reply-To: <4D5C15C6.5000802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

User namespace xattrs are generally useful, and I think extN
is the only filesystem requiring a special mount option to
enable them, when xattrs are otherwise available.  So this
change sets that mount option into the defaults, via a
mke2fs.conf option.

Note that if xattrs are config'd off, this will lead to a
mostly-harmless:

   EXT4-fs (sdc1): (no)user_xattr options not supported

message at mount time... 

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 1d2927c..4cf0863 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -147,6 +147,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_feature_compat, 0);
 	set_field(s_feature_incompat, 0);
 	set_field(s_feature_ro_compat, 0);
+	set_field(s_default_mount_opts, 0);
 	set_field(s_first_meta_bg, 0);
 	set_field(s_raid_stride, 0);		/* default stride size: 0 */
 	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 2910e6e..e9e3129 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -829,6 +829,18 @@ static void edit_feature(const char *str, __u32 *compat_array)
 	}
 }
 
+static void edit_mntopts(const char *str, __u32 *mntopts)
+{
+	if (!str)
+		return;
+
+	if (e2p_edit_mntopts(str, mntopts, ~0)) {
+		fprintf(stderr, _("Invalid mount option set: %s\n"),
+			str);
+		exit(1);
+	}
+}
+
 struct str_list {
 	char **list;
 	int num;
@@ -1576,6 +1588,16 @@ profile_error:
 	}
 	edit_feature(fs_features ? fs_features : tmp,
 		     &fs_param.s_feature_compat);
+
+	if (tmp)
+		free(tmp);
+
+	/* And which mount options as well */
+	tmp = NULL;
+	tmp = get_string_from_profile(fs_types, "default_mntopts",
+		"acl,user_xattr");
+	edit_mntopts(tmp, &fs_param.s_default_mount_opts);
+
 	if (tmp)
 		free(tmp);
 
diff --git a/misc/mke2fs.conf b/misc/mke2fs.conf
index a96251e..775e046 100644
--- a/misc/mke2fs.conf
+++ b/misc/mke2fs.conf
@@ -1,5 +1,6 @@
 [defaults]
 	base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
+	default_mntopts = acl,user_xattr
 	enable_periodic_fsck = 0
 	blocksize = 4096
 	inode_size = 256
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index 1e777cd..791cf7e 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -314,6 +314,13 @@ relations.  It may be overridden by the
 command-line option to
 .BR mke2fs (8).
 .TP
+.I default_mntopts
+This relation specifies the set of mount options which should be enabled
+by default.  These may be changed at a later time with the
+.B -o
+command-line option to
+.BR tune2fs (8).
+.TP
 .I auto_64-bit_support
 This relation is a boolean which specifies whether
 .BR mke2fs (8)

