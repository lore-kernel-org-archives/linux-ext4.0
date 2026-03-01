Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8A7259C80;
	Sun,  1 Mar 2026 02:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330473; cv=none; b=BPWLu9w2YkCNDuZSY3FVg8RqEZZufTRg8CIApyzEjXGtkLYzuYuH4MMGDOfvYZzNC2hxdjDmYqDSuWFXkoPyFBb1Xkx+9IMeD+q14mbigOJlsczkvuunm3cdlmowLUIzCv8uJqYQY1i5ee1CEjPRPLKQ+40IcueEZBjkHCZcocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330473; c=relaxed/simple;
	bh=N+84yPRtQSsIVVI9Mx6KffsAX8pcGcIU7x4RqbqPuKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AeG1eYgQDVP6yIgzX1zKh6KpJPnXncM/fdRtz05KuZqqzjD7ASIstMGuWNS/5O0mk5y21/wwqsIxNLvNUXK7CA66nLTWGw/seeu+AzCyX2OXQut3Xo6vXSq3PM1mNwHCZNm4MLp8Iik6015Eo614tv7vQc1iYY18VjM7aj3W/fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UY5WXw9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UY5WXw9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39334C19421;
	Sun,  1 Mar 2026 02:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330472;
	bh=N+84yPRtQSsIVVI9Mx6KffsAX8pcGcIU7x4RqbqPuKw=;
	h=From:To:Cc:Subject:Date:From;
	b=UY5WXw9RHI1hUSRp/r85irJHFsDVsYk/IxvLD8x7vNThXzGVdDWIbpVhZjNvT57wU
	 YMP6MhtKrvr/hkL/qIgS3NUX/bIUGkg3muxG+Hrs/cyH11QfNDjn81a3gvPr1umL6Q
	 97nBvbOa6OC2Ktu/2nrzdz2xAQ8+V9vGUmitcaK2U5BGVew+TpMOsQ2lOierjbxqFH
	 KAOHF0Hb+CQjBbDYvelwd0aTYK46BgUwYhfYwYzucTfxQJTHz7YJukOlOVmkzSgzci
	 IXTM7vPEc666Tqx5D3zp7RyE6p0OsX3nbl5SSs0sEIyroKfJkTXvIXluIGvJS6q2GW
	 pGcRMEv9laE5g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	zilin@seu.edu.cn
Cc: Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Ts'o <tytso@mit.edu>,
	stable@kernel.org,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: fix memory leak in ext4_ext_shift_extents()" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:01:10 -0500
Message-ID: <20260301020111.1728228-1-sashal@kernel.org>
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

From ca81109d4a8f192dc1cbad4a1ee25246363c2833 Mon Sep 17 00:00:00 2001
From: Zilin Guan <zilin@seu.edu.cn>
Date: Thu, 25 Dec 2025 08:48:00 +0000
Subject: [PATCH] ext4: fix memory leak in ext4_ext_shift_extents()

In ext4_ext_shift_extents(), if the extent is NULL in the while loop, the
function returns immediately without releasing the path obtained via
ext4_find_extent(), leading to a memory leak.

Fix this by jumping to the out label to ensure the path is properly
released.

Fixes: a18ed359bdddc ("ext4: always check ext4_ext_find_extent result")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20251225084800.905701-1-zilin@seu.edu.cn
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/extents.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 27eb2c1df0128..e0295e0339b49 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5406,7 +5406,8 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 		if (!extent) {
 			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
 					 (unsigned long) *iterator);
-			return -EFSCORRUPTED;
+			ret = -EFSCORRUPTED;
+			goto out;
 		}
 		if (SHIFT == SHIFT_LEFT && *iterator >
 		    le32_to_cpu(extent->ee_block)) {
-- 
2.51.0




