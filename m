Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB5013B7AE;
	Sun,  1 Mar 2026 01:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328134; cv=none; b=qbRcC6ODQH0340Ij/4x7hNKB63+vn0fRNP5fhOg7JbcTqbyKAAeXQx7/O+Z8uLsadS1mIP4Lociv4v8+W1aYTS7wBleMB7PyVoqF8kWMiZGT3IiF6QphyRnNmlX7ReiPGSPImYk4MKQyC2mbQ9ZhC5VHcJ7bbPEQ1ip3x/QyKQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328134; c=relaxed/simple;
	bh=tw4Xe3eDj0h8VQYORhuzbl4Ht7yZwkVp+sv65tI+m3c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qjjD1ggcuIXu1NXSpBYgLk6TTOo7bdbPEo4cT99eMNKkg8w4SXPS9osNxgxWDVwhpERAVkU2OXLn7JqiLRyl5BnqtSb6ql8yeEWa1BsnQGyoFrmCzc3JqoXNHLqaGNdDZP99VNcQyYMUM9jnb6oAPEgM3vhmCHuxQR2wiHtG1h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azSyG/tB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azSyG/tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9044BC19421;
	Sun,  1 Mar 2026 01:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328133;
	bh=tw4Xe3eDj0h8VQYORhuzbl4Ht7yZwkVp+sv65tI+m3c=;
	h=From:To:Cc:Subject:Date:From;
	b=azSyG/tBzbSeFPzvIe2JN2RwXlMyS++45FlTbX6QHWWEHmc+0HS94Mpxd7pmPLx4g
	 S/jPTf+xuPr6gG9l2nTKkil+S3tF/+hK67LmMQlArVdldj4AVYoVllhX6HcYd0vi3Q
	 R2KN5GJeO4EVVlUDVQPUbNatQYMp+DPiUaNNvOJEXmsBpFeVSOrrmlaW4cYGn5wlVg
	 aZM5+D3qYPga9nKojNZXg+aLUVNXBHhGmxO4BHqSPTJ3vnRVgTSUEnZW8dkslXBzTO
	 vyJknbmuai6NZUNMg10OQdBxxU7giOUXTLViy353dg5vAJGhAI9nHeiTFY7MEl+CZi
	 drRLZD2AkDkOQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	jack@suse.cz
Cc: Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	stable@kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: use optimized mballoc scanning regardless of inode format" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:22:11 -0500
Message-ID: <20260301012211.1678359-1-sashal@kernel.org>
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

The patch below does not apply to the 6.12-stable tree.
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




