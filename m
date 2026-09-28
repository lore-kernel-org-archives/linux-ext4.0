Received: from mail-dy2-f21.google.com (mail-dy2-f21.google.com [74.125.229.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189A3C5DA1
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790598565; cv=none; b=J69S1tdv+OEnoMpz9wo4ay8VqAeSgDCRTqw1ltW0IO8YYUSq7PwpEIgDAYUDS1xMkDf+rDTuczIbIts9frP6EGquCt0VF+EKQb+Xb1pG5/+agK0S/2+8gm6kznGeAY24d4hypnA3GYoM6ODPWVWd3B6T7pTJ6iUNBtWP9RhxSHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790598565; c=relaxed/simple;
	bh=j3BOzkVTWmPC5O8cjcPhdTZ8zN0+S10iryI4hlm4ScY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=MIN/nG9SQVPepmgFM1906fwkx4saWopitRCI2ztAi4z4T5r+4CGl+BPt9sUTGB0468p6U8Xl8kbvu4FXcfJQdmecRqLJw4HWEgV3aBMqWZ6xGuGtPkWA5m+2KjK8efBVtEXuwrYSJ+n6fpuH1NnIFIRyIB9NEPNEcV5PT947cOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=buUpnmnA; arc=none smtp.client-ip=74.125.229.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="buUpnmnA"
Received: by mail-dy2-f21.google.com with SMTP id 5a478bee46e88-33e46a156f4so1616594eec.0
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 05:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790598563; x=1791203363; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=fY4cWUdK+H65toW54POWJWqs/zZFvqRSfuZf5LsPr70=;
        b=buUpnmnAym3Gl06eTYq4LbcmfQfP6aAkg+qKGELuMRGkhy/J8WnYx5LlxYhklVwLJc
         PVwYwzLRA7Dogri4M+/T/LxAWWE9NYVgWV08Uw6HFkPyqdINQcWwQBgAhZ512cDImEl2
         2eUN7+rjAfZZCGa12doZMir7VW6RH8UdY2f5P9wanVz4fNjCnBXS3jCLU6sYHmC7EfxM
         X7CODU14VRysLwSCdRIzIuOeYcGmKyMEt3jZ8lc9wlu7exWe+Uqfa4rN+V2YnHXVKmtE
         TTlaf0qT6rPozn18cemSbz1dSHFFag5IeevCR/F4JZsBQA2BOZaOK5m8KiF7xHm3GWYv
         WEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790598563; x=1791203363;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fY4cWUdK+H65toW54POWJWqs/zZFvqRSfuZf5LsPr70=;
        b=fjebX5WvFR45K04jX+w9214XnSpd7i5fyDMCS1l7XVHOhv2VuG/00AWRzwJKmPBuay
         jm7gBhuxQhgFc37XNAGsfr7kzRnQiuVHyQ9IaaGQFioRtSDJDf3OUUaKORwCLtmCbomx
         p+vupt24ONtjmXRC/TiQ++Mim2dSAYk7XnXPO72Xt45RKLO/moxaueAc6RitqJ3ImZYW
         7kXP6iJhKjChM6ginPK1ZpgFLEte0OHRxTZqpR1VqyCNGhngjgZGRTClUyzmIc8oBX4V
         Q5Y++SGVJYikMigK5cr5lMvfbKRLYqGPFpEObF4nqYfkIU2AVOf1cLMl6o3zfUuY/wLO
         QRvA==
X-Gm-Message-State: AFq9FYLMTKB6FmgZQYwaqFAX+fFmcHI7WKnWovBi/7a+nLtAqa/eXpHf
	weOjiDa39fwcbzIbNveRlu/YWZTNFUGcsVboUeyyP8Mtt2PyaiWJ7BUj
X-Gm-Gg: AYBFou0t5FgOCBUyh5k9/1vi0iI5wnJMEx6RUNwXMKwk8g++xtQTMBzJLx8eKQMU7TD
	dVzfL6iWv8dhiyfvumDddv+oUqVDig1A78U/vaZ8YuFzqYRMgj2waAD+/cSMyx30V3G4heBXc59
	nBxcAVUBzz8mmzSVZObXAtG7AWF8MKdWW3Z66i0GiHdiNc9gHQYp4OUD/f/0xVakzbRvzhE4UAC
	OTp15B19s0eM+ij4ZPwaaaluZm0u/ULngzAjWGc9EWZyYQQJNFUFZWI4j2R9Dmn1cfSbDi8w0+2
	ZqxeareWaLsdrC2CTX8+mWveKY/OF5pzpBiHVxeicO82W+50mavCk5l9UAnX99aN4/3XJvI40as
	9U3iibJ9csarmKfKrcrEBZGozdqrkSo/3OW1szPKorplJ//BJ3ww3pHnIid9NyTZpBzHeGc25gP
	ce6w+KY+9CF0K3vSidaqnf4x/SniPTYk5v+PuJqgyUzrs8piYGRc/PrSAlmD1nwVX2mw==
X-Received: by 2002:a05:7300:7313:b0:341:3ca2:de2d with SMTP id 5a478bee46e88-342700bdf94mr13157867eec.6.1790598562816;
        Mon, 28 Sep 2026 05:29:22 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341463ec3ecsm29337067eec.31.2026.09.28.05.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 05:29:22 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Mon, 28 Sep 2026 20:29:18 +0800
Subject: [PATCH] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com>
X-B4-Tracking: v=1; b=H4sIAJ1dumoC/x2NQQqEQAwEvyI5b2CMII5fEQ/uTNQoRElgEcS/7
 +CpqEN13+Bswg59dYPxT1wOLVJ/KkjrpAuj5OJAgdoQqcNZLty+mdBXE93R06So9lI5Y2pC7FK
 OoWaCsnIal+R9GMbn+QPclOHicQAAAA==
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0

The jbd2 checkpoint shrinker's count_objects() callback,
jbd2_journal_shrink_count(), reports the number of checkpointed
journal_head objects via the j_checkpoint_jh_count percpu counter.
do_shrink_slab() reads this count exactly once per invocation and
derives a one-shot scan budget (total_scan) from it, then repeatedly
calls scan_objects() in fixed-size batches until that budget is
exhausted.

jbd2_journal_shrink_scan() never updates sc->nr_scanned, even though
include/linux/shrinker.h documents that "the callee should track its
actual progress" in that field. Because sc->nr_scanned defaults to
sc->nr_to_scan before every call, do_shrink_slab() always believes a
full batch was examined, regardless of what
jbd2_journal_shrink_checkpoint_list() actually did. That helper
already tracks real progress through its own nr_to_scan in/out
parameter: it decrements it once per transaction only by the number
of buffers actually freed, and returns immediately without touching
it at all when journal->j_checkpoint_transactions is NULL, or when
every checkpointed buffer it looks at is still busy (still being
written back) and gets skipped by JBD2_SHRINK_BUSY_SKIP. In both
cases jbd2_journal_shrink_scan() currently reports zero progress to
its caller (nr_shrunk == 0) while leaving sc->nr_scanned at its
default nonzero value, so do_shrink_slab() has no way to tell "there
was nothing to do this pass" from "a full batch was scanned and none
of it was freeable", and keeps calling scan_objects() until the
original, one-shot total_scan budget computed from the percpu count
is drained, even though no further calls in this reclaim pass can
make progress.

Compute sc->nr_scanned in jbd2_journal_shrink_scan() from the
difference between the nr_to_scan value passed in and the value left
behind by jbd2_journal_shrink_checkpoint_list(), and return
SHRINK_STOP once that difference comes back as zero, since that only
happens when there is genuinely nothing this pass can reclaim.

Tested by creating 20000 small files without an explicit sync (to
let jbd2's normal 5-second commit timer move them onto the
checkpoint list while their buffers are still busy being written
back) and then triggering "echo 2 > /proc/sys/vm/drop_caches", while
tracing the jbd2_shrink_* tracepoints:

                      total scan_objects()   calls with
                      calls                  nr_shrunk == 0
  before this patch   168                    168 (100%)
  after this patch      6                      6 (100%)

In both runs every call found the checkpointed journal_head objects
still busy, so nr_shrunk stayed at 0 throughout (this is a different
trigger than the empty-list case in the analogous ext4 extents_status
shrinker fix, but the same missing sc->nr_scanned accounting). Before
this patch, do_shrink_slab() kept retrying at the same priority level
until its one-shot budget ran out; after this patch SHRINK_STOP makes
it give up after a single failed attempt per priority level instead.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 fs/jbd2/journal.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 09efa337649e2..2602e5946cc14 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1262,10 +1262,26 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
 	trace_jbd2_shrink_scan_enter(journal, sc->nr_to_scan, count);
 
 	nr_shrunk = jbd2_journal_shrink_checkpoint_list(journal, &nr_to_scan);
+	sc->nr_scanned = sc->nr_to_scan - nr_to_scan;
 
 	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
 	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
 
+	/*
+	 * j_checkpoint_jh_count is a percpu counter, so count_objects() can
+	 * report a stale/approximate value that is still positive even
+	 * though the checkpoint list is actually empty by the time we get
+	 * here. When that happens jbd2_journal_shrink_checkpoint_list()
+	 * returns immediately having examined nothing (sc->nr_scanned == 0).
+	 * Without SHRINK_STOP, do_shrink_slab() has no way to tell "nothing
+	 * was there" from "a full batch was scanned and none of it was
+	 * freeable" and will keep calling us with the same stale freeable
+	 * count until its scan budget for this priority level is exhausted
+	 * one batch at a time.
+	 */
+	if (sc->nr_scanned == 0)
+		return SHRINK_STOP;
+
 	return nr_shrunk;
 }
 

---
base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
change-id: 20260928-fix-jbd2-shrink-scan-nr-scanned-c3098cd901e2

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>

