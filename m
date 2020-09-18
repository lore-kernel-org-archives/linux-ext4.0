Return-Path: <SRS0=ab0F=C3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6C2C43463
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Sep 2020 02:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E38723444
	for <linux-ext4@archiver.kernel.org>; Fri, 18 Sep 2020 02:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgIRCst (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:48:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13285 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728254AbgIRCse (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Sep 2020 22:48:34 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2378F5ABF8437A190EE7;
        Fri, 18 Sep 2020 10:48:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 10:48:30 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>
Subject: [PATCH] ext4: Remove unused including <linux/version.h>
Date:   Fri, 18 Sep 2020 10:46:05 +0800
Message-ID: <1600397165-42873-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 fs/ext4/ext4.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 523e00d..ac63456 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -27,7 +27,6 @@
 #include <linux/seqlock.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
 #include <linux/blockgroup_lock.h>
-- 
2.7.4

