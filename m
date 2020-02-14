Return-Path: <SRS0=E9RY=4C=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C49BC3B1A6
	for <linux-ext4@archiver.kernel.org>; Fri, 14 Feb 2020 17:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B34A24680
	for <linux-ext4@archiver.kernel.org>; Fri, 14 Feb 2020 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581700895;
	bh=Ajl/zcIjPh0ERddEeFG+OgbIY8Rj9+hPm3YaD5Ib0Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Hu9nWnbWrG6Wczh+dkwgu04ruJpy7na0yh0FSI48+DynSQXrIp8UfOQu11r5E/+7i
	 p5r8NkUORR5NhSoLj2TliwZB1+d0CV3vRgho5PLZuV58M8wsDCbRQ4imuRUpYT7ush
	 DpbMzlZMnBiLJXsNKzIj1sL59iWF9izqVKUpY204=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391583AbgBNRVe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:21:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391444AbgBNQKR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F3C124695;
        Fri, 14 Feb 2020 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696616;
        bh=Ajl/zcIjPh0ERddEeFG+OgbIY8Rj9+hPm3YaD5Ib0Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBuOMSTaMvaKU9ShpO47bYUttwtljA37OiFpSiH304XFxdRGWZyWVpn9T9d3t6ttS
         Kh1V3tXQebfMGMA5In59b3p4seNTLEdARF7+1DH3HTiB0Styr7YZcjLuX47AP3g/7W
         3Gf6FkCMKWEhoh5ZsYP2EIad6FCOK1NknwxFBWR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 398/459] jbd2: switch to use jbd2_journal_abort() when failed to submit the commit record
Date:   Fri, 14 Feb 2020 11:00:48 -0500
Message-Id: <20200214160149.11681-398-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: "zhangyi (F)" <yi.zhang@huawei.com>

[ Upstream commit d0a186e0d3e7ac05cc77da7c157dae5aa59f95d9 ]

We invoke jbd2_journal_abort() to abort the journal and record errno
in the jbd2 superblock when committing journal transaction besides the
failure on submitting the commit record. But there is no need for the
case and we can also invoke jbd2_journal_abort() instead of
__jbd2_journal_abort_hard().

Fixes: 818d276ceb83a ("ext4: Add the journal checksum feature")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191204124614.45424-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index c43591cd70f1c..b33adae434331 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -784,7 +784,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		err = journal_submit_commit_record(journal, commit_transaction,
 						 &cbh, crc32_sum);
 		if (err)
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 	}
 
 	blk_finish_plug(&plug);
@@ -877,7 +877,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		err = journal_submit_commit_record(journal, commit_transaction,
 						&cbh, crc32_sum);
 		if (err)
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 	}
 	if (cbh)
 		err = journal_wait_on_commit_record(journal, cbh);
-- 
2.20.1

