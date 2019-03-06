Return-Path: <SRS0=J2/x=RJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763BBC10F00
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 11:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E76220675
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 11:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfCFLGq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Mar 2019 06:06:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729272AbfCFLGq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Mar 2019 06:06:46 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0233D87622;
        Wed,  6 Mar 2019 11:06:46 +0000 (UTC)
Received: from localhost.localdomain (ovpn-204-114.brq.redhat.com [10.40.204.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D60D619C6A;
        Wed,  6 Mar 2019 11:06:44 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     linux-ext4@vger.kernel.org
Cc:     Frank Sorenson <fsorenso@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ext4: Fix data corruption caused by unaligned direct AIO
Date:   Wed,  6 Mar 2019 12:06:42 +0100
Message-Id: <20190306110642.11804-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 06 Mar 2019 11:06:46 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Ext4 needs to serialize unaligned direct AIO because the zeroing of
partial blocks of two competing unaligned AIOs can result in data
corruption.

However it decides not to serialize if the potentially unaligned aio is
past i_size with the rationale that no pending writes are possible past
i_size. Unfortunately if the i_size is not block aligned and the second
unaligned write lands past i_size, but still into the same block, it has
the potential of corrupting the previous unaligned write to the same
block.

This is (very simplified) reproducer from Frank

    // 41472 = (10 * 4096) + 512
    // 37376 = 41472 - 4096

    ftruncate(fd, 41472);
    io_prep_pwrite(iocbs[0], fd, buf[0], 4096, 37376);
    io_prep_pwrite(iocbs[1], fd, buf[1], 4096, 41472);

    io_submit(io_ctx, 1, &iocbs[1]);
    io_submit(io_ctx, 1, &iocbs[2]);

    io_getevents(io_ctx, 2, 2, events, NULL);

Without this patch the 512B range from 40960 up to the start of the
second unaligned write (41472) is going to be zeroed overwriting the data
written by the first write. This is a data corruption.

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
*
00009200  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 30
*
0000a000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
*
0000a200  31 31 31 31 31 31 31 31  31 31 31 31 31 31 31 31

With this patch the data corruption is avoided because we will recognize
the unaligned_aio and wait for the unwritten extent conversion.

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
*
00009200  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 30
*
0000a200  31 31 31 31 31 31 31 31  31 31 31 31 31 31 31 31
*
0000b200

Reported-by: Frank Sorenson <fsorenso@redhat.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Fixes: e9e3bcecf44c ("ext4: serialize unaligned asynchronous DIO")
Cc: <stable@vger.kernel.org>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 69d65d49837b..98ec11f69cd4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -125,7 +125,7 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter *from, loff_t pos)
 	struct super_block *sb = inode->i_sb;
 	int blockmask = sb->s_blocksize - 1;
 
-	if (pos >= i_size_read(inode))
+	if (pos >= ALIGN(i_size_read(inode), sb->s_blocksize))
 		return 0;
 
 	if ((pos | iov_iter_alignment(from)) & blockmask)
-- 
2.20.1

