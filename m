Return-Path: <SRS0=X8xt=SS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80664C10F13
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 15:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 545272087C
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 15:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfDPPxS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 Apr 2019 11:53:18 -0400
Received: from relay.sw.ru ([185.231.240.75]:57612 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbfDPPxR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Apr 2019 11:53:17 -0400
Received: from [172.16.25.169] (helo=localhost.localdomain)
        by relay.sw.ru with esmtp (Exim 4.91)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1hGQOY-0001Si-3Z; Tue, 16 Apr 2019 18:53:14 +0300
Subject: [PATCH RFC] ext4: Actually request zeroing of inode table after grow
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca, ktkhai@virtuozzo.com,
        linux-ext4@vger.kernel.org
Date:   Tue, 16 Apr 2019 18:53:12 +0300
Message-ID: <155542964388.661.13244611252760297285.stgit@localhost.localdomain>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

[Hi!
 I occasionally found this place, and not familiar with ext4.
 But this place looks like doing the wrong thing.
 s_groups_count may only work, and there must be another sign.
 Please, take a look.
]

It is never possible, that number of block groups decreases,
since only online grow is supported.

But after a growing occured, we have to zero inode tables
for just created new block groups.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 fs/ext4/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bab3da4f1e0d..20faa6a69238 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -978,7 +978,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (err == 0)
 			err = err2;
 		mnt_drop_write_file(filp);
-		if (!err && (o_group > EXT4_SB(sb)->s_groups_count) &&
+		if (!err && (o_group < EXT4_SB(sb)->s_groups_count) &&
 		    ext4_has_group_desc_csum(sb) &&
 		    test_opt(sb, INIT_INODE_TABLE))
 			err = ext4_register_li_request(sb, o_group);

