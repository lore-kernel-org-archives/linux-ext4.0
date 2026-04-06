Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DA01A262D
	for <linux-ext4@vger.kernel.org>; Mon,  6 Apr 2026 07:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775461870; cv=none; b=DLMcCt+q4ZJKFFL22o6RZlfNRlll7D4CXgMj76r1PsHj4SzhvFxRYKvJfhSS3qTGyC596FcoZO3kYZApK6KPlv6soXf0EvyK5E6JyWpMYWTMEGmZmrPSDqfx3sFuCWcEEchQdWlnj77WSTU0ZMJXOOdZYmaYR19m87sq5SkY1XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775461870; c=relaxed/simple;
	bh=9oLFOPLbcEP5zMFcmtTTYeCP7QRgw3sR2GvdV3mT4NM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VKFssZZ0x8rNvmfSKn0C4jPLOpb6AYwwomKuy9a9yPyAMz3KAcwD10wVhRhwbe6vSh9THBsxVmi5seDPjfXEUpIir7zRaV0gP32qxrBt+K4PSRAi0sm0ptNQA9lFtjYy4zapJssDBuvytcEjCqvUTjmOlVQ3Pb0QC81GjbWryeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MtWye16E; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MtWye16E"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2adff872068so16086985ad.1
        for <linux-ext4@vger.kernel.org>; Mon, 06 Apr 2026 00:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775461869; x=1776066669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mfRe07VDdxyeiOp2leNAtv/+o9PcSTvv9BUYN12UeKs=;
        b=MtWye16Ed97CJdE6B4g9DUmwoav16sZSbS5VL13omwWGz8UR9xCBbtLe+fvsoPOKzT
         0xIbHD0hRTolPVQ0NemuCngg9AwnZd9/6io5yz6GAC0evOu8Dpys0tlrcnAAKxJGs6Gf
         Du9lk7zI+MNGJqn4BGzCLlWcFxBFCAfd6NSKc+rrD2kK33xaw/FZte+ppO+ECb9roa35
         golq6RMU/DilnxXDm4sQNeg3zfA6K+/GuIawa5gOBDQOd//Wn2rSf45F7exKao+GKHLO
         Fw1YNEdFSohlmfNhW6SjFS/n6pVp19K7P+SgXlXIQRJttAmPs6/aYyAf8VClszuzFw+T
         vb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775461869; x=1776066669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfRe07VDdxyeiOp2leNAtv/+o9PcSTvv9BUYN12UeKs=;
        b=BSC/yPbOJspqLzlR3RdvP7gjVpgvt/Jdai16i9qq+Um568W6LdVYexMkjm5VIvsF/3
         Dq/dSpZIRxgN+pSsXZJMptMILc/sYi5lS/OgDqFhHFt5HaAgBNUgPPdGqkdvzB4ro8Ew
         dHIEMiKVie3YV4I1VhAq706onW5m6LjxcoozZrd8Is+wrQ5ZEp3GMoyJf66wjDgMuF13
         HINRAeZVwN43SHlD+Pn1Grb2RXdkL3TwyKdgCvAoh8AgSK/96AtENeYT0H/AnZOfsyt8
         5h5hdtGgTTgEie6nuP058XnJ/pbei/GVId5akv2iWGvZ+cgtPco3lwSSxnr7AVODCW5H
         2mrw==
X-Gm-Message-State: AOJu0YzWnYazA72IVqoPXFIJfTTKIK2Rg/Zp9QxDjAQ9g8lGp6WcNYGZ
	uj59AIKAe9+vxC7AHgFJ1iTzSUD5wTEF+FPSQWoyFE1f8Ji53IsxlQp1WbJ/eGrX
X-Gm-Gg: AeBDieuDn9YII6pShGKE9t3icE0g1JjMw4QbisxjN1505KN/ThQHiK4T7rKTN5daW2p
	ewE35b29YiKA1yQy+jvWrYCTJjtc2eCt8R07tmS9NQI2c1ikZg3KfWJB4vp5AyRSBDcEX/t0dxK
	jI0c9XF/sdtgaYIqyixntGJ4b0qpOdqkQBagzBxt+1CrWve5IB5KmLz3BRyBzeInsDMEAybhrl+
	m8ue1B2Mo815bh/XAu5a9Oem0Yk/kVJZkscr4yhSzrvOCjxjgtFMSjMDxBuG0pN/4y70sDxGR7S
	5PfaLIB2ioLzvwV0rKTD890QPgtzgSemZzAJf5lMSf+MPZBcSjjbKXHLF2WC25favyFJsRQk10k
	bIFN0RT980EZUTbyMcCoCw7TlkigWjAUS0E1JqAueVx0xKwnU2DZ1pfGgKRxG21prMla8vS6cfo
	Bs1mbh48aV75oUW256ABuuCPmgRSRC1Sg27Nyi6R4cyDYGmpASSgW7qgLDNlW5W0izA2g32g==
X-Received: by 2002:a17:902:e749:b0:2b0:c106:a42b with SMTP id d9443c01a7336-2b2817fb179mr138260415ad.12.1775461869125;
        Mon, 06 Apr 2026 00:51:09 -0700 (PDT)
Received: from localhost.localdomain (hpcs-gw.cs.tsukuba.ac.jp. [130.158.42.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27477c54bsm167478635ad.27.2026.04.06.00.51.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Apr 2026 00:51:08 -0700 (PDT)
From: skoyama.kernel@gmail.com
X-Google-Original-From: skoyama@ddn.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	bhupesh@igalia.com,
	Sohei Koyama <skoyama@ddn.com>,
	Andreas Dilger <adilger@dilger.ca>,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()
Date: Mon,  6 Apr 2026 16:48:30 +0900
Message-Id: <20260406074830.8480-1-skoyama@ddn.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sohei Koyama <skoyama@ddn.com>

The commit c8e008b60492 ("ext4: ignore xattrs past end")
introduced a refcount leak in when block_csum is false.

ext4_xattr_inode_dec_ref_all() calls ext4_get_inode_loc() to
get iloc.bh, but never releases it with brelse().

Fixes: c8e008b60492 ("ext4: ignore xattrs past end")
Signed-off-by: Sohei Koyama <skoyama@ddn.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: stable@vger.kernel.org
---
 fs/ext4/xattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7bf9ba19a89d..19c72e38fb82 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1165,7 +1165,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 {
 	struct inode *ea_inode;
 	struct ext4_xattr_entry *entry;
-	struct ext4_iloc iloc;
+	struct ext4_iloc iloc = { .bh = NULL };
 	bool dirty = false;
 	unsigned int ea_ino;
 	int err;
@@ -1260,6 +1260,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 			ext4_warning_inode(parent,
 					   "handle dirty metadata err=%d", err);
 	}
+
+	brelse(iloc.bh);
 }
 
 /*
-- 
2.39.3 (Apple Git-146)

