Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB701372EFB
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 12:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780920107; cv=none; b=sNFeNN5L4XNOT2N1+bhoWEoNeomm2wX7Gtn9NP38kSIld81bI6O8no8OHi0eNvNTv7kwvM/RftAoatDbXvXPjlIHvmnDuM4tuU0AJ1AkSN46ZCkKDGgYDwcssqRX5TV8izesVrpvgg3YaLcJ6dMHJQ4zdOAe4GNZyXop4mzdc3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780920107; c=relaxed/simple;
	bh=wxWvBk5S1GNJR6O3oCaVFUg2J3fD8SJG2heZUJAWFTw=;
	h=Content-Type:To:From:Mime-Version:References:Subject:Date:Cc:
	 Message-Id:In-Reply-To; b=PnWVnr9HCJG/NYzJV42byw52ckODTUfKC0xUeOME+v64fUUMFrTtpvRWVrSyLBRJyMU4+6xr4FGWmzAJ5UrMAIWrxCpoUedqwFoz6HhBA3s38AA3nbYL9dmVqjoX4S9Nx2sNRuvlJXlmLQbEZH/y2poJO+qAYG6J/FwDNVrB/iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lCC1PENW; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lCC1PENW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780920100; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=xSsEgVbAmxGOedx+6CLOAx4Uzox4bh9t0p/Bj6Qx9MQ=;
 b=lCC1PENWQmMgIYaCZEHSdvYzrBxLarYY79F/fyYmpSlIC74dRyFyR2C42mjnpyB4NMn7HE
 F7c+Mf7SCjdtZX/vG6aCsTFWoJdo8QU0V/Q/HAarIYd7dngl19XwRqWZb8yXM/MlkpSRqu
 e97z9MME4SP6+0pSU3K5qIUOJvkfGD/RgF1M6GKpuDuEgRMPfaCXfmU9NfEgJP28YpQFM7
 Lp+zCBU02KFzt8JUfqsDogrkWsFSO+Nes1SpU+APdWsxy7YVwfsR+ZHkJ3FtLbdIPHD9ik
 rpAWdC6kMeh0yITkdQkt8FK/vwotxrxnIMPqgwttJtluHhcsyDbFOduIF93A3Q==
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>
From: "Jia Zhu" <zhujia.zj@bytedance.com>
X-Original-From: Jia Zhu <zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
References: <20260603134800.25155-1-zhujia.zj@bytedance.com> <20260608120131.45146-1-zhujia.zj@bytedance.com>
Subject: [PATCH v2 1/2] fs/buffer: avoid tail commit walk for uptodate folios
Date: Mon,  8 Jun 2026 20:01:30 +0800
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Lms-Return-Path: <lba+26a26af22+2b5445+vger.kernel.org+zhujia.zj@bytedance.com>
Cc: "Matthew Wilcox" <willy@infradead.org>, 
	"Alexander Viro" <viro@zeniv.linux.org.uk>, 
	"Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, 
	"Baokun Li" <libaokun@linux.alibaba.com>, 
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani" <ritesh.list@gmail.com>, 
	"Zhang Yi" <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Jia Zhu" <zhujia.zj@bytedance.com>
Message-Id: <20260608120131.45146-2-zhujia.zj@bytedance.com>
In-Reply-To: <20260608120131.45146-1-zhujia.zj@bytedance.com>

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
