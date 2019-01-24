Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6943C282C5
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 18:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B53A2082C
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 18:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="swbnd2nW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfAXSF2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:05:28 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36519 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbfAXSF1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2019 13:05:27 -0500
Received: by mail-wm1-f66.google.com with SMTP id p6so4063404wmc.1;
        Thu, 24 Jan 2019 10:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ST1S/wdYHVPR6YefIbuvcLdipaueWUym48k5N0UrsWQ=;
        b=swbnd2nWVO2FIn5tgjFrgWNn0rEzVhYj31REVIvV2CKRVCM+PTey3MGBhPUUsb89M1
         K/OcQ4ZfoVEksj/FersBlMr3DPImRJqLg5mrl+ZFOLXm2VfH7XVK/fTCKa2vUASb9jOn
         y9cx7R6RN0IluiUvyX01uqlsxiJMjlvzJ5Uma+Q/F1z6ViFqyemP4LmYKOoAOI400jwP
         /P4iyn/c5XGwfzrj0UMZwtSVl6V0UorbxgONTpH00KXartKPe82Z4Ld4tv7fJKeeNwA1
         mGC9kZfBl+4Z8OTR7V+dh1M9Pypf6rs7rLcBIO1VmKe0/O8Zm85PUlZc/gaew+X/X8WK
         1MmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ST1S/wdYHVPR6YefIbuvcLdipaueWUym48k5N0UrsWQ=;
        b=GbapFu+ORqHegumr4271+tiSbRUgh3gAICg0Vws8YKDPCC+1IVB1tO7ICw3rnmRkWN
         LjOi0ZqJSbdDdmmU+LhEgoX9Ft/PoNALzFX9OcoaleE49rsLTTHZ97O7CGpm6W6ACtEV
         jv+MI9H4Bks+yGQdpB0gB6NfEkUiBmoNGfgjZvAvnFMW6WTHb2psl5Q3t0nW9eB1MYji
         /JeLb8su7GmWIm0wp2FqIUGEKNtpzLaCtAox26IszkrmCpPqT2+7hUNbOonfzWj6B6K8
         vbhCFNd49LyLQhdulUU7qv2s+jPPl6N5CsyKp+Fuq365zTDRBFhem8nTnhZ7SPZ0LIk3
         yuTw==
X-Gm-Message-State: AJcUukfp6f2A7OoSR3V+syFvsSjj0ljp3/l2AQJWQTOXbThJiJpv7ZDx
        fnXy8CEnlo6lcuFwTZYdh/LLarLn
X-Google-Smtp-Source: ALg8bN6pnOUR39lOAR424gMsufuKLdj75Y104V937Wo9ER4FGO/zaBubnoH388wUktezdOsvqkXWNA==
X-Received: by 2002:a1c:5892:: with SMTP id m140mr3669308wmb.60.1548353125915;
        Thu, 24 Jan 2019 10:05:25 -0800 (PST)
Received: from macbookpro.malat.net ([2a01:e34:ee1e:860:6f23:82e6:aa2d:bbd1])
        by smtp.gmail.com with ESMTPSA id y145sm46067600wmd.30.2019.01.24.10.05.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 10:05:24 -0800 (PST)
Received: by macbookpro.malat.net (Postfix, from userid 1000)
        id 07FEC1143573; Thu, 24 Jan 2019 19:05:18 +0100 (CET)
From:   Mathieu Malaterre <malat@debian.org>
To:     Jan Kara <jack@suse.com>
Cc:     Mathieu Malaterre <malat@debian.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ext2: Annotate implicit fall through in __ext2_truncate_blocks
Date:   Thu, 24 Jan 2019 19:05:04 +0100
Message-Id: <20190124180504.19912-1-malat@debian.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

There is a plan to build the kernel with -Wimplicit-fallthrough and
these places in the code produced warnings (W=1).

This commit removes the following warnings:

  fs/ext2/inode.c:1237:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
  fs/ext2/inode.c:1244:7: warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Mathieu Malaterre <malat@debian.org>
---
 fs/ext2/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e4bb9386c045..e64029b1bd50 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1239,6 +1239,7 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 				mark_inode_dirty(inode);
 				ext2_free_branches(inode, &nr, &nr+1, 1);
 			}
+			/* fall through */
 		case EXT2_IND_BLOCK:
 			nr = i_data[EXT2_DIND_BLOCK];
 			if (nr) {
@@ -1246,6 +1247,7 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 				mark_inode_dirty(inode);
 				ext2_free_branches(inode, &nr, &nr+1, 2);
 			}
+			/* fall through */
 		case EXT2_DIND_BLOCK:
 			nr = i_data[EXT2_TIND_BLOCK];
 			if (nr) {
-- 
2.19.2

