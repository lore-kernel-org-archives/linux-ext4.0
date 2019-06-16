Return-Path: <SRS0=VFkk=UP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8911CC31E50
	for <linux-ext4@archiver.kernel.org>; Sun, 16 Jun 2019 15:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63DA52064B
	for <linux-ext4@archiver.kernel.org>; Sun, 16 Jun 2019 15:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfFPPIR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 16 Jun 2019 11:08:17 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25451 "EHLO
        sender1.zoho.com.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725879AbfFPPIQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Jun 2019 11:08:16 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1560697690; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=dwYP+DCOLbLdGLQdcGzvXkM6HxK9jzIlcu6Udj7qcK0eFiwqODsk2b2CqaL4oevLPw+Sy8q95+5bVGeussAGxPHABBbsI005kBha4/6NQ94aFce9ZZvFxtx9fmD0sJVioTPDU6cx6qkG/ViwHdFra+BvxsLRnRFLb8Hjek3IyWw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1560697690; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=Wf53hg+okz/TcqIQqrT1mVPw9mXz0q2TDkW3doCD21s=; 
        b=blAsj0+YVicmkEh/605jELL4v8BMWnXPPtS3Yt5bPcL1hhkXhStK1pPrz8atPiToBOqODbwtnicf5X2zSbfwW7q9xUSpmIngduDqD5GpYgTHjRCZd9E/d3h9eXn8uimWa/1b+usk/EH9CXAo1As9m5AtWh9QCfdeF/2hxhWBGRY=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=zoho.com.cn;
        spf=pass  smtp.mailfrom=cgxu519@zoho.com.cn;
        dmarc=pass header.from=<cgxu519@zoho.com.cn> header.from=<cgxu519@zoho.com.cn>
Received: from localhost.localdomain.localdomain (113.116.51.202 [113.116.51.202]) by mx.zoho.com.cn
        with SMTPS id 1560697688293629.3553326145355; Sun, 16 Jun 2019 23:08:08 +0800 (CST)
From:   Chengguang Xu <cgxu519@zoho.com.cn>
To:     jack@suse.com
Cc:     linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@zoho.com.cn>
Message-ID: <20190616150801.2652-1-cgxu519@zoho.com.cn>
Subject: [PATCH] ext2: add missing brelse() in ext2_iget()
Date:   Sun, 16 Jun 2019 23:08:01 +0800
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Add missing brelse() on error path of ext2_iget().

Signed-off-by: Chengguang Xu <cgxu519@zoho.com.cn>
---
 fs/ext2/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e474127dd255..fb3611f02051 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1473,6 +1473,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 	else
 		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
 	if (i_size_read(inode) < 0) {
+		brelse(bh);
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
-- 
2.21.0



