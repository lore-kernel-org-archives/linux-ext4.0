Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0217D48665E
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035601; cv=none; b=E7+Cun1MpoymTUn5Mw5GPY4jZsE/mDNtPUt78PFoZbeFVzOhKusHEfIy6UvNf74n8sIoB7aCVQLLYCxiAFm8JPdbIR5tnB/GnfcTqgUAPMNjqz0nJ5PSALqL4iWM6Q12R8T9Hpx0Kx1Ia6n3Fq2upyvplR5mOhh/BMMAbcIw/yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035601; c=relaxed/simple;
	bh=HkO8BGQDQ+F35lZWVjrmgSFoTizhXNL+tmvKt5ZHgXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMdjdpKh7uGVyo6KVJR+0jKMetx4Lwj6HdF8kbA2zlxxAxCF8SF3jQgaTjNhDpgzih4N9wmmofzOi7z2YMMa0v+LHpoDQ/AD+op9jIVYHCfbEeYKCxPa4hR7xQ4+S6nK3zaDXYx25WUwANHZmTC7zKepVS/GBkakeqzxIfcU9Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aWG/QPYD; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWG/QPYD"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5bf9466867cso723817e0c.2
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 09:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035599; x=1786640399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZCchMwHGHYssXWVL8RzH7mG+qMzuQy0Z9sJHAbSWGok=;
        b=aWG/QPYDgObiC5oHwi3r4RGEv8fl5Qqg+vzRkoHqLwL3M7xaao4P1JP+Q0GtXy6kxy
         52iWjvnt0VfQmtTBS3/TJLHn1aKhppIHkVIVFun6gSHoUn65a7CPRiFzC02gx9+q6Fii
         EGb2REQlnMOq9Sl6cYjBvwN/r47X09oUdWMsJbRhyWSOM+kAl6i6BHoH4NJj69ise5gu
         3hUm69dOh1DwFMFvahHUiCt+kdTGuUDIma8DUh3EDwJWBbHFss86RZpMcn19+GPRsBzH
         Tw/924LU6IvKMCbELJARidOlBgfi/kgCJgKsa4BLJmGVrXM643dWAZH9ZV549qqCtXYb
         JMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035599; x=1786640399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZCchMwHGHYssXWVL8RzH7mG+qMzuQy0Z9sJHAbSWGok=;
        b=AWwp5F9G8t9wmRXFZanWNzebZ1+4fv4vk2XMo2q5C4kjaMlIcuxoXZ/rmf6wTZ4no7
         JFRdxpfh2kMHz9IVRPl6e6CvVFDVIyrjpP2Pf4mc+e75e290MgepPPrggEucU091dS1K
         EIXwa2I+jsdbda6CmTYLTAGL9ztts8/VcvSUJIudGYplw4uzht9RvLnFuyAeqO7GXvTn
         kU0ABtuylJ4NRbzL8aBk/oqJDeNb5+O/tZzOUUmBLfZaTON7iVKIzy6v2yCUFH0a9Z+A
         Eymu3Pdj58PdM7PoOsv+FKNYPyTAwETbZ8SJ0YQsi4CNaQg1Cx/PnDOv4eqmlD0Hqope
         5Fpw==
X-Forwarded-Encrypted: i=1; AHgh+RqzvmfIZmgZuMY0XqC5cIS4jf8xmc9sMezTGhLfVRBF/eEWSPj77vfjwNLj4K1NO+OwhcdQTnbcevHN@vger.kernel.org
X-Gm-Message-State: AOJu0YzkGFIL7ftzUdzjU5bypUPMMV0ysDHqMlziteCWVPeSHaZ2dhNc
	SPxM0X2SJzaJuBuwCOr/fWoCOpjr3luSxLn9ZU0iZdND1X45t2ddrIEJ
