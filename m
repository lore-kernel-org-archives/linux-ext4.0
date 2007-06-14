From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH 1/6] Separated 64-bit i_version patch
Date: Thu, 14 Jun 2007 21:26:14 +0530
Message-ID: <1181836574.7779.43.camel@garfield>
References: <1181835073.7779.9.camel@garfield>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-fs3ri4778co8xr3IX7GR"
Cc: Mingming Cao <cmm@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:32984 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXFNP4L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 11:56:11 -0400
In-Reply-To: <1181835073.7779.9.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-fs3ri4778co8xr3IX7GR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

64-bit-i_version.patch which only replaces the 32-bit i_version field in
the generic inode with a 64-bit i_version field. 

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
---
 fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

P.S. The VFS-level updates of the inode version are still in the
i_version_update_vfs.patch and this patch has been moved to the bottom
of the patch series.


--=-fs3ri4778co8xr3IX7GR
Content-Disposition: attachment; filename=64-bit-i_version.patch
Content-Type: text/x-patch; name=64-bit-i_version.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch converts the 32-bit i_version in the generic inode to a 64-bit
i_version field.

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: linux-2.6.21/include/linux/fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/fs.h
+++ linux-2.6.21/include/linux/fs.h
@@ -549,7 +549,7 @@ struct inode {
 	uid_t			i_uid;
 	gid_t			i_gid;
 	dev_t			i_rdev;
-	unsigned long		i_version;
+	uint64_t		i_version;
 	loff_t			i_size;
 #ifdef __NEED_I_SIZE_ORDERED
 	seqcount_t		i_size_seqcount;

--=-fs3ri4778co8xr3IX7GR--
