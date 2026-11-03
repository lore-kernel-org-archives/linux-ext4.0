Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713852;
	b=bedCyhqd8FC5aie+yP7eg1zUTgciGwqO8N9YbWplJOt9mbB+qdyiL0XpNhJDuMD930Cv
	 iNwW0oX0uWz/sWVtMBBM9Ch9XHrtZSO70k/smLde5ImUpsZfP5aMWkR/PV5qCRfZSMkqF
	 m76VlQMZs/LiD4N1dJRHaUy11/VLPdCKuK8ej7APPc3jclz+lLp8GXUqNooeKGR/6c+3a
	 aCiq/nyMzNNIJYMez/r0R3HKb2+PMn6Jut21v8DcHKGDGvhTdlCsYkSC1p9WwIJwpfdRm
	 Xw3DO/yzpUMK1mj2s/Cu+dBswu0XYMXMn6+FNvVNIOwPWYuyX9WfLrcNmk6xTEnZ7Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713852;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3OkI1uzBhr+gaWTPMIeHE8P1H82EumpKMa+06HbPpx8=;
	b=v2KXdv8aC/rrg/8i3FdHEsXOwMhjrxLxIqZfhjxgnqKq0eXeEhCk26g9GJhsODJPPKp/
	 /Nqm0fYIC09A8nbhRCI8QV1nmHtY3ImwEI1JpT7MSjhJtR7GrfAEi+cMFUz+Bh9RtaWdQ
	 Hh8TwsAcXzGS/nDD1YupgqI0udetsnFJJidk7iSUkkoE3n4yImE8s6iD0XgXP+Z37KdCS
	 /8PfjjKGZ6Da4eEU066+zFAGW7xCR6pItA9x8Ip93VtEiwfF1NGk8f9Bdtz2yNSb+pcku
	 S6KtsWxc+TsyCDzh3YaKFZHuvmGqM8aG6pT6suQCdCpHJm+uWlF8oFlY9gtY9xvrtTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N+v5NQWh;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14C8606A335
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F14C8606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N+v5NQWh
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48c4be28b82so4390507f8f.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713850; x=1794318650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3OkI1uzBhr+gaWTPMIeHE8P1H82EumpKMa+06HbPpx8=;
        b=N+v5NQWhniWOmfSLK5yWFdT+IUTqiiEpZ1ijAPqja1ioZ5Qv9mDx8kfKbdBKty0UzC
         lsbS+Nmj0G216wE2LyP53U6NzTNwbvVXWoBr+7V4TbgfHUS3uYP2VfeKz6eTAF2Wwqcf
         tH5rQyhqeA4jl3fBI3A7bPr+rUtV8CW3wZRUaernrgHUksamn0j3bYY9wL+Ed2WdFm+f
         Nn7/3KyeoKESEEmcQZCPzsn8Pltc/6ziwQYHBC2aafrshrTo9Di6h7OrlEKeYKfJWso2
         OMmFSI7HKTYoI/py6HQw6Gd8YNy/bjxuFfhxhE6ZiPlO8kcHFX87D+/wFCwNL2gZnujb
         htOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713850; x=1794318650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3OkI1uzBhr+gaWTPMIeHE8P1H82EumpKMa+06HbPpx8=;
        b=ckQNQGI+nrZ7XSBOuJi2FA8fLFyv7klP1/yZmZE9CWiwZV4wnmHAM4/Ot3vBJKi/dN
         ehgF6Bl+czhZuybm8AQukkTDO7KMeZc1uEZRPWlD774TYlA2iICMeXHS5x8rDrwuz/ir
         FlW5T4RWwUCkGaf5U5seKtUkxLPVJiAzaP1IM4QA5TP+7g1P3QuSEmHepVlYhzE6NO73
         WHR4QIQDjRGGna+cMEkOD8F1dHVO/r7j8dvu37ayUk9mWCbnOmz1rw8DZCQHSGLHuADM
         z1COM4tJVE8J71gvtah3ebdJ3W5XUbXonQRZ+aV62gAqLUj4dZgCYesrg9fIPJOD6Mw6
         FomQ==
X-Gm-Message-State: APuU4Z9qI6vg2exwxHzKEn0/HQ5xy/7T1BYkDtGUqy/ceuBjqQaZ36N0
	HiZO/j3t2dnqh6xyhn4Zi4eXZ4pnctm/OgY7cqy8bvZpuByI3XXxRTGIRHx6XtecMnM=
