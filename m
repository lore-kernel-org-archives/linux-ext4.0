Return-Path: <SRS0=w/cN=SC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0626DC43381
	for <linux-ext4@archiver.kernel.org>; Sun, 31 Mar 2019 08:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBCD12146F
	for <linux-ext4@archiver.kernel.org>; Sun, 31 Mar 2019 08:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfCaILu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 31 Mar 2019 04:11:50 -0400
Received: from smtprz14.163.net ([106.3.154.247]:34635 "EHLO smtp.tom.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbfCaILu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 31 Mar 2019 04:11:50 -0400
Received: from 172.25.16.147 (unknown [172.25.16.147])
        by freemail02.tom.com (Postfix) with ESMTP id D54FEB0152F
        for <linux-ext4@vger.kernel.org>; Sun, 31 Mar 2019 16:11:46 +0800 (CST)
Received: from 172.25.16.91 (HELO smtp.tom.com) ([172.25.16.91])
          by localhost (TOM SMTP Server) with SMTP ID -1738974630
          for <linux-ext4@vger.kernel.org>;
          Sun, 31 Mar 2019 16:11:46 +0800 (CST)
Received: from antispam2.tom.com (unknown [172.25.16.56])
        by freemail02.tom.com (Postfix) with ESMTP id 58D8FB0150A
        for <linux-ext4@vger.kernel.org>; Sun, 31 Mar 2019 16:11:46 +0800 (CST)
Received: from antispam2.tom.com (antispam2.tom.com [127.0.0.1])
        by antispam2.tom.com (Postfix) with ESMTP id 4EAB681774
        for <linux-ext4@vger.kernel.org>; Sun, 31 Mar 2019 16:11:46 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at antispam2.tom.com
Received: from antispam2.tom.com ([127.0.0.1])
        by antispam2.tom.com (antispam2.tom.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uI6kK9q-6lYz for <linux-ext4@vger.kernel.org>;
        Sun, 31 Mar 2019 16:11:45 +0800 (CST)
Received: from localhost (unknown [222.209.17.169])
        by antispam2.tom.com (Postfix) with ESMTPA id 084CA81518;
        Sun, 31 Mar 2019 16:11:44 +0800 (CST)
From:   Liu Xiang <liu.xiang6@zte.com.cn>
To:     linux-ext4@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, liuxiang_1999@126.com,
        Liu Xiang <liu.xiang6@zte.com.cn>
Subject: [PATCH v2] ext4: fix prefetchw of NULL page
Date:   Sun, 31 Mar 2019 16:11:34 +0800
Message-Id: <1554019894-11041-1-git-send-email-liu.xiang6@zte.com.cn>
X-Mailer: git-send-email 1.9.1
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In ext4_mpage_readpages(), if the parameter pages is not NULL, another
parameter page is NULL. At the first time prefetchw(&page->flags)
works on NULL. From second time, prefetchw(&page->flags) always works on
the last consumed page. This might do little improvment for handling
current page. So prefetchw() should be called while the page pointer
has just been updated.

Signed-off-by: Liu Xiang <liu.xiang6@zte.com.cn>
---

Changes in v2:
 remove prefetchw() when pages is NULL and change comment

 fs/ext4/readpage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 6aa282e..f138c47 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -126,9 +126,10 @@ int ext4_mpage_readpages(struct address_space *mapping,
 		int fully_mapped = 1;
 		unsigned first_hole = blocks_per_page;
 
-		prefetchw(&page->flags);
 		if (pages) {
 			page = lru_to_page(pages);
+
+			prefetchw(&page->flags);
 			list_del(&page->lru);
 			if (add_to_page_cache_lru(page, mapping, page->index,
 				  readahead_gfp_mask(mapping)))
-- 
1.9.1

