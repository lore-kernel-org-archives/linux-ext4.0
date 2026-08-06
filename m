Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8DC486E72
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035603; cv=none; b=FRGdfZwWvNyrN8n2rt1aVPYxDQpUkTdInq9xA9x/z/WLEEdwPR6kOs8GAXoSMmSx54lSFyr+DyQcvXEnv6bbWLMnQnNF4TW2IaqI8IFlcaI1Vzzioq3Dyam7WxOt7J9zQXl/cbTIE+36LgqPq5P57FIsHeWMCt931y7ut32TZOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035603; c=relaxed/simple;
	bh=MXEWU902YGIdYxhsplvnnMAlAsOIW5B35iOVcX+SwuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p//QKl8FKMNcLeYqZEBS7Tv2u5QRKbDRE1tz2Bb4kZp60BW6HiNSpy8vrnqPYa4Kv6iagAI4I8bkAQFDxiVN/62C83urZuKJ2M/rs18+XC96e0aThxPEb7JwcH+mZTYxvpR/0rgSJQFxh7EIEkMAFfmAwlB4tE43XmXqXMDdmYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CeaUzuYS; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CeaUzuYS"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5c375a9e76cso1469005e0c.0
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 10:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035601; x=1786640401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dTojca6QcAoa5sJYmeZWsS9cCWtcJ0fPl4l3Xf8SOVQ=;
        b=CeaUzuYSQ3enDOlK1H7lHo3zY4g/E5FMxkIobVwsLT5LdMUU6mjXlBLjOG1Z6BwVD1
         yOIG/XpFLgEZgRgxXr7aTcIwlP8hftYPuuD7I2qv/Uakt3gsJe3uh+ubDvfDaVRZvBVr
         kmzjUh9Is3a6uAMM86MthWTkjeK3REUYk7IvawYEx3k4aphnHv1dEflZdNxP8cqgI+zj
         1lRpNAHWrwU6eNdDgHn6gQJZ32Yzpu5uujZ51SvxVsW8HgBIHynr44GG/R5rcz9pqusy
         FEErmqp0a4wzYCgJtsIbxUnI7jXpwH22ggp2hJDFAhzdS6jCtp0ho9u+SykPnOb5qWhB
         8qHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035601; x=1786640401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dTojca6QcAoa5sJYmeZWsS9cCWtcJ0fPl4l3Xf8SOVQ=;
        b=rAIWVuRx789stKozOnUbLoExZ+DVE9zPCHB+xMwiyuP7duCZYcG9YA9vagkIKETTWg
         KUTRjPKwHpUPfDyvAdXEtRkWOGmJg7Lx09cNeb6g/Hb3rZlcrJokURUUK6NLNqdeWE2O
         pMsMNdrosmCkW7uBg9yRA0JrF+HQX2L3KTI7exYK3QdrXnCdpSh7CvP0GDeCP/JvkbTq
         wQqXQVDwBrWGnHscxawEXyuKT9RFkRpa/4GvZgfz3aYNG6uH4eopb241SPs9p/DCQ6nI
         cly9W8acp2cgZs0oglzL83Jpn/YZXueuTNlD/xLFBBC+ai1JpAjR3NAftf0K3x5EiUj7
         TyeA==
X-Forwarded-Encrypted: i=1; AHgh+RqXNCRETf8JoSug7s8i1aL+KDVJZD/lcoFwZSUttf2X7y5iUGuPW2NRyo0LIj+txt5Rsw+/HyQIrcc6@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6rxJO4D4vkTc9i/Rbzqo74rvGssQFqQBhSoW1iOcm2nAdp9ua
	C9v8GRLPxcBl6YwNtohT279eZKAsQjwBZp50FNE8jmZyWm+wtKPO+/QB
