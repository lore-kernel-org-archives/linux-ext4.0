Return-Path: <SRS0=5xRJ=B5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18622C433E3
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Aug 2020 02:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02C9D2076E
	for <linux-ext4@archiver.kernel.org>; Wed, 19 Aug 2020 02:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgHSC4u (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 18 Aug 2020 22:56:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59310 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727048AbgHSC4t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Aug 2020 22:56:49 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 26DE9B1664F72363B505;
        Wed, 19 Aug 2020 10:56:46 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 10:56:42 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] ext2: remove duplicate include
Date:   Wed, 19 Aug 2020 10:54:34 +0800
Message-ID: <20200819025434.65763-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Remove linux/fiemap.h which is included more than once

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 fs/ext2/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 80662e1f7889..de6b97612410 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -36,7 +36,6 @@
 #include <linux/iomap.h>
 #include <linux/namei.h>
 #include <linux/uio.h>
-#include <linux/fiemap.h>
 #include "ext2.h"
 #include "acl.h"
 #include "xattr.h"
-- 
2.17.1

