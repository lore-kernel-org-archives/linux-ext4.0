From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH] Add i_version_hi for 64-bit version
Date: Tue, 03 Apr 2007 12:26:47 +0530
Message-ID: <1175583407.3846.4.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:45521 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbXDCGyo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Apr 2007 02:54:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I have changed the i_version_hi field to a le32 and also cleaned up the whitespace. 

This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: linux-2.6.19/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.19.orig/include/linux/ext4_fs.h
+++ linux-2.6.19/include/linux/ext4_fs.h
@@ -336,6 +336,7 @@ struct ext4_inode {
 	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
 	__le32  i_crtime;       /* File Creation time */
 	__le32  i_crtime_extra; /* extra File Creation time (nsec << 2 | epoch) */
+	__le32	i_version_hi;   /* high 32 bits for 64-bit version */
 };
 
 #define i_size_high	i_dir_acl

Thanks,
Kalpak Shah.
