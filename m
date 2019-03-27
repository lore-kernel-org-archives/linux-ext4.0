Return-Path: <SRS0=Z8NG=R6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA048C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 19:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CB421734
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553715005;
	bh=vOWr6nCvbaiF3lCzop1vDUGXuj5KMLJjAQGHE5o7Rks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yb8et6iar1Q+HRBKFxnAv3ULv38XqPkNtOBHL3Yf9weH9i8cD7IOnZBZwSWvRF1aU
	 Pn+WAHmpiM/zNCpbFT3YUQV2jxjrwj8wcpZpYXDa+wtKXCHC0+EIMYoKz0/24ZFnn5
	 X9ePjllaKe1Ap7ubLdo+r2EMIyhE+FkFlfjcP7Kk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732705AbfC0TaA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732672AbfC0SDj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 27 Mar 2019 14:03:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 038F42183E;
        Wed, 27 Mar 2019 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709818;
        bh=vOWr6nCvbaiF3lCzop1vDUGXuj5KMLJjAQGHE5o7Rks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE14pBeOt3Oolsruv8TsytJ47J77/UdF8oO2LpMarwBhcXYhKmXcpIc17NgVWAqmd
         YhLKgygog5kz1jYGqaGMn3S5fzO8Cx+OgGGL0ijEeRqy1EitnqolEKXPq7GePuFaKW
         tMjAXR2+Uu0MjXB8kue+74Y92RGXvPOldolHmaD4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     luojiajun <luojiajun3@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 057/262] jbd2: fix invalid descriptor block checksum
Date:   Wed, 27 Mar 2019 13:58:32 -0400
Message-Id: <20190327180158.10245-57-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: luojiajun <luojiajun3@huawei.com>

[ Upstream commit 6e876c3dd205d30b0db6850e97a03d75457df007 ]

In jbd2_journal_commit_transaction(), if we are in abort mode,
we may flush the buffer without setting descriptor block checksum
by goto start_journal_io. Then fs is mounted,
jbd2_descriptor_block_csum_verify() failed.

[  271.379811] EXT4-fs (vdd): shut down requested (2)
[  271.381827] Aborting journal on device vdd-8.
[  271.597136] JBD2: Invalid checksum recovering block 22199 in log
[  271.598023] JBD2: recovery failed
[  271.598484] EXT4-fs (vdd): error loading journal

Fix this problem by keep setting descriptor block checksum if the
descriptor buffer is not NULL.

This checksum problem can be reproduced by xfstests generic/388.

Signed-off-by: luojiajun <luojiajun3@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2eb55c3361a8..efd0ce9489ae 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -694,9 +694,11 @@ void jbd2_journal_commit_transaction(journal_t *journal)
                            the last tag we set up. */
 
 			tag->t_flags |= cpu_to_be16(JBD2_FLAG_LAST_TAG);
-
-			jbd2_descriptor_block_csum_set(journal, descriptor);
 start_journal_io:
+			if (descriptor)
+				jbd2_descriptor_block_csum_set(journal,
+							descriptor);
+
 			for (i = 0; i < bufs; i++) {
 				struct buffer_head *bh = wbuf[i];
 				/*
-- 
2.19.1

