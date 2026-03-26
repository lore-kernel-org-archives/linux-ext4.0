Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98817224AF2
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 20:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774556297; cv=none; b=sDLc/FBlZwqWtZfqht0FigL3deEq3rBq6VCLEhUHGe7Nmg96TIJRWYEEnSTqYbmg4ROHkt7f/EzBkUVzAWv2QjJrxGpGGR8Jz/IdYMgWpGMozdFrSq1uGtgCYeyNJ9m1IJKgU64K02Q33F148UyAysBbCOEiQSunYqLvJnGXYQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774556297; c=relaxed/simple;
	bh=psa8oqtuzo1Fd6KKuBsX4zIThnmsNywLbmjROmFxDYE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iy4tJy2vKYpUNTgw+MD2jSPRwX8j7zzRai3VJJiCr+M8yQMf1tq3UDbZLsAqKlIidH3CpAjPeWPoX/NE0qCLNlDiYiqvxi5b3OgGamSpvZ22EhjJ0vFO98bcLmetzBR97CLYN7iwLv5F8+8hkBTnBCzgrc/F6QonNk5oGe3jacg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m/pO3B0x; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/pO3B0x"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so12430635e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 13:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774556294; x=1775161094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d+yR8XT8nASwGHMWYhsKkkmFjd2K2R90pTX2kvttbtQ=;
        b=m/pO3B0xrilhHCDLjGlVSi7c/8aG9FmyzwGjujOKAfIwwRhdqgYeWQmqgms5hsA7Xx
         kRWuHqJyPDGM6nNGS/7hgF+mzQF1or/GgwN1BZ5VV2jB9iilezJNjc22kajnSdiLuPSi
         RNTUNNNPt95Q/lR7m8htdqUrqA+NIvSc5DycHNlxIQQuW1A8S1WyXFeCDqcNAQXaXspV
         TOOx8cKlGmiA05oUQXO0Mdg+nI6zsjB126z4HghSbuwNM64JmBnIhFhz2nd4mFRQj0zm
         BvDxNs2epnOU5NCzSvYzlqoqDvpxVbXN4M2Vl3Z9uZeXQ3kn/8PCCD1TFKjDc/x3aVq0
         Fh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774556294; x=1775161094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d+yR8XT8nASwGHMWYhsKkkmFjd2K2R90pTX2kvttbtQ=;
        b=CWfqbjNeSiZYt43FvfSe1SzSIBYu1XvORdONGD4lqefqImuxaTOQld6riyzuNrRWGD
         k+5r7+jGwOGuLoGO9qEDpNAXvjqTWbKTU0V7z350i7S8Q9cMsf0GZh77Mx9kHMZly3pX
         78p9Dk++kd9sekZfm2LDWhtlGGmVn7QULXIR0FKrflLhKZNC5GcyWjKBNOX4K4Ch32Em
         BrktyPbTEb9IuPQj0tTGW7df31SNv5uTvzHnRIfaIxVS+3srWPPuJSLNTX0ETw7xAckq
         g82MOPqnW93CRO8g0pM+jnVYBm1PcCJz7zvt9kIlH4UH3QKQkPBK8sesP32s2GX0UhgX
         Lo0A==
X-Forwarded-Encrypted: i=1; AJvYcCWEDe+7x27DeCADW5ANFOh0VFfeupn+W2VBg/EMIVHHmAJ1OAP1EZWIzBvumyU/vb/NqBSpSBcOid7x@vger.kernel.org
X-Gm-Message-State: AOJu0YxqW9EELSdxe2GNiGKS7dJ3Ni2pahoEJaKbgLoVysvghzULpJ/i
	yHqp85virx8jSCbGHnN6KG5yMSJFYZC+rDkzPmdbzcO5QSt59CTkxQYE+gjqBCwb
X-Gm-Gg: ATEYQzzxgHfXklfYXkuDOlmUMwtFyR4R6kVeK55Zosizcb/XqLiZNsS+wEgvVFRkhg4
	JYgifh+yS2neMzBf7V8Wlrt4qRZRs4kHx5QhanwCxZAZnGMNpJsR/YkXMt0Jf9OFicCGyc2je4o
	6K80Nlfi2YhZsHfqiCuKb65IzEDewl099mioOaydp9Qer0uwCcZXky1oDZ91Zt9TJszstQ2+TWi
	ghnnSjdcaP7K9bfsJ6/A3uslpQHrm+0pQNYPer8QuGE+ziz0yOpzvyyaesLMIx5RdKu+Uk3NgbI
	UVOuTW4wks4aeD6umNBs3qsSOwq73y7wSFacJp21KJxWIZDvSpTNgCE94UEmgH5tsf6lm+CKxGE
	HEXgrVGXTU6Fu+4gyf2JXA9jJ1hrZTkyJRTc2VTehrG65SzCofigLP4lHnWKLMxA08XPAOilSMH
	ZKgUuEzuUlZJRmnaSAAhSCibWDNGv39J/YGZoHLSXz4hy3+trhFgWcBeXimjALnUEG1TLRk3gGQ
	nyBLf3PZaU2
X-Received: by 2002:a05:600c:4e93:b0:486:f893:56c6 with SMTP id 5b1f17b1804b1-48722bd529fmr49056345e9.10.1774556293832;
        Thu, 26 Mar 2026 13:18:13 -0700 (PDT)
Received: from snowdrop.snailnet.com (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722fa8dc6sm90653825e9.1.2026.03.26.13.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 13:18:13 -0700 (PDT)
From: david.laight.linux@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH next] ext4: Fix diagnostic printf formats
Date: Thu, 26 Mar 2026 20:18:04 +0000
Message-Id: <20260326201804.3881-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

The formats for non-terminated names should be "%.*s" not "%*.s".
The kernel currently treats "%*.s" as equivalent to "%*s" whereas
userspace requires it be equivalent to "%*.0s".
Neither is correct here.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 fs/ext4/namei.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c4b5e252af0e..7aaf5fbd4498 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -647,7 +647,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 					/* Directory is not encrypted */
 					(void) ext4fs_dirhash(dir, de->name,
 						de->name_len, &h);
-					printk("%*.s:(U)%x.%u ", len,
+					printk("%.*s:(U)%x.%u ", len,
 					       name, h.hash,
 					       (unsigned) ((char *) de
 							   - base));
@@ -683,7 +683,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 						(void) ext4fs_dirhash(dir,
 							de->name,
 							de->name_len, &h);
-					printk("%*.s:(E)%x.%u ", len, name,
+					printk("%.*s:(E)%x.%u ", len, name,
 					       h.hash, (unsigned) ((char *) de
 								   - base));
 					fscrypt_fname_free_buffer(
@@ -694,7 +694,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				char *name = de->name;
 				(void) ext4fs_dirhash(dir, de->name,
 						      de->name_len, &h);
-				printk("%*.s:%x.%u ", len, name, h.hash,
+				printk("%.*s:%x.%u ", len, name, h.hash,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-- 
2.39.5

