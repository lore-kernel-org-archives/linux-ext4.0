Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38531607A4
	for <linux-ext4@vger.kernel.org>; Sun,  5 Apr 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775404043; cv=none; b=DOWjvGLRofptghvKe7BYwEQpv7FpEOUhrrw/VMdCbTTN5VD6Pz6b65bXteD6c1Fx0MjafFSJs6J7Lv3KiftATAeksq5tdUndyy7790V7fn4f2HELAGRZekUTf74iCeMulTZfCypEIg4k1wGmwjorQK0M3iPuuEIOlr9bZMCZJUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775404043; c=relaxed/simple;
	bh=BNIRLoPJ9ZVc4u13iRAIH58YhBoOsSDeQACdOg0OADU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DQ+WT7I1bsucPq4jUwIZGhxv2ga4BOBP/rIEBnWF07oeTUpvcXlm8ZT8dA6XV3+U436QLD7jOYYHS1w4SRstzWHtPaRUk5XLxYg0KayFt67KtMVZn00ItI/3ybQ0nhcQ2YpKnm6aHQ/7UCLLCyrFZ3uOkc+mhYZbMqf6EQKQ4hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HckJ/dJk; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HckJ/dJk"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d03db7f87so1749966f8f.3
        for <linux-ext4@vger.kernel.org>; Sun, 05 Apr 2026 08:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775404040; x=1776008840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1GDXqrrrB7O1mYRlr6Wy+npEAnYQu5f2vICcrraJGro=;
        b=HckJ/dJkFdwsIPGH9Q3TcxglILV9I1Brdcor44KdMlUgtlWX8kZTClep6W5/vRh4Gp
         fCloRjvJc9qFZWh2mVSocIyE0HymhLpd4cxvC9CSQk3BQWPwhHf21ehp3A6Q6uPAjQP+
         DNrlvRa4IN0h+rWMPAZwzTsmyTgizgl1jT/wCtB/rU457NPP2YNgtj4uHYO5XPgemkOC
         ks777eevWa80UXz3fTYrJefrlV1JEfQAeTIgWTRLaIRn1e7fNZNGhASsWtCnOWzg8ccP
         Oz6x2NskQ7i7BpddDDsXpwnt8M/G9AmzzOKlZykwui8YhDLwPVqljzJmEpOLja2886aQ
         ylSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775404040; x=1776008840;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GDXqrrrB7O1mYRlr6Wy+npEAnYQu5f2vICcrraJGro=;
        b=frWVTjlA6/5LsZvGEX+h4K+ngCo/iTfWWASYzNTsV/zHzKRuMPSgs7PtR7F6Jwp8n9
         pmrUA3O2qMoTCtm2qR556G76it2Xwtpd0xvTLvxVU473T9xTU3r9Uv9cpZbH6mEMvVqQ
         6cfWBYZkOOw8N01BMf6iUq6Y4uchDmnSsvav1R0ZPmlQLTCQneDq/wxQr+7VStn5TkG4
         CVnh/GrTggU+bDMw7ylVPqyXlV7dvo6MdT/sq1TH8woTCGOZOp8vXCzc+PRj2vz02l+Q
         5eh4jksNAGRmMy9gNTWaHrpbYwSbOky0yLGcYiuvxFc7emUdJOVGUjfgkW9wMepx8Rmw
         G0Nw==
X-Gm-Message-State: AOJu0YzNQ3Cv1OWozaqfavVwIWcWlMC5VempjM91BN7/QL094oAeCfFR
	upttY/vZPSSz1hSWL8cx+2iGqTh1DK6VWZZHCQby9Pzyajkm55VMUZIj
X-Gm-Gg: AeBDiev43Dvbn560BFH8krXtjF+ltv8VAbrfqvmOwnuNjlGm/8tHHhurne0gCtNYh7w
	Nj8TV2wIqNMu/BU1HjlOPg8OiGGbN01/wgTjtewyJ3dEGC/s1DPk1r/KEnKMNt7B0PHmo9DNZHP
	/WnvGqWuTO8KTa+1WqYE28ICMzS7fsvKG3+tvpiGhDFaLQZzD1WxCTldXz1sWph2TuAaeqfFxtg
	1XFgf/SvoPTuV/+noTmktqymD9KB7j6uFXuZxjPY6/YZ6WHOmMpRd6Y6m2dbGPwLn+/c23h0thq
	+4Dotpj367F3VC44Xj95pqdOe298fRpUquUmkcenR33brzLNGqMA0BhSRO1nRAhm8ixBZq6JIVs
	60ZHMw7EfSNtUYoRC9lG5qJbLOXhXypG4kc/7urWjJ4DghgCt96oK5o38bZwDLe+yLykVaPr+Z4
	VKinL4bTMaa0c889e5n/FiPCi1cOJTmxoqs0WuljguTcqgbm/azN4Izq5uuvbdhj7w4gWg7LQAw
	FXjbjdrfIX1
X-Received: by 2002:a05:6000:230c:b0:43b:48d3:2a46 with SMTP id ffacd0b85a97d-43d292fc2bbmr14715546f8f.33.1775404039977;
        Sun, 05 Apr 2026 08:47:19 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4e52a0sm31665769f8f.30.2026.04.05.08.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 08:47:18 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v3] ext2: use get_random_u32() where appropriate
Date: Sun,  5 Apr 2026 16:47:17 +0100
Message-ID: <20260405154717.4705-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the typed random integer helpers instead of
get_random_bytes() when filling a single integer variable.
The helpers return the value directly, require no pointer
or size argument, and better express intent.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 fs/ext2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 603f2641fe10..e4136490c883 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1151,7 +1151,7 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto failed_mount2;
 	}
 	sbi->s_gdb_count = db_count;
-	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
+	sbi->s_next_generation = get_random_u32();
 	spin_lock_init(&sbi->s_next_gen_lock);
 
 	/* per filesystem reservation list head & lock */
-- 
2.53.0

