Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D376D48CD6E
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035615; cv=none; b=ldqrJ7zNs/pKER2fydyoSONT2FKJQXR3Y/VcJ7IyZyPSBKE1V1XtICY5lWyqm3j0rgbUtRCwQsLL6vp2ocycnESEi/wDKZu3XXCYCQA/VRgVe1io9smkTtiy+q5d9btf92Jkj+VbYXR54jd4S4CPvoIvzjhrX/yP+stVxYuRt4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035615; c=relaxed/simple;
	bh=K9/W1FO8N8xTnhyFws4RenGjtbgDOPBPnEUZbmmiB0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3Lj9wHno91c1+DkN6tkd6WoUTW7uBNYFrT9Gv50Z5sFqsmumX8nIdgTcxZ0/jtL1iuakDYE4rR1bHP95wsjPeZiUCyuYJDhO7SEmFKB4EZCtgdu07369R39I7wV7PrGkL9iENN2C3s0RU5EpNY4BMAUTyHkNkDLJY7dUV0rnw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DYMymKr9; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DYMymKr9"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5c27e38ee18so1234342e0c.1
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 10:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035613; x=1786640413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dBfFE9yENSRT1Ltqp2iNdGevVOH72zBv0XCWLRoCCcc=;
        b=DYMymKr9iJ0MfWNFmHTMcDp+vfbmJcVQ4S81aC4XPOGI5fJYig+5tGL9yuQ7IjHb4J
         5fjgTj8DJ/MP2ApXWr5CxtfH/jEotJgLkxPkTflbko7TdRb/yUmI1lZlVCGtpN3mG86k
         GsKAHGU84ajwLE1ch2hnLPfL66yAj44ebPDrkLC3IBGK+BEzh9HiS8kuotGS58UNR6Ff
         8f/3fcEDC9jjcRSwGDq3fqLEVNyjKQNdllgRt5DjatQ6RDeoLfb+VS3S0TVmD74Ye+OZ
         vUW/74/GKVa/mnu6Gv8OV7cbDAWDVC03WSNg98YruRvqahYi/g3Lg6Pbj52sND835+Tp
         u6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035613; x=1786640413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dBfFE9yENSRT1Ltqp2iNdGevVOH72zBv0XCWLRoCCcc=;
        b=COIg/nCvglIRe8/dY1h9cXKJaQ+TBkGutxl7BXpxVuyx+dwODdXitO7qckpb4fIwqu
         338pCalYWbqzLUEUe/hBfEFvsnCitiU9zIzbjCEnWE2xwV1VHKTxkz1Ur5PlP7rRyHEa
         iZis5HhKSEOwmvHV3I8Ix0tEFPgRSfWYhxKJFvqv/CnO3Wi+dQ5C4FbcpTojjiN2G0UQ
         Gd7yGLetolMAYmUdqZC3fjdo+DJqwPP6N59moymLrYhuwGEyX3XjIACsTghdQtoOXiLq
         I5Hkjf5tGFqxqs6BVOHvti023kVtIgb1yTd9qH0vic+wH21dYzLUbAmQT2EpgV7sDkw6
         i24A==
X-Forwarded-Encrypted: i=1; AHgh+RoVU2licm/7raXkcFbGiyKyQBfkbJnnDVbRW0ru/A6kdArdbxLfLg4HZHL4HfrksPEoqCXXs28Yx3EA@vger.kernel.org
X-Gm-Message-State: AOJu0Yz09zDzRXl8BE6zicKSvLe+3119R8kbRFxnOHJub8/Qr1zXjQFN
	k78ljsi2WsT5frPNufNP6Fev1FO48s+4h42eBNnmhu3z8K/drurHw8D4
X-Gm-Gg: AR+sD1087mHdFIIZqw2uqSjjYQ/yeC+ab12jvr1ieXxPQVQfFAwX3pooscI1/TlItBo
	UOFKU/jspG8kfrHzDzvOxLENCMAKGGh4ePUxUmBfD1JajSViD1tveW4GZy+18l55MuXLpL+BYdc
	LW7hInMDST9J6E4bLDq9hAu54DsEbPlkkicrx3lmB5bKxuPoGAXLa99VlgoHX/Py+L/Uu7++P/r
	c3pQTUugOZPN4VirI5Xo206tx+lQifrysY2dobgj/+2YQ+PDPg2Y5kMHQw6GAJ2ZVioLJROa8Ua
	jAT51dkoLkxI81a2DR5q9hVx7K3YmEGb1IQ5hzVRKuejAG8P4ltOC768stVnaMggWp/aImIkKKm
	fQW/YzBBfuHjrVHhhRPlwpdT8AL2PQJq331cy7lnkI6LOUxnvvm/BXYhg+Tg1/5kjRO9e5D0MRF
	cWidLgoUq/oHXGOGbSyrK0Q+3LLtP/rbxzKhzjh8R07EmDs8LyHBBcAh28hc833qcgI4WsYGit5
	jqg+44=
