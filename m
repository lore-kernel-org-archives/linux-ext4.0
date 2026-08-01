Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05D03AE713
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 22:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785621693; cv=none; b=GspXaGO/8AcU0HJfvGvWkTC1tqNvv9xxQNeq5IZEDx2OUDnDNgv1XfmJmD++9o4PGghOvL10XxjGjdGFkO2D6Kmh7mXE4N4ztYFDUVQXxA9603IdXfQacnDK74LQ/VnStO/ktwmM/RH/8GV79iVDo7Xf7pA9nLcdIrsG3wd8fI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785621693; c=relaxed/simple;
	bh=njsuMFgQW9XgoUDzJC8DUF4aImr/QOgd49oen3uWUEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5esuYH39gy1wwap4DJSosoMe/GdvAirjOCcCbjMOnxMwhPKjMv5gytoFS/B4n5TTu1x7xispkzLhaMULIkXElESVAVWVvPJPBZ5ZD20g4r3vQj+T+aLkB5ipsLe8lu5/WAViURBfuGOUS/b1isWPRCBb/CaDOzMhi9/I0ABRoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GMURzrMd; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMURzrMd"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81e6f2ee60bso42983437b3.1
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 15:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785621689; x=1786226489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nQgNx97XjQWdnRUlGoDKYUMjSoMBL5tDz0tOo1NQ/rc=;
        b=GMURzrMdQ+0fCw3lI2AlYxm2541TapXakDa4FRTLpuF9BBkzpyEeoJXFKdW6YwWTIX
         yFl2b5Ai4tPDsQWM1420067C7pIVz/ho5qyqdpyNZMHQMNhGUb+VGPIcjfLJgtGuW6i6
         wFlKnOlTMQY1AX6TOHxlJWAPONXvwFfSMzL+Brx2S22U9Zdng1JIjq6wwkGuGiovpcC1
         L1dCTBpUiSloYeMTRMPc236X34icQBnowXCsHv846XBzdnXCROvUnjoaJqsUwoklM3ym
         7/AK1Ub/6dJ01t7/EqyswYFx1Ce3Q73CvXd38rVyZNmOOxnkZ3QHIox2onpR+o1GoEfA
         7suQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785621689; x=1786226489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nQgNx97XjQWdnRUlGoDKYUMjSoMBL5tDz0tOo1NQ/rc=;
        b=HwfdPJfgt9bslsYxp8usxMrmzGo+h+LwMfll7oXBk/wllRSrtAMPIc59wEzoRWTUad
         M3DziPn4ZV2GIuv7L2oreeXMjjtKbbdCQxb3CLmAf3NicoVyq3f2p5+xMXucYuAdMlyU
         JdNsNKBJZjeWFY7al6UjmSszAYW0qkRsL10lKxvfZs51RQJFzMvqCwV8q3tIPKST9vg9
         tHcF9QZLWp5ZUOvqRScidIXeRxrrgNTParLXSMf9omLTcvUA/apzRev0KNAl/O/FyyYH
         nRxu3RsiNfn2Nqa7UClwtGHDVoXzYbYAkkOgpILjL6yoaEumz7TOdUWCU4ZGEj1i3MqW
         I2lg==
X-Forwarded-Encrypted: i=1; AHgh+RrSweZs5NgimBy4gDxgxI/k5wNJDfC48Sna8mJLMQX5zqMIu0UwgfsYMDlNafxQYgJOY0T7MsbEVx+d@vger.kernel.org
X-Gm-Message-State: AOJu0YyWpG4lSqG28QCGa6QKeD2GWtpjJgNW8qsdug0m8bWC2XrausxY
	PH2WX5W5mXtHHCD8UCF9AQGkZS2lhCujDiCV/Y4ifIf61/vY56euvVmD
X-Gm-Gg: AR+sD12P9jDM0R0tuPZpq2cvlS1e/Gbs3E8GtT0UBOLInZTAZnJhTy79WobW/NvQHnt
	oWT31+rWFFf4Qi7wyYYAZQw/8AxrAQypFd+nB4ufbDCMmlgfabGAPLQvHDikYD1oydjI9PZd7C6
	kfrBn72+X5pexKeT2ii9IdAUu20v6XdByZM0JpiN/c0/nl8zEIbpje4i0IMLSOwpBRPRM4iSuOz
	hj+x9oMS30rNItl+QSpnmYBZFEjjf0LT65npdy4ch/O1W0wyS3jAOaDi+7ds74NHzZH5rtqpdSI
	YsNO6f4nJCtZ9szv4CXwnAUyXJlRg0/ovui7FfL01Hm9YIytOEN4ltHRdj1LVKmPQW/TJ/4DZ2g
	ddPhpjv8qsJWrUHvE8Akmg6dVl7UuSiVuKFfeyqPWV9NBZRr1+Gv5VLXBaJ+bE3f+O8GBQswmes
	D+/KHggXcsfYP7TXTFuRvhguSUMBJ2nLcDI11zDj+7tgFDdMiYyZC8w2JHn0X/uIck5QVp2PmCX
	bLK/iefPcqwy8ckvQ==
X-Received: by 2002:a05:690c:e3c6:b0:81f:69a:3739 with SMTP id 00721157ae682-81fcbd4e504mr95002497b3.18.1785621689541;
        Sat, 01 Aug 2026 15:01:29 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fcd0d6fbbsm29903767b3.25.2026.08.01.15.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 15:01:29 -0700 (PDT)
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
	linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Chao Shi <coshi036@gmail.com>
Subject: [PATCH 14/19] ocfs2: check for a stale write error before reusing a metadata buffer
Date: Sat,  1 Aug 2026 18:00:58 -0400
Message-ID: <e63c15e7001fea3f83e0a0aed1512224832b8b1e.1785621505.git.coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785621505.git.coshi036@gmail.com>
References: <cover.1785621505.git.coshi036@gmail.com>
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
is cleared under the buffer lock when the buffer is submitted for write
again, so taking the lock and looking a second time avoids turning the
filesystem read-only over an error that a concurrent rewrite has already
cleared, while keeping the common case lock-free.

The code in this patch is Jan's, from the review discussion linked in the
cover letter.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chao Shi <coshi036@gmail.com>
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

