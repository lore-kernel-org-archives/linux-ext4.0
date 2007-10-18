From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 3/6] ext4: Code cleanup
Date: Thu, 18 Oct 2007 15:59:33 +0530
Message-ID: <1192703376-20594-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1192703376-20594-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1192703376-20594-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59210 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbXJRK3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2007 06:29:55 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9IATkT0004802
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:29:46 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9IAXLjC174478
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:33:21 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9IATjXN003673
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:29:46 +1000
In-Reply-To: <1192703376-20594-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

rename i_file_acl to i_file_acl_lo

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c         |    4 ++--
 include/linux/ext4_fs.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8908ab3..ef073df 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2825,7 +2825,7 @@ void ext4_read_inode(struct inode * inode)
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
-	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
+	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl_lo);
 	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
 	    cpu_to_le32(EXT4_OS_HURD))
 		ei->i_file_acl |=
@@ -2980,7 +2980,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	    cpu_to_le32(EXT4_OS_HURD))
 		raw_inode->i_file_acl_high =
 			cpu_to_le16(ei->i_file_acl >> 32);
-	raw_inode->i_file_acl = cpu_to_le32(ei->i_file_acl);
+	raw_inode->i_file_acl_lo = cpu_to_le32(ei->i_file_acl);
 	if (!S_ISREG(inode->i_mode)) {
 		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
 	} else {
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 514464d..6464ff9 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -325,7 +325,7 @@ struct ext4_inode {
 	} osd1;				/* OS dependent 1 */
 	__le32	i_block[EXT4_N_BLOCKS];/* Pointers to blocks */
 	__le32	i_generation;	/* File version (for NFS) */
-	__le32	i_file_acl;	/* File ACL */
+	__le32	i_file_acl_lo;	/* File ACL */
 	__le32	i_dir_acl;	/* Directory ACL */
 	__le32	i_obso_faddr;	/* Obsoleted fragment address */
 	union {
-- 
1.5.3.4.206.g58ba4-dirty
