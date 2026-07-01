Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334C2190473
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 00:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864712; cv=none; b=Pkhre8gyZyBzacmqytQ0G3Opv9df4QuHq4cCEl72oK8dDyGPsL3PMTpropYrc+iGfcZGll8O//v6fb/HkYmCXMOQc/MJ89ca6DpvhEP88Py+flHZFpTLFi6kZJ8HEdVOO0GRG+MuKPQTWj5BAke9fjhVfFRhnlqIQWUhOVNFviQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864712; c=relaxed/simple;
	bh=poQXawbGUGaPktypVMuM6tBnwR6xT/UlwmthSZUnqQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuQPX9CJOtDOskhH+gCwdh0n06IK73rAjyApNtEL8/0vkczaEIwLl8dChaw2KQKMIS0O6wmqVJr/y/TjD0AesXBNak7s5o78DlluEKVeCzpKEd6rDiJTtWjyEveC2X3RN58sR8QKeDHYUy2dKhxWEs7h5sciRx1kN3hSLDOd5OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=stmI8qs0; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="stmI8qs0"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-48f0e5e6698so91100b6e.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 17:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864710; x=1783469510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLxtQ8RRcat5JdEG4+gqeCTF1rh6owEPHX3/SlXOuvo=;
        b=stmI8qs0a8S1vLOdV0zgac6LUfcTYRnBT1sYkVQdVmasBJS1tGW+zWP1oIRZpGZTpC
         AjqIg08VT1h5EoVzqOfyINTuTU/7K8lfWF6kCNTfLbMNPFKLcSModGKgyuq4mXEvMkqT
         JFWmXH/KpJ6Rs91nVQLNN7kdWdMzKJ9SZ57mXwKCdjoAdRFuu87cz/KUg09Bt9GhzA7d
         Zj4AlnuvKcSczA4Jzje1wCsjahxVn69YHQ6W+T6HG484GBTy2x+3/uc5w1QdpV5ewZBs
         yNdQDmCvn+afphO1GKZaWHVnEzhyrHm283HfNCXZAxRz51rS+oWWS1hTBA3g2gWMSeKX
         P/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864710; x=1783469510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OLxtQ8RRcat5JdEG4+gqeCTF1rh6owEPHX3/SlXOuvo=;
        b=P8lQWdMl+GPCA/hXnG23mYvDbLEU2lbh3dwy89BisLIU5DL5gPCK75kktxvI1hBXuc
         kbyaECgDu+eVZmuw/t2wKXdNay85FX0G00MJT8QSV2vc2tDXN3xshtHyioEPki3KMSbG
         K6y7eZFaLHuLHckx69goZofW3O0mf1B1sViuE4xapWmHuOdAicJDNwnZU0UDZW9fusWq
         oEC64EKroNcOJoBzhWkqvFhL6POTS3BSkfdQNq7D1CqE0ompOX7Dd3DbsW8TXLRrNXhy
         iTiTfLGILWu3JyXpmNlFup+waAsdVr7U853dWkuRiiUwk13BgGJIWN4GykM9+xSon0lf
         hiKQ==
X-Forwarded-Encrypted: i=1; AFNElJ/1JA6ZCMbM3hHvJXxOvngm2romitY0tLIxyLcW1TPTmpGhGTSkLQi3q3AkbddfSooOCEqrW7KDigr+@vger.kernel.org
X-Gm-Message-State: AOJu0YxmztnW66Lx4AF2uLVBf5mSyD7Ho+wz0ZYJHGSrPFR3nHbYlsyw
	ts4jCkhph6MX4rey4+nKdeerDU5YyvEL5QD5awuoZ5QPR045u4P5YDUS
X-Gm-Gg: AfdE7ckDSkCdd4yFcCz0klESzJQPoRSIZw6AWaa/16a8bSzkSg58rXFmLW341ofPR+y
	zijw3AJuzhZZUcyTEOrMScl49MM+6tdJ+pGI/QWjFmXS9NvF1vYYu2cun6MSV7ZPV32K83QQZAl
	VNa9gHNZWUjF/+kzzwrjS+j3Sl/8BCcR+nem1sRr5ZCmCBBYj+g3FR4uTc4kvnEAjHcCQTGVkM6
	bCkNBbQX4FKPET+heX9P2XkY8niDBkwnc7yLvKdlK1RBLDO01rpgoP8NoEZj2kkWHnT4QVAD2Qd
	eFMpc+/zwqw6wp9RSgs0B0bFScqKDLkLi2q42nsTeU+6aLrrJerSWrOMbIIPcZbXv7RqQyIo0Uz
	cMW8ZnoiTBRy33hwwvrTPC5sL0a6nO5RDGhGP0rNbS7ExyMjPLP+iRZ4HF6lzwboa3W64/LI0YH
	3FbFcojFyZWlvo3rVV1dvnVPL2v1CIyq2QXm1IOLnbv61swTI0G+LYfPK/IWkvmRRj
X-Received: by 2002:a05:6809:196:10b0:495:f104:d898 with SMTP id 5614622812f47-495f104e5ddmr2749952b6e.32.1782864710224;
        Tue, 30 Jun 2026 17:11:50 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-49606b1309csm242012b6e.13.2026.06.30.17.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:48 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 09/18] ext2: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:24 -0700
Message-ID: <20260701000949.1666714-10-joannelkoong@gmail.com>
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

Convert ext2 iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ext2/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 29808629cce5..0693059caa35 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -860,9 +860,15 @@ ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static int ext2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			   struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, ext2_iomap_begin,
+			     ext2_iomap_end);
+}
+
 const struct iomap_ops ext2_iomap_ops = {
-	.iomap_begin		= ext2_iomap_begin,
-	.iomap_end		= ext2_iomap_end,
+	.iomap_next		= ext2_iomap_next,
 };
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
2.52.0

