From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/54] tune2fs: Rewrite inode bitmap checksums
Date: Tue, 06 Mar 2012 15:58:31 -0800
Message-ID: <20120306235831.11945.20963.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:53181 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031282Ab2CFX67 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 18:58:59 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 16:58:57 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id AC63B3E40036
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 16:58:40 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q26Nweu6111502
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 16:58:40 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q26NwZVd013578
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 16:58:39 -0700
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When toggling metadata_csum, mark the inode bitmap dirty so that they are
written out with new checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/tune2fs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index cb1aff3..478b651 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -427,6 +427,9 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	ext2fs_init_csum_seed(fs);
 	rewrite_inodes(fs);
+	ext2fs_read_bitmaps(fs);
+	ext2fs_mark_ib_dirty(fs);
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 }
 