X-Gm-Gg: AYBFou1Yys4oljZpKRxvI+aMCp/ylB3pu/ZyNe9TX85fBGM8O69Pt0eyMT3xwwFp7tg
	Cojc/GLZyyi6E4ANH71Ot3sBCBMWDuiCCidy1dAVED0xZWRtQSfpg/pcD7krRl/U9RwyeqIUEvs
	XnSbpUTIqlb7lOh9OdDxSfP6f+2SqI5wGyeYek0sR7gGOra9NYFOMAWJZQxnbJx/tjJGQoxB+7N
	AeVkh6T77OxHkbUi6e7W1Xkm0FbQKelHIMxTDDNUwgjKLQlFvQueMNZX5tQONBodBxDQkNQjH5h
	SZwE3v6L69zXuXo+x6PN+a31tdjiVeqzRYFcpZgBki3WUxhCZ2qOVvP133jHct0TX48djJhNIrO
	IdnldY6ovdMoX5YisqyyzoCdrzdWDWoqMGTFTkef51gIYXdBt+hAsMmsXhTC/JBumYIzJVXdBG3
	XetfbABBV9hTit3HQDGHjEB8XKuv9kt2iLsvSoESyoj0DYmbLJG2iNDwdcBlVR9JmNo95G1synZ
	2f3kyIZ88U2LlKXrEBY2B7zkRp+IRAiQdxKO+nkswGi/vC4P2BLntLWFx7XNJEazqymxbTjkcuK
	er6k9u5P/sbZqHHPzXvK3E8ihuPnq/MKwppK6Y9aSzeV7gMuFD37sgJmbsw8
X-Received: by 2002:a05:6000:4202:b0:48e:6159:8274 with SMTP id ffacd0b85a97d-48e6e4f500cmr28607772f8f.27.1793713850353;
        Tue, 03 Nov 2026 05:50:50 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:49 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 01/13] ext2fs: Consolidate duplicate min/max macros
Date: Tue,  3 Nov 2026 13:50:25 +0000
Message-ID: <20261103135037.610132-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
References: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
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

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Move duplicate min() and max() macro definitions from individual source
files (alloc.c, fallocate.c, rehash.c) to the common ext2fs.h header.

Add include guards to prevent redefinition warnings when files define
their own versions of these macros before including ext2fs.h.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/alloc.c     | 2 --
 lib/ext2fs/ext2fs.h    | 9 +++++++++
 lib/ext2fs/fallocate.c | 1 -
 misc/e4defrag.c        | 1 -
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 3fd92167..ff29b888 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -26,8 +26,6 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-#define min(a, b) ((a) < (b) ? (a) : (b))
-
 #undef DEBUG
 
 #ifdef DEBUG
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c4fcb10b..374b8289 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -134,6 +134,15 @@ typedef struct ext2fs_struct_generic_bitmap_base *ext2fs_block_bitmap;
 
 #define EXT2_FIRST_INODE(s)	EXT2_FIRST_INO(s)
 
+/*
+ * Utility macros
+ */
+#ifndef min
+#define min(a, b) ((a) < (b) ? (a) : (b))
+#endif
+#ifndef max
+#define max(a, b) ((a) > (b) ? (a) : (b))
+#endif
 
 /*
  * Badblocks list definitions
diff --git a/lib/ext2fs/fallocate.c b/lib/ext2fs/fallocate.c
index 1ef989cd..82c18ab7 100644
--- a/lib/ext2fs/fallocate.c
+++ b/lib/ext2fs/fallocate.c
@@ -17,7 +17,6 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
-#define min(a, b) ((a) < (b) ? (a) : (b))
 
 #undef DEBUG
 
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 68e937fd..e07f28cf 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -59,7 +59,6 @@
 	fprintf(stderr, "\t%s\n", (msg))
 #define STATISTIC_ERR_MSG_WITH_ERRNO(msg)	\
 	fprintf(stderr, "\t%s:%s\n", (msg), strerror(errno))
-#define min(x, y) (((x) > (y)) ? (y) : (x))
 #define CALC_SCORE(ratio) \
 	((ratio) > 10 ? (80 + 20 * (ratio) / 100) : (8 * (ratio)))
 /* Wrap up the free function */
-- 
2.52.0

