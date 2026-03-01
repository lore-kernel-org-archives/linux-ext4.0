Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384DF26ED35;
	Sun,  1 Mar 2026 01:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329847; cv=none; b=L7OeG2hDU9sI92kXjRNOgo757TVewYiQDgG5X4czCZ30E+gFO0UV0+SnR4Mlk1dgWnn0J8rO0N4gfwSIEvgPYXsnaVw4HiBk5V3B75piDpVQ/Yv56EOL4gLqhCC0KcYqi/wg5jqx+XF+96EhKqQqSRh0i9sh9Eg898W/901tyhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329847; c=relaxed/simple;
	bh=7w6PAphvqVFdydftwBShThjulrK4zoO4RQKXsSTeS6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tfUpO6ReMsvECKy6mFmzSjOik46RAaukw41iGj5CQMZvgunBW/hi296LTD1v+fpcDvNV5lrwspemdPCNjmPf5GBqUzN+UHLzaweU7/gTHKkdLc/pxHM4L6ncHxqRZv8VKCHsxIfyWH6DYqbc8s2AMQ3FO6pldyAKmji3sdW4WDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4Za2G+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4Za2G+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E14C19421;
	Sun,  1 Mar 2026 01:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329847;
	bh=7w6PAphvqVFdydftwBShThjulrK4zoO4RQKXsSTeS6Q=;
	h=From:To:Cc:Subject:Date:From;
	b=d4Za2G+PcgGALGcsH/SRK71Hp7x7YlqF3co5iT8lepyUPeS4HsZQj3/vA5ybbFrTR
	 UaqXGRlaztdOEcqzyNAceiDCR+Pe6jhY5GZGbhpVzc0IM3oROfHpSsjiT5IbcfeJlH
	 vkGYc5wVo6M6qKFZaovFTOUdVkyGpaQm1A4W/lFuC9xe55M9aeL6r1VYOnQjioBLky
	 tcZaF95BzGt1oo+4PqA6cdPog2fq68RLp3kvCulX/9ZQmaHNTOKnMBn2Kv2b0a2xcA
	 XSC+1U4NMVFGSIhnyrlzgk37Sqyl69dIosdexW/MjR8mYlBSrx5Ay55GMyq5Ad1cuK
	 QyaMBJciqUVGQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	yi.zhang@huawei.com
Cc: Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: drop extent cache after doing PARTIAL_VALID1 zeroout" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:50:44 -0500
Message-ID: <20260301015045.1716859-1-sashal@kernel.org>
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

From 6d882ea3b0931b43530d44149b79fcd4ffc13030 Mon Sep 17 00:00:00 2001
From: Zhang Yi <yi.zhang@huawei.com>
Date: Sat, 29 Nov 2025 18:32:38 +0800
Subject: [PATCH] ext4: drop extent cache after doing PARTIAL_VALID1 zeroout

When splitting an unwritten extent in the middle and converting it to
initialized in ext4_split_extent() with the EXT4_EXT_MAY_ZEROOUT and
EXT4_EXT_DATA_VALID2 flags set, it could leave a stale unwritten extent.

Assume we have an unwritten file and buffered write in the middle of it
without dioread_nolock enabled, it will allocate blocks as written
extent.

       0  A      B  N
       [UUUUUUUUUUUU] on-disk extent      U: unwritten extent
       [UUUUUUUUUUUU] extent status tree
       [--DDDDDDDD--]                     D: valid data
          |<-  ->| ----> this range needs to be initialized

ext4_split_extent() first try to split this extent at B with
EXT4_EXT_DATA_PARTIAL_VALID1 and EXT4_EXT_MAY_ZEROOUT flag set, but
ext4_split_extent_at() failed to split this extent due to temporary lack
of space. It zeroout B to N and leave the entire extent as unwritten.

       0  A      B  N
       [UUUUUUUUUUUU] on-disk extent
       [UUUUUUUUUUUU] extent status tree
       [--DDDDDDDDZZ]                     Z: zeroed data

ext4_split_extent() then try to split this extent at A with
EXT4_EXT_DATA_VALID2 flag set. This time, it split successfully and
leave an written extent from A to N.

       0  A      B  N
       [UUWWWWWWWWWW] on-disk extent      W: written extent
       [UUUUUUUUUUUU] extent status tree
       [--DDDDDDDDZZ]

Finally ext4_map_create_blocks() only insert extent A to B to the extent
status tree, and leave an stale unwritten extent in the status tree.

       0  A      B  N
       [UUWWWWWWWWWW] on-disk extent      W: written extent
       [UUWWWWWWWWUU] extent status tree
       [--DDDDDDDDZZ]

Fix this issue by always cached extent status entry after zeroing out
the second part.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Message-ID: <20251129103247.686136-7-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index be9fd2ab86679..1094e49234513 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3319,8 +3319,16 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 			 * extent length and ext4_split_extent() split will the
 			 * first half again.
 			 */
-			if (split_flag & EXT4_EXT_DATA_PARTIAL_VALID1)
+			if (split_flag & EXT4_EXT_DATA_PARTIAL_VALID1) {
+				/*
+				 * Drop extent cache to prevent stale unwritten
+				 * extents remaining after zeroing out.
+				 */
+				ext4_es_remove_extent(inode,
+					le32_to_cpu(zero_ex.ee_block),
+					ext4_ext_get_actual_len(&zero_ex));
 				goto fix_extent_len;
+			}
 
 			/* update the extent length and mark as initialized */
 			ex->ee_len = cpu_to_le16(ee_len);
-- 
2.51.0




