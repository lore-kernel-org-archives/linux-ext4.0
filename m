Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554FFC433EF
	for <linux-ext4@archiver.kernel.org>; Sun,  5 Jun 2022 19:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351597AbiFETjV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 5 Jun 2022 15:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351592AbiFETjS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jun 2022 15:39:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4882C4D62C;
        Sun,  5 Jun 2022 12:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nZd7FdfhHHpfkPZj2gtn0+UCb6ZHZaprTIaRzyl1jXk=; b=uFlx6IYCw7cKUMv6UFQU0NiN2j
        iQ24sV1L+N0JJ+PYt+whKlcyMvxX397wDiXAeuW16ipXpv7uj75S+ifah7UED1rGBmJ6INgUn0EaP
        +9Vs3ySStr9qIgZ0zF6RDK7wq0A7Z8UrY0v2gbCiqtYZYhxFzeNL/2ggxHjmv6qm+147lvrX2dSYA
        KrGPUqo5c0kBsr1HE5k1I7rfjNq5kWWJNZbU41W0uuZJbmiuIPzLxEOUcBBG4y5IcjIH3D5ekaRwS
        R4P3XSnF1YkMw+gsOSK1a5dkmx/misM3DKGpZBhb7qWzj2lws1FAo2SU2BuaoFyWnchKohsh2xIzm
        dolxg0Dg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nxw5R-009wsf-8D; Sun, 05 Jun 2022 19:38:57 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        linux-nilfs@vger.kernel.org
Subject: [PATCH 09/10] shmem: Convert shmem_unlock_mapping() to use filemap_get_folios()
Date:   Sun,  5 Jun 2022 20:38:53 +0100
Message-Id: <20220605193854.2371230-10-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220605193854.2371230-1-willy@infradead.org>
References: <20220605193854.2371230-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is a straightforward conversion.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/shmem.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 60fdfc0208fd..313ae7df59d8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -867,18 +867,17 @@ unsigned long shmem_swap_usage(struct vm_area_struct *vma)
  */
 void shmem_unlock_mapping(struct address_space *mapping)
 {
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	pgoff_t index = 0;
 
-	pagevec_init(&pvec);
+	folio_batch_init(&fbatch);
 	/*
 	 * Minor point, but we might as well stop if someone else SHM_LOCKs it.
 	 */
-	while (!mapping_unevictable(mapping)) {
-		if (!pagevec_lookup(&pvec, mapping, &index))
-			break;
-		check_move_unevictable_pages(&pvec);
-		pagevec_release(&pvec);
+	while (!mapping_unevictable(mapping) &&
+	       filemap_get_folios(mapping, &index, ~0UL, &fbatch)) {
+		check_move_unevictable_folios(&fbatch);
+		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 }
-- 
2.35.1

