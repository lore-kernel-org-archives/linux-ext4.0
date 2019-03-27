Return-Path: <SRS0=Z8NG=R6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C71BC4360F
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 18:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44947205C9
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712268;
	bh=WL1ye6weSf789Gn69V70fqgfnS05W55G6SFX1+W99Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mr6o6BAAqEuwjoykGO1pIJBweVnO8gyQa7m6QDkNXd8cDowXH+xXKmp4pkcQEQ0aS
	 GdzfEgVtyQGDU+Sbm52q+ksPzN2yU0V6zO59IItWVZ5mPRttWmmx5yNcCFIn4OEG12
	 AgL/pHIZ4AaZcCnys9klHX1llXwtcSZJeuq4mOYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391025AbfC0So1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:44:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391106AbfC0SVR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 27 Mar 2019 14:21:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C532082F;
        Wed, 27 Mar 2019 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710876;
        bh=WL1ye6weSf789Gn69V70fqgfnS05W55G6SFX1+W99Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BbsJwwGw++ATsTSKmYWkhrvcNaYs+l2A9iXkQhU6vYDwQL+C6Njkxm6CtCNM3scP
         9YwK06vVr5J0x6zK++gIPg6V2JNA+o9fbGjtlTtTxwdE06hDD4RbBxin1eEly0/MdL
         D29dRhVFputV37qUuOrfZJo3jB13hAUfCvE3o+0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     luojiajun <luojiajun3@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 21/87] jbd2: fix invalid descriptor block checksum
Date:   Wed, 27 Mar 2019 14:19:34 -0400
Message-Id: <20190327182040.17444-21-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182040.17444-1-sashal@kernel.org>
References: <20190327182040.17444-1-sashal@kernel.org>
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
index 31f8ca046639..10ec27676191 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -700,9 +700,11 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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