X-Gm-Gg: AR+sD11PqlvPSHUbvp+d3FEBi0yLy/ifROR4z+DbJbBrhf3rEIcH5aP6pMD2Wfv+0zD
	I+JwbD9vlo+CAG32nJjXK9g5SZy5t9UPcefOltEPhz6A9zXtK7gHCVUjKPiJh4QujMxp1xMs2xz
	10LrJSRlKvWkcsLgbflttZrt/C26oPbhHxou91w6wqjZ71saigFfqL5UZlf6/2vBHPcRixqrQGe
	82pzhE25P60Lhvct8qDx83Sp1iSuCqdC5IsGN6t+7p32aUGJ1/XCi1khuqL7xEOgxb5VICjKoeT
	CjU9izVSEdWvoNE4WIAU8mQk36eEHPo4pySOXQ0xDSaUHHEFhnnBTc7mzNnrhPxK8w0R8cLXW2I
	3efFLdTt8vK1naCm25QAFxVvKjoX7tHg9fDJac7E+HUr5ZJkVoFTG5uN0Vm9kZ7jeDF4Y4P+ary
	dBaOgEKsz1kSD9cn+6ACe0EscaPhTPyzgx8zS9Y2qYOsivRaBPjWDswXjISuwq1ZeQ+tzjwU/Ka
	+vNOOw=
X-Received: by 2002:a05:6122:178d:b0:5bd:9c71:11e with SMTP id 71dfb90a1353d-5c3f9eb0727mr555265e0c.4.1786035600948;
        Thu, 06 Aug 2026 10:00:00 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.09.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:00 -0700 (PDT)
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
Subject: [PATCH v2 16/21] gfs2: check for a metadata write error with buffer_write_io_error()
Date: Thu,  6 Aug 2026 12:58:39 -0400
Message-ID: <a09b6d08d31d24f69b833e4d855ed88875e87780.1785951556.git.coshi036@gmail.com>
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

gfs2_ail1_start_one() and gfs2_ail1_empty_one() decide whether a buffer on
the ail reached the disk by looking at BH_Uptodate once it is no longer
busy.  That relies on the write completion handler clearing BH_Uptodate on
error, which this series removes: a buffer whose write failed still holds
the data the filesystem asked to be written, so declaring it not up to date
is wrong and makes callers re-read it.  Test BH_Write_EIO instead.  In
gfs2_ail1_start_one() the test is the positive one, so the sense has to be
inverted rather than the flag simply swapped.

This is not a pure conversion for gfs2, because gfs2 already has a private
write completion handler that behaves the way this series is heading:
gfs2_end_log_write_bh() calls mark_buffer_write_io_error() and leaves
BH_Uptodate alone.  Buffers completed through it are therefore invisible to
both tests today, and start being caught once they look at BH_Write_EIO.
That is a real behaviour change, and it is the one gfs2 wanted: a failed
log write now withdraws the filesystem instead of passing silently.

gfs2_pin() is a different case and gets a different treatment.  Its
!buffer_uptodate() test is not only a proxy for a failed write - a buffer
with no valid contents at all is equally a reason to withdraw before
pinning it into a transaction - so the write error test is added to it
rather than replacing it.

Left alone deliberately: the BUG_ON(!buffer_uptodate(bh)) in gfs2_unpin()
and the two WARN_ON()s in fs/gfs2/rgrp.c.  After this series they simply
stop firing for write errors, which is correct; turning them into
BUG_ON(buffer_write_io_error(bh)) would newly panic on an I/O error.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/gfs2/log.c  | 4 ++--
 fs/gfs2/lops.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 78bba8cc10b8..e3e0dcb1f567 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -107,7 +107,7 @@ __acquires(&sdp->sd_ail_lock)
 		gfs2_assert(sdp, bd->bd_tr == tr);
 
 		if (!buffer_busy(bh)) {
-			if (buffer_uptodate(bh)) {
+			if (!buffer_write_io_error(bh)) {
 				list_move(&bd->bd_ail_st_list,
 					  &tr->tr_ail2_list);
 				continue;
@@ -321,7 +321,7 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_trans *tr,
 			active_count++;
 			continue;
 		}
-		if (!buffer_uptodate(bh) &&
+		if (buffer_write_io_error(bh) &&
 		    !cmpxchg(&sdp->sd_log_error, 0, -EIO))
 			gfs2_io_error_bh(sdp, bh);
 		/*
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 6dabe73ad790..3df6e4b7e8b9 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -48,7 +48,7 @@ void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	clear_buffer_dirty(bh);
 	if (test_set_buffer_pinned(bh))
 		gfs2_assert_withdraw(sdp, 0);
-	if (!buffer_uptodate(bh))
+	if (!buffer_uptodate(bh) || buffer_write_io_error(bh))
 		gfs2_io_error_bh(sdp, bh);
 	bd = bh->b_private;
 	/* If this buffer is in the AIL and it has already been written
-- 
2.43.0