X-Gm-Gg: AR+sD13vvN6KI1O7X7MEFfZtAvuODkKgHdQlQxDRriwfmKo/zjTKroCUcZV/AddHCeC
	lVVBofLNqZ8cD023K7Nus71BkTVHXG/CoIWiR9aRuUnlgs4tqgr0BDEiJFl1PwPN4foBOLOvK0h
	zt9JUVdCKoxca9KjkKlxyzXntf8tAXd1O6artNGh7sdlQp8fuarTXAuq1gcMu5QZf49A6aMF/wb
	PRDoND/n37Ly1Q2kU8bVyK6LbgwrMid5lUU8ck+k4kuMYgpFgKLxOqK4xD4bFchX+2Hk3/J2cnv
	q17PdPfTN5gBMoXZw+FdxEw1n8NQkUNaTSYmMgVUPfXW6mqFc5Xf3B47uO3mohfD8Br2YdVw06S
	XMYQXzMhiMMHPFTd5DA/gzib47eNde8yI9B2RSH1EKC7RwcyS86Fo/ZCl7zZS9QH9wPeAvU6Xyv
	F+tU5tD9Fn2oVVYuZiUTTpuQ7bnD/uf5bCvv2ioj91yLsLG/gxqzy7Y7BSr2ir3rhr0+XjCx9ZP
	SYVlAw=
X-Received: by 2002:a05:6122:1310:b0:5a4:6680:64f0 with SMTP id 71dfb90a1353d-5c3d9120508mr2112740e0c.4.1786035598926;
        Thu, 06 Aug 2026 09:59:58 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:59:57 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH v2 15/21] ocfs2: check for a stale write error before reusing a metadata buffer
Date: Thu,  6 Aug 2026 12:58:38 -0400
Message-ID: <ad75c40927060cafe5a8ac45ae71c02ae4dfba04.1785951556.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785951556.git.coshi036@gmail.com>
References: <cover.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__ocfs2_journal_access() refuses to journal a buffer whose previous write
failed, and turns the filesystem read-only rather than risk metadata
inconsistency.  That check sits inside an if (!buffer_uptodate(bh)) block,
because until now a failed write also cleared BH_Uptodate.

This series stops clearing BH_Uptodate on write error, so that outer test
would never fire again and ocfs2 would silently start reusing buffers whose
last write failed.  Hoist the check out of the debug block, where it does
not depend on BH_Uptodate any more, and drop the now dead second half of
its condition.

The mlog() pair keeps its own !buffer_uptodate() guard: it is a separate
"we can safely remove this assertion after testing" debug aid about being
handed a buffer with no valid contents, which is a different question from
whether the last write of that buffer failed.

The unlocked test followed by a locked retest is deliberate.  BH_Write_EIO
is cleared under the buffer lock, so taking the lock and looking a second
time avoids turning the
filesystem read-only over an error that a concurrent rewrite has already
cleared, while keeping the common case lock-free.

The code in this patch is Jan's, from the review discussion linked in the
cover letter.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index d8afbc1a76bb..ea6802d894c2 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -676,19 +676,20 @@ static int __ocfs2_journal_access(handle_t *handle,
 		mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
 		mlog(ML_ERROR, "b_blocknr=%llu, b_state=0x%lx\n",
 		     (unsigned long long)bh->b_blocknr, bh->b_state);
-
+	}
+	/*
+	 * A previous transaction with a couple of buffer heads fail
+	 * to checkpoint, so all the bhs are marked as BH_Write_EIO.
+	 * For current transaction, the bh is just among those error
+	 * bhs which previous transaction handle. We can't just clear
+	 * its BH_Write_EIO and reuse directly, since other bhs are
+	 * not written to disk yet and that will cause metadata
+	 * inconsistency. So we should set fs read-only to avoid
+	 * further damage.
+	 */
+	if (buffer_write_io_error(bh)) {
 		lock_buffer(bh);
-		/*
-		 * A previous transaction with a couple of buffer heads fail
-		 * to checkpoint, so all the bhs are marked as BH_Write_EIO.
-		 * For current transaction, the bh is just among those error
-		 * bhs which previous transaction handle. We can't just clear
-		 * its BH_Write_EIO and reuse directly, since other bhs are
-		 * not written to disk yet and that will cause metadata
-		 * inconsistency. So we should set fs read-only to avoid
-		 * further damage.
-		 */
-		if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
+		if (buffer_write_io_error(bh)) {
 			unlock_buffer(bh);
 			return ocfs2_error(osb->sb, "A previous attempt to "
 					"write this buffer head failed\n");
-- 
2.43.0

