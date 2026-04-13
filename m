Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4EC22A7F0
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 21:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776115650; cv=none; b=MZjSOkOo7QyUl9vDkJJBXpaSMrQTZBX4LtODpS39H0dgIQO83gGpc3mjuQaDbzKjPc6D5hvJj31TFAuouBkRJzSSCkEd0NcKxknrqv7l2w8c2MjV9n1YO93uoPretK1Iiqd1SqkwACZ0EJBeDcgcONZia4PLNKRRkGrSmi3kyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776115650; c=relaxed/simple;
	bh=p1EQkVL9fAySegcjHRatZB8ch2qAA3fPIHqJ1mFgnuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SFnG9NZnuMhrcxE/mVKc8ubMau5WuM8WL+cawnyB2GLxGKIYXnH/uLtV6jGMUzKNThTZs3JfGlz+4gxtkIYoVFhMeNJ8ZYUX6++aalIPpbibp8LKGplSyk1FOfncRak76v++XtoZqm/0lchVtkQhzVG7yyCDl9BUi9t5/I9dAkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CLrg58dx; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CLrg58dx"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2d832f2f44cso2208920eec.0
        for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 14:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776115648; x=1776720448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fdnkqLRRxLvmqVnji/KtjJDAwBPDnqcKNd/D02wywI8=;
        b=CLrg58dxorvofdayhy2D1boSlOscY4YGA80v02uQsKQ7dzLYbM58SGncxHd+hyC/UO
         4EGTHq408t/9SUxrcYQMTO3iPDQnX897tHB2O7VPrfHcK0uGDDjhUciB9NsW4k16J9LJ
         VMp+BbNYl3mcvvhXyx0uHMht496HnokLdtKJS8SSRr8YsZw25eC++AU4KWTbXt85TCe/
         VbDApaKPcyi1TMg3wSrbDnfG4RjgedGamkW+/OApiTO8fPilpcyZoq3Q2Dj4J3pYPd2M
         nrTRPZDaqvksvW8UY0TMkGsKwIR1qHPtx6zXGONDHZjojopiC7sme6oZTzrf7GCsj0Tj
         WIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776115648; x=1776720448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdnkqLRRxLvmqVnji/KtjJDAwBPDnqcKNd/D02wywI8=;
        b=AWw7vcu9U6dhuI+gE05uo+uKax55knecrVPU2wxfhcC2/MvTwRgSvetUX+u08kBZ5T
         41zJlhlTfxHz7QyZEnNQpbbdaClagMmrlMHklMpd6zK9xR5a3rsnoAuwRf0sOkouzsXw
         RZ1QFnKnaZqsuogZzWYl1tcM1yAYLEEEGZ0MfAINIu9OnWf8os1otalEz10qZ5G33d0k
         svZipCSAUyW3fAOfWPjalsAzJv7q/30459gZgbH4rQSndWHnip9TSKhIQ8GsuUezDNLT
         CKTCtSARVdiNsJ61kHqm0toS/X3B1X+23cgCeV18NnRfG29/jCquqHUvEMzP3MjKAhFf
         T4dA==
X-Forwarded-Encrypted: i=1; AFNElJ/CijRSGh2NtIBG7wiPikM4mbVikpd6LN039q6s7zqNq2zLI9INBbUIABawbxg1HjTHHesavg2nINNN@vger.kernel.org
X-Gm-Message-State: AOJu0YzijpSWz107diYqwHSqUsGEh2tq/GEmBPb87lR1lQVF5KnjI51r
	MLDCu2yYHqYWmHSQDgHJ/7f/cCIhs9BqXwyCYFm8wkm+KUB+0YyvN0lb
X-Gm-Gg: AeBDies/N+z34697kPMWEO2pAGZkKjn3qdxjmlpeMuDp9aIRLk5LQab4Ev/SrxCf3kU
	FeuJBGO+p2j3jGQ9wg87UuWwB3zaYq2sjDag4fndpq+PUpvaiTgBO1E7U5cN/BLaSZPoaJ85uZU
	QOn8IecKmqTiL+xPUc4zDQRqBNAgacbLpKJIv3SIXl3ESX7UawjhnwdMrcNJ4fX02JE27cSgVmU
	JOg/bo2y/Y8vo5Fk5eRC10qD3+4mEOxZa5xaYytbTktDirGuFF5hB94episNXUhFOznapJR1Cyh
	+ludoe8vdMLu2juqI7ewaFqOsU9CSFAGVJrfkq+qSk8IC3tJKucbKiJFed0gNqNpFTdKtsJmCKc
	2RRgWcPaSEjP3CNIBNJKEUY0dmSH4IbiCa9RaOyvDBUZlVYHAQXdUrLFMpJ9iuS1H5+Xi7DIAWH
	8ytWCBDro5+QlYP5a8xTuhZ5doVY8EY9H1z2kiOlKIaGYSXA6RxC+e0gEEzMMnhFSN2uDJxLEN3
	yIEuGfWv2tY6ADY0sadhPzELameJgiuJSyVQAhEdVGDosI4o0QOkSD0Z7v6Ll8b3rzmMGb6ydLz
	aW81hnf+O851MLJRv/+rjHlPAgxzARQV0L1ESz8WEQMxi/oqdQ==
X-Received: by 2002:a05:7300:690a:b0:2be:833c:149d with SMTP id 5a478bee46e88-2d589ba7cdcmr9365255eec.28.1776115648213;
        Mon, 13 Apr 2026 14:27:28 -0700 (PDT)
Received: from arch.lan (c-98-51-119-100.hsd1.ca.comcast.net. [98.51.119.100])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561bde70csm21099493eec.15.2026.04.13.14.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 14:27:27 -0700 (PDT)
From: Milos Nikic <nikic.milos@gmail.com>
To: jack@suse.cz,
	tytso@mit.edu,
	linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Milos Nikic <nikic.milos@gmail.com>
Subject: [PATCH] jbd2: enforce power-of-two default revoke hash size at compile time
Date: Mon, 13 Apr 2026 14:27:24 -0700
Message-ID: <20260413212724.127035-1-nikic.milos@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The jbd2 revoke table relies on bitwise AND operations for fast hash
indexing, which requires the hash table size to be a strict power of two.

Currently, this requirement is only enforced at runtime via a J_ASSERT
in jbd2_journal_init_revoke(). While this successfully catches invalid
dynamic allocations, it means a developer accidentally modifying the
hardcoded JOURNAL_REVOKE_DEFAULT_HASH macro will experience a system
panic upon mounting the filesystem during testing.

Add a BUILD_BUG_ON() in journal_init_common() to validate the default
macro at compile time. This acts as an immediate, zero-overhead
safeguard, preventing compilation entirely if the default hash size is
mathematically invalid.

Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
---
 fs/jbd2/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4f397fcdb13c..62b36a2fc4e2 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1565,6 +1565,7 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	/* The journal is marked for error until we succeed with recovery! */
 	journal->j_flags = JBD2_ABORT;
 
+	BUILD_BUG_ON(!is_power_of_2(JOURNAL_REVOKE_DEFAULT_HASH));
 	/* Set up a default-sized revoke table for the new mount. */
 	err = jbd2_journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
 	if (err)
-- 
2.53.0

