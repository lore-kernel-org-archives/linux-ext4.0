From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 19/47] tune2fs: Enable extent tree checksums
Date: Sat, 08 Oct 2011 00:35:17 -0700
Message-ID: <20111008073517.17888.89196.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e36.co.us.ibm.com ([32.97.110.154]:56984 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1JHHiI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:38:08 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987SRSu010202
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:28:27 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987ZJM3195052
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:35:19 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987ZINW012961
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:35:19 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add to tune2fs the ability to recalculate extent tree checksums when altering
the metadata checksum feature flag.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 24040e6..9edcfac 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -376,6 +376,48 @@ static void request_fsck_afterwards(ext2_filsys fs)
 		printf(_("(and reboot afterwards!)\n"));
 }
 
+/* Rewrite extents */
+static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino,
+				 struct ext2_inode *inode)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	int			op = EXT2_EXTENT_ROOT;
+	errcode_t		errcode;
+
+	if (!(inode->i_flags & EXT4_EXTENTS_FL))
+		return 0;
+
+	errcode = ext2fs_extent_open(fs, ino, &handle);
+	if (errcode)
+		return errcode;
+
+	while (1) {
+		errcode = ext2fs_extent_get(handle, op, &extent);
+		if (errcode)
+			break;
+
+		/* Root node is in the separately checksummed inode */
+		if (op == EXT2_EXTENT_ROOT) {
+			op = EXT2_EXTENT_NEXT;
+			continue;
+		}
+		op = EXT2_EXTENT_NEXT;
+
+		/* Only visit the first extent in each extent block */
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
+			continue;
+		errcode = ext2fs_extent_replace(handle, 0, &extent);
+		if (errcode)
+			break;
+	}
+
+	/* Ok if we run off the end */
+	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
+		errcode = 0;
+	return errcode;
+}
+
 /*
  * Forcibly set checksums in all inodes.
  */
@@ -416,6 +458,13 @@ static void rewrite_inodes(ext2_filsys fs)
 			com_err("set_csum", retval, "while writing inode");
 			exit(1);
 		}
+
+		retval = rewrite_extents(fs, ino, inode);
+		if (retval) {
+			com_err("rewrite_extents", retval,
+				"while rewriting extents");
+			exit(1);
+		}
 	} while (ino);
 
 	ext2fs_free_mem(&inode);

