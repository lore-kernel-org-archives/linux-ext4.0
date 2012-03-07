From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 39/54] mke2fs: Write new group descriptors with the
 appropriate checksum
Date: Tue, 06 Mar 2012 16:02:01 -0800
Message-ID: <20120307000200.11945.59962.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:55133 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031593Ab2CGACN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:02:13 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:02:12 -0700
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id D12BDC90050
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:02:09 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q27027oe3358960
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:02:08 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q275WvWi017145
	for <linux-ext4@vger.kernel.org>; Wed, 7 Mar 2012 00:33:00 -0500
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Update mke2fs to use the helper function to determine if group descriptors
should have checksums calculated.  Since metadata_csum supersedes uninit_bg,
quietly drop uninit_bg if metadata_csum is set, so that older kernels don't
get confused.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 92b80e9..61b332a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1936,6 +1936,13 @@ profile_error:
 	if (extended_opts)
 		parse_extended_opts(&fs_param, extended_opts);
 
+	/* Don't allow user to set both metadata_csum and uninit_bg bits. */
+	if ((fs_param.s_feature_ro_compat &
+	     EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		fs_param.s_feature_ro_compat &=
+				~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+
 	/* Since sparse_super is the default, we would only have a problem
 	 * here if it was explicitly disabled.
 	 */
@@ -2048,7 +2055,8 @@ static int should_do_undo(const char *name)
 	int csum_flag, force_undo;
 
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
 	force_undo = get_int_from_profile(fs_types, "force_undo", 0);
 	if (!force_undo && (!csum_flag || !lazy_itable_init))
 		return 0;
@@ -2325,6 +2333,7 @@ int main (int argc, char *argv[])
 	    (fs_param.s_feature_ro_compat &
 	     (EXT4_FEATURE_RO_COMPAT_HUGE_FILE|EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
 	      EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
+	      EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
 	      EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)))
 		fs->super->s_kbytes_written = 1;
 
@@ -2472,8 +2481,7 @@ int main (int argc, char *argv[])
 		 * inodes as unused; we want e2fsck to consider all
 		 * inodes as potentially containing recoverable data.
 		 */
-		if (fs->super->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		if (ext2fs_has_group_desc_csum(fs)) {
 			for (i = 1; i < fs->group_desc_count; i++)
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 		}

