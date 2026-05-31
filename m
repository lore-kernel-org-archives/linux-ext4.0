Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C562C187
	for <linux-ext4@vger.kernel.org>; Sun, 31 May 2026 08:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780214511; cv=none; b=UhJCDf5jjBsA1dbCQNlv9LaKVLGTgjVrluFPTpxLtG69B5FiGf+MU/ifCZsDk1r/8vF9V0+z1slVh9MiYdOgDsZUfA2aTptgybhOqfVtXCdV+p403vTU3BMBoPW2SyjSrpSAuvXLS2lrVxOnqzJfZMeL3qbiNS0JMEYmFxTUh6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780214511; c=relaxed/simple;
	bh=4/z6yP3+JuzW+3nQ9d+tB8xobpPUjdjHcioAcY9jFlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YZsPjgJjGoQ/KotlPZFRw55wUW6Xft7Jaf2zbGIFByX+Avtgy9fdlH9hkrsoOCttRqOQILp3zn9E8sYs+81uNb6sQcUOIY1+lENTuT3u9FMV6gXOpslaPbtzJdSF98KYPF/ESZX54h/gcUmzRsIq4cBEryIAiLwkdiICGhtvnd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=igf9ZB7Y; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="igf9ZB7Y"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c0c379e8ffso2684115ad.3
        for <linux-ext4@vger.kernel.org>; Sun, 31 May 2026 01:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1780214509; x=1780819309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwgjGyriqartm9D+KeKxuc1rd60Ey0Lbv69xmUQfiEQ=;
        b=igf9ZB7YfHmZ93CTyJtS81ePKA+/RsxS1k7f/9kcvMy1bpKj44GwTW8OeAoimzKqor
         uIoF9f704cVr5FtPU8wJqzWej+l2w3lkwArhOOlttb/m41fLc+ribzpn4ifgNXMf1T7w
         N4bHvzxysSpq2n7Yiu9XVtwDDobU4py4rV/42ZiaECRTO+wJwG4iessnJfC5t9u7lgd0
         ICh89xkBvHsXzVxv90t0gXq3GxAK+EYFcatyMaWy88xfokq6p/60CN609dWLkYvc4eaP
         w0V/1aRjs9kdOrKaX92WMoHpdlEUbSwZNAuVfyaG9vL83p+owH0yhhMGxjz1txQJpCvo
         Wo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780214509; x=1780819309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QwgjGyriqartm9D+KeKxuc1rd60Ey0Lbv69xmUQfiEQ=;
        b=sCcXtS+X2s1yYE7+43XAktrS/bfrvSbZcNrmc8M89AOtu4gvSmaof7xAyHuxvoUgIx
         6qMZVb6nFGDWgnEGnD3Vw/ETdQ5a6/UIQteL+2eeSTHjYEQW+sKmsd1WMirC9iZSKD6B
         FKHklgmOhaoHW+IZmlYy3stRxxaSki+EI5OGT4W+KmsEvuZ4qo7S4moO+WutR0NXBsCm
         WheuE8pJta3zGT53jZ94VgoIAlmWHTUjI8tuewfP/ZeAox9Jktc4a5n1xvDQNSqiGS8k
         NhRafV3nhwt9xIEzk/xKFqn6YsC2dSctsXNmaCHW2T47xOuLs9yHXVJtgW/zWzy7O1H6
         vbtw==
X-Gm-Message-State: AOJu0YwDyXetW6TxRpNRCIBQkmqpUfestdE4YNOfmPYIcKI3xnkiwzOq
	nEnkaK9MhSxrUDOBl9szSjDXKNQJCeEWGRPgEETVIGWDkvuGbtWA4oLKxEStucOw0+o=
X-Gm-Gg: Acq92OEgc7RdSZlfu68IAh5CAiDxzc+sMnp2vp6+XfhMAMiLmBoEDbDedkJFb1phFL1
	YjZ1wq1NlEGGk8xyR7aIwK6kn1BIKDcVAGKYHozBG8MKbYQmZst7+PyTEs3+DRehUghIy2zxqn0
	FBe1eMfgb/7fYZOKxkLiZ1CyC4r9zNMepNM+irQ7XIZi3COw9IHW5B/mI6NuC89wp46ugc2I644
	n0psnXdY+Ihck5PRYxcdyDr0BbigtOvkLmhjFy0ZDP3xmZHnzxmAX84cX9oQqOs3yiC84uoOkuL
	K7PF1C4afFfKjvS5TCfroKvPj2NaPlRCHRgrGl/3zwoCVTMmY1hyE7OWopQiczIGPWnR8nLHaCx
	8sv5IDp8cC+59WhTiObPKfjwVfIOoKXBigdzV/opnf/qVWZF46IiJ9j4YhMj6wGEUhZ23+PFPFa
	YFcI9iQgxhDhWV8pbXr44oD/iTWA36is4UtI5U5npI2RHVaqh5idrUCOY4
X-Received: by 2002:a17:903:32c3:b0:2bf:7b62:a02c with SMTP id d9443c01a7336-2bf7b62a2e2mr61420835ad.3.1780214509161;
        Sun, 31 May 2026 01:01:49 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:429:4bda:e5dc:8a16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c3f496sm70588225ad.76.2026.05.31.01.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 01:01:48 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	edward062254@gmail.com,
	visitorckw@gmail.com,
	david.laight.linux@gmail.com,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: [PATCH v6 2/2] ext4: improve str2hashbuf by processing 4-byte chunks and removing function pointers
