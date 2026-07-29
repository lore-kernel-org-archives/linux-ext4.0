Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA693D9DD4
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353443; cv=none; b=Mp6pknS4oLK+Xo5Czl1RLzQ7d/WCkYUHozfSJofgkKCwayYpT5HHgbjugzQj3nKNJwC7i5yZ/IA1qvCjComlxYUtTYFPRQIDlgWTtIMr4DDGqxHZZAdC7CswYpNkJgVdAvfIWUA6UUp72CQEmonHWBjbRU8XBNFBGv8n19KtVQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353443; c=relaxed/simple;
	bh=RAVvjWU3PzVBWv16Hd4Tai94P9Dy53r30XLsHoi9Bgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5/SUGDx4FuOlamfO9ygoUooxziSULQrJIVqg/UnXrg1ZOhloYVO807sVoDXj8B7RBv/0eby8h5hDzkG69Zo2XdyiwkfmPOnb3y1u9rALXj4cP9PYrL7zZwTfa+s5U3FSPu0gLrGNfzJ0FkWnF3zM+geZtsatbAJ6hp4vnpo1YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEnxdguy; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEnxdguy"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ceae1ed204so17810515ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353434; x=1785958234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9/In/JZMweca3q+77p/P5Cn2PY2lsATSfApR3PJ3ALQ=;
        b=HEnxdguynFZb+fmc8HSjbLUPKlvjv/7BKDOifbOIyfb0LSR6JopcPNPmTXQPNLCrac
         kgB7WfrMRrXHl178rVhs8aVPjt3OYYVU9W/AthyoBh5fhqo7q8DE/G4S0ulB+5I7A7WO
         bqvHjzk4E9+s9ke2YZdn5sPovtl7S7jOuPRd2DjtJXGCReMiZnmRzRMJ91gJyMW6VW0C
         WHaSgTBBtbmylKJ19Xwc8NH/bZ1DgbYOUbIP0FhO5G92eyh3Mj8rrbqU0u1Rx+q4VHk/
         /sGuuH1NO2JXxh7By5lPszaVHLDP69t4xqO58DlEgqWmO53/IUIlqribCPP/fYlaOQVI
         e3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353434; x=1785958234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9/In/JZMweca3q+77p/P5Cn2PY2lsATSfApR3PJ3ALQ=;
        b=fSo7XBJN/l4vgmp1isLQYZooobYn6OK4P5Z3QnzC9sofiCakckHB2itIvumHmfaIUL
         qkFX6HD9L79E5XV04sTZudGKJYVaHHzlRFvpYpmvRvluzdbpRZYseUqJ24BmwMzHAjyW
         80F/nrkgrVoaabWw6IAt8Xi/oq7YJIrm8QzxI9pphXU2CHa3Xz4yiVpcPStwlUL7UBbL
         9mE9Oq1+f4GB4riKtfNi1derkpCVnCRqUsvwxIikV+VX2EG68ZdmTCywz2d2jyx9vvh0
         EJA4zAaSWFxf5+BhUrJoMlVzZrZSSpUiOnMt/GsHH3qkr+MbUlGViS5u74MlZDN5sSFh
         IFVw==
X-Forwarded-Encrypted: i=1; AHgh+RqvIBdDhJqOkm1clvEWU/yl9a3WnzWNx72QnZbtoFwBS0/xIt37YTZRHC8/W2i/u3ciVB9TS8LRrsG/@vger.kernel.org
X-Gm-Message-State: AOJu0YxzCd16T1HR6IFCHbWpOkO7DZqT9bo8YNzWqKykv9ALG+vjioFE
	Vr9nQDEelZEsfJAu9p8f3PwhFHhp3s7u/llF5+KS8KvNSg/KAMw38UCT
X-Gm-Gg: AR+sD1073qBNKk1Ez7t15nROz1D3QNXjUmbZiH2re2jPzBiuwRoN3+rn63S9Erhpe3j
	LTcJmNnBfmQf7YJfcRvnPakc1Rn5+R1kTdsPmaMBurdxPY393lLWA6Y2suDxfCIkjVwa++pG/55
	BqRxpZ1GZ4W3S54GAaJWs/gksqx8skh2xFVryV/oO15uzznXbHP9sbNDMhFwBkn4gtso1uZ2aD9
	np9tchxw4TrKlL6KetBB33UF55A8JJb3wXae5bZqHQdPULZsbhE5qvP4yVVCX7EC0Mzm8HsRXFy
	PInXCUXTNtxcX8Tum/nlY4cNKL7MbhqBcVgBKdFZLSI09escqL5ySbALpVz0FcNHAIQLhvgar/S
	aze6l35C2KPHHdzv1gYBgbKKxgX2E4MWSDy6UK17ibZwPdbge0PUiPGlM0pl7buQaxeDk12j5nB
	Qk1GGrngtDq6LZVoq4yZuStMyHLytAdurdWgNlDtB2qwh5P9cbDiAP08XVpoFm8bbf4TwDn6oEd
	WPE8XuZZXDMzu2QLuzHP4C1RQkntUhiI7VZxHgm6Q==
X-Received: by 2002:a17:903:3843:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2d0336001eemr2188245ad.0.1785353434068;
        Wed, 29 Jul 2026 12:30:34 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c3721esm15989085ad.77.2026.07.29.12.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:33 -0700 (PDT)
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
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 19/22] exfat: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:34 -0700
Message-ID: <20260729192737.3190206-20-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
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

