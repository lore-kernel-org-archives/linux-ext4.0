From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH V2 06/11] ext4: Decrypt the block that needs to be partially zeroed
Date: Mon, 12 Feb 2018 15:13:42 +0530
Message-ID: <20180212094347.22071-7-chandan@linux.vnet.ibm.com>
References: <20180212094347.22071-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, ebiggers3@gmail.com,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53506 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753976AbeBLJmu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Feb 2018 04:42:50 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1C9cq5k116333
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 04:42:49 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2g30eyytpv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 04:42:49 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 12 Feb 2018 02:42:48 -0700
In-Reply-To: <20180212094347.22071-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

__ext4_block_zero_page_range decrypts the entire page. This commit
changes the code to decrypt the block that needs to be partially zeroed
instead of the whole page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/ext4/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 180dd2d..aac0e04 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4034,9 +4034,10 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		    ext4_encrypted_inode(inode)) {
 			/* We expect the key to be set. */
 			BUG_ON(!fscrypt_has_encryption_key(inode));
-			BUG_ON(blocksize != PAGE_SIZE);
 			WARN_ON_ONCE(fscrypt_decrypt_block(page->mapping->host,
-						page, PAGE_SIZE, 0, page->index));
+						page, blocksize,
+						round_down(offset, blocksize),
+						iblock));
 		}
 	}
 	if (ext4_should_journal_data(inode)) {
-- 
2.9.5
