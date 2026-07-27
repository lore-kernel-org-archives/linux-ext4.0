Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329E242CAEA
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187478; cv=none; b=enmsmIVNxvgGsv5UutTQRxUx1Cfi4DKhQYCSbhsseY5OCgQyHCCpTvavHzi5ozlWtkri+gIXrW4rckUXSc6s9ZiQRfnmxYCkz4qVwpvhMZmgJeiTGh9QVDK8i+sjv1LNVaGQ6HAOoijDuVC3kNwggoEVwD33oqTKx2CMr2jWPa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187478; c=relaxed/simple;
	bh=5irZFB1XN5m7fpRyd0F6vXnlyVcPBIQh1QapeNopw1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tmfr2OMXxWQLPyb1xMcoLJuvr1WeQ7fsS2qbISoAsoFjo5jGbvFNKipbNgFIj6Zx5uDNtCk3VYxjp8yzH823ftxWoKh0jVpFF1FNXD7YS/HM3fG4TzFeNOSooXTYo8URHzOXx4+NjbQbcmfuYyze0Zb+KSEAAKQDDVgJGKKcgRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vye7wOo1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vye7wOo1"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2caf228a910so24219325ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187476; x=1785792276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fwc+s3HmXnhuQ6ZSS0e/BayybuJcAxIo6JAFClX1stU=;
        b=Vye7wOo1YFuJq4v5MbNSuKmSX2GpQFSEcp8o6d/HPKbbG39FECGizpaY60xiQl1qBq
         jWEg7haV1Tf9KpvTgoUydp1ea8S1RiNTjWZF3Usb0fseu3nApcJ90iVcro8ZyZNsGpeE
         3XjBYwCA9mLyuCz0zX7m9/pzox3F24EmJKSAxeT5vyRZTnFmenyF0/S/mUALQ4LqRgM+
         WE6EgF9M6t5fEGYmHdf8HwtR3hB8bLO7Pvd3eYYhdHJgocyjSfF27D/fZgXIo796HxWp
         HXuEF09wI758vbaf/zYwnnHMIWKiOctjXSTFS6vg1NdF/uFciz0f8Cu14nalo2UXoax2
         X2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187476; x=1785792276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fwc+s3HmXnhuQ6ZSS0e/BayybuJcAxIo6JAFClX1stU=;
        b=tSNFfjpuhXdxLK+mbHgfQ+9GeUcsWkbL8E31aeb8cK6jbV3vgpVZHg6J5FkRFODW8V
         +q7xc+1lmYMvE2TcoGm6aEqSBQ39LFYoqzhX6QxvQD+pyB6gI3n0/nhx1CM9DNjm3Ksx
         90o6bP8aV2tBZg5JenuJJE8Rhg2ukDjWVU8qnPAgz0p//Six9LEfOPR2bbyc83TaCQu1
         mlDH8ZEIN2Hft82L7hBXYpH7u4TnkS+ahAa3DOKM7ZrjB4m1bnXGQ58XKNrqot45j8Ov
         VFVFK3t2IZ/AhxG8J+NRl5lW4Tvr7Te327g67INJwcKaPyM7Jv+LmzpIAHXExrILkMpA
         jwPw==
X-Forwarded-Encrypted: i=1; AHgh+Rq7/MVtGalIxsP40o8Xk27o5W0058q1MlgfSCAsuG+CJ1SJcxMzVMNJd1Empg31ccVaVPPwuJO79HLS@vger.kernel.org
X-Gm-Message-State: AOJu0YwfbWgCjYCug5b0ZFvJejfrj+CLJA3AhJl3NVyXDVzPJflttBO3
	ol7GVKZssWpEcDC6W6YuT/3wirdl16iAmY1xuexezflDLArFgYj5pNrX
X-Gm-Gg: AR+sD10jlHUfKYnR4o52C8wl4fXlacWAmkQDRJZTV2zpmIlyIBPSs+ZuzxqFmFGw+FI
	OnQQzlHTzyqlqjwxA/yop+DZWA4ECN2TNY6xSDtOB0hQntLthtUt/iXty35AI1RYoY//h9cMiA1
	+xM4WWVZqeSydfQcZuEMIbMYqB1cmOos5gThx+a4g2lChtJF2WBzAg+inVJjC2+Y0skgwpB6fCR
	aI0Dp4lTnOl7+H0n0S6JZKoGw6PFf51aZsvEmmVZDMycMFWKXrQqgoIybu5HLENvqEqrsfoGVTv
	VYXdCIQ5vHGETjoCpN5y39L3ob6W3Sn4LCiiGpFkHZ4HQ2JwbgSP/FMvOoD4PAdp+7hA7zMHIEW
	f7NWIML8bwi0W6PUeqtK6d2uLtoGVzvowJGaDGsMDZ/RD5wOW0IGnQWrp3nX5RusPq15Yun/4EQ
	YloXhGVy7KiMCeSSnduZVarzweFL7le6p1KkS4VqTM7/DVUmBOCdEh
