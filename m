Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64114426EA0
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 15:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105138; cv=none; b=s6pOfuZX+3pG494Sm1P7KUm62jY2tURmrVyePySP/7NIyOmAqcJILC5dwnJ3gVG3wGGeI/AyW090l573Wa5IxEmBlOD6HsKb3Z1XN6t0ykKM/uL2OuiWDXUE7pwZZ//SOwqFYYtuLbid1gbSIykcXN7urEbdTwoRpctZJ6VEADw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105138; c=relaxed/simple;
	bh=2lXmoqsuRZge3LSJyEefmkYupxEHkiwlZjc9db9af94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTXPqG8pk+l2aEaqnnUZVf+MkrsD7EaERQgYsXcWhA/ekZimYHqAX/QMQlV9T8hZwvLlIo04UcgMXMUdwkxbic2R41MLU3zKjY4CTn6ckwMcsSsJXKAb54AgjTLkL+H3qdTzKdDZMqyoecYQiMsfwXICkFzckC8+lLflilSsBuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A892E2VO; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A892E2VO"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490afc47455so37020345e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781105136; x=1781709936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4ZOXf7prDbc7cjk8kWZZ/SzJbuHL+bEndwp2BBX2y4=;
        b=A892E2VOWPCl/zKxfODCPzGcMtytkTNaf7Q0DYJdbhSU9b7iLWMOP2KLnj68NkpOfX
         uB/0kpbVfh0mMMWDnkf9Zx9lE4IMRbXXsrlhGUoGPA5NY7ro8vlb4QrNSwLpsaMJ1RuP
         5PpX0EcgWGN4yA9m6tne3+zqLm3+gP6K1FXY7UKss7WP+Fxmg9ACBzYU3xY11eLNMGnK
         etrXM+KjQPfYkX5aMnS1pjMIz9MTAtYXtFX5mj9OD+NvQT0QV6x4gYMZk2l/I+uXDeNu
         Et6GSj8QOY7VKie+YBVEBnkcuFwXwYTopE+wz9Cf6BfZQlbXBWC++/Vh4EfzDXXXxQ2K
         ju/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105136; x=1781709936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K4ZOXf7prDbc7cjk8kWZZ/SzJbuHL+bEndwp2BBX2y4=;
        b=iLRxCcFUqANNvU7P6zDhEZciwILVYisjK5va+Xn21VQHT6IxUYN9EoBdXbL8qlehoJ
         +dYTslrNcn2uzwECch5P4h/IJE0oAPeIA1Q3DfY7odzRR9OBWVSFc25j/5iRKtY9Rcw0
         Hsk7umZBcq2Iuub45vYqh05o8qQz/1mYYYJfq1m/81OfwqH7T29eg516KKxcxZw4oW6p
         2PmCImgUw8mCQHNhDFsndpiieUq9pma3/zs3bDSJNaDzO3QU/Zk9El3ylcFY0k4M7a10
         DXG5f88s+7GV/O1HnOIreSoskq2artdgY+1zBdDDfQvNy538JFvhX3ph19EFOBKayq7b
         xJvg==
X-Gm-Message-State: AOJu0Yz+xQIg4oUAMVWvxcZVTq+Xp9IR3plSNM1KBWEbHVATzmFjlKdI
	tdGoC9H6IRXaVkvBpcDNLqv2RZzfZXVsRPsUBWDV05wvmhqDiQ7EOchM6visBeClLFw=
X-Gm-Gg: Acq92OFnt0k7G0VMBU4nTMslBM+9894ugUJc39bETgSoG/fkqDDh0zHQ8KGUyplSE5/
	UY3Wx8DZwlGCy9B4HLD61SV1IpEuaAbumVVHX+BgYugcxfeLuAqgeQUudiak/Bx3XHSPEi4TAGQ
	7fMBgmMNJIt9zK4VMiHJh0urjmzFVRtRQxB09aXXloGAav6Xm5MZQ1QVBY52cDoApJ1joa+L2uA
	yDehmNjkYMBfEAKsM2nmhFJbPJ1y0O0ac14123ehKpaet6TrGtCCANvnlG0vjkIbG8P33qR7Uqz
	9Y4ER1Sy0kY5LFtzNTjsaLRBWSqV4iwDsL85KNf08V+J0wamotmY1Kj6razyRV2tgBocfTGeLle
	/xVyRyX0PmIT3DB91SuC2Epgbpg3a9XfVmu0yqKP6QafsrpKQXuNbmOXQkQMHcL5CBGHBW3+qVU
	3vfLX4hP6TRi0/TpqMKlBem60k9jQpbcoRLM8Qi56OLox68/sAurypodTQlEmKRQo=
X-Received: by 2002:a05:600c:821a:b0:490:4973:91a0 with SMTP id 5b1f17b1804b1-490d71fa976mr99551355e9.10.1781105135672;
        Wed, 10 Jun 2026 08:25:35 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm559103835e9.12.2026.06.10.08.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:25:35 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 05/10] ext4: preserve dirdata bits in get_dtype()
Date: Wed, 10 Jun 2026 11:24:08 -0400
Message-ID: <20260610152417.13576-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
References: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Mask the filetype with EXT4_FT_MASK when indexing
ext4_filetype_table[] to avoid using dirdata bits as an index.

Preserve the extra bits
stored in the upper part of filetype and propagate them to the
returned dtype value.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c36c3bf54590..f833f6ef0040 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2960,12 +2960,15 @@ static const unsigned char ext4_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
-static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
+static inline unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
+	unsigned char fl_index = filetype & EXT4_FT_MASK;
+
+	if (!ext4_has_feature_filetype(sb) || fl_index >= EXT4_FT_MAX)
 		return DT_UNKNOWN;
 
-	return ext4_filetype_table[filetype];
+	return (ext4_filetype_table[fl_index]) |
+		(filetype & ~EXT4_FT_MASK);
 }
 extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size);
-- 
2.43.7

