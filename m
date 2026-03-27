Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D572229B18
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 12:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774615250; cv=none; b=T0yWzUKBolJnhy/lRzx+w4R/rLb1XSQ8mhE/Gf41rGam2MD2XRimOm76wBMkTjMeROUrzToUwQQCMXyBgzrodx38rQg09L6uiSSGqavQajY/fKPQKambhGvWy0ve62qtZo/TioO3m7INvAPXPhfzl6hEqU1OM5VAM3phO/LTDd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774615250; c=relaxed/simple;
	bh=RYb9jxGkPQgp4iII1pHEowIpxAtVKauQd0c88YyW1tw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uuCFrqKPC2aHGNuGMMC8P7vjnrc/8jhyW1wKeHA5dKPcvqs+KYzJj1dOevQfTbOk0JbHKhYkflJnj76V8DE35s7WhPqhWZ6tfrtrALciUm9ADZ8M9HynbihAAdlruurR3oKc/ZCddpXzKmstiHRJPUXTb+P93Tp+oHcv5K4mMt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtBmXacR; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtBmXacR"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8c9f6b78ca4so282543385a.0
        for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 05:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774615248; x=1775220048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5qGaB3AmT5D3mlEzxaadIIfo4Dr31xEV4+lfk1MedwQ=;
        b=WtBmXacRfO729niEhxVumORUVsiifMPztGxVjo8eZyE0wg7g0A5eBm3fdEyREvuAPB
         L124d4ZYR7vQHP1GPtY4FAzw41phXjbrmyHEo8f7m03np1iRYcDsqZJs1Xz3mqI8Auhr
         hl+FPb04HL08wEPLve2PZR4PSYEfiMSkJkyFoFoH9A6MRmDjfyxznRjmx2nEPohnsqnc
         RRwmsyHdtoNfLcyrXFb/5hO4ByplHNnhMtcqqUNaKJGkvGoQiB3l7MrqGgLFQJdFnYOf
         98IywFIbAWmKHhfsPCMWYXIpB9t6uAwQ3EdvEfx+y10ZRMv4o43rtioVYnBdApZpqURQ
         1XwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774615248; x=1775220048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5qGaB3AmT5D3mlEzxaadIIfo4Dr31xEV4+lfk1MedwQ=;
        b=nNUj/DCAEA1F1Bs75el0aJ96HZHzv/xp3icGrcNplmf8j+XMP2PULsp9jVDnpouKLk
         PEItirix6tYNi4Acw/Vs5XlUtoj2/IwSRZphihJwEO2cJgVNmXOpEvC8Sho0nN/D7C2I
         byCoXOtJJjKWH32N/lVLelYiI7NpqJuYn6LKsqfqBIR3lvf+HjtNOsnHlwVnfMqzmOJ4
         m4pwY1xpqIRChnx8p3m0OI9zyFkLGd93Po3aL/TjwneZshr2v7O9UceDUhETMQprrT1O
         h+GTTV5q1lC+pM1p8Y/ju4kDjK0Ul70i8/X45YQdukCctQxkS3xgMYFSPCTvboOJcWtr
         ckLw==
X-Gm-Message-State: AOJu0YwwRcV6hbSvQTBXjFrj7rfjS7Xapy4lxyH5i76uN6f2eQvOV4WM
	2N5qiHb5TCdVLBKZ2QqKeIj0xUHhX4pkM0XA/m0zsVgW4e8Jk49U+Ig9
X-Gm-Gg: ATEYQzxPsfLHr7b+gyeqMDR0JUEbhKG4g2t9wVC6CWVZdFFhHm6PIHQKL0kuUS4l69b
	oJsYAlfmzpFNFs5DAbPXJ0nOTxFk9n9tCatWCLK0+1DsEFQeDHljCoFcs6ffKA6qC71MR5nCoBa
	ZK+DeDydMtFjA7EQ85t+owQJwFq5BFHkykOBnjNDY/9p37dbI9vZW8KRIm66zWqT4HUeytkg4/C
	m4PEEP0znFGFNAaGoscODwjRQJXHnfvt6ZHItdXs8csGEEaXqrpj49bGo8/RhY0tNFGR5UBuIMC
	XicWbGcGuKq78rJH8NLFArRhCBHCnA3xNGg4s+7YNPhEZl7M4eT0pnTu4G/lzUxXFg2tGw7gmVF
	u+lJ6OfiQns0rr4mFL7eb8B8ybqAXO/n1K5FuklnWjo2e6E4Yo31CJH9JTXLkNZPGRhNJr61cr4
	vtM74AiMjPWCL+KSwb9joYAQh48yn9IFQbAuqoIVpnx3JqmJRZPcc=
X-Received: by 2002:a05:622a:295:b0:50b:4e65:95d3 with SMTP id d75a77b69052e-50ba398eabfmr28858921cf.65.1774615248567;
        Fri, 27 Mar 2026 05:40:48 -0700 (PDT)
Received: from kernel-engineer.. ([159.203.59.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9215ad1bsm49556621cf.11.2026.03.27.05.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 05:40:48 -0700 (PDT)
From: Vivek BalachandharTN <vivek.balachandhar@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vivek.balachandhar@gmail.com
Subject: [PATCH] ext4: initialize ext4_allocation_request with {}
Date: Fri, 27 Mar 2026 12:40:34 +0000
Message-Id: <20260327124034.2968134-1-vivek.balachandhar@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace explicit memset() with struct initialization using = {} for
ext4_allocation_request. This simplifies the code and makes the
initialization clearer while preserving behavior.

Signed-off-by: Vivek BalachandharTN <vivek.balachandhar@gmail.com>
---
 fs/ext4/balloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 8040c731b3e4..21ea53346c55 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -737,10 +737,9 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 				  ext4_fsblk_t goal, unsigned int flags,
 				  unsigned long *count, int *errp)
 {
-	struct ext4_allocation_request ar;
+	struct ext4_allocation_request ar = {};
 	ext4_fsblk_t ret;
 
-	memset(&ar, 0, sizeof(ar));
 	/* Fill with neighbour allocated blocks */
 	ar.inode = inode;
 	ar.goal = goal;
-- 
2.34.1

