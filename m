Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50662349AF6
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915656; cv=none; b=spzTUqXzIRA0EOAz5SW+tKIOPH2D6fodRddBY6KIoGd+zCPkRmv2/m9TAA4M2lYcBY2HvM/XZatB+XEwyg6A53zhdzZP8RDV8iCHgfB1nTepgdKHE5QGttNuQ/EP1QXQZbL2DsNHHk46tXBr3bgCKGFjWSyn0y/L+TagUX55M3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915656; c=relaxed/simple;
	bh=yVLXZoLulwav1PxbuG31HH/kbTVB5XV4YS1ulHW2D/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cznp4miwQ0393lVfckaU5bEJzmWpux80NjnRjNyjuYkpFUuTMQ+5nO4EyrEyuoorMYl/2S8MZ3ntmzqGd/B0vNd9wQDRE1ef3Tflmvb863sc/lDhqdQxBMR6yRNorsVwsJ1qM4ZNvm+r/9yDgl246B6wsa8nhGmHMta8GKh7p2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tw1dl6WR; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tw1dl6WR"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so223226a12.2
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 07:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782915654; x=1783520454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eEE2GOdXPVl+8rgmSuNgRoIW5wbGqI/6NyjVQmxBuik=;
        b=Tw1dl6WRUjapKRCE2sRRZszJnUAv/6IxVEJHW2GHcvQJwPP0oXwFIUYv9BVCiYNC9b
         YkdJ2Fnyi8KFKJGOcLp/S5JVeguAfaIjP9oyOBZcXJrVrAtwIWi2z+Z0OnbVKXDp/4C/
         c3Acuor10rm3grBRfPUCplMaKO1+MCjTrWpFE4cfs/VFIiT1oxfwI2stamuQkqvYLg5P
         cztDcWcvzJpJ489+gXcWyRmGbShyi2BdzLtHTTwHw+LNyQlMJ58fVy5AMM5mkhWZTFhh
         uMuqAyCWQfd2bQfMY+FO0OtAOypDoD++izKKVPtMuwG51qp19CZZuRBD55gvUQTV3h8x
         Yw2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782915654; x=1783520454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eEE2GOdXPVl+8rgmSuNgRoIW5wbGqI/6NyjVQmxBuik=;
        b=InAYm8bZCZ82OIs00iAoZs1sAACamw6MtbXJLfxMvSrBa7rx/oBtkc5XWuZ+F9LyBp
         77DXHaWniZ26qptTgYjbWQk3n0AkRIaSTFYI3PPw99CY3zPHRTM78BDszW8327oU5LUE
         jzTzZRCj6lBouaiXCSNGJHjpj0Ijb/l1TB0WDQ3V4V39JLnw0fQSgYTgVlXxs16AzQJH
         QmPs9OEBgV0e2kgeVu0Z4jkJYLOOJaXwckV4Z6GUS6d2b7u3eDXMKcRxZ64NIdnJgAyM
         k1H3TC45mr7ppSlxPGB4MWug11b5AygZLVYq1BIKeS/I1zk1sHx+0klzMzTeXXyaHhVb
         wvZQ==
X-Gm-Message-State: AOJu0YyR4YrnwhEQNSYuGHweFrwNUKrqO+m5uwhQqIGYgUC+VEHPY3Xy
	oMA6onIlNkhaS1W/E41CQ/yyYoI6t0grJbD9d8sMRN4kgL7e9JEBplI8BOKHdaWPcMQ=
X-Gm-Gg: AfdE7cl2GrWknLE/4ceUOnMxpRENwd+l9zrl9v7pl/Lth7r38h73Ge9+o3OUTtKZDaX
	cYIad7M4HUKyJGDKKOwG/wSGqgn0acFJvuMacg4pnm6kK6UJI1JhYjwhwtjQN25JwgL9ZqnMxMn
	9NrkwBI008HgCx7AgLg6D4CF3bp2VCb3P1GbVJ9Uz3SP7bS7/EGUklNnpMF8lveCx0xF5uD8XW/
	zX0KB8xQANjMRtuCX6Oy1jCJ1gpV+cTTZPm546G+YuBFl0S7WXaHLi97y3iODWfnK5VgtnQDGa2
	t6H8UjCdix77OjEPcjr1wJIvzaKQT+nWv5Bqs6nuHM+7mdjkMmFPOPr1708XLPe9BbNaIvl44lO
	cZbuaboW2ji3XlJy6Dnkf2G4pT3WToo+T9vrjHGfKGoyXibTyXoqeY3GT/bKhDwnjwgCmxvpt+t
	LQ4lnC6j/jnovQDms9CHN8C7hPp7cohTIz9J2XumvZlNg=
X-Received: by 2002:a05:6a21:4688:b0:3b4:7eb0:47a1 with SMTP id adf61e73a8af0-3bfed2721b3mr2135991637.19.1782915654529;
        Wed, 01 Jul 2026 07:20:54 -0700 (PDT)
Received: from DESKTOP-DK6PUT8.localdomain ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e32ef8e49sm383894a12.19.2026.07.01.07.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 07:20:54 -0700 (PDT)
From: yizhang089@gmail.com
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 2/6] ext4: clarify return semantics of ext4_load_tail_bh()
Date: Wed,  1 Jul 2026 22:20:05 +0800
Message-ID: <20260701142009.1510104-3-yizhang089@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701142009.1510104-1-yizhang089@gmail.com>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

ext4_load_tail_bh() returns NULL for both holes and clean unwritten
buffers, but the conditions that lead to this are not obvious from the
code alone. Document this behavior to clarify the return value, so that
readers do not mistakenly assume that only holes result in a NULL
return.

Also update the inline comment following the ext4_get_block() call to
reflect this: both holes and clean unwritten buffers fall through to the
"nothing to do" path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..0b31fa873743 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
  * because it might have data in pagecache (eg, if called from ext4_zero_range,
  * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
  * racing writeback can come later and flush the stale pagecache to disk.
+ *
+ * Return the loaded bh if it actually needs zeroing - in written, dirty
+ * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
+ * a clean unwritten block).
  */
 static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 {
@@ -4065,7 +4069,7 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
 		ext4_get_block(inode, iblock, bh, 0);
-		/* unmapped? It's a hole - nothing to do */
+		/* It's a hole or a clean unwritten block - nothing to do */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
 			goto unlock;
-- 
2.53.0

