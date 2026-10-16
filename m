Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A864346A5E2;
	Fri, 16 Oct 2026 10:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792146096; cv=none; b=im2rrLiWUTtSN4sYKBTLI3FHAZTXwgi2FLGBVvR6cemF948mU1WV32lX6MW7Jax61fvWI3jQcIoeZZLWXYeO3sOsEWMrDnvBENffak3TRzN99s+nX+b5lNcHBfDKGHkAI1RMSA8QMx5OzPZTwcdDJIZVkdm7kAiouVNsRDp65cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792146096; c=relaxed/simple;
	bh=q4OwaTzadwgCTdJ9TVs0P3l712qfdWyz2bs4kl8ONis=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lj9XCZ1Ql+jDYOR7CSCNRU5GobJIfCwvx0KyYNdM0F5wtbZCYNyNeNh51W6afxoXD/C+YktsSi/xtlIf3WEhV8mRECDSZgf9YL6Wek/A1AGbeAtpDtLo59LZEUx/l4p9ZTB6J1YSeKsa60oxUXcP+k+taYr61yqEzM2VRgnmqLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=llCEn2yZ; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="llCEn2yZ"
Received: from localhost (gyproxy-mailtls1-entmail-virt216.gy.ntes [39.144.128.100])
	by smtp.qiye.163.com (Hmail) with ESMTP id 514e64cfb;
	Fri, 16 Oct 2026 18:16:09 +0800 (GMT+08:00)
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
Subject: [PATCH] ext4: record writeback error when discarding pages on failed delalloc
Date: Fri, 16 Oct 2026 10:16:05 +0000
Message-Id: <20261016101605.4039217-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa14436451b03a2kunm6f703c5baa467
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGktIVkhMGh8fTU1KGEhPH1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpLS1lXWRYaDxIVHRRZQVlPS0hVSktISk
	xMSVVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=llCEn2yZY/bNmfx1ZaT0CHDxDWlRsRG2EQCH7LRgdxkTdb1qKKk9tthJyIVW/sHJiVpzFGBrW8MOWENs/AhjEzxpSjaDbAY1i/bwI+82usY8ET+W/aOglDBtCt9j6WaUahAGaofqK3rNuOScanh+b1H4BAIZzcWxe9LW3r1Z+rU=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=DOLiDaA5ZGjG1eytvPuyuGBa6K7mUgIux4GKB6ue1nM=;
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

Fixes: c4a0c46ec92c ("ext4: invalidate pages if delalloc block allocation fails.")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 fs/ext4/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03..dba903d188e2 100644
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
-- 
2.34.1

