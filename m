Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B1EC433F5
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Mar 2022 03:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbiCWDvF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Mar 2022 23:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiCWDvE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2022 23:51:04 -0400
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED02B2734;
        Tue, 22 Mar 2022 20:49:33 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 23 Mar
 2022 11:49:32 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Wed, 23 Mar
 2022 11:49:31 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>
CC:     <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
Subject: [PATCH] fs: ext4: Fix duplicate included linux/dax.h
Date:   Wed, 23 Mar 2022 11:49:30 +0800
Message-ID: <1648007370-31984-1-git-send-email-baihaowen@meizu.com>
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

fs/ext4/inode.c: linux/dax.h is included more than once.

No functional change.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 fs/ext4/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 01c9e4f..6738ea7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -41,7 +41,6 @@
 #include <linux/bitops.h>
 #include <linux/iomap.h>
 #include <linux/iversion.h>
-#include <linux/dax.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
-- 
2.7.4

