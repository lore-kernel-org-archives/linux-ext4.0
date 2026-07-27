Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B19142E8E4
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187508; cv=none; b=u0QhZe91a4kdV5tq/QiVArY8amHpE3D/sWf6lWgNMZY6HURXXL6AiUUk7QoeKg7jn5mHVefMwbS4MEMayQJsuVNCmDdjZEUzGTVZDQbF4L2z5PyYwUbM3/FP634HTNDCHVkvA44XsiWUqdclZAaDat3nDu8pVMr4NB6dKxUyRXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187508; c=relaxed/simple;
	bh=RAVvjWU3PzVBWv16Hd4Tai94P9Dy53r30XLsHoi9Bgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiLfRud4sVU2Jc1ZEJ7hHhif/Mex/YpfzkSkjIzjL+qykAYqdHY4Qkesys43WcfIRBBIOKf3fjElgVUhEREHIt0059mLT91y1UOdyQlt535tamQAqmp60/OpPmmD+YJHus1AiWagb8h7ToICJl8bO4szIdF+tDgI1k+64uDnTJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJ9m9qtA; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJ9m9qtA"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so47208615ad.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187506; x=1785792306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9/In/JZMweca3q+77p/P5Cn2PY2lsATSfApR3PJ3ALQ=;
        b=TJ9m9qtAVWvlQZ3bfDpWjyKN2ifrelWkPwJZQehG3Qm8ejoMPM3BedESYsigNL37iT
         kGLf4XYvRo4oZtxuaqQy7MPbHHoBKrOBH8twVdkv+KXEZgtWTuSug2OwFepDXYPjfB0d
         ZhQ5sYgfCGpNCChfvefhmo2zmP9T5ia3jEfofWS1eB/BbAoqGKFZyOPe8pElsM24bRpY
         Bwi4/WhzQCHWLk8rnsuxLQ9hD3ehIx0uNQgfbDrH2xljaQAGQwXgmEnepPW60NERRt94
         agr425+ecpnzzAEYaKzNJRjAlL4Rh24bbDonbbCXW2Uxzh7dL/H/OAwoGzpeNpVixsJ/
         +vgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187506; x=1785792306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9/In/JZMweca3q+77p/P5Cn2PY2lsATSfApR3PJ3ALQ=;
        b=P/wB5iCseZu9/N0knTME1Gh3tVRKZ+3GKYDNMWp8TiWjXzYSOg9S6vVAUDjGnQJbPq
         71R58rU1ID2dkudaQtFyLwS5M82+S7J+KqxZfYu/3GZMVigCBM0N6HcxLujdAGCNmhZN
         h2qZPDlfqskmFNxaK8vXJ3Mdzgmv2gu/PeWr/DGpC5sutV4OQhvYTIu/cCBy8wghVn17
         J/y7w6sFZ2BvuN5lR/GUgY48t6Mt0HoADFVO6cz51Yo9/q3FV6Ihj94oGUJrWM0dtHTc
         BZLb213RQMA3kyfNiwgthguDk1JRTWr7WdBAS/dBQkljPWWJyOqqggaqOHih+6aY7roX
         tcgw==
X-Forwarded-Encrypted: i=1; AHgh+Ro8uyqfLtia66pHGlmrg22sJkCwOn3qnFwgcPfhkxZGHtWw7mmp58uNYnb4XRckdloWDhOGCuUa9RwY@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7nDSllZz809HdHAaax7enU3CxSuKsf1b2oICsqzKvBKxzvKwc
	HJv9KoOKdXLgGkd82F58sXDuUC6czjSRCVFjTNGWuKoPnttyjUQtVD/f
X-Gm-Gg: AR+sD121LMPA5NTtlNH5MbL98ppCscB0p1Cduuf3dgbT9mhrs5ddrbCC6CRheXRpx0K
	GV+9vUEYBEbdolHv9jmFdndew3IBeEJKdU5vKlGGzuE/zu4pA8SouWCcrt4YDemKQNg5NB/c6/0
	N9/YZubyJaYODRY1n8EaCw0aV9qLpRyFyxni/neXiZTm73skuWmAQLSe94DsBOVt/EB8usrf0pL
	Abfv1BNRaho4HAYrYdyNbIrmvymA4V9wUzw41VFlSJcNWdYhzLwen5wdHwrBEaIKJpOLZXMreu9
	LP+DlrqsBUto/I99v4wVfMKQmlUH3ZJZID3evZ9uNiiSVZPusXASn4S5YhGmvHQyhVMBxxIJK8e
	Xk/rH7YDUaLrlaYQT536ADDC/5pO1NoQXnWOFLpDptN0UP74cXcEe+QecuHbgUlpISpXTgh9G3o
	1D9T0PpM3a9qOmuShpi9nZGdkuqRuvtBd/qE8mO5deyz1imBR5JpRftw==
X-Received: by 2002:a17:903:2ec8:b0:2c9:c46b:1286 with SMTP id d9443c01a7336-2cfde86f7bdmr86035985ad.34.1785187505979;
        Mon, 27 Jul 2026 14:25:05 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bbdb7sm40703835ad.38.2026.07.27.14.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:25:04 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 18/21] exfat: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:55 -0700
Message-ID: <20260727211758.1116539-19-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert exfat iomap_ops to the new ->iomap_next() callback. Each
callback is generated with the DEFINE_IOMAP_ITER_NEXT() and
DEFINE_IOMAP_ITER_NEXT_END() macros, which wrap the iomap_iter_next()
helper to finish the previous mapping if needed and produce the next
one. No functional changes are intended.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/exfat/iomap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 1aac38e63fe6..b6dd396aa60a 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -151,8 +151,10 @@ static int exfat_write_iomap_begin(struct inode *inode, loff_t offset, loff_t le
 	return __exfat_iomap_begin(inode, offset, length, flags, iomap, true);
 }
 
+static DEFINE_IOMAP_ITER_NEXT(exfat_iomap_next, exfat_iomap_begin);
+
 const struct iomap_ops exfat_iomap_ops = {
-	.iomap_begin = exfat_iomap_begin,
+	.iomap_next = exfat_iomap_next,
 };
 
 /*
@@ -186,9 +188,11 @@ static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(exfat_write_iomap_next,
+		exfat_write_iomap_begin, exfat_write_iomap_end);
+
 const struct iomap_ops exfat_write_iomap_ops = {
-	.iomap_begin	= exfat_write_iomap_begin,
-	.iomap_end	= exfat_write_iomap_end,
+	.iomap_next	= exfat_write_iomap_next,
 };
 
 /*
-- 
2.52.0

