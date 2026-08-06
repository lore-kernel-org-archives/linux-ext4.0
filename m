Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A918481235
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 17:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035611; cv=none; b=EjdlcPwZNr8bbYoIN/Ia34ypdWyAGdzmTgyn4nB06F6MT7oRmQHq+wlsl1nYPEpecL/E+hwAm+sRePiQw9Su4gFt0aZwiLkRaAVS6/sC+1FHwQ+Dpp4WNT7DuLwqZDRmLidM8sw5P4HnFsVvxm0dQ5mMznQKjJ2GvKZ3HIRRxlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035611; c=relaxed/simple;
	bh=92j6zzfTbfyHLTwkDGD6bYfpfzSkLDZ7TK79qat2c7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5o+X1Glz5hvfOodaucg4j8gplQ1KeiX5G8IYpl6RtcCrf42g76ksfVTdW8j6tpref+/JVhGGz1OGrpCSWqCPN5GVmkhAfdqTGwztBUZcBAhvY5NRlrtzJQ01mNb1h1Y8c3V1ab681YI9bYNxT2LODCcA7RUx4oT/YY/TwJIxp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VXHWA5pY; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VXHWA5pY"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5c30d9adfa7so872147e0c.3
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2026 10:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786035608; x=1786640408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y0IvqThbFa3F9XFl8mEQfcRObacw4VhqXeJ5e5/Q63c=;
        b=VXHWA5pYllrSyJHP+Y1cW45sd9QyBnAXJFHXXQW3HsvtWFj+dNMk1t5z/PNZv2GDmT
         nBTs3sjvl4rowBP/1xgGEKnsdNQ8bxw/RrPisX1RGIsyT+BlmaCaI2UGD1RtXFSM/Vah
         eANb+YT/p99zHQuDGCef2a8qLpO2F3wCIl4QQaQ+1FQY3TkLt+cFPg+zQlyNJvCBvHPV
         vP9uBEFxZ1j2jmX/5lhIDi7Zlq2+jVeeHUR4G/1GhM9TPxPZN4P5V21YXug8kkc4GiIy
         oKmZ0ItaiS4P2YT5zc53QlpmMb+igjjNpFcYZ3u53z9QmaJNwgLukVF5+d7858rxPp95
         cD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035608; x=1786640408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y0IvqThbFa3F9XFl8mEQfcRObacw4VhqXeJ5e5/Q63c=;
        b=o1oNlxYtDke+xPqSN8Spn7w5bg1B9f85oQQtgxc+kYwiCGyYTAYbySDuwPdgJuupAK
         Hj0ow2jcgSMgwXkdLfTeOmiVkqGonu0HvrlnwVLEfF3grbtDZg9Ah+m1nuFf51yMaJCp
         0U8IuAKJG5uKxv+iq1oRkIOU6AF/hel0QAgus6qCcx21VZLNAJexvdY0D60bh90vRa0k
         EEhfZPw9obq4ETyrBchY7aJJzFuyque2+x7DWphYt5E0Ri99UbQAI3y6g1NfrVtM78pg
         c5Ka+kVNNgozJtewQWALmxj8f8ePkmtMBii4W5CbBHdqbGAdcfRf+oSgIiEYJU1tTyPP
         ZQFw==
X-Forwarded-Encrypted: i=1; AHgh+Row2gDR/KT4doUNxRSugi52u/dt2zwjKaNjK18aWORvU5/y+VPa45ETkZFYgpCZKa7TS01TSfsY3rbi@vger.kernel.org
X-Gm-Message-State: AOJu0Yys1BvdIgtrsyRYOy+bH8ndWAKL3WcGsjpOcI98thhZT73lvIgr
	SQr8LpohyAxjasQDJUpVcLG9AzCCYZ73WgoFcnUBXhlEeCjry+nM/Ba/
