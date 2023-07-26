Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBC3C0015E
	for <linux-ext4@archiver.kernel.org>; Wed, 26 Jul 2023 10:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjGZK2E (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 26 Jul 2023 06:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjGZK1Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jul 2023 06:27:24 -0400
X-Greylist: delayed 69 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Jul 2023 03:27:23 PDT
Received: from out-47.mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476A51FEC
        for <linux-ext4@vger.kernel.org>; Wed, 26 Jul 2023 03:27:22 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690367194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lwy1bya8EhY/7tZ1lMXE+4zXJK9aZUCgnxudXlZKm68=;
        b=ux551U6nhVvd09Fj1FVNymeGKcLT6zQsEBqhk225f+PUyMSHGeN5cY/do/fviplQGSDyEa
        wDLTA/5zkhT7BGUXE02iGDI3c9FhGSpI38RqZnn4nJtV4JEUJxp+DqWLdBDnHBPMLV6JSm
        NwF24t3Iddnn29aDeFdB1045RF83B/k=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 4/7] add llseek_nowait() for struct file_operations
Date:   Wed, 26 Jul 2023 18:26:00 +0800
Message-Id: <20230726102603.155522-5-hao.xu@linux.dev>
In-Reply-To: <20230726102603.155522-1-hao.xu@linux.dev>
References: <20230726102603.155522-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a new function member llseek_nowait() in struct file_operations for
nowait llseek. It act just like llseek() but has an extra boolean
parameter called nowait to indicate if it's a nowait try, avoid IO and
locks if so.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f3e315e8efdd..d37290da2d7e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1823,6 +1823,7 @@ struct file_operations {
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
+	loff_t (*llseek_nowait)(struct file *, loff_t, int, bool);
 } __randomize_layout;
 
 struct inode_operations {
-- 
2.25.1

