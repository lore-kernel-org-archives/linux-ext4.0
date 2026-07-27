Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F8342D74C
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187493; cv=none; b=BXwIT4pgtXLlb0yWhrfVJiN04OYqCXE9nDf6zAiyP/D8tQECcF5byU8xpmBU127qLLwFjQXqwmo1gQ8TcnCIQ/vliM2rmhxK6/Yj4ReoHcfs08GR87+NHJAO4AZdj4gaa+1QayAj+hk3Kzxz/5D6x9eDeL9qnZxYie43DlMJDP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187493; c=relaxed/simple;
	bh=mjtFePw905Ih8lZM0jTOp001M3VsZYjlem3tQ4B9G6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yy4HYPlU+qaS/T/eLscNyCpeyvyXT4Jn25oSg/ZqiZIz1Ig+YoqIm4dRw05mCHkKHkkdMkVdJo+NWFYtlp0u+Dfv0nqceC3N6cXmjxch4W6kMcbvvdkXNb9E+woe/eb7+GAiAsT+PZiJ51YgkNifoPNnkUjLNTNj7Zta6x62cjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gm4VlN14; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gm4VlN14"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ceb096e675so38616335ad.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187490; x=1785792290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t0HucSFNwCrhhqVsgsZLRy5u6x5BGWTlUoNlDXYASAs=;
        b=gm4VlN14wsV7YR4qhAHoqFHBZUxX8+3x2mYK6mKE4zZwsqvCeuqdEHWN+C7fWS6Mzy
         jL7Tgi9TmiK3bjUS4nyVE31Jxjx0BsHZuGkmi/sFjKa9SSuyGa8p4OibJxhdhUcr6wg2
         qY1QYasTXpjazlU07jjJcOxluStQBMy/jWqorkQMSocT0i6rjN4y8tyOSV2SR2dC0SXS
         hMiRddeHPFvl12HR1kxZAwGhWDnn+klXCDUe2ctbriydlxCasnbxhPwk+cTzkK0H7RR+
         j07wPLm9afZw/J2AeTuXeA3cmMBPToaS71p0AZ5MZ21oZTexkFPi9JRM6ewpEuS5uXa2
         1e6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187490; x=1785792290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t0HucSFNwCrhhqVsgsZLRy5u6x5BGWTlUoNlDXYASAs=;
        b=GWsamuz0iYfpRFxMHIxQgIGwT0gJKRJ31tWjonOX1BZMih+TjaRNlGzqtJJt1S2xMF
         peyjQkhRS0XT8nkuBZcJW5UEnmYO6pH7WKVfgZsAvYynhHsqdcW+ZCWf/fnQ4s5dc4d8
         3x4TaGMvZxO/Bsm5VaDXxFuOChbONergVp176Rp1epBFeNM9w6aUT5CJQha6uvO0qUpL
         K7h5W1lTseTWD2ybIIrMSaYdAACGpKBNVwdswPKrzfEmk2e/0JpqA0t7n201FRFMUliT
         P3kYWdUqlT7+8V5f6N1YTXG6MDeiiBIV5CpHJcjJmpC+GgkJzx5iMLyq/vuFuyJBMYmm
         +keg==
X-Forwarded-Encrypted: i=1; AHgh+Rp9N+hbPnMalLB/XBY6wUtrxOfrLJ/3sNtz5RyVV/TaeCl60mImkIop9dUl59n4bPfigoCd5EjQY1o/@vger.kernel.org
X-Gm-Message-State: AOJu0YxhF/OJAIaJQj20TN/ZOXxodzonNzkD8GTtIkS7qWvVhh8UkKFu
	iHcYPOF6buCy6HXAdbgi0S4+g5jVc3rK9LyEK3Xx1fkwop2e/Imr1cqm
X-Gm-Gg: AR+sD10YHDrj34hARTEE2U7E4r89hvsojFfJwp83iXhZILOHdXrthchmDGueKe0Oj4F
	bg5Fr6JYIusuJRXW5TtGxXUyG3fy9ACClZ358HrMKSfzvMO9vOa2+ROuBdJiVXnXgrj5onzFgfp
	UOKK3wmkDkwchw10KQM1UAaZeEMwGReeRPopkzTfC7dtsa2h5lfITwwlwPTh031LMIpN0kZqD9f
	Zu79GzGacayq1OOiVFMMpvGWDQwAODR323UaycJIRfFunIHUCnrzUab17buWTnOqMF15DKQImC9
	lyTybQVq3Aw6DjhxZ+/jId0Vb7MpqKdOndfKvcBV9GJ69YZI8mV4oFfJ8iOS2UNEsU5Ow/+aGEd
	Nvv0ACBbCmD+i+PK4fGnFLzg0wSUz2lsVQXFbbmuhHN8ZUJBbV6wwtPcsqzdMLRbX9/cpqp3rQW
	rMA4+xiFCp4Fu8lKh1TEWqA/BZtAYodB9dr2UfeUmD8nbeoxgStxEiww==
X-Received: by 2002:a17:902:e5c6:b0:2ca:d7a0:1312 with SMTP id d9443c01a7336-2cfde85f826mr100366845ad.25.1785187489988;
        Mon, 27 Jul 2026 14:24:49 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bbdf6sm40458485ad.52.2026.07.27.14.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:49 -0700 (PDT)
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
Subject: [PATCH v4 11/21] zonefs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:48 -0700
Message-ID: <20260727211758.1116539-12-joannelkoong@gmail.com>
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

Convert zonefs iomap_ops to the new ->iomap_next() callback. Each
callback is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which
wraps the iomap_iter_next() helper to finish the previous mapping if
needed and produce the next one. No functional changes are intended.

Acked-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/zonefs/file.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 5ada33f70bb4..5b34849be7a2 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -57,8 +57,10 @@ static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(zonefs_read_iomap_next, zonefs_read_iomap_begin);
+
 static const struct iomap_ops zonefs_read_iomap_ops = {
-	.iomap_begin	= zonefs_read_iomap_begin,
+	.iomap_next	= zonefs_read_iomap_next,
 };
 
 static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
@@ -106,8 +108,11 @@ static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(zonefs_write_iomap_next,
+			      zonefs_write_iomap_begin);
+
 static const struct iomap_ops zonefs_write_iomap_ops = {
-	.iomap_begin	= zonefs_write_iomap_begin,
+	.iomap_next	= zonefs_write_iomap_next,
 };
 
 static int zonefs_read_folio(struct file *unused, struct folio *folio)
-- 
2.52.0

