From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: add large_file to base mkfs features
Date: Tue, 30 Sep 2014 22:26:03 -0500
Message-ID: <542B744B.3070602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaJAD0F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 23:26:05 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s913Q4qW002328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2014 23:26:04 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s913Q3Xw021798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2014 23:26:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

large_file (> 2G) support has been around since at least kernel 2.4;
mkfs of any sufficiently large filesystem sets it "accidentally"
when the resize inode exceeds 2G.  This leaves very small
filesystems lacking the feature, which potentially changes
their behavior & codepaths the first time a > 2G file gets
written.

There's really no reason to be making fresh filesystems which
strive to keep compatibility with 10 year old kernels; just
enable large_file at mkfs time.  This is particularly obvious
for ext4 fielsystems, which set huge_file by default, but not
necessarily large_file.

If old-kernel compatibility is desired, mke2fs.conf can be
modified locally to remove the feature.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 2bc435b..2a16c59 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1927,7 +1927,7 @@ profile_error:
 	tmp = NULL;
 	if (fs_param.s_rev_level != EXT2_GOOD_OLD_REV) {
 		tmp = get_string_from_profile(fs_types, "base_features",
-		      "sparse_super,filetype,resize_inode,dir_index");
+		      "sparse_super,large_file,filetype,resize_inode,dir_index");
 		edit_feature(tmp, &fs_param.s_feature_compat);
 		free(tmp);
 
diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 4c5dba7..106ee80 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -1,5 +1,5 @@
 [defaults]
-	base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
+	base_features = sparse_super,large_file,filetype,resize_inode,dir_index,ext_attr
 	default_mntopts = acl,user_xattr
 	enable_periodic_fsck = 0
 	blocksize = 4096

