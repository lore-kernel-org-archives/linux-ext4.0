Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F34C282C6
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 12:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1AE82085B
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 12:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfAYM1W (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:27:22 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:36096 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727145AbfAYM1V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 25 Jan 2019 07:27:21 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C8CDF59771A5C5A8EEE6;
        Fri, 25 Jan 2019 20:27:19 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.408.0; Fri, 25 Jan 2019
 20:27:11 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <jack@suse.cz>, <adilger.kernel@dilger.ca>,
        <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: [PATCH v3 4/4] ext4: convert ext4_split_extent() to return requested length
Date:   Fri, 25 Jan 2019 20:30:56 +0800
Message-ID: <1548419456-4331-5-git-send-email-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
References: <1548419456-4331-1-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

After we remove clean_bdev_aliases() calls which used to unmap extra
blocks in ext4_ext_handle_unwritten_extents(), return extra initialized
region in ext4_ext_convert_to_initialized() is no longer needed, so
in order to simplify logic, this patch convert to return the requested
size instead.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/extents.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ffb72d8..ffe9671 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3456,9 +3456,8 @@ static int ext4_split_extent(handle_t *handle,
  *    of the logical span [map->m_lblk, map->m_lblk + map->m_len).
  *
  * Post-conditions on success:
- *  - the returned value is the number of blocks beyond map->l_lblk
- *    that are allocated and initialized.
- *    It is guaranteed to be >= map->m_len.
+ *  - The returned value is the minimum number of requested blocks or
+ *    initialized blocks. It is guaranteed to be <= map->m_len.
  */
 static int ext4_ext_convert_to_initialized(handle_t *handle,
 					   struct inode *inode,
@@ -3700,7 +3699,6 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 
 			split_map.m_len += split_map.m_lblk - ee_block;
 			split_map.m_lblk = ee_block;
-			allocated = map->m_len;
 		}
 	}
 
@@ -3709,6 +3707,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	if (err > 0)
 		err = 0;
 out:
+	if (allocated > map->m_len)
+		allocated = map->m_len;
+
 	/* If we have gotten a failure, don't zero out status tree */
 	if (!err) {
 		err = ext4_zeroout_es(inode, &zero_ex1);
@@ -4065,11 +4066,10 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	if (ret <= 0) {
 		err = ret;
 		goto out2;
-	} else
-		allocated = ret;
+	}
+
+	allocated = ret;
 	map->m_flags |= EXT4_MAP_NEW;
-	if (allocated > map->m_len)
-		allocated = map->m_len;
 	map->m_len = allocated;
 
 map_out:
-- 
2.7.4

