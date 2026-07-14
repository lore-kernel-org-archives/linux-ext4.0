Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75093845A9
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 12:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033623; cv=none; b=c38sNRKr76Vjm2CFf0C8GFbyufcP2X/DGpfKZGRCShIJFUgba5RKMImfgMw+76Ov7SS+IRPOw74cGXIt7iAHvYT9EIrnRaBoTJk2A1sEhTQ9uUBQ2u4H5c/9SSC2x00RxV/91NlzCRiWhEvGyrjcsOF3vO94n70OqQyYHAf+oH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033623; c=relaxed/simple;
	bh=mMwmh8CunMxX79/11+cozJ4+J2RN0zZKe8Q4zjY9iCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erKT4BB4i6TbAA6CDZy8UiUzfwjD9M9nlIo/CdpMkAAV1uauE7KCLiO+j62gpC9lF/wsoSaI5x+skyAnsNX97amMJ4gt8Pv4amEO1CVAzBfT7ittRTo5lO8JN5lkoBpZLFyfhktDAScGTiMhke/hNH9eEnGy4P5PbNFy67y+rnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=alHwLyhE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alHwLyhE"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so6511795e9.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 05:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784033620; x=1784638420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=alHwLyhE+9MMkteWrPTMp30++3Sv+bWmiGF0rAoyMw/GpLB5+d+wS2hoGYY1wtzr4j
         pASDGLYPgeuk/axY7lVozk5Hocz9lb1DyYRUH5iWrXGwV03KE9UC7dNmABBwgq2SbCtO
         hPFtjOz3a3hpXW8i3gssoCnQcp7+cvUgAZLm27jPDR+PU388mYG7x69BNSl0o4vo57gS
         wbz6zyxUsOKF59hQvqmW5bAOzOCfndBASyQRLt4B39m9jFZFx5woo/0RYr+WYEDKfFQ1
         sn0QvqPHGeD+ln17NhJEuEl/PGFvCvdSqsq/uSTEMEb5GBZbpjNjwW9AG6eTGZJSmqQ0
         8nug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033620; x=1784638420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFueboZLPWAkgNDj6HQNTjnIe1s16kAVfyJgzcPKDFk=;
        b=C6ogCY3YrWMMo30KES+L1qUrfDD2wLUuwQcailrQM2eri4w6gWtylQPiDyxkQQqhZ7
         surndUnDivDUubYTdxV2UIqmL8JaCi2czcazyUEja0KNknFWWYSmm55Zwq2wdoJoB7Py
         AU8HMdlS7HAqjMJfMbFigA6Q6ECr5nO0CsQBNezf2BWah0iiYv9Ny971xHn8O+yEqo7r
         Zy+AQ6ts3VOPIQJ4rkdF5xLQeVEvgF2isIJrRfLwsrhPOwdbQOEZFjI605nkG5AeQWt5
         44j2KNZidZkq7+QEGj2zemnPKnh24rTSk9ZCaapU5A+el4mcB0U9nNW0P09S8UgoY2o+
         NYOA==
X-Gm-Message-State: AOJu0YzJwiLjHr4skIqrmmPWdNG1ZORgT/nWC3eqVWxjZ9B+icZ4/Fky
	V82zWqB9NEnHrtTIjcwa36COry/GaY1AlzRPFQFHt2lPmQZYCyrVlylB+of9iyl3
X-Gm-Gg: AfdE7cmC3mZcyxfYIBC3CW8gvsCvNAEk0Ugc2ZNZkdyaVlJuX6eXoz6ifOIpWTZqYGL
	FWZt0uoGyQKCaMt+ZyHLGyuOzPslEHbCSpWhOHUfBlKktB06gnChVFlZmZknAv2j5vokfRYWVEt
	LCHA5wXDZboQm9YN+5JPSlV25X7tivQor1ndeX0g3x6lCxkm8r+7e4sOmmNTx568NOg58PCEA9V
	WISZa4eIydaJFv5zkLV173098HSs7Er0TXAC1Kxk2CwtLsu1oD++OSWXVK2itE/QiWMQXCGt/z0
	GtFObcfQO+f2EOlm9fNjH3RypFx7KYXcF/iHHWzpONp895FWlo9RR9A+uQ/RJC0Ox7p96b8Ku8P
	lLN4hvFsp/zXCi3J8zB5LTHz5WHqgTuK4oIydzcC3SywR1YyIfgzQjZ95SXbGEQviYUk4kPp/tY
	poov2LG32HUrGpWkOr4CJWRkzzupOb/nMI6IJFLNvI/p4wxQ==
X-Received: by 2002:a05:600d:8496:10b0:492:6f5c:fd8c with SMTP id 5b1f17b1804b1-493f88c6d2emr95959125e9.15.1784033619684;
        Tue, 14 Jul 2026 05:53:39 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:1827:2101:7130:c718:1edf:8590])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2ed840sm70052405e9.10.2026.07.14.05.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:53:39 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v5 01/11] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Tue, 14 Jul 2026 08:50:59 -0400
Message-ID: <20260714125111.14699-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
References: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
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

