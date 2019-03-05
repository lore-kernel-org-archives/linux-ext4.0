Return-Path: <SRS0=D5Fw=RI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A379C43381
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 10:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57BC9206DD
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 10:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfCEKyD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Mar 2019 05:54:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfCEKyD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Mar 2019 05:54:03 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 827BF5946D
        for <linux-ext4@vger.kernel.org>; Tue,  5 Mar 2019 10:54:03 +0000 (UTC)
Received: from localhost.localdomain (ovpn-204-114.brq.redhat.com [10.40.204.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCFFB1001DDD
        for <linux-ext4@vger.kernel.org>; Tue,  5 Mar 2019 10:54:02 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH v2 1/2] ext4: Add missing brelse() in add_new_gdb_meta_bg()
Date:   Tue,  5 Mar 2019 11:53:59 +0100
Message-Id: <20190305105400.4960-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 05 Mar 2019 10:54:03 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Currently in add_new_gdb_meta_bg() there is a missing brelse of gdb_bh
in case ext4_journal_get_write_access() fails.
Additionally kvfree() is missing in the same error path. Fix it by
moving the ext4_journal_get_write_access() before the ext4 sb update as
Ted suggested and release n_group_desc and gdb_bh in case it fails.

Fixes: 61a9c11e5e7a ("ext4: add missing brelse() add_new_gdb_meta_bg()'s error path")
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Mofe ext4_journal_get_write_access() before we update ext4 sb

 fs/ext4/resize.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 48421de803b7..5f89c19043a2 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -932,11 +932,18 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
 	n_group_desc[gdb_num] = gdb_bh;
+
+	BUFFER_TRACE(gdb_bh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, gdb_bh);
+	if (err) {
+		kvfree(n_group_desc);
+		brelse(gdb_bh);
+		return err;
+	}
+
 	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
 	kvfree(o_group_desc);
-	BUFFER_TRACE(gdb_bh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, gdb_bh);
 	return err;
 }
 
-- 
2.20.1

