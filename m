Return-Path: <SRS0=D5Fw=RI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36140C00319
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 10:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0687A206DD
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Mar 2019 10:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbfCEKyE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Mar 2019 05:54:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfCEKyE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Mar 2019 05:54:04 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A01D681F19
        for <linux-ext4@vger.kernel.org>; Tue,  5 Mar 2019 10:54:04 +0000 (UTC)
Received: from localhost.localdomain (ovpn-204-114.brq.redhat.com [10.40.204.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E72F91001DDD
        for <linux-ext4@vger.kernel.org>; Tue,  5 Mar 2019 10:54:03 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH v2 2/2] ext4: Report real fs size after failed resize
Date:   Tue,  5 Mar 2019 11:54:00 +0100
Message-Id: <20190305105400.4960-2-lczerner@redhat.com>
In-Reply-To: <20190305105400.4960-1-lczerner@redhat.com>
References: <20190305105400.4960-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 05 Mar 2019 10:54:04 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Currently when the file system resize using ext4_resize_fs() fails it
will report into log that "resized filesystem to <requested block
count>". However this may not be true in the case of failure. Use the
current block count as returned by ext4_blocks_count() to report the
block count.
Additionally report to log that "error occurred during file system
resize"

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: this is actually the first version

 fs/ext4/resize.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5f89c19043a2..939e91a8c88b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -2079,6 +2079,9 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 		free_flex_gd(flex_gd);
 	if (resize_inode != NULL)
 		iput(resize_inode);
-	ext4_msg(sb, KERN_INFO, "resized filesystem to %llu", n_blocks_count);
+	if (err)
+		ext4_warning(sb, "error occurred during file system resize");
+	ext4_msg(sb, KERN_INFO, "resized filesystem to %llu",
+		 ext4_blocks_count(es));
 	return err;
 }
-- 
2.20.1

