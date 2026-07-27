Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017353BED7D
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 10:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785148874; cv=none; b=XO9tqN1OJ+9thFptd4YnlEUUmkiKT4thXdrXtD8oJ/T+VDHx9uPzbYEf3chi0Ry1+3FSWbiuWHshZBG2XVZ2NDPg5jC19JCraTEPXo4mcFDSf0fYZGsLau1URAVop5E1ZCGRegGpOxaKTRKhPNy14Aop/aPoW501guC57PSF8Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785148874; c=relaxed/simple;
	bh=TJn2JwOWmnMJdsvB3Ml+tVO7F1bpXcZCz4SN80OG2bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HqH28ekAQ8pkGwjkb1uVUKSsZi30Vc78ooA23fnIOpxfIilXu6I1l+sSMb3FR7N4z4SvgTWAuSkqfji60KRdVzcR2eDVrBCRqKX1KutnUiXDXKBFgGukfi61nmp/2sohZ3/qM77UW91Dm54oCcbaqRh59nFMudt/QmKEQslsJMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ct36AGQn; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ct36AGQn"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-382ef647e20so2528741a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 03:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785148871; x=1785753671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fkqx4nE94LNudhI5+qXIvn8wfCUZ/BJzUN7nEjdkHY0=;
        b=Ct36AGQnhuWCuZ5uZ9olSSb6BWcA/kEYZt5p9SItRwA5RVJDg/PtjFUHElWbPuH7Uv
         3a+kFFUVnkpIy8KitslpPaVuWVzTEGmuGuhB9cnYGUOej29NE9oeTobxEY8YU08GoA8c
         GhD08ubC33K0N+XrVKhYRC2E6mMp0q/W2eBWVFc8tscaw3Y6Tdr5P3wmkguPCYrtfum6
         MtzMewb3Q56tBknkowtA2st7spccIWvo0YGAuevrYzUMMI9GekAkjJJIz5LQSTXByi9j
         C0EyQ7/Z1f25pcgbe85OU2wnS/W1axglNPIjmK4qyxmVQDyLx0mDCUtS4+MqdunIX3ml
         KIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785148871; x=1785753671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fkqx4nE94LNudhI5+qXIvn8wfCUZ/BJzUN7nEjdkHY0=;
        b=THrVrNthHyzdlRyVU1PUuYRIchwZiCQt6BoCT629ZyH5pXbLzJvUaPPc1ShsiYcVk2
         hwyq+TV6gPpt132haygzxg+WS7BYR00EEv6QIHuMtloUXo39GKvesUKzms8vX7SYmAgk
         9gxTiYlSBw4TSvSPzQVZHTYlN57fJxWb1yPSA5EvIqxryy3BAlmN8TII77GYpGEZ2imi
         riWYXVkDzCMspARAtgUOc908CFwew/7AnGIRzX7BoV8pwVidit0WTUUsLz0wY1o+GhBc
         cEBJnU/Q2y0XMynKK3JGP7KxgqlbTQNmAilxgDSUckCdMIh6V5ZXVScmBuMDROy6kbey
         Nb4g==
X-Forwarded-Encrypted: i=1; AHgh+RoobLTVaeZrhNS3gyhfg9mQdlv68prNYKjypxOjU0ShRtDtRyR6kSYG9NWLznPXjj0ETThoIY0gpzdh@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy4rzpPvwvaLVAjyGbTwzj0+7eYv98iy1J5phyJ5VWVeX/rMgG
	CIiCUbizTe4h/WVCj8g2DO4+LXGLE7AN9LLi6BCZnZK1M1tTV7ETzi6G
X-Gm-Gg: AR+sD13DSFhRaYt5CeZ2FkcZvSCqJtCr1tMSj+/kc9mcD61DJ3jEtbryPTUuuLRy3ce
	y/6/h3bYUdY6rcyA5SpFRbi3w0z8UZ523NGTjybJ4vqA0wCJRAWtrdNuPOQ5H48sKilWX2hl5Ig
	C1UOyRLuZkcXWZwDp0oFeNFCuwlUdQkndfnEff7no7/ao4vXTkvHCet+QGvfsROsflKMUE8KRwy
	Mv/EV27Pzi4EULLF33NGoWqEnJB3as1EMqMz2ZvHvK+z3+CRu6tIpQzy6iemTbeFjfklE5g4q+m
	K4pJFPqOtxUIXMbhNCiJmEJTwX5EF+a3NSm8dp+EjF5wCn240Nm1G84z/LyTJN5mJSuexPHD6J1
	j89cz3HdPD1ZzEFkr/KlgEDlwGHo4c7znqRTK4wCdbqy8PnrwL7Umfjq+bH6NC/PJuecqcjjduE
	Ckk8SrS2izH5knldghY6Y4NxwZ6XVahd8MRm3Nx74aizJVbu4mXDSlMGDmPp0zH/k4JGEldBwjm
	xnMMY929gFTnAo6Hng=
X-Received: by 2002:a17:90a:d607:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-38f294ea129mr7808326a91.14.1785148871248;
        Mon, 27 Jul 2026 03:41:11 -0700 (PDT)
Received: from 7cf34ddc0813.ant.amazon.com ([54.222.46.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f2951f0afsm2901041a91.16.2026.07.27.03.41.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Jul 2026 03:41:10 -0700 (PDT)
From: Jiazi Liu <jiazi.liu1984@gmail.com>
X-Google-Original-From: Jiazi Liu <liujiazi@amazon.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Jiazi Liu <liujiazi@amazon.com>
Subject: [PATCH 1/1] ext4: fix incorrect function call when initializing s_resgid
Date: Mon, 27 Jul 2026 18:41:03 +0800
Message-ID: <20260727104103.28916-1-liujiazi@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In __ext4_fill_super(), s_resgid is initialized by calling
ext4_get_resuid() instead of ext4_get_resgid(), resulting in the
reserved GID being set to the same value as the reserved UID rather
than the value stored in the superblock.

Fixes: 12c84dd4d308 ("ext4: add support for 32-bit default reserved uid and gid values")
Cc: stable@vger.kernel.org
Signed-off-by: Jiazi Liu <liujiazi@amazon.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6c18b5adffca..a187112cafaf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5380,7 +5380,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	ext4_set_def_opts(sb, es);
 
 	sbi->s_resuid = make_kuid(&init_user_ns, ext4_get_resuid(es));
-	sbi->s_resgid = make_kgid(&init_user_ns, ext4_get_resuid(es));
+	sbi->s_resgid = make_kgid(&init_user_ns, ext4_get_resgid(es));
 	sbi->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE * HZ;
 	sbi->s_min_batch_time = EXT4_DEF_MIN_BATCH_TIME;
 	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;
-- 
2.50.1 (Apple Git-155)

