Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F3B399365
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 03:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780977140; cv=none; b=FI3XqOwbBnqvGGFacoApPWO9r3xM3GxiAcqeNQi970Fs+94hMxWZ2eahOXsgYP8LY3OEhVsD6Q8soa3HANqmR/0fuUMYd8550pNDA62bNjr5is4cx0Dti0rB/fH4/qjyi5mAmZzNGxy6yykNYOxcl3f2HwMRKelXexejkx0ECfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780977140; c=relaxed/simple;
	bh=plbZEdBsEVoiceLx354lAPpDb+2W2oYexV0z66OGR+g=;
	h=From:Message-Id:Date:Mime-Version:To:Subject:In-Reply-To:
	 References:Content-Type:Cc; b=Rwq3K4rLQDO/5cHO44JJG5QVkCiPb2s+kP+uoRPhGIiRPfGfuGNHffriYqZz7/03StgCOp1xFHeaiJffQHa2P3aKBknjPOsRUj/NW1emZcSwj63JiFHj1SQVvMVsTSOx02MSilqlaXqXQsBnv4ZHLX+D6fyJPSnzE5Th1ynA5t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=fB9870Ws; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="fB9870Ws"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780977133; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ljcX9HGQP8qScfeDL8/boo3qpaXpTglRdp4ziKmpebY=;
 b=fB9870WsFGiHhl09pn8nfA5qaJjAt8MDvnPMqd48I9gfnXjN05QcjfcrKNTO7z/NNb8Vhv
 /pdh7/4gKNQ6RlWClYQI3XqWvG8E2Do5euK+QMkGMapFh/FJzvEFkfzlojE6FsCahFMgKO
 BMZif3R0afQq8s3DJvWoz8xP78yM4k4vMKpF/SSmTj4k1L44no6S7/Z4AnCTQbp7TRqJGD
 Gw77lFA8aWwPp/I10qIsfmydy/MkkdODxZQsdPSr4xi/xt+XEhot6zEJ9yoafvgxP+AbPo
 3e6WU+vt9R5UCAkaSm1Bmnr043u0rqcLLYlP0Uybj/EiSLDQrjDcCSx+bUeMXw==
From: "Jia Zhu" <zhujia.zj@bytedance.com>
Message-Id: <20260609035202.90669-2-zhujia.zj@bytedance.com>
Date: Tue,  9 Jun 2026 11:52:01 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a278deb+c7b3ab+vger.kernel.org+zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
To: "Theodore Ts'o" <tytso@mit.edu>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>
Subject: [PATCH v3 1/2] fs/buffer: avoid tail commit walk for uptodate folios
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260609035202.90669-1-zhujia.zj@bytedance.com>
X-Original-From: Jia Zhu <zhujia.zj@bytedance.com>
References: <20260609035202.90669-1-zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: "Matthew Wilcox" <willy@infradead.org>, 
	"Alexander Viro" <viro@zeniv.linux.org.uk>, 
	"Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, 
	"Baokun Li" <libaokun@linux.alibaba.com>, 
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani" <ritesh.list@gmail.com>, 
	"Zhang Yi" <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Jia Zhu" <zhujia.zj@bytedance.com>, <stable@vger.kernel.org>

block_commit_write() always walks every buffer_head attached to the
folio.  That was cheap for order-0 folios, but large folios can contain
hundreds of buffer_heads.  For a small buffered overwrite of an
already-uptodate large folio, the commit work is therefore proportional
to the folio size rather than the copied range.

This became visible with ext4 regular-file large folios, where cached
small overwrites reach block_commit_write() through block_write_end().
Before ext4 enabled large folios for regular files, this path was only
hit with order-0 folios for normal ext4 buffered writes, so the full walk
was bounded.  The ext4 large-folio commit is therefore the regression
point for this generic helper cost.

The full walk is still needed when the folio is not uptodate, because
block_commit_write() uses per-buffer uptodate state to decide whether
the whole folio can be marked uptodate.  Keep those folios on the old
full-buffer path.

For a folio that was already uptodate on entry, the commit no longer
needs tail buffers for folio-uptodate discovery.  The copied range has
already been processed once block_start reaches @to, so stop there and
avoid the suffix walk.

Fixes: 7ac67301e82f0 ("ext4: enable large folio for regular file")
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org # v6.16+
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
---
 fs/buffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496e..c8c41c799030d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2096,6 +2096,7 @@ void block_commit_write(struct folio *folio, size_t from, size_t to)
 {
 	size_t block_start, block_end;
 	bool partial = false;
+	bool uptodate = folio_test_uptodate(folio);
 	unsigned blocksize;
 	struct buffer_head *bh, *head;
 
@@ -2118,6 +2119,8 @@ void block_commit_write(struct folio *folio, size_t from, size_t to)
 			clear_buffer_new(bh);
 
 		block_start = block_end;
+		if (uptodate && block_start >= to)
+			break;
 		bh = bh->b_this_page;
 	} while (bh != head);
 
-- 
2.20.1
