From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 40/54] mke2fs: Warn if not enabling all the features that
 metadata_csum wants
Date: Tue, 06 Mar 2012 16:02:07 -0800
Message-ID: <20120307000207.11945.9180.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36341 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031610Ab2CGADR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 19:03:17 -0500
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 19:03:16 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id F016F6E8049
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:02:16 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2702GRd339330
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:02:16 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2702Dv2006706
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:02:15 -0500
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The metadata_csum feature works best when two features are enabled.  These
features are "extents" (because the block map has no space for checksums) and
"64bit" (this enables storage of full 32-bit checksums in certain fields).
Print a warning if the user tries to create a filesystem without those
features.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 61b332a..e8c60ca 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2309,6 +2309,25 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
+	/* Check the user's mkfs options for metadata checksumming */
+	if (!quiet &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
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

