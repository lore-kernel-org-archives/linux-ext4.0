Return-Path: <SRS0=5lQ/=AD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C483C433DF
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Jun 2020 01:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 435AA215A4
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Jun 2020 01:25:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Es1T5Ito"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbgFVBZt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Jun 2020 21:25:49 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17134 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbgFVBZt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Jun 2020 21:25:49 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1592789142; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=nAgALmoUAJXr/CoFtaujNpAHMNvhaptM2+TPW0E79cRP6vyWilUu992sWWoB2Z+L1tLTSaBzzXPngheeN5jZt5zmV3zvL9n/RC5zhsrcRUlSf7av6fbJwcosbRmzzmkAP7MlEc0UE2YVTNPKnqmJ4exXWv+iZA/w7uPVjhDB7yU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1592789142; h=Cc:Date:From:Message-ID:Subject:To; 
        bh=b43/ZsLyB1cGwYIJQZDZaDv/9N8+3bn4PgmRq2R7HeA=; 
        b=W8nAjn01yV3HGqtADQnFJVaFPXkpsspZAdIMfdIb6sPn1hu1F8rIruS4/XN0DwSyZr8oQd2jBTeYSP7JK1lkHSBx28XX83cr3Y9SToy8U9OkLF09H6Y0Nnwl3WWms+2LAXjxEXRC3L2ax6kV0BLCn2OjjtTQqjTdZOSUDStNXWc=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1592789142;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=b43/ZsLyB1cGwYIJQZDZaDv/9N8+3bn4PgmRq2R7HeA=;
        b=Es1T5ItoHbgrcj9Ya3Qi3PprGY7Y0IVbM5ErX2Pfk66Wo7fDwNA28ymYgs4GI+Gp
        m6joG0Ldl+p0fVFejOKP7zfc6zTDm6u0YFzRrwFMAkXWhJFDd42iJZvT55hFCBCfLu0
        ziIsqzCFNBGQMj89KZgmRJsEdRZrbilSsRUKybWU=
Received: from localhost.localdomain (113.87.88.87 [113.87.88.87]) by mx.zoho.com.cn
        with SMTPS id 1592789140551601.152588810136; Mon, 22 Jun 2020 09:25:40 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     jack@suse.com
Cc:     linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Subject: [PATCH] ext2: delay discarding block reservation
Date:   Mon, 22 Jun 2020 09:25:26 +0800
Message-Id: <20200622012526.4688-1-cgxu519@mykernel.net>
X-Mailer: git-send-email 2.17.2
X-ZohoCNMailClient: External
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Currently block reservation will be discard when a write mode
file structure is released. It is not efficent for concurrent
writing, so change to discard block reservation when last writer
release file structure.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/ext2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 60378ddf1424..28eaf429138b 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -139,7 +139,7 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
  */
 static int ext2_release_file (struct inode * inode, struct file * filp)
 {
-	if (filp->f_mode & FMODE_WRITE) {
+	if ((filp->f_mode & FMODE_WRITE) && (atomic_read(&inode->i_writecount) == 1)) {
 		mutex_lock(&EXT2_I(inode)->truncate_mutex);
 		ext2_discard_reservation(inode);
 		mutex_unlock(&EXT2_I(inode)->truncate_mutex);
-- 
2.17.2