X-Received: by 2002:a17:902:e804:b0:2ca:d172:7228 with SMTP id d9443c01a7336-2cfde7a73a4mr104187015ad.11.1785187476604;
        Mon, 27 Jul 2026 14:24:36 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc338sm40992665ad.43.2026.07.27.14.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:36 -0700 (PDT)
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
Subject: [PATCH v4 05/21] xfs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:42 -0700
Message-ID: <20260727211758.1116539-6-joannelkoong@gmail.com>
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

Convert xfs iomap_ops to the new ->iomap_next() callback. Each callback is
generated with the DEFINE_IOMAP_ITER_NEXT()/DEFINE_IOMAP_ITER_NEXT_END()
macros, which wrap the iomap_iter_next() helper to finish the previous
mapping if needed and produce the next one. No functional changes are
intended.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/xfs/xfs_file.c  |  4 ++--
 fs/xfs/xfs_iomap.c | 39 +++++++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b733225d2864..768cabf6250b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -859,9 +859,9 @@ xfs_file_dio_write_atomic(
 			NULL, 0);
 
 	/*
-	 * The retry mechanism is based on the ->iomap_begin method returning
+	 * The retry mechanism is based on the ->iomap_next method returning
 	 * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write is not
-	 * possible. The REQ_ATOMIC-based method typically not be possible if
+	 * possible. The REQ_ATOMIC-based method is typically not possible if
 	 * the write spans multiple extents or the disk blocks are misaligned.
 	 */
 	if (ret == -ENOPROTOOPT && dops == &xfs_direct_write_iomap_ops) {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0536e2aeddcc..71c45be8c652 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1037,8 +1037,11 @@ xfs_direct_write_iomap_begin(
 	return error;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_direct_write_iomap_next,
+		xfs_direct_write_iomap_begin);
+
 const struct iomap_ops xfs_direct_write_iomap_ops = {
-	.iomap_begin		= xfs_direct_write_iomap_begin,
+	.iomap_next		= xfs_direct_write_iomap_next,
 };
 
 #ifdef CONFIG_XFS_RT
@@ -1089,8 +1092,11 @@ xfs_zoned_direct_write_iomap_begin(
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_zoned_direct_write_iomap_next,
+		xfs_zoned_direct_write_iomap_begin);
+
 const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
-	.iomap_begin		= xfs_zoned_direct_write_iomap_begin,
+	.iomap_next		= xfs_zoned_direct_write_iomap_next,
 };
 #endif /* CONFIG_XFS_RT */
 
@@ -1274,8 +1280,11 @@ xfs_atomic_write_cow_iomap_begin(
 	return error;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_atomic_write_cow_iomap_next,
+		xfs_atomic_write_cow_iomap_begin);
+
 const struct iomap_ops xfs_atomic_write_cow_iomap_ops = {
-	.iomap_begin		= xfs_atomic_write_cow_iomap_begin,
+	.iomap_next		= xfs_atomic_write_cow_iomap_next,
 };
 
 static int
@@ -1298,9 +1307,11 @@ xfs_dax_write_iomap_end(
 	return xfs_reflink_end_cow(ip, pos, written);
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(xfs_dax_write_iomap_next,
+		xfs_direct_write_iomap_begin, xfs_dax_write_iomap_end);
+
 const struct iomap_ops xfs_dax_write_iomap_ops = {
-	.iomap_begin	= xfs_direct_write_iomap_begin,
-	.iomap_end	= xfs_dax_write_iomap_end,
+	.iomap_next	= xfs_dax_write_iomap_next,
 };
 
 /*
@@ -2168,9 +2179,11 @@ xfs_buffered_write_iomap_end(
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(xfs_buffered_write_iomap_next,
+		xfs_buffered_write_iomap_begin, xfs_buffered_write_iomap_end);
+
 const struct iomap_ops xfs_buffered_write_iomap_ops = {
-	.iomap_begin		= xfs_buffered_write_iomap_begin,
-	.iomap_end		= xfs_buffered_write_iomap_end,
+	.iomap_next		= xfs_buffered_write_iomap_next,
 };
 
 int
@@ -2214,8 +2227,10 @@ xfs_read_iomap_begin(
 				 shared ? IOMAP_F_SHARED : 0, seq);
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
+
 const struct iomap_ops xfs_read_iomap_ops = {
-	.iomap_begin		= xfs_read_iomap_begin,
+	.iomap_next		= xfs_read_iomap_next,
 };
 
 static int
@@ -2302,8 +2317,10 @@ xfs_seek_iomap_begin(
 	return error;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_seek_iomap_next, xfs_seek_iomap_begin);
+
 const struct iomap_ops xfs_seek_iomap_ops = {
-	.iomap_begin		= xfs_seek_iomap_begin,
+	.iomap_next		= xfs_seek_iomap_next,
 };
 
 static int
@@ -2349,8 +2366,10 @@ xfs_xattr_iomap_begin(
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
 }
 
+static DEFINE_IOMAP_ITER_NEXT(xfs_xattr_iomap_next, xfs_xattr_iomap_begin);
+
 const struct iomap_ops xfs_xattr_iomap_ops = {
-	.iomap_begin		= xfs_xattr_iomap_begin,
+	.iomap_next		= xfs_xattr_iomap_next,
 };
 
 int
-- 
2.52.0

