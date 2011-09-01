From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 21/37] tune2fs: Enable extent tree checksums
Date: Wed, 31 Aug 2011 17:37:25 -0700
Message-ID: <20110901003725.1176.19853.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e36.co.us.ibm.com ([32.97.110.154]:43688 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab1IAAhf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:37:35 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810Ut66001067
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:30:55 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810bSK3146064
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:37:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VIaxb7008044
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:37:01 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add to tune2fs the ability to recalculate extent tree checksums when altering
the metadata checksum feature flag.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index dd4011e..0c0a911 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -355,6 +355,49 @@ static void request_fsck_afterwards(ext2_filsys fs)
 		printf(_("(and reboot afterwards!)\n"));
 }
 
+/* Rewrite extents */
+static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino,
+				 struct ext2_inode_large *inode)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	int			op = EXT2_EXTENT_ROOT;
+	unsigned int		printed = 0;
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
@@ -387,6 +430,13 @@ static void rewrite_inodes(ext2_filsys fs)
 			com_err("set_csum", retval, "while writing inode");
 			exit(1);
 		}
+
+		retval = rewrite_extents(fs, ino, &inode);
+		if (retval) {
+			com_err("rewrite_extents", retval,
+				"while rewriting extents");
+			exit(1);
+		}
 	} while (ino);
 	ext2fs_close_inode_scan(scan);
 }

