Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A09C4338F
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Aug 2021 09:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B794611B0
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Aug 2021 09:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbhHFJ6p (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:58:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229725AbhHFJ6o (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2021 05:58:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628243908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sb8h5uoCELs6vcLcpaMhZUmgx+JvOd9nGgs0hNSi1UI=;
        b=X7bYd0+eCLMuITi3uNVHtyQ2l7r5t3riu3TFEhlIh1K4IcTIJsF7GgHwjxKDiSsMLOeESy
        mm0fiDZ0uOZ4OWy6AaKEkAiAG/KTEehqFhaxnz1/8xcq/PZsf15Gtq3IphDAIEcNrP4XAs
        D8XBJ+GCTIrMBX2/8aLCsQNJIk4hWWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-eoIqYEoMP-GxyHVzKTlDkg-1; Fri, 06 Aug 2021 05:58:27 -0400
X-MC-Unique: eoIqYEoMP-GxyHVzKTlDkg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96C4B87D541;
        Fri,  6 Aug 2021 09:58:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDB356A057;
        Fri,  6 Aug 2021 09:58:25 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH 1/7] e2fsck: value stored to err is never read
Date:   Fri,  6 Aug 2021 11:58:14 +0200
Message-Id: <20210806095820.83731-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Remove it to silence clang warning.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/recovery.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 25744f08..48b5efd2 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -760,7 +760,6 @@ static int do_one_pass(journal_t *journal,
 				 */
 				jbd_debug(1, "JBD2: Invalid checksum ignored in transaction %u, likely stale data\n",
 					  next_commit_ID);
-				err = 0;
 				brelse(bh);
 				goto done;
 			}
-- 
2.31.1

