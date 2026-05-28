Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FDA4028D7
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984422; cv=none; b=TcOqwkryE9V6MhM0rJszBj8lk3fanAT5B/EY2Er5dFM6ymc7A1UglNHx33hcEXbqgBhUJZXmMvC75v1TCgbt4CZ1mT9a8L7Q/YK98Kuyriv2D3mHBiIDPoaXLfjxJrdYvuZ5WBLkW1CbNQWgrg3jv8NxdUijXXpfJ1ZviaSOtmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984422; c=relaxed/simple;
	bh=NhhlB1AJ+tWvf7EJVBnRnRvVlnSuieyH4m+PY56sS+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g/EbrhVa332j6ZUP0EhhYAdm30PDNz4WavXxC6WqGUwo5IlGrM/7rK9BoWdpLMayaLX8y3994WIQFD7GqezKLg6qVvKhc+zKf/Q6FTr+VNePZTm2MeaQviDO0qWGFcNt9r2HKRwbCrv+kfmRIEckdeGgO+HwURlD4M5NH9dCZFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N4n6mdTo; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N4n6mdTo"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490426d72f7so62718985e9.3
        for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 09:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779984419; x=1780589219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nyGvajXzU3/Aog9JpxDeQq4aBQFxucadRNMIY3nKXok=;
        b=N4n6mdTobNwg07DMdQdBPKhHhEMM0Sk8v53D2uE7yKrLF09g6un5LlL1TAqLECglyV
         QWm/bHbnQck1YuBk1gjdGoZQq5SrDERD34onfbWfSqulj9um7yWls7PuBfl/f0psBfN4
         s0b0ASNt7oOF2wbPsQaGAyi/YfI1ZU/YayFTgY3IDws/s6H6rnjti1V+nkhXu96o6wFz
         tU7yo43j/e566S/NhD/91BqxPosHW5wUwO7i4WlhhmcUHrpDGKu6XQFacpn1H8x0mQmH
         2F2DcjjzVnMxdzSFDr/Y/HiU0lfx6WwgudaWj+g+Twx8MqqTXSI1ccMu3U1vS897LS9L
         ptyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779984419; x=1780589219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyGvajXzU3/Aog9JpxDeQq4aBQFxucadRNMIY3nKXok=;
        b=MJ35BMj5Y3RxfYHPr1maqdo+QcjcJWPszztSggYndEMhKArMzx+X7MwQ9XzhWy3JA9
         HWRuv2uwSc/qMXp4Hqa5Qqq0usZnVIeOEKBrdNjedC8aN/iCJ5de95jp3qfarAvub8EC
         qRPGJWWCx6ppcavnLpSoEK5f8QOiRMzt/bMilKCeVQQNt1ZRf7mHVDL946A4Bpn0AX56
         5+Yi3swH4TJIni5bjnX7Sv7zLhwlQaw5mjKrZctHEhqg+Mx+HTQSzVbiBAZENwKf2pGh
         mpulbygMiM6Q/4qKavKCopU48SH29J8KT+xIL7JqSeeeWXPXcc1Pe/7v1RUUNZAaJT7Z
         ehuA==
X-Gm-Message-State: AOJu0YzF3Rk5X3mSxoh3OtxS7LPnWdjRxbZVxXxoXN4vg0OOjV9sWLJk
	70reC5vJpGoAX0giaTKGdADzjkWgqsz9LUGJ7KEHXH+Mq3qNyBkapEzq8sVK2e8g
X-Gm-Gg: Acq92OEJroSgugNlQAivAyCi9MAu9PE6JVjRG4i0PQ1GMXqY7XkDTIl/oD/b0R1ofwn
	QBazDmHxyH0RhHVRpk0ToxvU+TmswOzntZfIB6n+DeuPc0CPy6HRQXKBDQEGPTfHP1bAFj+M7WP
	dkuXixjwmh/lAby7giImGJaSZ+nmJvTJjiA+0vxpPEr1W8PrsPfJyvWyqMiRBpCiywjTDjNjjEl
	E2PFBLrz429uyQWbgmVpW0AoU3suM7KxIoDXij01nnBoyUV4dRZKPkUrf/GHt3EkPvFjJvhNx2H
	RIV/gv6wdl87e7RuyCfhhXHIIryZUqt9WxHbZ6PjLRFqrZYyudwZg0NsnSgTIk0Nz+hCEOlr5oy
	R/fFEOxJZrP74dIz1fXnmHZJZUTftXOjlGqit688bxTsNGmK2dm1aYHNpEAkwnswFr49gMFY+aS
	x985Xvui0IV51QXts0thYfM33/G/qug8C0QA37vD5B81EXJVIcX+PTP5kxWYGjpmU=
X-Received: by 2002:a05:600c:4fc1:b0:490:7227:100 with SMTP id 5b1f17b1804b1-49072aa14b3mr216430205e9.18.1779984419270;
        Thu, 28 May 2026 09:06:59 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb549addsm14136574f8f.5.2026.05.28.09.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 09:06:58 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] ext4: validate dx count against limit in dx_csum
Date: Thu, 28 May 2026 12:05:57 -0400
Message-ID: <20260528160557.6956-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko AI, during inspection of the "ext4: replace ext4_dir_entry
with ext4_dir_entry_2" series, reported a missing bounds check on
count against limit in DX block checksum verification and setup
paths.

The code validates that limit fits within block boundaries, but does
not verify that count <= limit. A maliciously crafted filesystem image
could therefore provide an artificially large count value.

Since ext4_dx_csum() uses count to determine the checksum region
size, this may result in an out-of-bounds access crossing page
boundaries into unmapped memory, potentially leading to a crash during
checksum verification.

The same issue exists in ext4_dx_csum_set().

The bug was not introduced by the patch under review, so the fix is sent
separately.

Signed-off-by: Artem Blagodarenko artem.blagodarenko@gmail.com
---
 fs/ext4/namei.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a316fc2ac41b..20b7bac69889 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -472,7 +472,8 @@ static int ext4_dx_csum_verify(struct inode *inode,
 	}
 	limit = le16_to_cpu(c->limit);
 	count = le16_to_cpu(c->count);
-	if (count_offset + (limit * sizeof(struct dx_entry)) >
+	if (!count || count > limit ||
+	    count_offset + (limit * sizeof(struct dx_entry)) >
 	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
 		warn_no_space_for_csum(inode);
 		return 0;
@@ -501,7 +502,8 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry_2 *diren
 	}
 	limit = le16_to_cpu(c->limit);
 	count = le16_to_cpu(c->count);
-	if (count_offset + (limit * sizeof(struct dx_entry)) >
+	if (!count || count > limit ||
+	    count_offset + (limit * sizeof(struct dx_entry)) >
 	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
 		warn_no_space_for_csum(inode);
 		return;
-- 
2.43.7

