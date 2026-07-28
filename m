Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844EB3E63A8
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 23:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282248; cv=none; b=b+D+LFtYZ3ZyEEQDwbxFOUFiDByOEWzb/VmQUGaGs3R4eGR4ePL/EdaKHT59ybdTBVqniABG07uIv6SoXWe++VnE6gDvWuT6Tw1SNToWCvIWm/rYrR31ZWTQ0MVDph7pnATw5zPm6nLgjn5I77JM7hfYuSL61XrWn8XCb3mrNSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282248; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA4DMqSKcIPawUpGwqAT1FocdhznIyTdbF4WDrI+A5LjkoQqIuoBJ8XhMIjfWptOLlb88519ZuScziZzHGPaxi6BpZW349XlvoAQxPEXdJmITx9cRb0z6gXyo5pXbweO2kbQrUvCfXPyZ8P9kG6rbd+PbQg6dtXm4ccaB0Tyloo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r6btQqSR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r6btQqSR"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so2250665e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 16:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785282246; x=1785887046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=r6btQqSR+cqgI1mBIh/NJbnrnLTnlWFmsIj/eRRgwrf+ca4j0Dvn3fU1RtWFyHOdX4
         Jt3kceskbiaNhe9fRh7AQOjbPSj5eHAM3zM+C4mI9Zh8NKe7Aq0bFpbpcVDdROEIjmKG
         8c1Qnb2hfm/p57DLnvCnP/4xw0uWIw9EMQnCAN9Oja2AS4SxUUqVA0Jn40p8uQhrVhdr
         E4652GMYD7NEJWD9rrkArIGKTaHwlkp0ksUNwOUfeEVXCoGczvkTFP2g12WotmbuVgnn
         kDbtl2rwK1MZ33y8uLw/k++daDkzklrTeLqOzcjUxzueB3QJIiIDBtJHxWdLxwkzAgW9
         yr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282246; x=1785887046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=YMGxaXoOPUyvX6gxBjU6EDxEk5GkPMS+kMCnZ+OKa6/fALIJvNSRBwyl9S2i70Ukqx
         JKLbXI35ejS/UIjx+Q1Yrou+Uia1EdO0O6Xg9x5z8uLmIcoJIpAIPYE4VbYLasVc/Lhv
         dy12Eyejk5MfAn2jw3y0/cJA/pm/CVoXgaTGZoCGHZnTj98UY0NhHkI2/CLK/Nlj+MAd
         7Uj0lBQZcXEz+D/5nRwYu77YH04nu5Cl2zDw4ergjDoBrQo1l9+DAr0pbKJPICZzs+Py
         Mw5f7b9D5QMf1VudCIVJXhiz7N0RCCAfFfT8G81D6kgBFxkNUj/RYdwbg0N3YX9QUWeQ
         uRCw==
X-Gm-Message-State: AOJu0YxfRv8kjupEnrmfJMEa1L+HhhmaWZd47DF/VEC3b5OE1JgFmeYX
	FrtPTImA/CgzLzNK5ZG+a33ctd3VUqfa/QQ6jOCy5oAQC4wGiq68bUQGrALYMf4E
X-Gm-Gg: AR+sD129ZrGfea6ueXzV/O6pin0nacVpfQsitaZp4yWglaO987lDOyQ0uhlDR9w3S8B
	ZxV1A2wgDLXs9oCDWpuRaYs45My/r3nM+fvW2Tcxg1CbEfZ5UmVUDLbIW39zUa71AYoD55aA6bZ
	buM1DT8puQTnTNFFiOjPRT8bnoZha29Svze1u21Nm+pIVgQP1Qlx26kZXBOu++M4AdyL+uJTkpS
	7EI7LguciDeoSwMAIyO5oz1MmyjuYQ7sulreB2ZhEm3kAkJZFkgiJYejVqyC8+QYCYKBKt16zmP
	yQHBCT9Eb1RqeYSt9+mXpHTzFWWyIp2TVu73ZSXciqS2CMu3kx9f3ZEF4kFLdYlMH3wCqKRLJ/A
	3a5NNqjc8PoIbq8F0jsCNQmbs9kT4Zwhc3iT5jgijJoP/GKL4HSLzTN5nvoV7/r7PVSbwKToAul
	QtidzktEexGd/wSbWf87leoOjgNxvhb3fhJbuZVEi4l/hEAlH+Xz/mPZw0jH03Up4NB863G+WS6
	OBtJay8UXFFvGw4oc/K
X-Received: by 2002:a05:600c:5296:b0:493:c2cc:aecb with SMTP id 5b1f17b1804b1-496c6599c19mr46389885e9.38.1785282245753;
        Tue, 28 Jul 2026 16:44:05 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496fa499a96sm13980365e9.3.2026.07.28.16.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:44:05 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v7 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Tue, 28 Jul 2026 19:42:12 -0400
Message-ID: <20260728234226.51753-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
References: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dx_countlimit's count field was read from disk and used directly to
compute the checksummed range (count_offset + count * sizeof(dx_entry))
without ever being checked against limit -- only limit itself was
bounds-checked against the block size. A corrupted or maliciously
crafted filesystem image that sets count to a large value (e.g. 65535)
makes ext4_chksum() read far past the end of the directory block
buffer, hitting adjacent slab objects.

Reported-by: xiaowu.417@qq.com
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cc49ae04a6f6..a283e285937a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -477,6 +477,10 @@ static int ext4_dx_csum_verify(struct inode *inode,
 		warn_no_space_for_csum(inode);
 		return 0;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return 0;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	if (t->dt_checksum != ext4_dx_csum(inode, dirent, count_offset,
@@ -506,6 +510,10 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
 		warn_no_space_for_csum(inode);
 		return;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	t->dt_checksum = ext4_dx_csum(inode, dirent, count_offset, count, t);
-- 
2.43.7