X-Received: by 2002:a05:6122:d96:b0:5a4:7e8b:3171 with SMTP id 71dfb90a1353d-5c3d91e6c7amr2524108e0c.11.1786035612662;
        Thu, 06 Aug 2026 10:00:12 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.10.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:12 -0700 (PDT)
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
Subject: [PATCH v2 21/21] buffer: clear BH_Write_EIO when a write succeeds, not when one starts
Date: Thu,  6 Aug 2026 12:58:44 -0400
Message-ID: <1c976fd191aa6e99dbe65d6a1ec63f8706cc0dfa.1785951556.git.coshi036@gmail.com>
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

BH_Write_EIO is cleared in __bh_submit(), when a buffer that has been
written before is submitted for write again.  That is early: it says the
error is gone at the moment we start trying to fix it, rather than when we
have.

It also loses errors.  A task whose write fails sets the flag and then goes
to look at it; if another task redirties the buffer and resubmits it in
between, the submission clears the flag and the first task sees no error at
all.  Neither of them is doing anything wrong.

Clear it on successful write completion instead, in the end io handlers -
the same four the rest of this series has been converting, plus gfs2's,
which already marked errors this way.  Then the flag means what it says:
the last write of this buffer that finished, failed.  A resubmission no
longer hides an error that has not been fixed yet, and one that has been
fixed clears the flag when the data reaches the disk.

__bh_submit() keeps setting BH_Req, which is what the rest of the tree
reads it for.

Suggested-by: Jan Kara <jack@suse.cz>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/buffer.c           | 15 +++++++--------
 fs/ext4/fast_commit.c |  1 +
 fs/gfs2/lops.c        |  2 ++
 fs/jbd2/commit.c      |  4 +++-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 425fbfe72ad1..68ea0ef8470e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -202,7 +202,9 @@ void bh_end_write(struct bio *bio)
 	struct buffer_head *bh;
 	bool success = bio_endio_bh(bio, &bh);
 
-	if (!success) {
+	if (success) {
+		clear_buffer_write_io_error(bh);
+	} else {
 		buffer_io_error(bh, ", lost sync page write");
 		mark_buffer_write_io_error(bh);
 	}
@@ -433,7 +435,9 @@ void bh_end_async_write(struct bio *bio)
 	BUG_ON(!buffer_async_write(bh));
 
 	folio = bh->b_folio;
-	if (!success) {
+	if (success) {
+		clear_buffer_write_io_error(bh);
+	} else {
 		buffer_io_error(bh, ", lost async page write");
 		mark_buffer_write_io_error(bh);
 	}
@@ -1114,7 +1118,6 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 		enum rw_hint write_hint, struct writeback_control *wbc,
 		bio_end_io_t end_bio)
 {
-	const enum req_op op = opf & REQ_OP_MASK;
 	struct bio *bio;
 
 	BUG_ON(!buffer_locked(bh));
@@ -1122,11 +1125,7 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
 	BUG_ON(buffer_delay(bh));
 	BUG_ON(buffer_unwritten(bh));
 
-	/*
-	 * Only clear out a write error when rewriting
-	 */
-	if (test_set_buffer_req(bh) && (op == REQ_OP_WRITE))
-		clear_buffer_write_io_error(bh);
+	set_buffer_req(bh);
 
 	if (buffer_meta(bh))
 		opf |= REQ_META;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index a2028fbd4540..95998827ff01 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -209,6 +209,7 @@ static void ext4_end_buffer_io_sync(struct bio *bio)
 	if (success) {
 		ext4_debug("%s: Block %lld written",
 			   __func__, bh->b_blocknr);
+		clear_buffer_write_io_error(bh);
 	} else {
 		ext4_debug("%s: Block %lld write failed",
 			   __func__, bh->b_blocknr);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 3df6e4b7e8b9..7440e5b72f8a 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -179,6 +179,8 @@ static void gfs2_end_log_write_bh(struct gfs2_sbd *sdp, struct folio *folio,
 	do {
 		if (error)
 			mark_buffer_write_io_error(bh);
+		else
+			clear_buffer_write_io_error(bh);
 		unlock_buffer(bh);
 		next = bh->b_this_page;
 		size -= bh->b_size;
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index cd7ef783bd36..ebf6ba58ff4d 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -36,7 +36,9 @@ static void journal_end_buffer_io_sync(struct bio *bio)
 	struct buffer_head *orig_bh = bh->b_private;
 
 	BUFFER_TRACE(bh, "");
-	if (!success)
+	if (success)
+		clear_buffer_write_io_error(bh);
+	else
 		mark_buffer_write_io_error(bh);
 	if (orig_bh) {
 		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
-- 
2.43.0

