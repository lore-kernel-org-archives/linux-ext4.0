Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D222D8780;
	Sun,  1 Mar 2026 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328785; cv=none; b=CAxkAI7DIaucZ51JDohqC8RPXhBwsEqGYp4OaDKu6ZRCxHi1EnAU96GfNGrsfhP2IWecRjUzFPOAGLIDbQAdRVEeHWh48Nwsgpxh32v8VTlkDvUKssSLG9xgJH8UPrReIvuUTjB6nJ2ZX8YXqlm2/nlTseEs2or2IlncfsSIAdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328785; c=relaxed/simple;
	bh=P9V//pMvW5aLiUoXIAYNn/4cAlV+2ge8y7BF94/J5pU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YAmFU5wFRH9u1iVKitghUfjUpPcQIY8df5DTv9YM/ScXiVQ1rcfvJ+qHQVE9b2+8Hh07Qtg/DR8LzAVdzpWtbsMNfhGokcHTYRkoohjB4GGNuMp3O5LzuwKHnMvag45Ztpo61EFifYLpUaCEcmGUNYS7WjBboBSYDMb16xa+kB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpU5E+LM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpU5E+LM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626FBC19421;
	Sun,  1 Mar 2026 01:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328785;
	bh=P9V//pMvW5aLiUoXIAYNn/4cAlV+2ge8y7BF94/J5pU=;
	h=From:To:Cc:Subject:Date:From;
	b=TpU5E+LMeMp3yRR+2ZExaF7wvlusvcmMKslvYN94ap2r0X0FSonGbj5xGMSaCfNOz
	 zWjIWijb+/43oDOO/iPwMGbimaP7BOeAnZ+L64PD8ekqUFFJIQTEWCCN5UJGDbMxJE
	 WgeUa0EMnyo8HLMpSQcys7ughwVRDeoldTiemVOvYLsGAq7CUQPCAffTkMk5gJeXSG
	 FcFa8ooSfzRS2Q4kPEgDGM9Knq/vnCgfe7pY0IZXdWsj4ZVzWsA929FG31ITJZv6vL
	 m+8cGZYRJ8KzOqT4CRG+8jP3xUmUFnMSq5y3ZokkzCNwcHGzSQZ+uwQFe9wBdT5SdH
	 KMUC2+52SJT4Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	yi.zhang@huawei.com
Cc: Baokun Li <libaokun1@huawei.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Subject: FAILED: Patch "ext4: drop extent cache after doing PARTIAL_VALID1 zeroout" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:33:03 -0500
Message-ID: <20260301013303.1692208-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
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




