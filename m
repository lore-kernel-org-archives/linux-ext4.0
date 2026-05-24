Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927292C11FE
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779654896; cv=none; b=hO6xWEdXIBw6YLtBi7fSmQO7pBAuGi3o4nCJVrcbs/KVXi7DGno7k/Zz2m7+4vEzDBuDFdqwelegbeDOBDIg8r7VbAOOyUvQcSinBm1kN7P4JUBgNRIrK9/xmTWukSprlWJ/kfor8Lz2V9BYdv6UWLMGJ1mDrSXaRn4SfM4JzVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779654896; c=relaxed/simple;
	bh=CYNXz4zwWJL9v/Huwi5vpwbfvuB1GDuCXm/RcJXUH+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GUuSMKfvnT1kzKQfhveQ/cvBXibHbtfG9bmv97NfmGwpNOJREtcNePegoIUpdSjOBdSTTkWXBy2H/59vboRiyp7QeaiazTl9CZoyN59zvU0TxiJsGLHpGfjKicWX0NM+OkTfaTglnqMdQHw/lAYspFL1rp5O+rAoszU1/zvxPIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bN7JaboO; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bN7JaboO"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48d146705b4so95010955e9.3
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779654893; x=1780259693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m7P0fG3DUnEDmle9wQEulWcAbcDYn/9AHx78F5umJiY=;
        b=bN7JaboOYwcTikxIOwXRUt6BccDp7gEzXbKGg51cN6vdosI4WKEEMxYcT+UCXWSmGV
         iPQBo1D6QhDhW5P9uMVsB2s28pm6TrpbOResWRvbY/4uKhdAXcDKUgOHsSqwAti1EzzL
         C9vnOtb2sStyoQboVNRKsLvl+CsdiZINrCeL4qnMRMuTSnPgfraPawfhWCWndwv/68oY
         zJ1fbT+5CnMUE7exX4BarUK3C3LMpNpjYaudi0KYRzvm1B2m+2oGNq0mB8kqS29M/Kes
         qX3XA42SeDW5Wx6aC37J/r3+LerVPQmSyINYapaAanNCy7Pvb56TtkkJuqz2ZKIoXG4g
         kfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779654893; x=1780259693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m7P0fG3DUnEDmle9wQEulWcAbcDYn/9AHx78F5umJiY=;
        b=LrC3I1WgyNaWz+KB3S0R//mGbtLqmXajjpHCOy0j5OIllwSBWECaZ/2tFZUw08wajL
         6udZI2vpzl+52o7/376LH7RKOrp7BASPZxcdNVubsOQNCgoDS3EnGaBYaRajHcNayZ8/
         AsXnr9K6I+hdTTGs1pO5VmKmbP0cyzA3aUuUwFR6Dovwhj+q0fMNUN6L/jhPk60kfXXG
         6wfcGIKD0NYbgB4g3aZGLRuG5s4+KThL+UBAF+/YQPHJmnjJacju/ux8iesH3TB6aEOQ
         nDzhhXBHlQSx3+x3v5fRyGXWqpKHua4/jQsEKFZRzRJ4nW23Qh+KCjCFMgLU85jYCKQB
         Wf3w==
X-Gm-Message-State: AOJu0YzSlkRK73xVkkaWhviXq5xmdxQzEAgi6uFba3qxoNA2CmcdSAsT
	N1lq3MrVriiLIlCn9kJIicIrQjfnWq8N3YH4Vo+MxAsB9jALWEPW8dUnmPlOjw==
X-Gm-Gg: Acq92OERo1MknbRzHdm6qo313NThGffcI+Y5BofnmJFSHXxfvC2igowpg9llM3Ia8wf
	I0nsqOeuU22b1hQOBdJZEHYYMT28K55P6fb7cDhjviXxJ/x3f9u8jkkkJ4XG6yMgFIqq4qCxFy0
	nG2f6VPv3xpf86N/6LtaWcOan+o/VpL6RXivdhqLvbZCx6Hmo+bNzZfegvjBJrAg+id49X8lqbt
	s018U3BOgHxjesnL54uOYxN7mPsePObeu6SljHkoD68mGf/chQ0gfcCmEo9CNtdfgzYKgMNiW4j
	z/RARrvh2Pj4WrG9/LotjQ2hwDAMLX3IrOgq4n+OW0hJIHSQF1b+oU6BAS0zQCyTT/ObaqI7lFB
	LAZKYy9i2sA5/sb11JXvxWrqMe9wcDswQpsyhqUEFfPKLHFb4FJVtwygitZ1CcBoaN3CrJhmH+J
	9T3RJAApZlcFJNVO3qyCmUHKsB8kvxvCYTaaqEstGG
X-Received: by 2002:a05:600c:4ecc:b0:490:3c15:7146 with SMTP id 5b1f17b1804b1-490426cd872mr192664105e9.19.1779654892701;
        Sun, 24 May 2026 13:34:52 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454a0b9asm197382655e9.11.2026.05.24.13.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:34:52 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 01/13] ext2fs: Consolidate duplicate min/max macros
Date: Sun, 24 May 2026 16:32:55 -0400
Message-ID: <20260524203255.12228-1-artem.blagodarenko@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 3fd921679..ff29b888e 100644
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
index c4fcb10be..374b8289e 100644
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
index 1ef989cd3..82c18ab75 100644
--- a/lib/ext2fs/fallocate.c
+++ b/lib/ext2fs/fallocate.c
@@ -17,7 +17,6 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
-#define min(a, b) ((a) < (b) ? (a) : (b))
 
 #undef DEBUG
 
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 68e937fdb..e07f28cf6 100644
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
2.43.7

