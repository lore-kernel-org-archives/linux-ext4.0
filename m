Return-Path: <SRS0=Q+OU=EC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CF7C6379D
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 00:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 618F2221F8
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 00:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603758869;
	bh=C7kJQJ0S4jIW0hiAo8BwjaG923P/qlYE9ayfR6bR/nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IdXv7V/DicayUvBSJxYvW8kLkhWU7qyomAdC3lJc+x2adNfnaHyVzJ10H61R/f7GL
	 TRkfFeS0mmP5vRP/PqKbvUeCiwWr1GU5S0iLD2pclyWvrestJVZcMP97cCM6CwH9Tq
	 zHbGuvD3DcC6eJqiyKIKCKkFEL9ufTAbCjD4iAsg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443552AbgJ0AbN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409443AbgJZXvc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8671621D42;
        Mon, 26 Oct 2020 23:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756291;
        bh=C7kJQJ0S4jIW0hiAo8BwjaG923P/qlYE9ayfR6bR/nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWoxP0l5ACOeT94f8noo2sKT0QyWRP0MNSpjZQX9VsFK9PQ/HhtHLywpHJ/KVbUD2
         Sh70qZev+d6Y4qyRcaUpwuQJsBN8u/qH6eLcZGATD2ifuydZ+GRrSJ1/5FMuQlvNUS
         NtE80Ap9vHYbZDo1+pTONSxosxX8ZMqDYYKkKE14=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 119/147] ext4: Detect already used quota file early
Date:   Mon, 26 Oct 2020 19:48:37 -0400
Message-Id: <20201026234905.1022767-119-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit e0770e91424f694b461141cbc99adf6b23006b60 ]

When we try to use file already used as a quota file again (for the same
or different quota type), strange things can happen. At the very least
lockdep annotations may be wrong but also inode flags may be wrongly set
/ reset. When the file is used for two quota types at once we can even
corrupt the file and likely crash the kernel. Catch all these cases by
checking whether passed file is already used as quota file and bail
early in that case.

This fixes occasional generic/219 failure due to lockdep complaint.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20201015110330.28716-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea425b49b3456..d31ae5a878594 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6042,6 +6042,11 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	/* Quotafile not on the same filesystem? */
 	if (path->dentry->d_sb != sb)
 		return -EXDEV;
+
+	/* Quota already enabled for this file? */
+	if (IS_NOQUOTA(d_inode(path->dentry)))
+		return -EBUSY;
+
 	/* Journaling quota? */
 	if (EXT4_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not in fs root? */
-- 
2.25.1

