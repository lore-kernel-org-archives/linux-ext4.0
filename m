Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C8743E48C
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780085071; cv=none; b=KWOSKVtjmCL588z/PXK0X57R2ssM4KE9Vaw7jRbX1fgkLl3qp5crwn+NJC0cHr64f5NX7x3n49WToc2XCCzFq5Ob34eUZwH3mVtltyd6Xl0LE896OHm9JCSbHd++CWbEElXyqMuGhED67D05/RLrpR4D/ZWSCnb8X4Mwfh/Vilk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780085071; c=relaxed/simple;
	bh=t8c3UPWs6LSPrek83Fom1BUanMur5MmsqIrGAEUrEkI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V21jfLAw4AJQ4dn5AlXFGebiqaGvIEJmzI/ou/FCZvNGEaRDr/MXYAQIaQ8/rxvgPl11zn87N7aS1oYVsnt83sSCf7ngW/whuMAg3Ncm7DqY7eq+zcFI/E1aasGmuRFtaidavvBAWiD3WYI8PkwlHelvJNrs1/Equ1vySnPZuD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=xaCLN/kY; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="xaCLN/kY"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c8584e80d59so96646a12.2
        for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 13:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1780085069; x=1780689869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCvzo6kENU5hfMwATrGUenB8gEg/jvADBWhFYI7Pqds=;
        b=xaCLN/kYYWmW8hL2VVgmMn24fve56tugvW9OceUh0bwcnKXLaS02Xmc7Fiq20Xj++s
         amXuSFOoPNqc0bfki7X28SSuHSQhXhpI9uCXGQBsmzNaI/LEXVT5Zp/ljnhyhhqDMc37
         dGWrB8WsbYmFmWbbR29bGhDiqQGnvRoZpGNzLmHN7y8yCZYO02SXFKwyN+Wrz0fa2mjt
         v9l3akPkufI+MhxOWm6f/MT+5X32rl8W4zbSnJiXn/+9Wxz4pA0eFacIhTt3i8MvWRAE
         DnJeTgTZJMFCaKkEP9fvG1bLgF4uGu/h49b+YU5t6NfE8HBgF+i3hezcZlYvTpkKyRgZ
         jLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780085069; x=1780689869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PCvzo6kENU5hfMwATrGUenB8gEg/jvADBWhFYI7Pqds=;
        b=Y21uWRviAe2IKDPd6XxDQsoEfITtP4GbJAEyMgF89ecByLtwcCNCxbA4oL20xhzBKQ
         OcRbJIGaCcpEk7Je0TKg6Pwm8QIy9wejXr7M5TIioOAUrhoLrWHpXRkD9YgmMqF+Mwpw
         wLelM1k64Ba88r1o7Tr/A1OvjXMYcvBwP5Ns3uG0+Ibyl6ygikQWQO/PZQTsbkgJrq+n
         kmajkZ+yAyRNsYNtKNGbd0xYv7Ee1EuWFEoPDLrJrpMe6MUNU06nLhEE553TwWeGfDuG
         fnnlfJJnS+eoIVzxJCzALaMLBRS0a6SNFE/APPblAtyGjR+INEUirbBKB6jaY8XeQohN
         HbeA==
X-Gm-Message-State: AOJu0Yw9bJSZHS6mH1XAGH4ySC4YfxrSSEDa6MNrdpmShRviv+OcppAH
	X9Gsxu2ZlZEOTogl1dwVtby5xE40WvQ1OurG89P3LRU4MKNzItOQCK1kIsPrX4HXTwI=
X-Gm-Gg: Acq92OH160xXJJsdXmimx7/QMIdUhy7Ib0mfFTAXMDbAmx6Qz7HSfUSmt+7Pmcckivv
	Z1sAnHor4DXGKch4FfqSnz6BomaAgaZrafAfec/SqMPsnW6f88snPLveI2Y+rsHWNslXVagcseq
	GmwKadJAIn7IvgOLYzPMURL8/Pf0xcLJIkCF6HQQS8fa/RC+hw2EBqOwousJkzcH3WtHiD4ggqG
	ek7bBW5zIzF5Xfb9GI+LXDbT8z1muM1NWE9qC3rayBvG611FOlLASswV7svzpXocZb5ovzlu6Hb
	O6llKH2fjnwfTfOqCmduk8tnNB9wi4BZqKoh1UJhw4fJ1h0mxO7/QzZPd8HelRgDQzlO4V3/TQ9
	F2RFls2r5om9U3jQHSl0P3KYSDV5nhsDYwPJ9PrrxujEJlAZfHT8sSa4r+qgS0ZhbIH+ukGMOcr
	Wno/lz1yzNgs9hcGWgRQh1xMrG2GWz/DldRIYgwX+CgKJ4mfetvLm2/Ry6
X-Received: by 2002:a17:902:f60d:b0:2b2:4d36:7ba with SMTP id d9443c01a7336-2bf3637f9bfmr15395035ad.0.1780085069055;
        Fri, 29 May 2026 13:04:29 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:2c74:88a:7b8d:d752])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c51f80sm30140075ad.80.2026.05.29.13.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 13:04:28 -0700 (PDT)
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
Subject: [PATCH v4 2/2] ext4: improve str2hashbuf by processing 4-byte chunks and removing function pointers
Date: Sat, 30 May 2026 04:03:08 +0800
Message-Id: <20260529200308.889706-3-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260529200308.889706-1-409411716@gms.tku.edu.tw>
References: <20260529200308.889706-1-409411716@gms.tku.edu.tw>
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
index 72645bd92..d6e33b1f3 100644
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

