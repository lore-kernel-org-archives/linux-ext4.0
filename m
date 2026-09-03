Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAB94FECED
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472970; cv=none; b=olpds85PtiYiA2jGIfURSjk97m/l2mHrnc9NkGbrnLBGGQTFVcjn0AVZYbC6VtZH4WzU9gRUyQ0D4UI7ZK+6CKsc/GbMBfrJa3xqV5vK3XrhE4Ys6PFuIwmAp5yH6PUI0e12KN5B4ZifoyoGi9SY5axjBqEoy3FXLO53GwugiK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472970; c=relaxed/simple;
	bh=CZeQ5jlp+cp6gKjxbVDn1s3+zvrk0SSwZTZOeZT6kLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CazmL1khx5HhJqO0SBoDxOjv4HH3xKhSrpZTHX9V23lrhHEVc3WNS/i0CwdwLop/dFyvd4ycXx70/i73UIuBF3/VdURV2i6wy+kI4xp3gHWG6XLFrJUetwpF3mSJ1CG1nShE4qoDGQMdWvKMe6wjjHryTFa/3hxhNV3RuOxbkZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VHufXZiQ; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHufXZiQ"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so353132f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472966; x=1789077766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sA8qfcMKn60DrBJK1FofCY+ODB0p8kaEII2FgoKTuCw=;
        b=VHufXZiQMQsJkU37WM+raY0rFvgUZ6pzDO9sMk6Xx6x8k8OtVl9a8vhevlw5ww3qwZ
         lE6TVLQI5bUFZ4t5QSuzPN593PiCorMeykzu/4lHW/deR22vafCJCS6NtYJFBie6VWUj
         DVxnl1M6zv3O5DACcsJDrt9WT0Bh+CY1KYfD6767CHEiVIRplW6GW8BvPF8VahCOFR0S
         Lpo5v2VnUw+/N+UuLNlNbznv5kwMbJW5L+8AGmmFN0VkepDe9iz21QFTcF59CUaoPKdV
         Lfs/YeSaDwKlvFETuAKXYeRfJ9Kzz1epHmAoG07FneFHMzYu7lC3dM1bbtu0pm47yc/o
         pEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472966; x=1789077766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sA8qfcMKn60DrBJK1FofCY+ODB0p8kaEII2FgoKTuCw=;
        b=s/M2F8W7W2Zwr9OA9ZS37PbS68sdhoSOJWfQOX85lDTaSlW7TVNRB1FcxK/oVpeH+K
         CfhOJgQTndfQD9dFBslOrmEUeeqgirPRwfSnB62jx15dy3zMli4CLiG4EtS0jJt1DF1j
         LvvggcHzNEX+Fj9kFL/X/Z1Y/KTFt5ZUuUt41gcxOIc4h0TN7i6SQlZLqLA3O6oSnmDY
         BFrOlfrjXSSLmINDIQ2xup67TDzrVN7keuwjyuM0TDPzc0TaajtiQcir7FiTMfr9fE0s
         1VIuOd28C63958QxCGg7iTh86EkNNdj3c5JWRjGY8KT7ekH7OV2tUUyP5PU/V7Adt0mO
         9+vg==
X-Gm-Message-State: AFuF++k7mxE3ZV4X1wjbmwjZxHYFEFtFY95wAgimVV/b591kVQvTNAD7
	zmiLqtyZxDj0no2Xtl7i1H2VNwhHyykzKTRh01KGDwaD/s/RK4rNuVzc1baOpg==
X-Gm-Gg: AYBFou00dbetKOQ+MjCUaGq8cx0Lu83N5JeBIknahinkGPot7x6C7RDICBG3Fdju31h
	yTjF5vp7E36m9vXzkTNQZvtdgp7BqeAdX4iScbwkAjeFWa5YF1ZkWZIm6zqjUu96urwYZNnimWH
	tDnyQZ+pv85SodFFMpQXxN4VEwfKv/b2bae7YTkf8kQL072yLUzoWIl2I7B/9on3Vsz/e9sS+qa
	rTPLHYTGVkM/RvZNaQANdmo/eIt7H7ZYrwftTK0oRzjOwwrXIHXO9KbtTDhx615v6UBmyTWYQlG
	po6REuHQnM7yZAxwcgIFJsjRDn3Yytu4UFDbcVLQxTWPFeH+akxZx9q5jvA9BXA7wbkjweGrUU0
	v2LDntEz2k2OTHNV37yp1sI0ODt9v9Qfb4HoXEIYJiXR6CIq4VHP4j/yMk6H9rzivSK171apSQk
	r1yqeMR2NKydPk045aL2qH3qe/MarXu+0Ehc6wW2NWrM+jOYU730O6UL3U+ayNqsGrtOE/te36t
	lZwj/tXwmH8Bnx3iq9K
X-Received: by 2002:a05:600c:c173:b0:49c:cedc:3c36 with SMTP id 5b1f17b1804b1-49cf82a514cmr18211345e9.16.1788472966132;
        Thu, 03 Sep 2026 15:02:46 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:45 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 01/13] ext2fs: Consolidate duplicate min/max macros
Date: Thu,  3 Sep 2026 18:01:34 -0400
Message-ID: <20260903220146.19752-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
References: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
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

