From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 8/8] ext4: enable encryption for blocksize less than page size
Date: Fri, 12 Jan 2018 19:41:29 +0530
Message-ID: <20180112141129.27507-9-chandan@linux.vnet.ibm.com>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934016AbeALOKx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Jan 2018 09:10:53 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0CEA7bD098969
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:53 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fexbd101x-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:52 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 12 Jan 2018 07:10:51 -0700
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we have all the code to support encryption for block size less
than page size scenario, this commit removes the conditional check in
filesystem mount code.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/super.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ebb7edb..5a52c98 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4138,14 +4138,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
-	if ((DUMMY_ENCRYPTION_ENABLED(sbi) || ext4_has_feature_encrypt(sb)) &&
-	    (blocksize != PAGE_SIZE)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Unsupported blocksize for fs encryption");
-		goto failed_mount_wq;
-	}
