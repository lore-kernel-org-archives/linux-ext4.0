Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8E52BD0B;
	Sun,  1 Mar 2026 01:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328105; cv=none; b=TvVy8zNI29IJC75RXeYv6VmwGoKy00VVdBBzq0y6hnpfhSVMQUHjFdbGwnOpmDnVhXDhJCpjaDIYUUDnWncapjl6RW417SdPkvyDdq4MWp1Q7Ld082biAlXsMm44Npw+4GBB+1FJdL37kY3lxbDW3DWnytYk0+6ff+rKBsSM+3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328105; c=relaxed/simple;
	bh=qVglVOBXn8gGhhpQvt0rdSXC7AivysAsQGPj6jMH0gk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I2RE5VY04cPufsAUfbVKb5V/3nQc+D9MC2hjAMPSA/mMrcX7E3tcjUPkzxpL2pKvSSt8s50Dz2CH5R4Z6TgdaSbDu2R1iV1aLdY04Jc9vyivy6oZA+vE5q7ewkxqtIUqd3PlvpmTXlwKwjD2HCwi9YXnHv3T3AmJ6+sTASam598=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWIfdCjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWIfdCjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F91C19424;
	Sun,  1 Mar 2026 01:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328105;
	bh=qVglVOBXn8gGhhpQvt0rdSXC7AivysAsQGPj6jMH0gk=;
	h=From:To:Cc:Subject:Date:From;
	b=bWIfdCjhlilUHqwoT7GVzd4VgDXy/EPz5Si1d1GLQTgGwXHOYizeVfZlxBI+5JZR7
	 kClAokPTyrvZo98irrdgzlRgSy9/yth9xmf+3HVNTGNmqCXm+AQ3doRZT1BIkWQorz
	 MYPqUrjwlfZfkOW3JJsdT0JYp7NtDqGepRpcPqQabw2W6JtZNgqNaiqEuV2tU5IK0A
	 T/i6+ZW1IkAhp23IRUcEXDlOeBzofUMBVKMTgC1AFc5fqBc6KTM5bENq3PiEqwhRAu
	 Bonn5niHmwYE3NfnLHW/2vqR7ojOTrhi9bq6Qe1kXi97XrCxfVGCwzaKUnmZHiCRD4
	 uwlxcOskRsP2Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	yi.zhang@huawei.com
Cc: Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: drop extent cache when splitting extent fails" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:21:43 -0500
Message-ID: <20260301012143.1677766-1-sashal@kernel.org>
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

From 79b592e8f1b435796cbc2722190368e3e8ffd7a1 Mon Sep 17 00:00:00 2001
From: Zhang Yi <yi.zhang@huawei.com>
Date: Sat, 29 Nov 2025 18:32:39 +0800
Subject: [PATCH] ext4: drop extent cache when splitting extent fails

When the split extent fails, we might leave some extents still being
processed and return an error directly, which will result in stale
extent entries remaining in the extent status tree. So drop all of the
remaining potentially stale extents if the splitting fails.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Message-ID: <20251129103247.686136-8-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1094e49234513..945995d68c4d3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3267,7 +3267,7 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 
 	err = PTR_ERR(path);
 	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
-		return path;
+		goto out_path;
 
 	/*
 	 * Get a new path to try to zeroout or fix the extent length.
@@ -3281,7 +3281,7 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
-		return path;
+		goto out_path;
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3358,6 +3358,10 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 		ext4_free_ext_path(path);
 		path = ERR_PTR(err);
 	}
+out_path:
+	if (IS_ERR(path))
+		/* Remove all remaining potentially stale extents. */
+		ext4_es_remove_extent(inode, ee_block, ee_len);
 	ext4_ext_show_leaf(inode, path);
 	return path;
 }
-- 
2.51.0




