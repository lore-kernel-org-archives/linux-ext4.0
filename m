Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B513351C10
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782468480; cv=none; b=ZnP2Uzt/7oVYyu9FIE90IdszHjA2e2gwY8tGSl+vPLsfeb2kGL0SkVctyVeJUKL1/U/x0Wv+lnmojiaKAiDUXGiPJt0VvPXkME5+ckfwY+zthErf0jmDOK6kDQTBLycZD+JVsqOHcr5y6Cq67SUXtVOk4+UNFgi3j9vQ2m6E24c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782468480; c=relaxed/simple;
	bh=496daIy9Oynkrnkj9PQ6+RVEEu0Tbv+Ca2uKBtp295I=;
	h=Cc:From:Subject:Date:Content-Type:Mime-Version:To:Message-Id; b=cL8jFo+KCjccp6Pk8zigQ+MiNLZUGmPwvVZIqBsFYjZzGD4l3+A4GXNJbab22oKkdOnj+k7SI4YRkmXzuiRvGmpasJG1nqTYYKfud75IQMBOdSjC37slP0o5I4v8d12XtCYnqFHAul17JBPTNYmUsFXDcb4mxeDlSi6duXakWZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=b306XkxQ; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="b306XkxQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782468466; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wbsYFv/aAybDSG7qH0hXOfSoTmIEui7F1AIt3Vyenn8=;
 b=b306XkxQJFxtsg5iQm1zrJtSr57z67MfuUEKzyizS3JsdlZzPLThnji7TCZkxKYXXIXPSS
 cbN5TFK074TwnLA+BFs8ytl0xlrx1l8stgiLSenWJvr+TPwDRl496cC+6r5+lYaQfgfwwv
 aEZXbK/SkB4BnrPbSR4tf5KRNK95MgudaibejLrvNqz0TLHoszT+gdQGB2ghnkPayrPoub
 TI6kRaFiv9t0QW+7wM5OTZtFRCbpsn5FUP8tezIptw7vPBbjf7S4qzdn4JYx+eXTrJtyUa
 octFUSFhuhlGv7WNEo51mrhJwxDjsHn6/LRIsueeTwcv/ZNop1TW8D8/uV3heg==
Cc: <libaokun@linux.alibaba.com>, <jack@suse.cz>, <ojaswin@linux.ibm.com>, 
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, 
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Zhu Jia" <zhujia.zj@bytedance.com>, <stable@vger.kernel.org>, 
	"Zhang Yi" <yizhang089@gmail.com>
From: "Zhu Jia" <zhujia.zj@bytedance.com>
Subject: [PATCH v2] ext4: cancel dirty accounting for folios without buffers
Date: Fri, 26 Jun 2026 18:07:40 +0800
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a3e4f70+67c9c1+vger.kernel.org+zhujia.zj@bytedance.com>
X-Original-From: Zhu Jia <zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>
Message-Id: <20260626100740.52455-1-zhujia.zj@bytedance.com>

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
accounting. Then cycle the folio through writeback state so the generic
writeback helpers update the xarray DIRTY/TOWRITE tags.

Fixes: cc5095747edf ("ext4: don't BUG if someone dirty pages without asking ext4 first")
Cc: stable@vger.kernel.org
Suggested-by: Zhang Yi <yizhang089@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhu Jia <zhujia.zj@bytedance.com>
---
Changes since v1:
- After folio_cancel_dirty(), cycle the folio through writeback state so
  generic writeback helpers update PAGECACHE_TAG_DIRTY/TOWRITE, as
  suggested by Yi and Jan.

 fs/ext4/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d1..4c25dcd47fb15 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2715,7 +2715,15 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 */
 			if (!folio_buffers(folio)) {
 				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", folio->index);
-				folio_clear_dirty(folio);
+				/*
+				 * folio_cancel_dirty() pairs the dropped dirty
+				 * state with dirty accounting. Cycle through
+				 * writeback state so the generic writeback
+				 * helpers update the xarray tags.
+				 */
+				folio_cancel_dirty(folio);
+				folio_start_writeback(folio);
+				folio_end_writeback(folio);
 				folio_unlock(folio);
 				continue;
 			}
-- 
2.20.1
