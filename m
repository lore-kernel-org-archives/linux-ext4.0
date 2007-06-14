From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH 2/6] add i_version_hi to ext4_inode
Date: Thu, 14 Jun 2007 21:26:16 +0530
Message-ID: <1181836576.7779.44.camel@garfield>
References: <1181835073.7779.9.camel@garfield>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-41C70k+pIrJCVmrxkTw4"
Cc: Mingming Cao <cmm@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:32990 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbXFNP4S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 11:56:18 -0400
In-Reply-To: <1181835073.7779.9.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-41C70k+pIrJCVmrxkTw4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

There were whitespace problems in i_version_hi.patch. I am attaching the
corrected patch.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
---
 ext4_fs.h |    1 +
 1 file changed, 1 insertion(+)


--=-41C70k+pIrJCVmrxkTw4
Content-Disposition: attachment; filename=i_version_hi.patch
Content-Type: text/x-patch; name=i_version_hi.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
---
Index: linux-2.6.21/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs.h
+++ linux-2.6.21/include/linux/ext4_fs.h
@@ -342,6 +342,7 @@ struct ext4_inode {
 	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
 	__le32  i_crtime;       /* File Creation time */
 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
+	__le32	i_version_hi;	/* high 32 bits for 64-bit version */
 };
 
 #define i_size_high	i_dir_acl

--=-41C70k+pIrJCVmrxkTw4--
