Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7D8C433EF
	for <linux-ext4@archiver.kernel.org>; Mon, 30 May 2022 10:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiE3KD6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 May 2022 06:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbiE3KD5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 May 2022 06:03:57 -0400
X-Greylist: delayed 182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 May 2022 03:03:53 PDT
Received: from cmccmta1.chinamobile.com (cmccmta1.chinamobile.com [221.176.66.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58500CE18;
        Mon, 30 May 2022 03:03:51 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.93])
        by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee4629495cf2d1-67f92;
        Mon, 30 May 2022 18:00:48 +0800 (CST)
X-RM-TRANSID: 2ee4629495cf2d1-67f92
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.97])
        by rmsmtp-syy-appsvrnew07-12032 (RichMail) with SMTP id 2f00629495cec5c-7fecb;
        Mon, 30 May 2022 18:00:48 +0800 (CST)
X-RM-TRANSID: 2f00629495cec5c-7fecb
From:   Ding Xiang <dingxiang@cmss.chinamobile.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: change variable "count" to signed integer
Date:   Mon, 30 May 2022 18:00:47 +0800
Message-Id: <20220530100047.537598-1-dingxiang@cmss.chinamobile.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Since dx_make_map() may return -EFSCORRUPTED now,
so change "count" to signed integer.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 fs/ext4/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 47d0ca4c795b..db4ba99d1ceb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1929,7 +1929,8 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
-	unsigned count, continued;
+	unsigned continued;
+	int count;
 	struct buffer_head *bh2;
 	ext4_lblk_t newblock;
 	u32 hash2;
-- 
2.31.1



