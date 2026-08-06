Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8CE48A2CC
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035606; cv=none; b=ZTUqxIpdP6EQBj3DiMcuAGp6+zWh08ltHVadq0KFHrbPRbdkYIy/t7YbQLuco/kM+3uTXJCbViZf+O3DNUWThhjZnSywTm1ULTUv9Xcyxk4It7Zp+Yx2nha4X6PoaAG0sBcK+BLNHyOkBZTKC9CVbCRI1QkLDYn+Dk7SqXxU9AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035606; c=relaxed/simple;
	bh=0Xc44NcsBrwibOoz0erVurOyZIpK7szMhrJzMbzCwzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVvtz3FY18xFNu8Ih8D8fhQE6UL8PZLAK4HQp21JI26IujJS6RuBG6IIQeYLz81yMTd5djkLDollP1aQZfUjWZBAVkrs9MUnVR8XlqSwUKXCgFLAfngNlIIL32Cuwg1zCzZmNval4CW8PbqheOYRJn0DwMg+vWQR3it/0NFCCuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q0YZKXQ1; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q0YZKXQ1"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5c38568d9e1so883705e0c.3
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 10:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035604; x=1786640404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=strVwQ0MT1DlcADT982qPWz3+mjqKycZhsT3ISgkZz8=;
        b=q0YZKXQ1P/RE2QS5L0BG0JRBDW2ZaYAqxHt0h8DPluGopl0qTilJWD4RJuupSUm/R0
         eIF8/cINMoy9kCJ5Zlk4NCT6a2mI6pFHC+oNsPVyVMywN0X+ugOvwUua5ZgXoiAMSRyj
         MIgCUjBsij4a1X2YtQnSSXgN47E5jx0vEq/Xk02DlCZcu/ANijOmjdJ6fl32pToDGBLg
         spNG84PaPJQV1O8jrDk4/beLjZIc8hrnkbwJ4SAA1Y8i+pzvH3rag5NdisG9BmCYzaQy
         Kek3m4d9h/QwNFmQj/9/OrJJisM1jedUR0BL4xFV5UHT+U1LZHOg9dxzvX7XPrC95mGA
         d6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035604; x=1786640404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=strVwQ0MT1DlcADT982qPWz3+mjqKycZhsT3ISgkZz8=;
        b=TxXZRoW8c8DckCyOFrf/GPgnV9Q5bxOSvCigVvVQFTnlmcZOP4yQpBrviwDFJSQOZR
         tZapxJoiIK4n0+y7P1yIHaqok2ie/lbbcJ5c1jwuiOFKr1pgQhwbkzzccp0TIAMy42J+
         sjvMIA+vq9wvmgWvOvLifcryDsRcNn+aQoJ8VSLSxUPuY/mBO7yo0YodVRXR8k7/Up4n
         nELX0s+AYaQpxbU7vhNt4XkO7g9PSUamDwm62rWY8FMxQ4KXKOLfP+u6PDOIhXskkLwm
         8ZX/2CcmjHbmHrb3xVGnRn1pOcZ8FAPFMiZA2VYyVu1AoC58p4KtO+4N8EYPX66G5uHp
         IIag==
X-Forwarded-Encrypted: i=1; AHgh+RorpHrrkYA4kll7KpyFnSKBZTHmSBAm4CgnixmvgdzbVZC/B66/b41eg3tZ4hE+mA4vr/bf3D2F6ytP@vger.kernel.org
X-Gm-Message-State: AOJu0Yym2ZIm87jGu3Dy0jcGxapbPJynxgEOCNi0gAKYUP3AR/hiWYai
	jd4AV7pEPA+xZDbeKmayR1kqQ9cZmJY5MtqhwUBzN6yRe1glFN7K7hYS
