Return-Path: <SRS0=E9RY=4C=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14092C2BA83
	for <linux-ext4@archiver.kernel.org>; Fri, 14 Feb 2020 16:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3B0824696
	for <linux-ext4@archiver.kernel.org>; Fri, 14 Feb 2020 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581697312;
	bh=ocdjRBdF3SWbCeWgrak9y4X6hDQvhe0i5iBNvmefeNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z0Em/sBDMb9TzEbRLiU24+uerm7pYCeQredfK/M/EuFny1CyPhFF7XEtvW8zdYRah
	 Aqb4v8x4KBhJwl1juPCb37StVit9lNa+uAfdUwvRiPS2cOX3Ry77jhfCnPre18kRfT
	 rV4RAw/gfM7YSoLSK4E/iPtr3Ov+uNKfElv/SxF8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393112AbgBNQVw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393100AbgBNQVv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 14 Feb 2020 11:21:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01C96246AC;
        Fri, 14 Feb 2020 16:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697310;
        bh=ocdjRBdF3SWbCeWgrak9y4X6hDQvhe0i5iBNvmefeNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMUC7m/DihzXHniIG7eJSj78Pwp7HgYrAw33KKRUWrxb1W5Pomi+DbKiVtiIpD0YF
         8OyI6JcIyWvMkuZyBvFnczuOJCntWCIz37XWz/z1U1vy3qZuMQ9050Rg/9CaBTmsXm
         y12rQdhPprINA36KQOI8FBCZJIO4uCQ2dBZ7Q1Yk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Li <li.kai4@h3c.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 022/141] jbd2: clear JBD2_ABORT flag before journal_reset to update log tail info when load journal
Date:   Fri, 14 Feb 2020 11:19:22 -0500
Message-Id: <20200214162122.19794-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Kai Li <li.kai4@h3c.com>

[ Upstream commit a09decff5c32060639a685581c380f51b14e1fc2 ]

If the journal is dirty when the filesystem is mounted, jbd2 will replay
the journal but the journal superblock will not be updated by
journal_reset() because JBD2_ABORT flag is still set (it was set in
journal_init_common()). This is problematic because when a new transaction
is then committed, it will be recorded in block 1 (journal->j_tail was set
to 1 in journal_reset()). If unclean shutdown happens again before the
journal superblock is updated, the new recorded transaction will not be
replayed during the next mount (because of stale sb->s_start and
sb->s_sequence values) which can lead to filesystem corruption.

Fixes: 85e0c4e89c1b ("jbd2: if the journal is aborted then don't allow update of the log tail")
Signed-off-by: Kai Li <li.kai4@h3c.com>
Link: https://lore.kernel.org/r/20200111022542.5008-1-li.kai4@h3c.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 3cbcf649ac660..40c754854b29e 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1670,6 +1670,11 @@ int jbd2_journal_load(journal_t *journal)
 		       journal->j_devname);
 		return -EFSCORRUPTED;
 	}
+	/*
+	 * clear JBD2_ABORT flag initialized in journal_init_common
+	 * here to update log tail information with the newest seq.
+	 */
+	journal->j_flags &= ~JBD2_ABORT;
 
 	/* OK, we've finished with the dynamic journal bits:
 	 * reinitialise the dynamic contents of the superblock in memory
@@ -1677,7 +1682,6 @@ int jbd2_journal_load(journal_t *journal)
 	if (journal_reset(journal))
 		goto recovery_error;
 
-	journal->j_flags &= ~JBD2_ABORT;
 	journal->j_flags |= JBD2_LOADED;
 	return 0;
 
-- 
2.20.1

