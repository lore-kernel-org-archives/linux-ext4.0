Return-Path: <SRS0=QItb=SB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493B6C10F05
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 00:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07826206DD
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 00:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553907281;
	bh=cRkDvbkGVjYnAxmFphy6GMC2+BOMm5V6n+aNWwX+i6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=acuyJU/T4579wVee5A4oLpT9LXfXxyFOkdcEoqYXfcBdT16IQ94eLzKNWTXoJojrm
	 N7XpQTJ/uUSVsTTfaxdYCH9pP/HP41gh2z7dXgvtT++bQTERCSo8Jk4+9BcpN/71Ie
	 pLcDuURaGEV0RHFvr6hlU+5vlcPtIMwRRRxlxuto=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731568AbfC3Ayk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 20:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730667AbfC3Ayj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Mar 2019 20:54:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1031218D3;
        Sat, 30 Mar 2019 00:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553907278;
        bh=cRkDvbkGVjYnAxmFphy6GMC2+BOMm5V6n+aNWwX+i6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSIG1gii2TUfnUHEuSkVtImHP2grqUg/OEZVubk/UYtBL7sqP97SsuY0j9Xs/eEnI
         Xkm+baXeXahjoD4Dlndqg+2H1WIHqx3Gocx8DtshD7Zogx10fEaqfOWNa1qRqIkc2t
         xET8d7LuZ62CwWujfxmg7GIW92mqpOHdzQA9d8qc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 52/52] ext4: prohibit fstrim in norecovery mode
Date:   Fri, 29 Mar 2019 20:52:59 -0400
Message-Id: <20190330005301.26868-52-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330005301.26868-1-sashal@kernel.org>
References: <20190330005301.26868-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 18915b5873f07e5030e6fb108a050fa7c71c59fb ]

The ext4 fstrim implementation uses the block bitmaps to find free space
that can be discarded.  If we haven't replayed the journal, the bitmaps
will be stale and we absolutely *cannot* use stale metadata to zap the
underlying storage.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 2e76fb55d94a..5f24fdc140ad 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -999,6 +999,13 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!blk_queue_discard(q))
 			return -EOPNOTSUPP;
 
+		/*
+		 * We haven't replayed the journal, so we cannot use our
+		 * block-bitmap-guided storage zapping commands.
+		 */
+		if (test_opt(sb, NOLOAD) && ext4_has_feature_journal(sb))
+			return -EROFS;
+
 		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
 		    sizeof(range)))
 			return -EFAULT;
-- 
2.19.1

