Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795373834;
	b=s4lRtZfOKxYtKDk3avrQ7+icSNCLEY6MJC/4ZT6a2N538Tr1DMlY3HJWxr4oO96u0Zfj
	 XixzNLutBCXlx6wlZYJCCB9Db0RT/K9R1oH/1fDYzU1EkOne+CHjIR3LpNOdvl4sGAHtD
	 Wn/ULG5gm23pqYn4gfIKOy9Kj+z//uCxnd3pmDBwN1qb70SsvAOENoeMNuqdEsyYcC0EK
	 D+NnepSAQX2nkboMUQPa4lLOKXh2sAtrgCWWMU8DM8mz5JQV4XL4DhrX0BIJ0dOA9RLkP
	 L3mHqLiG1kpR6CtSbzrzNDjVyEcALG+B24TbPlMUFSAbZQq53JdMhezL5rO0eEbA6Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795373834;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xwmobEd3hQ6lpemGeL2iwCP5woMC3tr8S+4Fo/XGFUw=;
	b=pWa35Z1K/rmWm7JpvNyaAS5JJ7MdfmRruK7zqX518027Ibl79tWtVTQJeP3QZujao/16
	 PiLNFGiW13GYV/BnuarpmxhT3LfbsAdNCPgdSmNfo9nX3jPuesIdqWdMhV02WgtbJErOf
	 K7oqRGW2HAqMx+3ad+5QIBKZrizAZikOSiVTIlj/lYqp/zQKnjtZgjRCUYgXnBnlzeiAK
	 U0g661P2cjxtemky1EOymFEO/cFkQgdNVBiO86UbVtaf964H541qlrBd5Bb3782I6ATra
	 l/lAKiLW78aS4tVRI3nG9W9YJ6/0XJPeBJJt9eZwihGXdvNLUwXAGUL7gjTylirTGJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mffPxBaC;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA39B606A32C
	for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 18:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA39B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mffPxBaC
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so21848145e9.0
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 10:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795373832; x=1795978632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xwmobEd3hQ6lpemGeL2iwCP5woMC3tr8S+4Fo/XGFUw=;
        b=mffPxBaCoZ4ED2VPGmv2EEN4bgAd/NQfqWcLxmhBnbVrzTsLT1o6+pdR6LWQyuEmVx
         X1bVefl1noi19QQV+/4WQsEXlPrnVcqOVdIjh9Z8y27x5at6Cz74uKCH+RKvLqHd1AjI
         M177OdZNaO+pOSspS3GbjJtBUejOXuNuHNPEGug5tbR5dmKItaQ3vYKO3MI0XUY6TLYY
         SqOR8/fspYO/Yq4hHb7x7BpvF1AcHXosDOxdKjB5kN0HrFWkHm6+0F6OHud9VDbNGf7O
         N3v4j4YFKpUi+BIRFEzc0c0A8JKu1gxkbMsUmxoXEQahYl5xKERtOdrzVW8ACHUZvNIT
         msjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373832; x=1795978632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xwmobEd3hQ6lpemGeL2iwCP5woMC3tr8S+4Fo/XGFUw=;
        b=rkioeZAx6P9m7m5M41TCubuNblcs9Ou8ICBgycDU4of3swoZhEJ8kszLspiZ5c4Qg4
         xi4HRDLZlnN65QhckJ9JIQ1KUpWWNtmMjziDE/XptWQM57EOre9j3w/1V2Cs7VMJp/W8
         e7FDLpSBFIWfikQsc7Cg7JtOqGmNaLbikQkN14eeFb862DPev+9dpI+j4AZlZ03SYiTx
         QaBdSiaQGvBlpw6VbviWGXAafjdHj9kqK+oS97N42vRfF0P9cbSb4i44dL29pZK6AhgT
         pxuRN+MlDbVGcx0059R0R/SbzLFnNnuinZVRRdpiU+eWYwZBIPx+q/zKKwitJnpbjXau
         4ZiQ==