X-Gm-Gg: AR+sD11dTqE9NSVk4hLneiCH6egewQ8a8puRjpmW/lgNbYCyKFOaxdv6Jv62jqMpXko
	L2/GWCY4OltJVQT3HwqYwSTxVsvXU1hzi1tREqZ2IJXxN+xHfeOTezzqs4rGILS6u7ha4mkQL3x
	8eM3ofydZi1Qs3xNnh8KhH7aVagBhMByS22ISXEES+Mn1BaPSV2VRGIf0su8NM209rHNpCLDqBY
	YKO55/dqPHgXKDHB1VmnRQ0QwfqFAAJUFarepfBSLpArQgF9uoC6x3Y8Jx3xBxhSGdNjC8asWig
	hYtLxHutaXQ9/jgvbzcWz1MPJ7iiZ8VWYdPJUzF4hdMfQ5kEu9iQhPC516JcUaC9MCNzgznp6xg
	1xqUGDScd7fh2I5Pw5KFRQiW+01pGCKV2GI3XKbBr+S+Lm80ZEHCPTKruWFnQRTlrnQgJHtTLqY
	Nha7HMRfXYWvEEXpk/u+BmS9hNu3ZMWyhV5QWCKd6pC+9A9mCZXn3dM+3+Yq5AdwpMQ1u+sA+YG
	4Mmlac=
X-Received: by 2002:a05:6123:2c7:b0:5bd:faa8:74e1 with SMTP id 71dfb90a1353d-5c3d92900f0mr2225801e0c.13.1786035603729;
        Thu, 06 Aug 2026 10:00:03 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.10.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:03 -0700 (PDT)
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
Subject: [PATCH v2 17/21] jbd2: report journal write errors with BH_Write_EIO
Date: Thu,  6 Aug 2026 12:58:40 -0400
Message-ID: <c700983eea955429d927791fe5fb9ffe6cf11056.1785951556.git.coshi036@gmail.com>
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

The journal's own write completion handler,
journal_end_buffer_io_sync(), reports a failed write by clearing
BH_Uptodate, and the three places that wait for journal writes look for
that.  This series is removing that convention: a buffer whose write failed
still holds the data that was supposed to reach the disk, and saying it is
not up to date makes callers rewrite, re-read or WARN over data that was
never wrong.

Set BH_Write_EIO instead, with mark_buffer_write_io_error(), and test it in
journal_wait_on_commit_record() and in the two commit-phase waits.

The handler stops touching BH_Uptodate in either direction.  Setting it on
success was never needed: every caller marks the buffer up to date before
submitting the write, because a buffer with no valid data is not something
you can write out.  The local flag is renamed to match what it now means.

The two changes have to go together, because commit phase 4 waits on a
mixed list: descriptor blocks are submitted with
journal_end_buffer_io_sync(), while revoke blocks go through
write_dirty_buffer() and land in bh_end_write().  bh_end_write() already
sets BH_Write_EIO, so converting the consumer alone would keep working for
revoke blocks and silently stop detecting failed descriptor writes.  With
the handler converted, both halves of the list report the same way.

mark_buffer_write_io_error() is safe on all of these buffers.  The shadow
buffers from jbd2_journal_write_metadata_buffer() have no folio and no
associated mapping, so it does nothing beyond setting the flag.  Descriptor
and commit blocks are ordinary buffers on the journal device, and marking
the journal's mapping with the error is what write_dirty_buffer() already
does for revoke blocks on the same device.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/jbd2/commit.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 0c85af91f9b2..cd7ef783bd36 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -32,14 +32,12 @@
 static void journal_end_buffer_io_sync(struct bio *bio)
 {
 	struct buffer_head *bh;
-	bool uptodate = bio_endio_bh(bio, &bh);
+	bool success = bio_endio_bh(bio, &bh);
 	struct buffer_head *orig_bh = bh->b_private;
 
 	BUFFER_TRACE(bh, "");
-	if (uptodate)
-		set_buffer_uptodate(bh);
-	else
-		clear_buffer_uptodate(bh);
+	if (!success)
+		mark_buffer_write_io_error(bh);
 	if (orig_bh) {
 		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
 	}
@@ -169,7 +167,7 @@ static int journal_wait_on_commit_record(journal_t *journal,
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
 
-	if (unlikely(!buffer_uptodate(bh)))
+	if (unlikely(buffer_write_io_error(bh)))
 		ret = -EIO;
 	put_bh(bh);            /* One for getblk() */
 
@@ -834,7 +832,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		wait_on_buffer(bh);
 		cond_resched();
 
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			err = -EIO;
 		jbd2_unfile_log_bh(bh);
 		stats.run.rs_blocks_logged++;
@@ -877,7 +875,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		wait_on_buffer(bh);
 		cond_resched();
 
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			err = -EIO;
 
 		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
-- 
2.43.0