Date: Sun, 31 May 2026 16:00:19 +0800
Message-Id: <20260531080019.3794809-3-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260531080019.3794809-1-409411716@gms.tku.edu.tw>
References: <20260531080019.3794809-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The original byte-by-byte implementation with modulo checks is less
efficient. Refactor str2hashbuf_unsigned() and str2hashbuf_signed()
to process input in explicit 4-byte chunks instead of using a
modulus-based loop to emit words byte by byte.

Additionally, the use of function pointers for selecting the appropriate
str2hashbuf implementation has been removed. Instead, the functions are
directly invoked based on the hash type, eliminating the overhead of
dynamic function calls.

Performance test (x86_64, Intel Core i7-10700 @ 2.90GHz, average over 10000
runs, using kernel module for testing):

    len | orig_s | new_s | orig_u | new_u
    ----+--------+-------+--------+-------
      1 |   70   |   71  |   63   |   63
      8 |   68   |   64  |   64   |   62
     32 |   75   |   70  |   75   |   63
     64 |   96   |   71  |  100   |   68
    255 |  192   |  108  |  187   |   84

This change improves performance, especially for larger input sizes.

Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 fs/ext4/hash.c | 64 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 72645bd92..978bd92da 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -9,6 +9,7 @@
 #include <linux/unicode.h>
 #include <linux/compiler.h>
 #include <linux/bitops.h>
+#include <linux/unaligned.h>
 #include "ext4.h"
 
 #define DELTA 0x9E3779B9
@@ -141,21 +142,28 @@ static void str2hashbuf_signed(const char *msg, int len, __u32 *buf, int num)
 	pad = (__u32)len | ((__u32)len << 8);
 	pad |= pad << 16;
 
-	val = pad;
 	if (len > num*4)
 		len = num * 4;
-	for (i = 0; i < len; i++) {
-		val = ((int) scp[i]) + (val << 8);
-		if ((i % 4) == 3) {
-			*buf++ = val;
-			val = pad;
-			num--;
-		}
+
+	while (len >= 4) {
+		val = ((__u32)scp[0] << 24) + ((__u32)scp[1] << 16) + ((__u32)scp[2] << 8) + scp[3];
+		*buf++ = val;
+		scp += 4;
+		len -= 4;
+		num--;
 	}
+
+	val = pad;
+
+	for (i = 0; i < len; i++)
+		val = scp[i] + (val << 8);
+
 	if (--num >= 0)
 		*buf++ = val;
+
 	while (--num >= 0)
 		*buf++ = pad;
+
 }
 
 static void str2hashbuf_unsigned(const char *msg, int len, __u32 *buf, int num)
@@ -167,21 +175,28 @@ static void str2hashbuf_unsigned(const char *msg, int len, __u32 *buf, int num)
 	pad = (__u32)len | ((__u32)len << 8);
 	pad |= pad << 16;
 
-	val = pad;
 	if (len > num*4)
 		len = num * 4;
-	for (i = 0; i < len; i++) {
-		val = ((int) ucp[i]) + (val << 8);
-		if ((i % 4) == 3) {
-			*buf++ = val;
-			val = pad;
-			num--;
-		}
+
+	while (len >= 4) {
+		val = get_unaligned_be32(ucp);
+		*buf++ = val;
+		ucp += 4;
+		len -= 4;
+		num--;
 	}
+
+	val = pad;
+
+	for (i = 0; i < len; i++)
+		val = ucp[i] + (val << 8);
+
 	if (--num >= 0)
 		*buf++ = val;
+
 	while (--num >= 0)
 		*buf++ = pad;
+
 }
 
 /*
@@ -205,8 +220,7 @@ static int __ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 	const char	*p;
 	int		i;
 	__u32		in[8], buf[4];
-	void		(*str2hashbuf)(const char *, int, __u32 *, int) =
-				str2hashbuf_signed;
+	bool use_unsigned = false;
 
 	/* Initialize the default seed for the hash checksum functions */
 	buf[0] = 0x67452301;
@@ -232,12 +246,15 @@ static int __ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 		hash = dx_hack_hash_signed(name, len);
 		break;
 	case DX_HASH_HALF_MD4_UNSIGNED:
-		str2hashbuf = str2hashbuf_unsigned;
+		use_unsigned = true;
 		fallthrough;
 	case DX_HASH_HALF_MD4:
 		p = name;
 		while (len > 0) {
-			(*str2hashbuf)(p, len, in, 8);
+			if (use_unsigned)
+				str2hashbuf_unsigned(p, len, in, 8);
+			else
+				str2hashbuf_signed(p, len, in, 8);
 			half_md4_transform(buf, in);
 			len -= 32;
 			p += 32;
@@ -246,12 +263,15 @@ static int __ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 		hash = buf[1];
 		break;
 	case DX_HASH_TEA_UNSIGNED:
-		str2hashbuf = str2hashbuf_unsigned;
+		use_unsigned = true;
 		fallthrough;
 	case DX_HASH_TEA:
 		p = name;
 		while (len > 0) {
-			(*str2hashbuf)(p, len, in, 4);
+			if (use_unsigned)
+				str2hashbuf_unsigned(p, len, in, 4);
+			else
+				str2hashbuf_signed(p, len, in, 4);
 			TEA_transform(buf, in);
 			len -= 16;
 			p += 16;
-- 
2.34.1