X-Gm-Message-State: APuU4Z87Q72HhZlv+MOgPFWoZUxNvS3IWsZlaxcHZbRsbmWuTsXFKMz0
	Rz0uFr2sT/3uMiVhy5FKesSYOkMhitUbpCavlzX8RT6VWUtx3fYbgOQ0ZETh0Qmagdru
X-Gm-Gg: AZFdTZeDSfVlkaqGicsEJxu2vGz+PXvItcjDSzY9oY9zbApmmOMTfkkX48/rxpfDDU+
	+TYt80qPXFByMmKLFIiJzvpK4UDIM0KkcEPLgMNw5wL2J2g4xRrROe0ZrfFfdiCaha7icXFZzCE
	XNJ9PrZizSs2VLjSJJjN7kzQOFMhWLZMmaftjNJzkCF4kgh4/GHgLi392Us6Ox5YDZdkfX3htgT
	cZ7iXtiwHXOhpKE0yONY6waiZgvrlwh+m9v0aECV4MV8lG4ear46eXcFBVXm1eZ25QRkFDuhSLe
	wboxobBXAmOmWT9FvkxpLSWAETlS2h1YHMUMACfRYDKTA2RXQxtVv5870u8aA25eTl9sdFCbWon
	qBzy6snHkEG0B7ZBPuhwOCh9HWvQSApPOLCbdveQUyQRFe/pEkM3UqyAUenHADZXX5Wo59LFNZY
	7rvnvh1FaWW4U1Db6LPc9zYz87LnOYojFn4geKDLF2a0yt2aKeL8ExTrBCeMIgPjy1jFMTG2k3R
	zzYJM727RhH4sGQoR79PtznC9tOmJK7nWRXE1MQ/qB3dS2KZIYsmPTDj5ZdLV/Z2nRL1IbXS+my
	Gt5loaJaazURYn9z
X-Received: by 2002:a05:600c:a11:b0:4bb:69f2:87f7 with SMTP id 5b1f17b1804b1-4bb88812c92mr206697395e9.18.1795373831668;
        Sun, 22 Nov 2026 10:57:11 -0800 (PST)
Received: from kali ([182.180.9.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb905f0f1csm113765085e9.0.2026.11.22.10.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 10:57:11 -0800 (PST)
From: Muhammad Umer <mumer.mobi@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	Muhammad Umer <mumer.mobi@gmail.com>
Subject: [PATCH 2/2] ext4: fix off-by-one in CR_BEST_AVAIL_LEN min_order
Date: Sun, 22 Nov 2026 13:56:30 -0500
Message-ID: <20261122185630.2112-3-mumer.mobi@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261122185630.2112-1-mumer.mobi@gmail.com>
References: <20261122185630.2112-1-mumer.mobi@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the original request is longer than 1 << min_order, min_order is
raised to fls(ac_o_ex.fe_len). For a power-of-two length that is one
order too high: a 512-cluster request is never trimmed to 512 and falls
through to CR_GOAL_LEN_SLOW even when 512-cluster free extents exist.

Use order_base_2() so the trimmed goal is the smallest power of two that
covers the original request.

Reproducer: every group has only 512-block free extents. 2 MiB-aligned
O_DIRECT writes to a file with a 64 MiB i_size; 9 of 12 allocations
reach CR_BEST_AVAIL_LEN:

  write size   before                   after
  511 blocks   9 x CR_BEST_AVAIL_LEN    9 x CR_BEST_AVAIL_LEN
  512 blocks   9 x CR_GOAL_LEN_SLOW     9 x CR_BEST_AVAIL_LEN

Fixes: 7e170922f06b ("ext4: Add allocation criteria 1.5 (CR1_5)")
Signed-off-by: Muhammad Umer <mumer.mobi@gmail.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 37825743f..8743ff5be 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1093,7 +1093,7 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
 	}
 
 	if (1 << min_order < ac->ac_o_ex.fe_len)
-		min_order = fls(ac->ac_o_ex.fe_len);
+		min_order = order_base_2(ac->ac_o_ex.fe_len);
 
 	start = group;
 	end = ext4_get_allocation_groups_count(ac);
-- 
2.53.0

