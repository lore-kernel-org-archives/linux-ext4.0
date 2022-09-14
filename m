Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41009ECAAD3
	for <linux-ext4@archiver.kernel.org>; Wed, 14 Sep 2022 09:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiINJ60 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 14 Sep 2022 05:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiINJ6U (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2022 05:58:20 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D6C4D162;
        Wed, 14 Sep 2022 02:58:02 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSFzH2Zhmz14QR2;
        Wed, 14 Sep 2022 17:54:03 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 17:58:00 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>
Subject: [PATCH -next] ext4: fix miss release buffer head in ext4_fc_write_inode
Date:   Wed, 14 Sep 2022 18:08:59 +0800
Message-ID: <20220914100859.1415196-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In 'ext4_fc_write_inode' function first call 'ext4_get_inode_loc' get 'iloc',
after use it miss release 'iloc.bh'.
So just release 'iloc.bh' before 'ext4_fc_write_inode' return.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/ext4/fast_commit.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 2af962cbb835..b7414a5812f6 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -874,22 +874,25 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_INODE);
 	tl.fc_len = cpu_to_le16(inode_len + sizeof(fc_inode.fc_ino));
 
+	ret = -ECANCELED;
 	dst = ext4_fc_reserve_space(inode->i_sb,
 			sizeof(tl) + inode_len + sizeof(fc_inode.fc_ino), crc);
 	if (!dst)
-		return -ECANCELED;
+		goto err;
 
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, sizeof(tl), crc))
-		return -ECANCELED;
+		goto err;
 	dst += sizeof(tl);
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &fc_inode, sizeof(fc_inode), crc))
-		return -ECANCELED;
+		goto err;
 	dst += sizeof(fc_inode);
 	if (!ext4_fc_memcpy(inode->i_sb, dst, (u8 *)ext4_raw_inode(&iloc),
 					inode_len, crc))
-		return -ECANCELED;
-
-	return 0;
+		goto err;
+	ret = 0;
+err:
+	brelse(iloc.bh);
+	return ret;
 }
 
 /*
-- 
2.31.1

