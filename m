Return-Path: <SRS0=wvBl=EF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546A5C4741F
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Oct 2020 02:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD9E720756
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Oct 2020 02:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJ3CY7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 29 Oct 2020 22:24:59 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7101 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3CY7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2020 22:24:59 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CMmNp1RF9zLqQR;
        Fri, 30 Oct 2020 10:24:58 +0800 (CST)
Received: from szvp000203569.huawei.com (10.120.216.130) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 30 Oct 2020 10:24:48 +0800
From:   Chao Yu <yuchao0@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH] MAINTAINERS: add missing file in ext4 entry
Date:   Fri, 30 Oct 2020 10:24:35 +0800
Message-ID: <20201030022435.1136-1-yuchao0@huawei.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.120.216.130]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

include/trace/events/ext4.h belongs to ext4 module, add the file path into
ext4 entry in MAINTAINERS.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e73636b75f29..d1d4e49a695a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6618,6 +6618,7 @@ Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 F:	Documentation/filesystems/ext4/
 F:	fs/ext4/
+F:	include/trace/events/ext4.h
 
 Extended Verification Module (EVM)
 M:	Mimi Zohar <zohar@linux.ibm.com>
-- 
2.26.2

