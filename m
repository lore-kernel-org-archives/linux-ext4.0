Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359A336B905
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186813; cv=none; b=Nd14fZSp9Ua0cnqlJbD6AJzkID1HcGasT9XxTaBdKxIKWFDJSJgge/oSOAP459BFhRnw/2HN4zgyrdcE/8SL9/9rQXswCpeuN6rYNLsUCQeBe8JlNShhCVjV5XIpzk7K35qYWXIKftzvXRVS4lDbeMztDk4w0XO1mF/K6zck7ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186813; c=relaxed/simple;
	bh=CZeQ5jlp+cp6gKjxbVDn1s3+zvrk0SSwZTZOeZT6kLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxNtC6EugOkPUK1YLNGjrE4aewK6zolEqVx36gG6zdwa2UjZ0kW/rn+ujdXcztMjSpLfndxyM6jnCiMpTN7DuRTiPt3QzFF1+jhyllJwICZlALNkigtgLdrOFLQqtZRRM3YqFTzLJQoJJemJOm0Z/VKraywSCHe3kFyif+jk6mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m2rYFDSv; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2rYFDSv"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so31012235e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186810; x=1785791610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sA8qfcMKn60DrBJK1FofCY+ODB0p8kaEII2FgoKTuCw=;
        b=m2rYFDSv9X60FBdZk4fQ9drzx3bAcp8qsPyM9GZrehqx4FoHguOIy4DEUTJYzvunzx
         s6svkgLSke6/ZfuQVsVth9H/wy0eCYrJLX8WeSJPaHv5tK65rlfegNiLWENBiIkDDgyE
         WU5DjxkPhqGTjyNy5TqLsD/xnWtUHt3JFHnRdWLiYU7KIQLiNQws7LwfzB2kgfwbMFIz
         1fND94RxWsbpUl5UGSNQZDcN/D33jfi4mHsxeZtxoXYgj3pP11KljSVkVMWNBxTwbCOZ
         n9X0ge3+f1eba8MrNFZsV+aT9pMQldT6vnQGz9r5Pj4DNfCS5pJH6OFUp59uOz4MSh+D
         r2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186810; x=1785791610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sA8qfcMKn60DrBJK1FofCY+ODB0p8kaEII2FgoKTuCw=;
        b=FR0k1JWgWzGa3y3/XMzYVu6mhGX4tl+F5QvhgakWowSd+vnnbcfsZjN6kB1sxuwMkd
         NokkyLeZ6Elo7MLoDcuEA0JM8jMxhTQCeqp5EE6mFikmikFDOracGfgGEcb4TNw2u4gz
         96EEyYzePAzAeYrfQ3ZNp9JoIzEQ+7TGTXCdrQEfHByNLYxrSExV0GgXEbj+1l4bFSSS
         6r8MQauzKmG4xRo5/R6kGlc+DG0guuucAflrYMbUUwj2VP8Zuu0aQ/11Bq5ilK0x5MJy
         JHHiOuLvTOZ8vpad05tRFWWRs60184ZDm0RLrehURBL/j7CNlWfgHnHdBwlDnyUe/yBk
         pOcA==
X-Gm-Message-State: AOJu0Yykjxdk8W6Onxl5MkGOg2P05kcKvlRIfF2P8SSVzQ4mdcO6cFS3
	sy1sHYyuPH3XQwxT5LiEsGXW3HyRIZfVU4HOybXZql5skC2nq0VEomi1/Y4Z5L8Y
X-Gm-Gg: AR+sD12z8CREiqbU6pmGUDE22ehzOFK7UMX/+9tlrGIw1WeqEaAAsEPR+XJtTnVzzsC
	9w3GUpZedRT/UeZzZoIp3UAQv4M6qNpB88bRQnimQ3XvBJoGovujyGxQ9JV4mvI8CIxB+GtZANh
	JJGNY6CBcGTYtQAtBizJ/2ge/Q92iKGV104b9Bij8e3PZsKBIRZFYRJcQphpjL50FwYseT+vVia
	qH87UkZ92YOpO9cLvRChYzAhsWpKKRmDLQeJWRb8iwL04hfEp3j5o2yPI9FpwLKhmmREi3s5ONK
	1QWjhRm37Obgdy81hupIWmR6jdOkD9DJpMAdcx2qbvMBlH7A0Dqwt8i27b6C07HgMElCwbAZm3c
	f4E5h/BOQJ1KTQuUo8+bvQM0ISpSaeAJrcSwb9TCzXfAiM94H0Kr8Hzmc3sgeB/Saq2r+mQ7QVZ
	EfZOWUasGCxqaRTkT0Hi72qm1tTOLpnwUymilDOq6E4HcF
X-Received: by 2002:a05:600c:3b86:b0:496:bbce:f3 with SMTP id 5b1f17b1804b1-496bbce0140mr86841775e9.6.1785186810480;
        Mon, 27 Jul 2026 14:13:30 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm270073775e9.1.2026.07.27.14.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:30 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 01/13] ext2fs: Consolidate duplicate min/max macros
Date: Mon, 27 Jul 2026 17:13:10 -0400
Message-ID: <20260727211322.19686-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211322.19686-1-ablagodarenko@thelustrecollective.com>
References: <20260727211322.19686-1-ablagodarenko@thelustrecollective.com>
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

