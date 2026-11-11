Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794401598;
	b=Y3GatvGyxsr/N3uzqVrWxf6yYDVzfcMkVolRUZPs7bvf6K7QOd015X5zNqVtSdnjh60o
	 QdwJhEqvYEMC9d+5Eyx2BeERHZEKYt8mpIbcWRbiOJkgSdoWd2IH7wH9WLtOO26ToxRdC
	 cOA/gnRfm62m+DFIN+b2CfPpuEe9bUO3lV8hx1r00S2lQYxtru/DmH8grtsZ864iHe/vG
	 rweTZ6+yjQTTqNoLpYaBuH0R+ybO96TodK4u4TZUSV62uW2IaimtQkQFiB2vqAR4dJbZC
	 8Kr1VJ/MD5Rdo1E1HJP/4jx39EbOEjXKetMm4OGov5Kee74JHPXemZ0/D6JcjLvyMJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794401598;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g2sjA6cABSNzxAYxR70z3q1ml4Hdcp04R6x1d5IKBJk=;
	b=IGSLFTfTvcg5NfDi9Nj39sueiLI4kbLStO1JVrJPPuzE/+MeHLQc++ePD8hTZntKTAv2
	 ik05g11CX6jg1xyiwD0Q2GmpCL+hzD1gsWRpjzkWHZaC2BiBc33hwJ9Ft69T7FHMGfzv7
	 LlV9BrvT7XbLPp7cEjnHLLZoLM5ANGTv8kWwD5QmrOpt7qr5gxu2xOYDfUIngh8MiM8MY
	 hLnlSDbvhAtceqD8XZHmaYJfnofi/gDQQK5crKHLQQVDBl0PFk9rPlqbjQBGoR4vkC93L
	 bM6rcR31Q/uH1jxiLS1heYrisXj2a91Pjmwu/JHxM/2f8H66j15MAZHqKMdGeI2yu6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QQwliFBL;
	arc=none smtp.remote-ip=74.125.229.133
Received: from mail-dl2-f5.google.com (mail-dl2-f5.google.com [74.125.229.133])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC03606A324
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 12:53:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AC03606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QQwliFBL
Received: by mail-dl2-f5.google.com with SMTP id a92af1059eb24-1ac216daf7dso1754546c88.1
        for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 04:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794401596; x=1795006396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g2sjA6cABSNzxAYxR70z3q1ml4Hdcp04R6x1d5IKBJk=;
        b=QQwliFBL59LbzdPN+fSHueOXUcK2ZuWGPBBNhxVaab/2KI0FxdLaia5tHIamDE4n2m
         ZxY+nPghSkD1yImiBgfT+qKSSU7ngLRcx/Sy2N3ym42WL4dl3Xy+hvYt86qaL3kXuku6
         5ZOmvnE/4V4Lz4YqZq4n5iPqwrP2xHg/Ophy6fU/bYfz9EKoq01HfVCGbDd9REjSgMA5
         MIjq36d5M9WDQ+M/VU9teTVorh3y4OUL40rdQEeIIfDn/zLuXIhn2hWZ0srqYw5RTjm6
         48txMAUAqJOgj8CnSoGYJnO5BQ50YO/ZggG/vfdpMb97wlBcdhhoX9NWJYEWaoOMtkKi
         t95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794401596; x=1795006396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g2sjA6cABSNzxAYxR70z3q1ml4Hdcp04R6x1d5IKBJk=;
        b=JYVKJr5DjyN7hBm6J+G/GggOTA1cdWOJ5uwhnFjzczqsGiaFFfnN+6r6zIaNKSOEOu
         tB3YDvgkZWnUvuzMUmrnH9wkf33yTeftm7XKxiGVjQlx8Wz1ZQcuKkbqRXVtwMUDdS6l
         /QcE/K2kRuuMqsBJswjVTxgiYVzeogjbQQFZSbePU9qZeer/CYxwUOgQolvb9ErQkhAj
         6gobAwXB7povjJri6PlcnG9fk3I4ibpkjruAYXhesJXoRhtv08HVslfoXMoPR/zLHS9M
         JLw9DKNB9bZmSQGtDcyGdqSjku6iNdRIkYu6skzcTVB48OqVxCS9tPY57CevPVpM2GdJ
         Q1fw==
