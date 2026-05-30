Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6CD2C11F3
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780156746; cv=none; b=DbyusBp3LU373iVPUtUcwz7Ar6+Q9nhrQDam8CYKBfn4owOZpiTJczzvysCTTPHUHGY4uqGOdwja8qzWtLjOG+xplq4dvaIT3B90tUHBoyvIhxWi2NV0r1u5dVjYjXRVQUCyYJw2vMd2zWy9TVzaypHkIhkCIGRjOPvWZtf+PI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780156746; c=relaxed/simple;
	bh=4/z6yP3+JuzW+3nQ9d+tB8xobpPUjdjHcioAcY9jFlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hkMlruSTs5n4dgVDMZNMh+6g9xfow1gpztzga3ZtV3lIztoLimMZ8vHanxKT8GW+tSVG7jNkiH3dCnJwnLf3WfuSXssM7c3CIGcBKWgrLBWzBNACPWMXDy9OnYq/wq/TsZSTBx3NZMVZ4L3OP3cthQn7fh1hXrNS6RrLDcKfIxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b=LSV1nAVD; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20251104.gappssmtp.com header.i=@gms-tku-edu-tw.20251104.gappssmtp.com header.b="LSV1nAVD"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c0c20f0c0aso40955ad.0
        for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 08:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20251104.gappssmtp.com; s=20251104; t=1780156743; x=1780761543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwgjGyriqartm9D+KeKxuc1rd60Ey0Lbv69xmUQfiEQ=;
        b=LSV1nAVDGRrj97WDMhvQWlJ22AQPEFVEN5tbEtOU9woZItk0FwrK0cI+oGm7xpfJUd
         nFvK7QZSf64oEJq5JhyD63m5vOHAlevgc68TwJ1KTM1xiNhPMnJuAmUkCejrZ1iaUfWO
         YChsYMbmxqf6Me+rSC5FvpmVqYepg8WXQIt9Fa3Z5CvH6bHcSXPljYG5Vq5HveWbv20H
         9v6i4x/XTF3O94fuidm1EUEgtAt6hpVoiiNxdc4LElEzwXoENRVCPQA8u0kLv5/EZjFQ
         qO1RwvyK8FnaZJ5CXqDWjo3Ruy8LmAhh6xTbkQhQEP8aIk4whWsFPxXdhdgokSbLzqIz
         OijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780156743; x=1780761543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QwgjGyriqartm9D+KeKxuc1rd60Ey0Lbv69xmUQfiEQ=;
        b=tJhR+I1FQXrPdbaE3gH63/2SqnfBX0a/qgU1N/BWdnlgYbJ72IPxK2med8uaqq4px9
         Z+hnwU7WWywhk8on3PQpSL899/Yr/brfCotadl5G3dpqkwMQz86z5iShJWcyWJSUnQAO
         O1Naiicr82awYZbC8Vlzj1usKFI+TBsGo8lPzOAxb78pj2K9567gj+1MCj1pSKqdcq+G
         PyZoCjSu20i+uZzIwIIORT1UcmMpqK/kj1joVE4LFejX4nJ6dVCNOro4GlMbHhoczQ80
         PoLwCaEI7LQBXk3tjtoL3xyj+KLVFylK1cWqUNqOUHweW3dbObpoS+/gQz4hFdxb2FeH
         f2Bg==
X-Gm-Message-State: AOJu0YwSNK51j/D/jYWLMOs8ysjmfQbeEcSkw5EokRa0asZV8/rPFZ4g
	Jdef04J+HSJ3mtR6xSldchv7rVAADfABvifIW5kfr4Vbj/FGaG+yVUOPIZwL7ko7HvA=
X-Gm-Gg: Acq92OEV9mJKNfq/2k1xvK5mxW86izgrBNfHzYbRV7kwXJnlMjZ9HGZClXAqC0cTOID
	eWjdkemrfbDMdRhAYfOtDVeLfInUj9TvYXE8y6HRbhseIaqL6MFL1jk11fVS6MywTP/1hO2JDDN
	4ea3Z4vXDLhgmZQE5MRqH9TMkbW8RCBwuJkpdGwGIFXFjhiftPTAqEJi8pvdy8CeoHL9Xgw71sO
	mOlMcS/w6MYMuINQ0iX5TCugRtibtsEew00KXDWwmixJVlCAi2Su32SReWW1k6uPZK38ZqGkOt0
	hGSK+6ybxJ5D5+SJuRKAMoYUW4jOXcRumOXTXuTZ04bi6+lIi4+xdptGxCNDlIsVJjnDV0zSK9k
	0MVYOehVOb2kQVNwJ0CvhDL4VPrWQ/T36w0xbeOLvr/Nc9zv4l2YC+Em8PWxVk1XcLCJFC5GD/h
	XnEwEzb/jjOFl2khFNP+RSfYuvAVwWYlyllRwpWxICb0e6ddBjuEO1sC/a
X-Received: by 2002:a17:903:1983:b0:2bf:23ad:8595 with SMTP id d9443c01a7336-2bf367b260amr49708545ad.4.1780156743412;
        Sat, 30 May 2026 08:59:03 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:429:4bda:e5dc:8a16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c1e46asm51130855ad.61.2026.05.30.08.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 08:59:03 -0700 (PDT)
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
Subject: [PATCH v5 2/2] ext4: improve str2hashbuf by processing 4-byte chunks and removing function pointers
Date: Sat, 30 May 2026 23:58:17 +0800
Message-Id: <20260530155817.2311587-3-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260530155817.2311587-1-409411716@gms.tku.edu.tw>
References: <20260530155817.2311587-1-409411716@gms.tku.edu.tw>
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

