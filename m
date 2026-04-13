Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA39392C4C
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 06:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776063103; cv=none; b=p6Y41hzJ/PfCCBCjMSMhkUGt8OQUWrQ/BqnBLCtolRdCZdWPTw1TB0WxGi19UeVMnAF5MrpSB6Yvi01x3bIaJnTND2DN48Vn9pGSm/yh4D3r50kYyi0QQ+i1nuIaauMZIijz9QrF5iu2axYh3Sr8LpbFEVQKguJnQ1PZVqJeOfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776063103; c=relaxed/simple;
	bh=q9+P125CZ549OI7L3wYHYt7w3xleV/ATVK4sTB5jhk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S2HRfUP0HOL3kPbS7B/2GaBNH2H2HcjAzPrEzSWS8hA0rvNRlNFE51mpoRHE9re3wJPtgO+xpMVDsJJP7jIZMOzI8Quhx+53Km9Tz2konkhCbDAbvJRFl1vpNsENp93PFtprQdsnWH6b+qUKIJdo0EHwLDR2z+KkwAC+orOcNac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=kIVZo7hZ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="kIVZo7hZ"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ad4d639db3so18986015ad.0
        for <linux-ext4@vger.kernel.org>; Sun, 12 Apr 2026 23:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1776063101; x=1776667901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D4TXFklFQDmQmwxZ0Ud/cdt/UKuliJ1cGjB8R+Go2+M=;
        b=kIVZo7hZtsxgQ7iDHlkvyYqtoezBnE411i0cky1Hk72TbJnW6Riy+Q8Xy5TYjluytp
         ztV3xITlC/hKBGNCihdyFFviAHWD6XqnCYO67AY4wlRDXqQhCdh2jdFkBA79aHEp8Gw8
         PUrcOdn25/LVsQ5oYi7vfZpQNBhOv+u3v2AOBvBtK+h18kQppTx4OelZQITSJBtdl9rn
         xHcz76k4cVfk39WEUCbRQZAFTv+6PhE3ytFEWsvTRhsYxO5oRQOwngxmzoanr2AVNShs
         XHoUs+GyN/NwDwG8AhOCuMrtwfCtlCWvsj7jAAXbmGhOXjO27aNbxlAwETL+3x7cqUWS
         7jWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776063101; x=1776667901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D4TXFklFQDmQmwxZ0Ud/cdt/UKuliJ1cGjB8R+Go2+M=;
        b=pCLb9CJ+cOL5T1dHHsFyVL/0VM9m8pr75RcIq5Y/QD4iYQKNenrfseFUX1iv9Vli5L
         7gtRtVrQvm0KkmDUp5f4SKYBtIsYlokhjGMKj5v7ga8PVw7T6o1EA9oFoqEwzyjQ8waY
         zvBKUHuDW73TD+kHoBE1l343zE2jtotRsmd8fJi+3eqipKYkAASjcMgUb3DeEr6olp+u
         Anb94Uia2JUK+ScsRdKchDDetR6LyP7tiHrodPLI+b9/U2GkIg7o6hKT3U4O2q88lvus
         JXRIWCMk0pJYCfB9Dp3nefI0eH9k+cQBT4iA0AXi1OLhtmh5t7zFmLaTS9EuSOBEbPBJ
         3GQw==
X-Gm-Message-State: AOJu0Yxxulopu12mIlVZ9V8I4Bwk0jbPCRa+gvzXQTSiUIUx6w9q+1KH
	64ASOEwswSYo1KBE5WEHUyfDBYGJAdu3SxY4rDMgNMezMQZ8X8zHPdqshz/X9LdDvyU=
X-Gm-Gg: AeBDievpMADLPoSKljCbHtC7pyxqqbttC3j/8URyGwfdh/VYGr7Uva+lYntvmJ9ltOL
	EEaWhhrY6hJkKasDUtBfeMl1nD3cipyDf5LBi1xnlXvUcruEub1EaV+/cyPsFxEHbTLq9jBAAq5
	9alU1/r4+nf1KtEqyqvO42jiAfNwFzUAqd2qiDpldYPhFSj0eACkLHWW91MMISL5QZtc6g+4plS
	ZlYs2j+ua3c0jA7gC4i52fPkfPJcoXfjDmWubCHKEJAUuEsCjlYNHbcZmfoJYJPPGTi7LmSgB3s
	VpYwmWJY2MUHRpGlcFK8a5jtI4f8NoaN0Wgwr8Bruj4XNuTCZ3Yt/mYusd/l/9d6jgftLF3sqH0
	1ATt9qX/XWg9eGTd1gwmRGgenbd6X57+zq56ICpFzDMvEXnSAaRodTxiY/hXFxuW5N2tN3UJzn9
	VfLOvsLpR1+r8bIa9FXRkw5MS0aekAD8YyKUiYQ5gUJNow7Gc=
X-Received: by 2002:a17:903:3886:b0:2b0:6ce3:8f7 with SMTP id d9443c01a7336-2b2d5a95db7mr111280365ad.43.1776063101390;
        Sun, 12 Apr 2026 23:51:41 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:d062:a770:8a34:87a2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dde346sm100107855ad.29.2026.04.12.23.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 23:51:41 -0700 (PDT)
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
Subject: [PATCH v3 2/2] ext4: improve str2hashbuf by processing 4-byte chunks and removing function pointers
Date: Mon, 13 Apr 2026 14:51:14 +0800
Message-Id: <20260413065114.730231-3-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260413065114.730231-1-409411716@gms.tku.edu.tw>
References: <20260413065114.730231-1-409411716@gms.tku.edu.tw>
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
index 48483cd01..c3fb2df44 100644
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
+		val = (scp[0] << 24) + (scp[1] << 16) + (scp[2] << 8) + scp[3];
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

