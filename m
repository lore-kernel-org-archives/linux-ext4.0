Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B9D13B58A;
	Sun,  1 Mar 2026 01:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329345; cv=none; b=RceP6gvKy/awBzA0BVYrFrRSvu2J6nGFcN8poLT6MVhDnHl9KZ+7WRpt6RogopGJLz6PXeB3WgJ22TROK0AlfT15nk25KYJIG2ynjJGCJifolzZIDB8I7cT5xqQYwL2cRmTgsjXPtPvfNkFg8Ye1z2bTVXb39GCuG/iXN7Ltwrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329345; c=relaxed/simple;
	bh=VWSDQRqOmFOzNp12VZsoWxduv1zGxmNnCZnNHuLZ13g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rXJ9pymCLogZSsRmEAzV9QYlDejJyhKOsMey5RIKxD1GEHm+QGjpM36bis8wiH8eVO09FKuN+r0wxan7NGt9DcaJvUNimdzFFd0lj+aycA03Ud00cEt6ixd3VlV3oCVfkeL1UxrZoFyMKBVWRm67vHjFT7NytevwBAx2iyEB+oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwLZ3oaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwLZ3oaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78B6C19421;
	Sun,  1 Mar 2026 01:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329345;
	bh=VWSDQRqOmFOzNp12VZsoWxduv1zGxmNnCZnNHuLZ13g=;
	h=From:To:Cc:Subject:Date:From;
	b=jwLZ3oaEy5RZTkcv5hofeh4NO9IaiH8bJiAB1laY1ZufQ42KR36LMtGmOP2EIyPVM
	 Q4mHYqv4CS+yCk051so6Girx9yT/ITDgoW/W77bYezYhkkkPzuvmSV5v2SH25C2qwu
	 OItzpqYiurf89QLlZqcmtLJpvgd6cRlb+BHbgCP+lsDZpG9dB/b50nBSoSyp/9uiY/
	 uB5Dcx+NVEoyrZ36gHVdoG02bg6fdieldobsWXjEUl/UhPumQcmwQJV+HECBGjpRxp
	 ZbJpAfQTt+N5GmlfHCu739PpNZQuZS7beLOocp4wKhBNO2++7y0RiaDwWeqiquUkOb
	 GvoKT8R1Ek0oA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	yi.zhang@huawei.com
Cc: Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: drop extent cache when splitting extent fails" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:42:23 -0500
Message-ID: <20260301014223.1704235-1-sashal@kernel.org>
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

The patch below does not apply to the 6.1-stable tree.
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




