Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211B553E0B
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 09:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782208207; cv=none; b=sxtCsZIzWNh7wjOHGRKpC1Fj9QzMSzGbBYKS45S2eevF1F5m7t6+EZOUozt5O688jj9oqojojxwjD7t/5anL5MP09zBszhH+9OCq9vgnjC2by8/PdOpenHEw7tuxk1eCjMappL4W8ZTtluOT/lpCwvEJc+SpIVfXVLiBB7phvkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782208207; c=relaxed/simple;
	bh=GjqYyK2hVDn1WEv+LfV7QwaRoebxQ49H8BhODJuEJhc=;
	h=To:From:Subject:Message-Id:Date:Cc:Mime-Version:Content-Type; b=L5qwYjl3HmmhZUhpG/bdrAOzdjbovMFKWc9mnVY0d+YyIsS9EXbyVejhRqsad/K6SOMOhR0SnlEj/cDlfidTkpAw1DhKa2tSk98oDthNfPAYiAiVJKYYzYEzbPVKN05d+vzmv1Haa26yHFEizucNlWuQp6t+EASS/+Ix0qlEF7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=LVSpLGI8; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="LVSpLGI8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782208193; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=GAZyq8qnvXQ9uWpGNOBJpOeyhs4XJXzEVP5U6mNKgns=;
 b=LVSpLGI817egX/YhNqXL17WWXlwCFe5gVEq7u+9RNzW8EvfFc3X/DyUg6ztjl+Z6wE+yXr
 gByUqZJksZHyauKcpfO6r/x2TC0OWNoc9wIk7RGfPHwmScnVf93TcLXSHC8Mu+OWS1P0zI
 yCXMkjiMqb08M7hAUVR3wU6V1Cl0tjkF3gRIz59KMO/KZ6YnM0WzRpudzJn+s20pSFNrRq
 FYcgPUU4jqzCzwxdlI65fQlnvToXXvQVKjesWRH7NBlPtnXOTgGXP9O6mAHYB9N59pmLHV
 DaDdN+Hm7bBZCFMvWPn6MAVXA7iPMtlMHGAKOKOrtL+3n9qMvaaNYb2x412ecA==
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>
From: "Zhu Jia" <zhujia.zj@bytedance.com>
Subject: [PATCH] ext4: cancel dirty accounting for folios without buffers
Message-Id: <20260623094947.7853-1-zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Date: Tue, 23 Jun 2026 17:49:47 +0800
X-Lms-Return-Path: <lba+26a3a56bf+f7de73+vger.kernel.org+zhujia.zj@bytedance.com>
Cc: <libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Zhu Jia" <zhujia.zj@bytedance.com>, <stable@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Original-From: Zhu Jia <zhujia.zj@bytedance.com>

Since commit cc5095747edf ("ext4: don't BUG if someone dirty pages
without asking ext4 first"), mpage_prepare_extent_to_map() handles dirty
folios without buffer heads by warning, clearing PG_dirty, and skipping
them. ext4 cannot write these folios because there are no buffer heads to
map and submit.

That recovery leaves dirty accounting behind: folio_clear_dirty() clears
PG_dirty but does not undo the accounting charged when the folio was
dirtied. We have seen this in production as Dirty/nr_dirty staying high
while Writeback/nr_writeback and device write IO stayed near zero, with
many writer tasks blocked in balance_dirty_pages() throttling. Thus the
warning-and-skip recovery can still become a dirty-throttle DoS.

Use folio_cancel_dirty() so dropping PG_dirty also cancels the dirty
accounting.

Fixes: cc5095747edf ("ext4: don't BUG if someone dirty pages without asking ext4 first")
Cc: stable@vger.kernel.org
Signed-off-by: Zhu Jia <zhujia.zj@bytedance.com>
---
 fs/ext4/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d1..7ea280e70c06e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2715,7 +2715,13 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 */
 			if (!folio_buffers(folio)) {
 				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", folio->index);
-				folio_clear_dirty(folio);
+				/*
+				 * folio_cancel_dirty() pairs the dropped dirty
+				 * state with dirty accounting, but leaves stale
+				 * PAGECACHE_TAG_DIRTY/TOWRITE tags behind. Later
+				 * writeback may rescan this clean folio.
+				 */
+				folio_cancel_dirty(folio);
 				folio_unlock(folio);
 				continue;
 			}
-- 
2.20.1
