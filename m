Return-Path: <SRS0=b5V9=CC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C90AC433E3
	for <linux-ext4@archiver.kernel.org>; Mon, 24 Aug 2020 17:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 453A32074D
	for <linux-ext4@archiver.kernel.org>; Mon, 24 Aug 2020 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598288859;
	bh=VqZEGlV5YySvxvIOAiaROZF3nCTEX0kSUQga34yXjE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WblGew4txrULz7gSQUIxhE4DijaMzdeYJmSCq/BrqqY2R0nc796CLZc8MI9DrcpGq
	 p10zhGLxnR1inH1NhXUTH8UxXIUCDfVFE7wWTkX7xWpbqujt344AVPTYpymBtIDYsa
	 vHoy+h34Ch0nbwU7x9peZo8mSJBGNDWOuC+CQJQ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHXRHA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 24 Aug 2020 13:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728439AbgHXQi2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FC7E22DA9;
        Mon, 24 Aug 2020 16:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287078;
        bh=VqZEGlV5YySvxvIOAiaROZF3nCTEX0kSUQga34yXjE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5vyMOC/AlYn8D9BXuh1uhWDSW024SCosunIOQ0ycP3Aq0GU/GFmEVUBQLTIcQg7U
         GedzWFJSNJvDyWKEfygH8njqquMfTXxheOlV6O3FojBGXeZP1eRmKkMlDhjgDrg/yA
         5nNglODbQMBB+RYr8wkfrvRrKS1pEk5NcY3Z9hmU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/38] jbd2: abort journal if free a async write error metadata buffer
Date:   Mon, 24 Aug 2020 12:37:17 -0400
Message-Id: <20200824163751.606577-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163751.606577-1-sashal@kernel.org>
References: <20200824163751.606577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: "zhangyi (F)" <yi.zhang@huawei.com>

[ Upstream commit c044f3d8360d2ecf831ba2cc9f08cf9fb2c699fb ]

If we free a metadata buffer which has been failed to async write out
in the background, the jbd2 checkpoint procedure will not detect this
failure in jbd2_log_do_checkpoint(), so it may lead to filesystem
inconsistency after cleanup journal tail. This patch abort the journal
if free a buffer has write_io_error flag to prevent potential further
inconsistency.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20200620025427.1756360-5-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/transaction.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 0b663269771d4..90453309345d5 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2077,6 +2077,7 @@ int jbd2_journal_try_to_free_buffers(journal_t *journal,
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
+	bool has_write_io_error = false;
 	int ret = 0;
 
 	J_ASSERT(PageLocked(page));
@@ -2101,11 +2102,26 @@ int jbd2_journal_try_to_free_buffers(journal_t *journal,
 		jbd_unlock_bh_state(bh);
 		if (buffer_jbd(bh))
 			goto busy;
+
+		/*
+		 * If we free a metadata buffer which has been failed to
+		 * write out, the jbd2 checkpoint procedure will not detect
+		 * this failure and may lead to filesystem inconsistency
+		 * after cleanup journal tail.
+		 */
+		if (buffer_write_io_error(bh)) {
+			pr_err("JBD2: Error while async write back metadata bh %llu.",
+			       (unsigned long long)bh->b_blocknr);
+			has_write_io_error = true;
+		}
 	} while ((bh = bh->b_this_page) != head);
 
 	ret = try_to_free_buffers(page);
 
 busy:
+	if (has_write_io_error)
+		jbd2_journal_abort(journal, -EIO);
+
 	return ret;
 }
 
-- 
2.25.1

