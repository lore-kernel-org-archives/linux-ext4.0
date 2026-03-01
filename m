Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8FA1DED49;
	Sun,  1 Mar 2026 02:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330460; cv=none; b=kpf3ONuES2a5X2hDzw1bUGnk4sF6uTuLDxRybnyqmjAkV77uzmEyWAvlGVW/QghGshNvFj4OuEJQCJo4amBtBA1I4KQNz4+TrKMXH2qOjK4cuhz9YiSXe5rhGiombU8gML7L0kyDaUsjbIy4uxlllvl2sPz/qKBtB3HscLVj2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330460; c=relaxed/simple;
	bh=SfOSfyfAXN/2qOeS5QnWaJ0wiGy6jwhyZChS6qo0kgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XLsvDrKqVv916xKO6BY3YV3azZ/pFeVM/TWefLM76pZwYxr2MbY1ft0T5xqGY483Rgi4cmRUAaC2TIuZtkyw9/os3ZvSVNhnzYZaAMnPAbjrtLVU2ssUG0s/7ZA+YepeVdn7OkC6Q1mmDMR7AnZPgCN41c4UJ0sBCPRPCCYvU90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBabF1Pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBabF1Pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CD4C19421;
	Sun,  1 Mar 2026 02:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330460;
	bh=SfOSfyfAXN/2qOeS5QnWaJ0wiGy6jwhyZChS6qo0kgk=;
	h=From:To:Cc:Subject:Date:From;
	b=SBabF1PwVt8Ia1q8K2B+Bj3judxuL4vGV3guicfy33UeDFD/xks8Ir/7yCUQNLoyN
	 0KRNz88rg4lOVailPLUxo4wqW14K0GHgALtMaWdKrvEGLouNsuagxIzXHJ7dYs3vQH
	 qEnAadv1OVL+KO52inDy8yyLJW5vw2ef8nHn8bq8qYOXh0IgwqewmjzsDUDBriFawP
	 hH0VwxE+Gvg+S8/xwb8/52DB6T3K4EWnducuRtg69eV0yQ1DpVYJfWo4lW+vbuKk00
	 0NC2wH6vk4gdNYJqo2G0b2rQcprG1Q/w1zIbwwmeI5okFqrSz6AlPEjgqm5EJJTtlg
	 p34nH962wqpag==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	jack@suse.cz
Cc: Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	stable@kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: use optimized mballoc scanning regardless of inode format" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:00:58 -0500
Message-ID: <20260301020058.1727910-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 3574c322b1d0eb32dbd76b469cb08f9a67641599 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 14 Jan 2026 19:28:19 +0100
Subject: [PATCH] ext4: use optimized mballoc scanning regardless of inode
 format

Currently we don't used mballoc optimized scanning (using max free
extent order and avg free extent order group lists) for inodes with
indirect block based format. This is confusing for users and I don't see
a good reason for that. Even with indirect block based inode format we
can spend big amount of time searching for free blocks for large
filesystems with fragmented free space. To add to the confusion before
commit 077d0c2c78df ("ext4: make mb_optimize_scan performance mount
option work with extents") optimized scanning was applied *only* to
indirect block based inodes so that commit appears as a performance
regression to some users. Just use optimized scanning whenever it is
enabled by mount options.

Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20260114182836.14120-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/mballoc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 910b454b4a21e..dbc82b65f810f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1148,8 +1148,6 @@ static inline int should_optimize_scan(struct ext4_allocation_context *ac)
 		return 0;
 	if (ac->ac_criteria >= CR_GOAL_LEN_SLOW)
 		return 0;
-	if (!ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS))
-		return 0;
 	return 1;
 }
 
-- 
2.51.0




