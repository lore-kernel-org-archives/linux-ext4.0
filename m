Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8062E57C9F
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 00:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864697; cv=none; b=lJg00fH8RQUX593e/IJ+oaVvflQlTLcumiCoBpe5dgu2OKjXjfs921/KT2Z6Ao3DesioZKhBB2rAAfI/LJR1fNQuurDOSj/jvCes07uM6X/5yJcwUU7jZA+q7/GadSD0u5DLTQ8EoSZrd7o+6CL77NX0IjaeqgZZI34zgdfygH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864697; c=relaxed/simple;
	bh=Iv4GCJaO/34mDYJOmxkE3wt9pN6X7diuAH2PZb21ThY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rL2QOHrGgPk5nvo9DW3+/9qQuDmejU/5o0nNxI25OlTuOVJeZMFIWGACTrnn41dSgmkYMYBkR8wAWY/H/ueoDeiWbU6fEOfK/YHyXzTLZbFJVG9A69EL6RVL+VPDipF+06dR4DDD7UxxpSrpI+0QQAqZIMrkB5xBFEsddEXI/Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WHIDGtbA; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WHIDGtbA"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e9f5637634so61437a34.3
        for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 17:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864695; x=1783469495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y1putNs7Ll9/eGF0kN7bKSNzhAECn09yq2yevPfUrcc=;
        b=WHIDGtbArVdNZMw24xOhOcFhjwxafvzCNa1p4dcwSzUHP3gvV3NHVfHSGcoNHOiLJj
         CAP6OVPbW5jkZC4u7GdhdTolOnoKiLSIEGg6mf9uBUoMvh6ei57nEdJd2czfruNnNlxd
         gE5TQlMcpqxFigPcPIJ+/UauapJF2SnU3XQobaIcuvMWihcDnM3fqIndTGS4InFCnyIv
         zRpjeX9VwN13cLSWLC2KmYD9jNPMqU1GKTQQRZ/9j+vxvsAGViTtOgAFrmXNoxIG8Qgt
         Q0apAmxJDfDDBy7bo+i7d1C/yyK/YhW9QS/doeEltVdFDgztfm7Se5qfAMrxaeQd2Xf4
         tQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864695; x=1783469495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y1putNs7Ll9/eGF0kN7bKSNzhAECn09yq2yevPfUrcc=;
        b=IvWRkc4SOwzdPCcrgHrIvgZW4ZNMP5ZtQ13Tj07cmw0ur/TWsEqVmwzfg+NApZ599s
         XF7iR3niA1KS+vQ49hr+91DHoMJI1qgKUKT3coqzXi0PQw8uEhJashZg2PYoIXSt5WlJ
         NNL+colP4WLE3poYfy4QqomPX52vI8kaSBkwhheXIsB1aHo3OHvNEdVwYswe4uR3NXVK
         DDRIGVFR5r8LjovdQ9YVVi1IcZ3IeruKvTy7NaRFMdQVvlXVfM74A8vqFULi9HWaRtyo
         cYwxSt0YyPEXm85r9gjOGm2irA09oh3PR5iXr0MGtlc+LN3fxnw3KZikQqzTBmV2tVhF
         sv6A==
X-Forwarded-Encrypted: i=1; AFNElJ/JS30x8+W2v8KNMhFEcpKnzT2W4X5PN5r7Q9gmymRnnC+HUc/HyKqOPp78VCG0EduCZaF3+L9YxpSn@vger.kernel.org
X-Gm-Message-State: AOJu0Yza1LBCrZZk99IRKeJRrxdsfkvoie/7CNPlbu32cce3zu4PT1CW
	ETfU96urmWYN8GbFj/bpwgAlIXgHEhCELxkbmxJ0DladT/pjGacQHg3T
X-Gm-Gg: AfdE7clMED18cqlLfdIpIp+MvTB2CjuEaf3ZiZrNiJ9El3QrBhHHYhtPiFF17bjH+cY
	I2PCkP92NGUCp42AUq/ufs/WK8wFhgOn/Au0EOsojncCzssBAjL044DEokqO+fEfZTvISIXLAib
	2FQGJ0eVd8TXmKm2Y+8PCUDESjr57P9OxzJvQO979KGEUq8ogTj81AzIjXrlLr9fMD0BtkrfQew
	5vYdDJri5E49fxGsdP4J/kU9t7GYMkuD7DuhIUT7YIKlzbqa/8kF7tAxZ2srdUHbV0G6hbgBwK2
	sRc4o57Gc2c6ckbuZZELVysv6FDgYFqmmAbdAkvwPrl9Sr27+25rKSnqxVReGFK6RdI5m1nhtUm
	3JI2i4gIJ0ZhtfSxTp4fDoHjM2wsdQKrBUmf5wb5S9g3RD0Co0u4f/9YwD4rv4G0kgV/In16CjD
	h5hbSX1+vD6q43O/efOmY7DTC0WqzBlLBXFCiXQ1ns6GuiBrrJhVchJqWmhTwwVb4=
X-Received: by 2002:a05:6830:6f19:b0:7e9:f8e8:d905 with SMTP id 46e09a7af769-7e9f8e8e4e8mr2078716a34.16.1782864695410;
        Tue, 30 Jun 2026 17:11:35 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9ebfec7easm3576842a34.12.2026.06.30.17.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:34 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org (open list:EXT4 FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 06/18] ext4: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:21 -0700
Message-ID: <20260701000949.1666714-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert ext4 iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext4/extents.c |  8 +++++++-
 fs/ext4/inode.c   | 17 +++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91c97af64b31..431298eca7e8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5171,8 +5171,14 @@ static int ext4_iomap_xattr_begin(struct inode *inode, loff_t offset,
 	return error;
 }
 
+static int ext4_iomap_xattr_next(const struct iomap_iter *iter,
+				 struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ext4_iomap_xattr_begin, NULL);
+}
+
 static const struct iomap_ops ext4_iomap_xattr_ops = {
-	.iomap_begin		= ext4_iomap_xattr_begin,
+	.iomap_next		= ext4_iomap_xattr_next,
 };
 
 static int ext4_fiemap_check_ranges(struct inode *inode, u64 start, u64 *len)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..cf7aa8275651 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3850,8 +3850,14 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			   struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ext4_iomap_begin, NULL);
+}
+
 const struct iomap_ops ext4_iomap_ops = {
-	.iomap_begin		= ext4_iomap_begin,
+	.iomap_next		= ext4_iomap_next,
 };
 
 static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
@@ -3905,8 +3911,15 @@ static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static int ext4_iomap_next_report(const struct iomap_iter *iter,
+				  struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ext4_iomap_begin_report,
+			     NULL);
+}
+
 const struct iomap_ops ext4_iomap_report_ops = {
-	.iomap_begin = ext4_iomap_begin_report,
+	.iomap_next = ext4_iomap_next_report,
 };
 
 /*
-- 
2.52.0