X-Gm-Gg: AR+sD12YEixAjI8kk2mZU+ljP810t4RHTLbvxp6qZZC60RbozeglgitrEUytS87hZQZ
	pJdcWe2HMP2aFtrJ9kXqkKmXpgT8SvgeP6IYHGa/S1CSU/UplO0yeHx+l9HnRiXx52OqoeOCU7j
	HQMoNRY6eZoiVJ1aNNUxwm4MpXz/A1hKiBy+R1l3LD3DDvw7DdBQlpr+4rQpHNBh0gfcmk/Z+vK
	x52XGFokbG4pwG0HaTXfKbIswt2V8OIrZpT/hzBsBz9rbx4lw6bDUsN4UuRRa4iqmGVI8LpDoKZ
	+bUOwLhdo90ZijUIZU/8JFnZ5E+l0XAr8SyOd23XtqKFin2N/WGqpAU6nvfOdSbOWQct93l9VtN
	/f0UMkx1HzuZ3+Y+wrnneA2w+go7fkISuDMWknXApQEMKw9HGaofHzHgEpHMY6ifIdICDkv0hwl
	9nLfkUEloi3GCLi/vgGgDmyBTJdJ+HnABcyQ3wHqGVlKtVyZbW2waJgoz1BKgyYNb3ZSSX4zp6b
	OCOlxo=
X-Received: by 2002:a05:6122:390a:b0:5a2:5c65:850f with SMTP id 71dfb90a1353d-5c3d91f3c3cmr1985318e0c.10.1786035608151;
        Thu, 06 Aug 2026 10:00:08 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c3d05c594fsm3706321e0c.8.2026.08.06.10.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:00:07 -0700 (PDT)
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
Subject: [PATCH v2 19/21] ext4, jbd2: report fast commit write errors with BH_Write_EIO
Date: Thu,  6 Aug 2026 12:58:42 -0400
Message-ID: <970d8b9603d4620ab73038f49bc36831e37e00a0.1785951556.git.coshi036@gmail.com>
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

ext4_end_buffer_io_sync() is the third completion handler in this
series that reports a failed write by clearing BH_Uptodate, and
jbd2_fc_wait_bufs() is the only thing that looks at the result.
Convert both.

Like the jbd2 handler, this one stops touching BH_Uptodate at all.
ext4_fc_submit_bh() marks the buffer up to date before submitting, so
setting it again on completion said nothing.  The local flag and the debug
messages are reworded to describe the write rather than the buffer's
contents, which the write does not change.

They have to move in the same patch.  The handler lives in ext4 and
the wait in jbd2, but neither is used by anything else: the buffers
are ext4's fast commit blocks, submitted by ext4_fc_submit_bh() and
waited for by jbd2_fc_wait_bufs().  Converting one without the other
silently disables fast commit write error reporting.

Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/ext4/fast_commit.c | 11 +++++------
 fs/jbd2/journal.c     |  2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 8e2259799614..a2028fbd4540 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -203,17 +203,16 @@ static inline void ext4_fc_set_snap_err(int *snap_err, int err)
 static void ext4_end_buffer_io_sync(struct bio *bio)
 {
 	struct buffer_head *bh;
-	bool uptodate = bio_endio_bh(bio, &bh);
+	bool success = bio_endio_bh(bio, &bh);
 
 	BUFFER_TRACE(bh, "");
-	if (uptodate) {
-		ext4_debug("%s: Block %lld up-to-date",
+	if (success) {
+		ext4_debug("%s: Block %lld written",
 			   __func__, bh->b_blocknr);
-		set_buffer_uptodate(bh);
 	} else {
-		ext4_debug("%s: Block %lld not up-to-date",
+		ext4_debug("%s: Block %lld write failed",
 			   __func__, bh->b_blocknr);
-		clear_buffer_uptodate(bh);
+		mark_buffer_write_io_error(bh);
 	}
 
 	unlock_buffer(bh);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 6e05dc47e20a..72e8ccbf7de4 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -886,7 +886,7 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_blks)
 		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
 		 * buffer head.
 		 */
-		if (unlikely(!buffer_uptodate(bh))) {
+		if (unlikely(buffer_write_io_error(bh))) {
 			journal->j_fc_off = i + 1;
 			return -EIO;
 		}
-- 
2.43.0

