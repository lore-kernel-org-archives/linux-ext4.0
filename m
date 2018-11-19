Return-Path: <SRS0=ApgQ=N6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33100 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbeKSPqT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 19 Nov 2018 10:46:19 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAJ5EjrN056862
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 00:23:49 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2nuj05tnkx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2018 00:23:49 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 19 Nov 2018 05:23:48 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, ebiggers@kernel.org,
        tytso@mit.edu
Subject: [PATCH 4/7] Add S_VERITY and IS_VERITY()
Date: Mon, 19 Nov 2018 10:53:21 +0530
In-Reply-To: <20181119052324.31456-1-chandan@linux.vnet.ibm.com>
References: <20181119052324.31456-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <20181119052324.31456-5-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Similar to S_ENCRYPTED/IS_ENCRYPTED(), this commit adds
S_VERITY/IS_VERITY() to be able to check if a VFS inode has verity
information associated with it.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index bcfc40062757..8129617c9718 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1938,6 +1938,7 @@ struct super_operations {
 #define S_DAX		0	/* Make all the DAX code disappear */
 #endif
 #define S_ENCRYPTED	16384	/* Encrypted file (using fs/crypto/) */
+#define S_VERITY	32768	/* File with fsverity info (using fs/verity) */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -1978,6 +1979,7 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 #define IS_DAX(inode)		((inode)->i_flags & S_DAX)
 #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
+#define IS_VERITY(inode)	((inode)->i_flags & S_VERITY)
 
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
-- 
2.19.1
