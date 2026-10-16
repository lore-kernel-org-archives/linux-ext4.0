Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0752DB7B9;
	Fri, 16 Oct 2026 11:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792148606; cv=none; b=jSWd4AwClcRpCYq2PiwOjTx4qvMFcUkG8mgUMMCOW/jivQVRnU/S+QwEdWRJtax1RIJ/WXh7JGLzTs8L9P0duf4SJOnEdUVwNTWv1D6TV1M0GNxyqejJcZoF1ulBrwyYRK8mCuAmBY3JkJSZFyTnHn99OhM70rKbCyxEBd7SaDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792148606; c=relaxed/simple;
	bh=9P8lqRlAbTkeMQpXKq/Ikj4bVVRw4PutoHzVKjSzJDU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ciQTn2vg1Hbt0tLyzy7bljmf/Iyx1pw110XiyCDS409HYiPUGgLt1x26wkX07V3q5n7/rUBZFhyCnDEWW+o9MettXSzjPdlHUoeOaY66JicP6XHtOe1j5IuKUBUC/iC0SYLvPybz5jZ7gdgTZl5jOS4LLqN/HwUfoIQ01BuKLMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=fcO8+zmL; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="fcO8+zmL"
Received: from localhost (gyproxy-mailtls4-entmail-gy2-virt39.gy.ntes [39.144.128.100])
	by smtp.qiye.163.com (Hmail) with ESMTP id 514fa5635;
	Fri, 16 Oct 2026 19:03:16 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: record writeback error when discarding pages on failed delalloc
Date: Fri, 16 Oct 2026 11:03:11 +0000
Message-Id: <20261016110311.71391-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016101605.4039217-1-guolingxing@tju.edu.cn>
References: <20261016101605.4039217-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa14461651303a2kunm42005396ac12c
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSEtIVkMfQh1OTBoZSRhKH1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpLS1lXWRYaDxIVHRRZQVlPS0hVSktISk
	xMSVVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=fcO8+zmLb3hDLqa2mrZ45FT3w844s9d1XIhxbt811Bfzv48okZJ1vZZgjgjkKpI5lHGQMF0YBZApa9IMb6tnMfMA1/FGPQ5wh5TQgpCV6Uyg6TC82G0mm/hl9EwwblN8G8BK+uqY/1QJObdOHEAzvFyfMYzZTCiGx33Dqi8I8Ec=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=1ore68OjlkOATLeoAt+1iQo67MKoFO1Vputg9dPZKng=;
	h=date:mime-version:subject:message-id:from;

When mpage_map_and_submit_extent() gives up on a failed block mapping,
it sets give_up_on_write so that mpage_release_unused_pages() discards
the remaining dirty folios. However, the error is not recorded in the
mapping's writeback error state.

If this happens during background writeback, a later fsync() may
report success even though the dirty data was discarded and never
written. Returning the error from ext4_writepages() is not sufficient
to notify a later fsync(). In addition, ext4_do_writepages() may clear
-ENOSPC when committing the journal and retrying, even after the
affected dirty folios have been discarded.

Call mapping_set_error() when deciding to give up on the write,
before the dirty folios are invalidated, so that fsync() can report
the writeback failure through the mapping's error state.

The give_up_on_write flag also persists across writeback loop
iterations. After a fatal -ENOSPC failure sets it, ext4_do_writepages()
may commit the journal and retry without clearing the flag. If a
subsequent iteration encounters a transient error and leaves dirty
folios pending, mpage_release_unused_pages() invalidates them instead
of preserving them for retry. Initialize give_up_on_write inside the
loop so that only a fatal failure in the current iteration causes
the remaining dirty folios to be discarded.

Fixes: c4a0c46ec92c ("ext4: invalidate pages if delalloc block allocation fails.")
Fixes: cb530541182b ("ext4: fix up error handling for mpage_map_and_submit_extent()")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
Changes since v1:
- Initialize give_up_on_write in each writeback iteration to prevent
  a stale value from invalidating dirty folios after an ENOSPC retry.
- Update the commit message and add the corresponding Fixes tag.

 fs/ext4/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03..ae54212e0a7d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2505,6 +2505,12 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 				ext4_print_free_blocks(inode);
 		invalidate_dirty_pages:
 			*give_up_on_write = true;
+			/*
+			 * Record the error so that a subsequent fsync()
+			 * / errseq check can observe the data loss that
+			 * discarding these dirty pages implies.
+			 */
+			mapping_set_error(inode->i_mapping, err);
 			return err;
 		}
 		progress = 1;
@@ -2774,7 +2780,6 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	int needed_blocks, rsv_blocks = 0, ret = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 	struct blk_plug plug;
-	bool give_up_on_write = false;
 
 	trace_ext4_writepages(inode, wbc);
 
@@ -2892,6 +2897,8 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 		goto unplug;
 
 	while (!mpd->scanned_until_end && wbc->nr_to_write > 0) {
+		bool give_up_on_write = false;
+
 		/* For each extent of pages we use new io_end */
 		mpd->io_submit.io_end = ext4_init_io_end(inode, GFP_KERNEL);
 		if (!mpd->io_submit.io_end) {
-- 
2.34.1

