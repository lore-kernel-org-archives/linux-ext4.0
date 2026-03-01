Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D04230BB8A;
	Sun,  1 Mar 2026 01:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329849; cv=none; b=YblOcKt+T9cDBF96Rlasq0K9y8tsPwANdYLMObGq3GyLmx48I6MtSz06tl9XJ1GaAZDQidRcLmnOSSUFVayPPq8F/OpZEoqcw2sA14ULu6WPpazoklpbIh5p9Un0tC7aIoQe3l+Z/3GdFRcHjKgf8PY38Vd7dDN06Ev7O3d9dgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329849; c=relaxed/simple;
	bh=oQWimNPAWK49i+9SaFbqK2vFe1Dy4Zp6u/nseVbi8TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lgA1S5v1gewpoVdZVQOjd114nNkIvESegxRxbY5OVYO2vHopnz/2uWvyg1PdBTa/j3TpUjACpteXnzehMI/vKr3P0HctSsIFvm1wq3MMI9WauS4GQ+HHhO/cX1lcdbz8LLT+In1SWOOyvsoxBw21Q/ygKIlVXvvzu1K8O3vC6bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L22vIXAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L22vIXAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FEEC19425;
	Sun,  1 Mar 2026 01:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329849;
	bh=oQWimNPAWK49i+9SaFbqK2vFe1Dy4Zp6u/nseVbi8TQ=;
	h=From:To:Cc:Subject:Date:From;
	b=L22vIXAdcykR3wmqtn80yx9Vy5O/ZSpx5OqjsYhoIHvY96yo30tVb38v+kj4azChc
	 8HvwnSQtmk3jLFe8S9uU/F13DUYoW64Cqa2oLfCIJjmDEAwLnzQBSV9E1tiJGKexXa
	 TyhHIXIrP9A4b6HYU96fZA8WYBW7qjhVb8dz0mFO0GTz6o7FC0pHew/7C5byPUfGxM
	 l2SffkL7+y489tLmywpLOodt0+qaB0wiKyIDKc2u43/NL5d83kiDuimnZj3H7/R0Ly
	 R+DM4f4By85dzrvaOnx19c/hBmIx3pUvgILbQ5Q+xs3+8MwuSX8eWXzpAcyi9ZGzII
	 Ij+m9oDX+6KXg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	yi.zhang@huawei.com
Cc: Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: drop extent cache when splitting extent fails" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:50:47 -0500
Message-ID: <20260301015047.1716906-1-sashal@kernel.org>
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

The patch below does not apply to the 5.15-stable tree.
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




