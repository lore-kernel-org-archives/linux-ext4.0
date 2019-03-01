Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6583C43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 17:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB9220850
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 17:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732514AbfCARQi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:16:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbfCARQi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 1 Mar 2019 12:16:38 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC42630B7DD2
        for <linux-ext4@vger.kernel.org>; Fri,  1 Mar 2019 17:15:07 +0000 (UTC)
Received: from localhost.localdomain (ovpn-204-79.brq.redhat.com [10.40.204.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E95E05D964
        for <linux-ext4@vger.kernel.org>; Fri,  1 Mar 2019 17:15:06 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH] ext4: Add missing brelse() in add_new_gdb_meta_bg()
Date:   Fri,  1 Mar 2019 18:15:04 +0100
Message-Id: <20190301171504.8583-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 01 Mar 2019 17:15:07 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Currently in add_new_gdb_meta_bg() there is a missing brelse of gdb_bh
in case ext4_journal_get_write_access() fails. Fix it.

Fixes: 61a9c11e5e7a ("ext4: add missing brelse() add_new_gdb_meta_bg()'s error path")
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/resize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 48421de803b7..e945f412cf58 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -937,6 +937,8 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 	kvfree(o_group_desc);
 	BUFFER_TRACE(gdb_bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, gdb_bh);
+	if (err)
+		brelse(gdb_bh);
 	return err;
 }
 
-- 
2.20.1

