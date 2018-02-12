From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH V2 01/11] ext4: Clear BH_Uptodate flag on decryption error
Date: Mon, 12 Feb 2018 15:13:37 +0530
Message-ID: <20180212094347.22071-2-chandan@linux.vnet.ibm.com>
References: <20180212094347.22071-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, ebiggers3@gmail.com,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753950AbeBLJmd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Feb 2018 04:42:33 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1C9clvg037657
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 04:42:32 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2g3552qfa7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 04:42:31 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 12 Feb 2018 02:42:31 -0700
In-Reply-To: <20180212094347.22071-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On an error return from fscrypt_decrypt_page(), ext4_block_write_begin()
can return with the page's buffer_head marked with BH_Uptodate
flag. This commit clears the BH_Uptodate flag in such cases.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6f6589e..e8ecf67 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1231,9 +1231,13 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 	}
 	if (unlikely(err))
 		page_zero_new_buffers(page, from, to);
-	else if (decrypt)
+	else if (decrypt) {
 		err = fscrypt_decrypt_page(page->mapping->host, page,
 				PAGE_SIZE, 0, page->index);
+		if (err)
+			clear_buffer_uptodate(*wait_bh);
+	}
+
 	return err;
 }
 #endif
-- 
2.9.5
