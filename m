From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 22/37] libext2fs: Introduce dx_tail and dir_entry_tail
Date: Wed, 31 Aug 2011 17:37:32 -0700
Message-ID: <20110901003732.1176.14799.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e33.co.us.ibm.com ([32.97.110.151]:43699 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab1IAAhj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:37:39 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810TbeQ025717
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:29:37 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810bYGa154386
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:37:34 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810bXKQ008062
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:37:34 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce small structures for recording directory tree checksums

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/ext2_fs.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index ec28fac..64adff9 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -217,6 +217,14 @@ struct ext2_dx_countlimit {
 	__u16 count;
 };
 
+/*
+ * This goes at the end of each htree block.  If you want to use the
+ * reserved field, you'll have to update the checksum code to include it.
+ */
+struct ext2_dx_tail {
+	__u32 reserved;
+	__u32 checksum;	/* crc32c(uuid+inum+dxblock) */
+};
 
 /*
  * Macro-instructions used to manage group descriptors

