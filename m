Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276881;
	b=gVUa252q17MBrzW8fIPP6f4Ko1qKUX+Oo66ma9auZTCkEXHdD0J5RxOtc286diCyDC9X
	 GdJlQLdhF37+4vEM4/F74qe1Tb8V0+sPZ9lRqAs96gke39Jgt6t9+jDFtLeWn6f4iHjOU
	 HKiVLq4JrvZf4V4FxR9wJIT9DZZTVtzJAJfUgprC5WEUo7RbGBXOCiYL2CualsJ2gBmvi
	 CM2BrlT/kRKWBpXQaf/hx124WyZO3OSpcyM/Pi83qZ/ds7U8eMeBgAtVXoGKwdwRB+q4l
	 AQ4sXqmhs5cTVGYZQB8oeKI7ISPYGXHZbxEneH3cTcWTefEnuTtjIWM1MbH1n+5kG0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276881;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3OkI1uzBhr+gaWTPMIeHE8P1H82EumpKMa+06HbPpx8=;
	b=ZqHICAdsMhCqnMz3wAtwcFEXvh4tcEtth09YDOXw6CKUxUxTbns5+S8M6WYJgFRJQMYR
	 3hHqaxZyECBeMVuuR59VW7v7bfvFhV7Y09QJkRwRR8pJ4HqE/csONf3KXXzhxP0i6tvzJ
	 m4tFel01KoG+WM4god2w5/03CJi3ZR/8ZL/Vt9ZwIgUYXni/YBb7PRnNjyih1PZonmIPZ
	 uXogB4MgnSdrGnqjkWYGIeANad+JvytkwheseDpyExyWifgmwLLDUOj9iNmflgKigUTh+
	 dWgSMSt51fwJLWGYeuUIiNDP2AyNfafnTSjFR4jTJaFvct6tpLNrqkWRPXiD1TL57VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Uw7lXCEJ;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C5D606A321
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8C5D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Uw7lXCEJ
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a214af2076so17234285e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276879; x=1793881679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3OkI1uzBhr+gaWTPMIeHE8P1H82EumpKMa+06HbPpx8=;
        b=Uw7lXCEJqQzdUAHhrzvMzOQ/TPtbv2TfUnZUv9vFKzflf1AAfY4CovQmZ/Zo+lcO+P
         vEBTmeJVCqgvjJxlM5dJL/oAx0TKnWRWhCVkLJx2fV1tzZtaSkYVhm3J3sQMbrgabQDI
         Uydn3MLjr62EWs+JViogGeLI0iCpCiwIgqE9fGWW7P7UN/+ewPgtq0g4NVJyEQNMHxaw
         b3zAu5PaKsAiHKqggDhW4+UKzX8OUuLPKsDQ0ShdUulhvQhes1hJqV703y8nrBmHHG56
         L9UH2Z7YSUSgBNkPZIg7BSE6rTdQiva0TjIeRj3MU7Aa7F9UAcqTPvXagnWBC+ULNT54
         AOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276879; x=1793881679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3OkI1uzBhr+gaWTPMIeHE8P1H82EumpKMa+06HbPpx8=;
        b=yhvdzQY0Yx2cwrYd7Mx5getJum1FSS19XjBqLt91lUTS4bFgF6FhIMrAEmp5MUHKLA
         tgWcx9mHzOVNPqFXXA15ScGPG5QZbvSINMLwaQoZB9PLcMbGNZ0oXZ55ek3FGG9RBZGU
         cBcDvVXGXo2S8ybeDKED9rY5MIupdlXUgcMM4Ov4rPy9ixINacjVyhvbWbMQSIG2cmd1
         1qtamZ8GZxhQnaH31WrrW8CKLMgVDJ8s8Gnzr4hyu6Cx+oWz111+dAdxid8dRg8R12C8
         BrKyU4OSPQJcKvFbgJFvFyiZNbDIW2KSOtWG8Lgnk4m9NWbJHPwrDZOQVzuO6qXIVYXU
         /xFg==
X-Gm-Message-State: AFq9FYL3FA066bg9/tzC8BNteAiVXheWR3T2Q01CjtCf7ozqWSGZL1+U
	D1ZGR8BVEWbYwUX2DUeTvMftnUqCT1ozGfG6+m5zGzGv1WoPQl6acIqOtoTYdTyv
X-Gm-Gg: AYBFou33L7gGWBaLNVZC0P1TBemRX+CnCHVfKAg2ERsXhksC9INesFFLpwfuJn3MQsA
	rQMYeEHAsIqNJ5S6YEJl0zH7Q442D0NPhbCu+pn49qX/xRE6d0/vEGaLs+DSb4sO4t2nRB66nS0
	nB0Vk03Zv6uk7w6MlF5ZM2HOFgxK1wj7LnO1qMpRyB5bxQszFB054c7CU/jS7/oisBhAUfxmz5j
	6e87MKGPuVtFRw42bED0l+bpMOcB0T896BDHz1wm8acbLKw8nVa8jC77zPhnD41B9AMVZjZV6AY
	fFeMBC8HJhuvxVlHroxSELUPHapYrSQs5ZNGF7l1kEton9b9XaErHUbMwlGtt4cfIkZnE/k5ihM
	qPk4kZfrpHQYY53PpGDRWzLjOfrU/Aw1x+venrwVEKkgOe4yB5lNpYdzCfnuXxpTciUtbxTfBHf
	b+J38/lOBfWLg6n+LpiyCFMmiNI4QxQt2QLIq7pzlsK5SI8yIZO5Yk50e8he2wY7+J5tGnD/8nM
	eqsMnDc6tmK08DB9mAWbkjpCQIsuk8pk9stMkq4DBeWYEF7o7GjYAadwiBdaD3loU8JveCK/fuM
	M/9ZP5+h787v51HJ/EVBSeAh0NjB3AEhGxPhhPRP/xECfjBP7C2dFAdGnBEY
X-Received: by 2002:a05:600c:3115:b0:4a2:1a:a128 with SMTP id 5b1f17b1804b1-4a966774f69mr121458405e9.19.1793276879107;
        Thu, 29 Oct 2026 05:27:59 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:58 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 01/13] ext2fs: Consolidate duplicate min/max macros
Date: Thu, 29 Oct 2026 12:27:32 +0000
Message-ID: <20261029122744.230678-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
References: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
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

