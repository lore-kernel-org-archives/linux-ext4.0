From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] ext4: reserve inodes and feature code for 'quota' feature
Date: Mon, 14 Feb 2011 17:06:50 -0800
Message-ID: <AANLkTinvSvUXNR-=pYTNp+dwLNFasuuXqfvVukVkw1qp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:34498 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1BOBHO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 20:07:14 -0500
Received: from kpbe14.cbf.corp.google.com (kpbe14.cbf.corp.google.com [172.25.105.78])
	by smtp-out.google.com with ESMTP id p1F17CAQ022414
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 17:07:12 -0800
Received: from pzk37 (pzk37.prod.google.com [10.243.19.165])
	by kpbe14.cbf.corp.google.com with ESMTP id p1F16xhm016658
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 17:07:11 -0800
Received: by pzk37 with SMTP id 37so1018071pzk.12
        for <linux-ext4@vger.kernel.org>; Mon, 14 Feb 2011 17:07:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am working on patch to add quota as a built-in feature for ext4
filesystem. The implementation is based on the design given at
https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4.
This patch reserves the inode numbers 3 and 4 for quota purposes and
also reserves EXT4_FEATURE_RO_COMPAT_QUOTA feature code.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/ext4/ext4.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0c8d97b..127f76f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -209,6 +209,8 @@ struct ext4_io_submit {
  */
 #define	EXT4_BAD_INO		 1	/* Bad blocks inode */
 #define EXT4_ROOT_INO		 2	/* Root inode */
+#define EXT4_USR_QUOTA_INO	 3	/* User quota inode */
+#define EXT4_GRP_QUOTA_INO	 4	/* Group quota inode */
 #define EXT4_BOOT_LOADER_INO	 5	/* Boot loader inode */
 #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
 #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
@@ -1337,6 +1339,7 @@ static inline void ext4_clear_state_flags(struct
ext4_inode_info *ei)
 #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
+#define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100

 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
-- 
1.7.3.1
