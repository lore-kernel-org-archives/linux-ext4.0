Return-Path: <SRS0=C5hz=UQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CAAC31E5B
	for <linux-ext4@archiver.kernel.org>; Mon, 17 Jun 2019 15:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2493208C4
	for <linux-ext4@archiver.kernel.org>; Mon, 17 Jun 2019 15:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pvyBh4Sz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfFQP6t (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 17 Jun 2019 11:58:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46690 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFQP6t (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Jun 2019 11:58:49 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so5909246pfy.13;
        Mon, 17 Jun 2019 08:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FyT2hle+5zaHBEVSoRC6acFHWsLzRH0TJvSPYgTWFao=;
        b=pvyBh4Sz2/AJZXhJ3CCiXotUVKPS8dcMHrE0gQ4IDI/ifwWlmMZOxW/Ne+B9z0ozh3
         asFMJRbUEWCKwi4iHHGR+hlgHrUFNOKFF6nkzGa7ofO4IsFBhjboFJa74EtrN24o9MUF
         ZEEsnXeqTZeJGPkSUZi0tAl/wRp65+npgvVYYefevI87c5idmsRuFNUOvhw9p2yaAlsM
         yh259GuzUzFCcBsi+6LRIDHrVnlDVQzKvogGOG5URGX9VJNhxwCg+/NkdNCmgCAqVa6w
         dhp1YI4Ja/NVVKqm74oIt1QuztqxrxXAgVv4ewpPmjgFUnwOrsDowq8EwPl3x9JyQWT9
         Sjjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FyT2hle+5zaHBEVSoRC6acFHWsLzRH0TJvSPYgTWFao=;
        b=XZ7UfUPm1e171BmtuN1j05FJVGAotkS1iRnaGhmUAqsmfGAkyljul4aYbzok7p5Wkd
         YO6KlSCT/vE+vRldn8I56ryllXj2H89YI9k8AMAQGORcgixzS14EYD1t9d1VFvM6pldN
         Fy7AII4tONomjPpn63XJeClQr82fIRsxpMYNNPaHIP1vWE3nV5s1mBhv1tD/PCsGew/x
         hUFB/DiIZK4dz5jiukllrdxoiAzAXNU/p5y4tqFcI7NEjUNKj2aN74GfJ8weEuVCjt/n
         rtz0/CzclpFc8pNfne26iVRNxUAynIZaiAN+GNVD7B6aO4nK/EC2R0uHkmariFKJ8y2a
         lkig==
X-Gm-Message-State: APjAAAU72H0rokT6rq/68LgUK5pLzB2LNNXnUMXS8smiJMYpR719exC3
        VOdbhsY7NOVcLBfysiKi8n8qj2Za6fRIJg==
X-Google-Smtp-Source: APXvYqxU0/xV0wJA8CuNsgKOKO7/RqC/3HcyD0xgWeqVYVwB83dsZDbQFcBH0QiHXEZ67kY5NShx8g==
X-Received: by 2002:a63:4f5b:: with SMTP id p27mr41233356pgl.273.1560787128479;
        Mon, 17 Jun 2019 08:58:48 -0700 (PDT)
Received: from localhost.localdomain ([65.153.196.167])
        by smtp.gmail.com with ESMTPSA id n1sm10948734pgv.15.2019.06.17.08.58.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 08:58:48 -0700 (PDT)
From:   jinshui zhang <leozhangjs@gmail.com>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangjs <zachary@baishancloud.com>
Subject: [PATCH] ext4: make __ext4_get_inode_loc plug
Date:   Mon, 17 Jun 2019 23:57:12 +0800
Message-Id: <20190617155712.51339-1-leozhangjs@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: zhangjs <zachary@baishancloud.com>

If the task is unplugged when called, the inode_readahead_blks may not be merged, 
these will cause small pieces of io, It should be plugged.

Signed-off-by: zhangjs <zachary@baishancloud.com>
---
 fs/ext4/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c7f77c6..8fe046b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4570,6 +4570,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	struct buffer_head	*bh;
 	struct super_block	*sb = inode->i_sb;
 	ext4_fsblk_t		block;
+	struct blk_plug		plug;
 	int			inodes_per_block, inode_offset;
 
 	iloc->bh = NULL;
@@ -4654,6 +4655,8 @@ static int __ext4_get_inode_loc(struct inode *inode,
 		}
 
 make_io:
+		blk_start_plug(&plug);
+
 		/*
 		 * If we need to do any I/O, try to pre-readahead extra
 		 * blocks from the inode table.
@@ -4688,6 +4691,9 @@ static int __ext4_get_inode_loc(struct inode *inode,
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
 		submit_bh(REQ_OP_READ, REQ_META | REQ_PRIO, bh);
+
+		blk_finish_plug(&plug);
+
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh)) {
 			EXT4_ERROR_INODE_BLOCK(inode, block,
-- 
1.8.3.1

