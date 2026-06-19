Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503D03438B8
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896319; cv=none; b=gwr4rL7RrJ9GGsjAhcnfDAgTGaOItPFw/tzt+4UHKmLGeu46loY4xmO8ZB6Ap+PE24MH3XuXGz8NOyiP9ik9+N9BGO+9hzmvirCSQm4R5wIWN282Cw4m+RnyHc0KA6lmy/UOuDB97UeR3fYg3wOlT7ZB2E874A/GlRphYBckpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896319; c=relaxed/simple;
	bh=OThOFHIElOUX1c/ZB6TWjLgE8iB04DaKWfOWIg0SNzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX3Riijjcujd9ZzYmMijNwRPJbqGs6olzFStX/1x1GrfXpTM+Ftekbsqh3d2MxUqJ0yUtXy702n24AkdaqHGCfeaJQZU9NnYk4BynpEPU43bFoUJY04kMB1xYu66MAJe8U7gTtZ00HIZogOvAOOvp2mwDAa4nkGyN+VlpFeRNvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fnylwPCS; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnylwPCS"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490cdae130cso13155455e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896317; x=1782501117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eO/0qFG1J/XyoZlo2kspw5sa44LNbKpl9dfwZgOZg3c=;
        b=fnylwPCS4vhhkF+bi4Tbk6zlVBUL7Q0T6pBpu/Ew/H4W2UVeT6YVFngwQQgwLanNtf
         IcVXhTMWucxegK/bOtuWFo4iKwC/8HKu918UuWllIlB7GusGuZ+jFFJEbmSbAnsNPRi6
         I5RhS0kNhNIXmziqvlKJCKoY2963oe5e/SJu/3BBoquxMAO/rGbaaZt0QvDtWO2P4o3R
         w8YP6uo6uf6hFe3gVs98vzU0kb272CurIdecpuehzuvGq/QQAtRn/fcVIbfpPH0go3lx
         6JccJHkiDehB7u8W3TrDtTJfB3hSNkeiXRFmpq7AxSwc/oGKQx1xRg55qXXUMGGmxF0E
         FboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896317; x=1782501117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eO/0qFG1J/XyoZlo2kspw5sa44LNbKpl9dfwZgOZg3c=;
        b=UQ8GzX0tJaXkam6TNhSzaIJqNNHs6o7quGGCE1OC3uaIt0xxN3kmZ7R3qTWGrd/168
         re35XDNlpc5+gUb4Q88pWWZ2GQpE0m3bev36tFtAAPrt9NBG1RnnJ/iqr2TyRnoGb3+s
         x7x7wk+LToFxfG4UWtM/ouMD7Rnn/QogAWXaIZVTJ3K0sxxA+O2x8eGOVyRGJulQu8f9
         CzysFEZYMWud6f+e4eNEPLJLPtmlPAQLo4QlEMmi7DyfAw14wvqQOxsPgvU2pK0v/vh0
         vbUqS6gc5eC7Ms6eRD/o6L4w5NltJDu6iVVBVXPeQa+ulc148uDI/d9XwK84x2k+Sz15
         dchQ==
X-Gm-Message-State: AOJu0YzAn2ibMzJqnndIz+IWNUd/0tjDvEoGCCYau7WFcIO9jtzotM8H
	t8cBtqXdI3HFWipzue9GrxCNFrTiXoowzITqDMiqs52DpluKB3hmCuADQ9hR+fEbB+/PFQ==
X-Gm-Gg: AfdE7cnCf1zqU8//wih0ncwUuDRPm01IQtnYpy6d2qlGZA/DcoMfV7UhEzNByAif/1X
	sDnEZpQRyQ6gZuXlNMPoe7R2MAA5PIYMnEHby+0eLw6ns1e8Fcylz43mWQuc/kQTTWulfLFqXsG
	pu6knUNlOEVrr2CILy6h3VWlx5r/5GpVUIBO4J3tE95x+dEJzxNMWB/aWh3clxOa63HH+C9M7F8
	OZDzk9L20Ff/bVfQNzJdvIyXkvIMZhBSduNnHCP9gtIDCXQDiFPyfeOaf/ES9dlXBs5pbLEnVHM
	BYF9Q2tSDxHakpXuUrAvce4rqxcwiyRDuPvvTX1QNQu63OD9eMuI7XC7lrommwxhvgiuPedOhNd
	uwaJ1lhHLuiFQDmdDF1QBqUp3XZi55HCvLzqkfcQyuCHLAeOogcIh7VnrJYdCHFTR4P7bwGyHJq
	rIIH+djKd19a/HCTrEIcDwmYS2hposQG3C2mTZG+S3sA==
X-Received: by 2002:a05:600c:c48e:b0:490:b0e0:3de2 with SMTP id 5b1f17b1804b1-4923f5a8fd6mr84097705e9.33.1781896316675;
        Fri, 19 Jun 2026 12:11:56 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:56 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 05/10] ext4: preserve dirdata bits in get_dtype()
Date: Fri, 19 Jun 2026 15:10:09 -0400
Message-ID: <20260619191022.27008-6-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
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
index 98603aa44693..2f29f50a12ac 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3046,12 +3046,15 @@ static const unsigned char ext4_filetype_table[] = {
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

