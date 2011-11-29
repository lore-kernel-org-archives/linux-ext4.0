From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 21/50] libext2fs: Introduce dx_tail and dir_entry_tail
Date: Mon, 28 Nov 2011 16:30:17 -0800
Message-ID: <20111129003017.17953.26889.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e31.co.us.ibm.com ([32.97.110.149]:41972 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1K2Aa4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 19:30:56 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 17:30:55 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0UM7t103610
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:30:22 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0UJl6026279
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:30:21 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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

