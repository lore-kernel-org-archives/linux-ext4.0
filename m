Return-Path: <SRS0=QItb=SB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BB2C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 01:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0BD2206DD
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 01:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553908065;
	bh=xjMq8WWA4YGJzG65zrxJDpFP/sqylIsCxnqaB19jZnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2Z97JCVSkfDy5QnT4O1U8H2VQOsfqMTn/BifA8nZJTs/DVNHjYw8UOQxot53igFYb
	 bl0RQFcPQgK1xFW3keg3MbqZvQ5DprX8WWl9LAbQRtnflyyzIZNajEZ+DEkvYJudKm
	 q7bcbUr/PwWRtKfPM+5RvqWEeUHdD20rfKFNjFhQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbfC3BHg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 21:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731183AbfC3AxM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Mar 2019 20:53:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75472206DD;
        Sat, 30 Mar 2019 00:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553907192;
        bh=xjMq8WWA4YGJzG65zrxJDpFP/sqylIsCxnqaB19jZnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doWpBu7Uw7nn3jReU7A6WIv4JE4+//5tAGIHHr03Ysp/2u5/9BGP2XrAjD/NiJ4lt
         sqbnBobYnSMUJFUCLh1uRqqisOynvcPSMBe7lPvbY4i1NyR4XNWEGGxnGmnODDRowL
         mDbIQDFdLMpANmp21NF11dkImrCevBxHDJHeAFtA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/52] ext4: add missing brelse() in add_new_gdb_meta_bg()
Date:   Fri, 29 Mar 2019 20:52:14 -0400
Message-Id: <20190330005301.26868-7-sashal@kernel.org>
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

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit d64264d6218e6892edd832dc3a5a5857c2856c53 ]

Currently in add_new_gdb_meta_bg() there is a missing brelse of gdb_bh
in case ext4_journal_get_write_access() fails.
Additionally kvfree() is missing in the same error path. Fix it by
moving the ext4_journal_get_write_access() before the ext4 sb update as
Ted suggested and release n_group_desc and gdb_bh in case it fails.

Fixes: 61a9c11e5e7a ("ext4: add missing brelse() add_new_gdb_meta_bg()'s error path")
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3d9b18505c0c..90061c3d048b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -932,11 +932,18 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
 	n_group_desc[gdb_num] = gdb_bh;
+
+	BUFFER_TRACE(gdb_bh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, gdb_bh);
+	if (err) {
+		kvfree(n_group_desc);
+		brelse(gdb_bh);
+		return err;
+	}
+
 	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
 	kvfree(o_group_desc);
-	BUFFER_TRACE(gdb_bh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, gdb_bh);
 	return err;
 }
 
-- 
2.19.1