X-Forwarded-Encrypted: i=1; AL+hErFIiGaNSHbxpqyaUbf/2C9JAR5iCji9bgLrAvH1FqLlKlMTx69SUDR2s7wcJNIX3B9ybr1Py+GzOCo8@vger.kernel.org
X-Gm-Message-State: APuU4Z8FheuAfX/y+IcWG85MgW2KBGy1SA5aMYmtDAn3XPgo9MyicGLB
	SZIdhEHThy7TbuQxFBftbe6uLyn9tRRcsucpUhve5677VpV+Blj4jfQE
X-Gm-Gg: AYBFou1S6/ZgugimS7m07JXf9Et+AJXh+Pr5q9E30tYyXT4v9XH5VzeI8ewWSGGFUBZ
	s2sRsRRc18ydvfqYYPwr1cfpJAp0IGk/BWxiJb7gJuNrA1P9CTsx2hZXw3soNIfrYrob7XDbWle
	s425lvw6jd6RjmnmFvD6BXQAU2zNf7Yfttane9iYO7/K3ZOiNynCc/y/AHgYtDwiLr4dCrxop41
	N7jjtnqQIWrwK7f5R2xEFStoJZW8SSlQu7/B2k+dAA/1T7yVTr4rQUpFJixdJoE4vfEUJHrFmrL
	jT+xLOk4cxYrl5RqB/JNmlmb51IPL+C2ppAhNddUo/mwx7dmMvuKUmgzZP5QmwPUzB98cKQIS2p
	t5LkU+3/i4qBv6poYvyrV/WhUVcC/l49w/NAEn4IfMwKwdB/T/29yLDQJ158KpuQkyT5NlbU6no
	vcNJAXo5RSBSCPuRAtdR57sHgER7HT47VNVRamncclwmZR/RRPmY6n3Vp4LS8UWmedgyU+CMu47
	eHhyLQDFswcDIt7rSR+d1lJ8XmWJvCTiCBdJz+njHlMqoZQ4uvd5l5tlCiFXf4UQvoYbfJOjhV9
	AwhnuKjc4aKn/qWv4GKTXgAfHuySHh+8Ovdu1nmRqjEvCgjimOZpK/vvXU7+DZzg1szj33i3+LR
	3fI/qCBn76vLACaQhAwRqxggdXBCBovIMST7R6A==
X-Received: by 2002:a05:693c:41c2:10b0:36e:58f3:6f0e with SMTP id 5a478bee46e88-37682f9334fmr3045707eec.5.1794401596123;
        Wed, 11 Nov 2026 04:53:16 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3752060dc0csm18487673eec.14.2026.11.11.04.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 04:53:15 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH v2] ext4: report sub-block project quotas in statfs
Date: Wed, 11 Nov 2026 12:53:04 +0000
Message-ID: <20261111125304.96354-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_statfs_project() converts the selected space limit from bytes to
filesystem blocks before checking whether it is nonzero. A nonzero quota
smaller than one block therefore skips the project space adjustments.

For example, a valid 1 KiB hard limit on a 4 KiB-block filesystem leaves
statvfs() and df reporting the underlying filesystem's space, even when
unprivileged data allocation fails with EDQUOT.

Test the byte limit before converting it to filesystem blocks. The
resulting zero block limit then clamps the project space statistics to
zero. Keep the existing rounding and the rule that a zero byte limit
means no quota.

Fixes: 689c958cbe6b ("ext4: add project quota support")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
Changes in v2:
- Add Jan Kara's Reviewed-by. No code changes.

v1: https://lore.kernel.org/linux-ext4/20261101125847.54531-1-dennylin0707@gmail.com/

 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9cae52471dee..91c1a54730f6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -7001,11 +7001,11 @@ static int ext4_statfs_project(struct super_block *sb,
 
 	limit = min_not_zero(dquot->dq_dqb.dqb_bsoftlimit,
 			     dquot->dq_dqb.dqb_bhardlimit);
-	limit >>= sb->s_blocksize_bits;
 
 	if (limit) {
 		uint64_t	remaining = 0;
 
+		limit >>= sb->s_blocksize_bits;
 		curblock = (dquot->dq_dqb.dqb_curspace +
 			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
 		if (limit > curblock)
-- 
2.43.0

