From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 20/47] libext2fs: Introduce dx_tail and dir_entry_tail
Date: Sat, 08 Oct 2011 00:35:23 -0700
Message-ID: <20111008073523.17888.30593.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e39.co.us.ibm.com ([32.97.110.160]:39897 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1JHHiJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:38:09 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987MEWt006569
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:22:14 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987ZPI2180112
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:35:25 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987ZOoH013881
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:35:25 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce small structures for recording directory tree checksums

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/ext2_fs.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index cdfc4a8..65d205a 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -241,6 +241,14 @@ struct ext2_dx_countlimit {
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

