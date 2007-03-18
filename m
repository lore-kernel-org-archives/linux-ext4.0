From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH] Add i_version_hi for 64-bit version
Date: Sun, 18 Mar 2007 15:43:39 +0530
Message-ID: <1174212819.3282.10.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	TheodoreTso <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38011 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbXCRKMv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Mar 2007 06:12:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: linux-2.6.20/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.20.orig/include/linux/ext4_fs.h
+++ linux-2.6.20/include/linux/ext4_fs.h
@@ -336,6 +336,7 @@ struct ext4_inode {
        __le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
        __le32  i_crtime;       /* File Creation time */
        __le32  i_crtime_extra; /* extra File Creation time (nsec << 2 | epoch) */
+       __u32   i_version_hi;   /* high 32 bits for 64-bit version */
 };

 #define i_size_high    i_dir_acl

Thanks,
Kalpak <kalpak@clusterfs.com>
