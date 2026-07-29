Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F4146C85A
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353413; cv=none; b=QDIsCphc+PNc8PEcTIkao34rJ0F+gqLVp8u/M+n3bb44f7AjYplZg5uBCmiwzR/kGoZMMCE92Gjg3IH8eMaYNZWOS/eRI7KTCESym9wL50VxoYDrMJZv5Vd+KJ9iEVNnR6bwkQOirFG47TyYPlL58rTE3CIOgwpkIW7c+WfMfB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353413; c=relaxed/simple;
	bh=K8BrKecw6uXGDxTWCk08ni93yyms9UC/GDj7MkfjZVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngbMxcWqANfeez20K4ap5TPJtFqwTm2SkoNPyopNYj/x2KEw0/52fklS5Cno74ZWsDQIZs0GRHTPdxg3zGobsi3YuFA2I4uaRBUkJqO9KQ2qQKdDYgnJboAv/n1SWlCdVWpwA3aD67KLvCNDP31afop+scw7WuY89bedfXc9id4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U+FLovW4; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+FLovW4"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84e0688b7e8so1186761b3a.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353401; x=1785958201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uE0LjfKNhl8kzjVRKnr3dsoBJ6HNUFyTJRWoUOQfCiE=;
        b=U+FLovW4U2wlAaOguqZEmGkM1u4q+2fnpZxvg/oU49iwLhqN5ci2bEje/+rVZtEKgD
         WpptpdqZcr/+pmlAqYw8jIGaGKx7ZtEjhh//BUOb1Ds96MuxlHq0F9x6yyGm/ZCttlxU
         DGZ0nJILSccrn+ynKxA2WyvH5d+VOpLB72cLO6bfdxmSMvuwvih+FXarhs/uRT08ZtgU
         KSeDnkSWgIjG9XN4KBSpXExHlRIfb/XVmWRE1FmLPJkUccEDS5u9Y65tD0dWWs19melu
         E6MwM0qGVMbqWJpTaCz8KTnT6dzW3HBQXfhU3X6kTGSucvKHg3sxBXqdAXprMZoo9Ey2
         1/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353401; x=1785958201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uE0LjfKNhl8kzjVRKnr3dsoBJ6HNUFyTJRWoUOQfCiE=;
        b=HZYb6rkBNY1Ivf4VQ7qrYMGmMcyk8u0UiF4qqgAp3zXsOUOUcjJa6sWcdhkqNgDD3d
         OphtHt45C4HKTEkZqgGj/wakhTj/u3OrKnj8xugx6KCOhFw8l73bfKUxivOagFzu5H2P
         de0HgwZYz6jn88vI/r9s57dolQXFDMfB0w3WCr3GTcKzT0N3U26Bv5F72RgCBCeBdqvj
         T9BocFdQsn/GT9BhDJqx/rCOczeNDIamjgs2aWZXPYwMLf3+/RKKIwndi3wQr3PCF6Fv
         /CEYozVy0UIcDgoa45ZOZr5oJHe3LxMZ4wgWVJ/D/1ligeHB7FTNUuSLju4nyotb0UZn
         p8mA==
X-Forwarded-Encrypted: i=1; AHgh+Ro1gHdHcje53b5sC7qdRvcwHZSAGphToraT0xzw0l2YsuyU6UzHcKrjhuPFwVrq1L1CIBcrJLUrCs/v@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr04u6+UTRT+M4lOPEAb4D8iWovk9S4/Fgue3JkUtsRdZ09Tjm
	W5pMBKPZNQqrVnk4uKbz1VQjQNzpChDWVc2E9T8q+8xdjwxmBTBo0GzC
X-Gm-Gg: AR+sD13/1KuLVp2M+8dttZNSkQqd+9IcTvA+hEl3bUPJh25AV0Yh2dKgH39QpxqGC5z
	YjTLbXdlkbLqjL+dUzni4NMLHiRL2TwYo5a1l8IlCwAzj1sTyeZtkZaQMlMWaFJAcOn5/QN45A1
	3o7Q67Juko9Se3IXibDFdcn0eZ0paRtTCBuZUuFAun5n/1wqH9Cr76SUdDMOMahbUIL5mKkciEF
	zQdQhcwiINQt5la0GUFl9mGGk72+52OmXL5PYgdYvs5jKkmgiQ3zGccipNxSXsVRlJpBmKLkbvF
	KWvdllsvDg1pjspBZXrsz+n30dB/yg0R03iv0DyNL0T4vT8LyKY199jQ+u57a2iu8O6BYneZcXH
	uTsZUzu/AqY/3sb40j8brSJpGzwIFXBVC2O1u+l6+0/u3/ySfwIxS5PtyCC3fS/J6Jj0OF1Y+Fu
	qIaiwTtwuNO+PvymhYENSUiQWNKh+NZbl2YMy0LJWsyIzXyy0RQAsW0Ct9DcthYttxxxeZUY3SL
	GnIAwINaAw7GG66mMMZLsPXNGizLgDS4ArAZKkUl0N1EB8E5QY=
X-Received: by 2002:a05:6a00:180c:b0:847:982e:cca0 with SMTP id d2e1a72fcca58-84eb9ebd657mr102429b3a.19.1785353401071;
        Wed, 29 Jul 2026 12:30:01 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea02ff637sm1861034b3a.39.2026.07.29.12.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:00 -0700 (PDT)
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
Subject: [PATCH v5 06/22] xfs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:21 -0700
Message-ID: <20260729192737.3190206-7-joannelkoong@gmail.com>
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

Convert xfs iomap_ops to the new ->iomap_next() callback. Each callback is
generated with the DEFINE_IOMAP_ITER_NEXT()/DEFINE_IOMAP_ITER_NEXT_END()
macros, which wrap the iomap_iter_next() helper to finish the previous
mapping if needed and produce the next one. No functional changes are
intended.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

