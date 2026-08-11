Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0B03594A
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2026 02:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786414758; cv=none; b=GKGIqLFEevue/X9mW9MwA+z5MRQQdwx1cSsfQgfQ1TWubdd829gs5Nipcjw69USQ3s9bdL9PDfNTsXotgA1II2Eqv44GHZNckShS4/vdngMozRhdRt7mfQQe7x0bJPZZef/PK9dk1hAHmweop7I5T8bwmghcLkd3b+Y+RYS1Mg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786414758; c=relaxed/simple;
	bh=y03BeuLpw0clTMby9Bytd5AgAB0HIJesW86JO624dc8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jrci6LMfFVgZjca9UFrUHjPINEve58BUaqcmQotGl48Yn8+qOxCscdEaHVQx1wXrB2ZHLhAqUfkI6TZu5VfOquD71bsZitoryJHqMrCgSIJAumrYHhd943Tez5e80y+UmLBeq5GFAZS1CmwfpziYjy3vdjIzCKuDyLXdzdTi1rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+e5VQIO; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+e5VQIO"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3900e39d935so2575532a91.0
        for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 19:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786414756; x=1787019556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8nXI3rat92cD0JWP6TTTyNXKpdxCaJVWr0Z/sJZTqyI=;
        b=F+e5VQIOw1Nx+ce3ARgDv4EIUF+VlZ6wVwBstkgl8uFCUk0+kcVHPtAjhJ32fHAZLh
         EG+585OBozyElvAIrUCqwyFWlky3SIccP7Zqh/5GQm0f03DievNAv/iRcBXcpUZJ5rTx
         5WatnOZYfstMZ7TjAgrorlrYzln/QEnlXMW7pXKrIpXF5WdJy9e5fYDLOJN8u4huE98S
         uDWWfMNkUTpaS6KSfxoA1kI29HM9az7JNl+d1epjLTUGtn4lx3tlfyQi3dgd4sZNNHsA
         +eZdhWjaGHUuSfR0h8NqRS5Jhr2B4+sYENXVrAzxvYS32hmNxCwltybqs+5aQGIIreNN
         tDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786414756; x=1787019556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8nXI3rat92cD0JWP6TTTyNXKpdxCaJVWr0Z/sJZTqyI=;
        b=gxhFVcaG15GVLIarOWhOwI3m7RzGDG9stSFB72IDmIA8xES68UF9KylM1QorHkb01e
         BsFjsyZ3y4BjWrb0SW0rgpHeYMccDD3OCcIRWZ1FX9NNF5G3wKumzopMYbSVS2SQoSL8
         9/aRDgLHlarRjdxaM4f6iDMCvQ97FuRQUi+6KT/de4PGGoMvbdcHZtNzKExxMQlSDS61
         TYoxBMeChJb9Lz3qKG47md+sSAhzDOSSxJEG0uLpAOYUZveIfWEbXMeVoK3d8srLOEHs
         kQjAUv6l7QQApbz9kY1pKx646bV1ufPySP6x+Ewsx08iv4k6HR0EQJUiPw2It9xceL9T
         yVmQ==
X-Forwarded-Encrypted: i=1; AHgh+RqW78OUwXMvYyowkBuXkjR2H6863PYqVAKK0FHtd/69zKQBHK7nL2QARXN0LF6o9ydySNn8HX5C1e+N@vger.kernel.org
X-Gm-Message-State: AOJu0YzgnlkDLoKow1xPDdrrCR53DUTaF5X9Konp4jSSymzVvlv1plBd
	PNwIH1Wri6I6rQkuZwlnMd5tF4UYv3lRdFjWgEvuw0mWv7zNms8RJNX3
X-Gm-Gg: AR+sD11Ru8b3KVfb3J7yZtzwBSJJJZVQR8FWSGCwNYuiK3uuIZtSc+YtRznJwpTta+g
	tqLOM2AqytT6HrSO9lsMQQmSfuZtyRP5jGtlDUvgYbcIKfw9viiLEvEWJbcKaMNlljV0/PWwGWa
	38okFslGUM/x6GLdYRnIpDkVSUM0oIYHfnGKiMZDHDE/b0LdMXP7qoAallM0Sw3mXmrYie3UADm
	FOH1pg1sIQolSt0R4E0LLM11eenv6bUx+wjV74I7XMhYXguwr/fpvGwuad4nxJr0C02PFz7UQOz
	ogcAs665JjD9uI4sSMcxcxad3ydOhbNkz3Dzx2r00yfrdgHm2ddMPIc3aSF957cVcap4E7Pvum+
	0dAjs202imNz2oEBazZsKaIBPrc2xZBa6d5M4UwWTqnrSPyGdn88aCEBKhzg/XaG7FA2A976VOW
	GM/d2XjcUqX9aWXg1bLzlcdmmISIIesD9E8RhnRv23egel3dahkciE
X-Received: by 2002:a17:90b:2dc1:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-392cc923cabmr5938911a91.7.1786414756004;
        Mon, 10 Aug 2026 19:19:16 -0700 (PDT)
Received: from n232-175-066.byted.org ([240e:83:200::351])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392d51b5e02sm1554783a91.5.2026.08.10.19.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 19:19:15 -0700 (PDT)
From: guzebing <guzebing1612@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guzebing <guzebing1612@gmail.com>
Subject: [PATCH] ext4: fix reserved group initialization
Date: Tue, 11 Aug 2026 10:18:48 +0800
Message-Id: <20260811021848.1821435-1-guzebing1612@gmail.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4 initializes the in-memory reserved uid and gid from the on-disk
default reserved id fields during mount. The s_resgid assignment
accidentally uses ext4_get_resuid(), so the reserved group is initialized
from the reserved uid instead of the reserved gid.

As a result, members of the configured reserved group can be denied access
to reserved blocks, while members of a group whose gid matches the
reserved uid can be incorrectly allowed to use them.

Initialize s_resgid with ext4_get_resgid() instead.

Fixes: 12c84dd4d308 ("ext4: add support for 32-bit default reserved uid and gid values")
Signed-off-by: guzebing <guzebing1612@gmail.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 245f67d10ded3..63de62a75a543 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5369,7 +5369,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	ext4_set_def_opts(sb, es);
 
 	sbi->s_resuid = make_kuid(&init_user_ns, ext4_get_resuid(es));
-	sbi->s_resgid = make_kgid(&init_user_ns, ext4_get_resuid(es));
+	sbi->s_resgid = make_kgid(&init_user_ns, ext4_get_resgid(es));
 	sbi->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE * HZ;
 	sbi->s_min_batch_time = EXT4_DEF_MIN_BATCH_TIME;
 	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;

base-commit: 06cf61899d6498b33e4b7c87d99d5bd471ccc375
-- 
2.20.1

