From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 1/8] ext4: use EXT4_INODE_ENCRYPT flag to detect encrypted bio
Date: Fri, 12 Jan 2018 19:41:22 +0530
Message-ID: <20180112141129.27507-2-chandan@linux.vnet.ibm.com>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933778AbeALOK3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Jan 2018 09:10:29 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0CE9ji2113674
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:29 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fevkaqexc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:28 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 12 Jan 2018 07:10:28 -0700
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For supporting encryption in blocksize < pagesize scenario,
bio->bi_private field will be needed to hold the address of the
encryption context structure. Hence this commit uses
ext4_encrypted_inode() to detect the encryption status of a file.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/readpage.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 9ffa6fa..0be590b 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -50,7 +50,13 @@
 static inline bool ext4_bio_encrypted(struct bio *bio)
 {
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
-	return unlikely(bio->bi_private != NULL);
+        if (bio->bi_vcnt) {
+                struct inode *inode = bio->bi_io_vec->bv_page->mapping->host;
+                if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode))
+                        return true;
+	}
+
+	return false;
 #else
 	return false;
 #endif
-- 
2.9.5
