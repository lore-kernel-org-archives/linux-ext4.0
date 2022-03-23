Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D09FC433EF
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Mar 2022 04:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbiCWEDi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Mar 2022 00:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCWEDh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2022 00:03:37 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70CF4AE27;
        Tue, 22 Mar 2022 21:02:06 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 23 Mar
 2022 12:02:08 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Wed, 23 Mar
 2022 12:02:04 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <jack@suse.com>
CC:     <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
Subject: [PATCH] fs: ext2: Fix duplicate included linux/dax.h
Date:   Wed, 23 Mar 2022 12:02:03 +0800
Message-ID: <1648008123-32485-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Clean up the following includecheck warning:

fs/ext2/inode.c: linux/dax.h is included more than once.

No functional change.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 fs/ext2/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 602578b..da4c301 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -36,7 +36,6 @@
 #include <linux/iomap.h>
 #include <linux/namei.h>
 #include <linux/uio.h>
-#include <linux/dax.h>
 #include "ext2.h"
 #include "acl.h"
 #include "xattr.h"
-- 
2.7.4

