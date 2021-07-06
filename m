Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94C6C07E9C
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Jul 2021 02:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CABF56197F
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Jul 2021 02:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhGFCgZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Jul 2021 22:36:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13081 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhGFCgY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jul 2021 22:36:24 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GJmkK6V7ZzZnFJ;
        Tue,  6 Jul 2021 10:30:33 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeme752-chm.china.huawei.com
 (10.3.19.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 6 Jul
 2021 10:33:44 +0800
From:   Zhang Yi <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <yi.zhang@huawei.com>, <yukuai3@huawei.com>
Subject: [RFC PATCH 1/4] ext4: check and update i_disksize properly
Date:   Tue, 6 Jul 2021 10:42:07 +0800
Message-ID: <20210706024210.746788-2-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210706024210.746788-1-yi.zhang@huawei.com>
References: <20210706024210.746788-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme752-chm.china.huawei.com (10.3.19.98)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

After commit 3da40c7b0898 ("ext4: only call ext4_truncate when size <=
isize"), i_disksize could always be updated to i_size in ext4_setattr(),
and it seems that there is no other way that could appear
i_disksize < i_size besides the delalloc write. In the case of delay
alloc write, ext4_writepages() could update i_disksize for the new delay
allocated blocks properly. So we could switch to check i_size instead
of i_disksize in ext4_da_write_end() when write to the end of the file.
we also could remove ext4_mark_inode_dirty() together because
generic_write_end() will dirty the inode.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d8de607849df..6f6a61f3ae5f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3087,32 +3087,27 @@ static int ext4_da_write_end(struct file *file,
 	 * generic_write_end() will run mark_inode_dirty() if i_size
 	 * changes.  So let's piggyback the i_disksize mark_inode_dirty
 	 * into that.
+	 *
+	 * Check i_size not i_disksize here because ext4_writepages() could
+	 * update i_disksize from i_size for delay allocated blocks properly.
 	 */
 	new_i_size = pos + copied;
-	if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
+	if (copied && new_i_size > inode->i_size) {
 		if (ext4_has_inline_data(inode) ||
-		    ext4_da_should_update_i_disksize(page, end)) {
+		    ext4_da_should_update_i_disksize(page, end))
 			ext4_update_i_disksize(inode, new_i_size);
-			/* We need to mark inode dirty even if
-			 * new_i_size is less that inode->i_size
-			 * bu greater than i_disksize.(hint delalloc)
-			 */
-			ret = ext4_mark_inode_dirty(handle, inode);
-		}
 	}
 
 	if (write_mode != CONVERT_INLINE_DATA &&
 	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
 	    ext4_has_inline_data(inode))
-		ret2 = ext4_da_write_inline_data_end(inode, pos, len, copied,
+		ret = ext4_da_write_inline_data_end(inode, pos, len, copied,
 						     page);
 	else
-		ret2 = generic_write_end(file, mapping, pos, len, copied,
+		ret = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 
-	copied = ret2;
-	if (ret2 < 0)
-		ret = ret2;
+	copied = ret;
 	ret2 = ext4_journal_stop(handle);
 	if (unlikely(ret2 && !ret))
 		ret = ret2;
-- 
2.31.1

