From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 38/51] mke2fs: Warn if not enabling all the features that
	metadata_csum wants
Date: Tue, 13 Dec 2011 17:17:31 -0800
Message-ID: <20111214011731.20947.27437.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e37.co.us.ibm.com ([32.97.110.158]:45134 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1LNBRh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2011 20:17:37 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 18:17:36 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1HY4X066844
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:17:34 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1HWDc030778
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:17:34 -0700
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are some features (gdt_csum, 64bit, bg_use_meta_csum) that help
metadata_csum to work optimally.  Print a warning if the user tries to create a
filesystem without those features.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index ba7625d..c07c468 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -884,7 +884,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_64BIT,
+		EXT4_FEATURE_INCOMPAT_64BIT |
+		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -2298,6 +2299,38 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
+	/* Check the user's mkfs options for metadata checksumming */
+	if (!quiet &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+			printf(_("Group descriptor checksums "
+				 "are not enabled.  This reduces the "
+				 "coverage of metadata checksumming.  "
+				 "Pass -O uninit_bg to rectify.\n"));
+		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+		    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM))
+			printf(_("Group descriptor checksums will not use "
+				 "the faster metadata_checksum algorithm.  "
+				 "Pass -O bg_use_meta_csum to rectify.\n"));
+		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT3_FEATURE_INCOMPAT_EXTENTS))
+			printf(_("Extents are not enabled.  The file extent "
+				 "tree can be checksummed, whereas block maps "
+				 "cannot.  Not enabling extents reduces the "
+				 "coverage of metadata checksumming.  "
+				 "Pass -O extents to rectify.\n"));
+		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_INCOMPAT_64BIT))
+			printf(_("64-bit filesystem support is not "
+				 "enabled.  The larger fields afforded by "
+				 "this feature enable full-strength "
+				 "checksumming.  Pass -O 64bit to rectify.\n"));
+	}
+
 	/* Can't undo discard ... */
 	if (!noaction && discard && (io_ptr != undo_io_manager)) {
 		retval = mke2fs_discard_device(fs);

