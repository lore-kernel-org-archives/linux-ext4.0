Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331FB34389C
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896317; cv=none; b=eQcT0WvzvwV1S52ZTeNn0ksnjkZaaNYZxPYTeF2BDHDOx0B5CCwOVfz1YkNGEKR3urofd4vf4mKhFDHOuP7dPVHVYmWltGm6HokKHtabIc/mjyoQlhQCDhXk64kGS7xd/9A9jahvqLa0+9jvU2OITySd6RecyjqCZbc/yNBoHl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896317; c=relaxed/simple;
	bh=KCRuBD8/skQjgVJ4CRwa/vSsUiwwoi7+s5BAumX3rzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjDsN0jZfOtb4lxRzBaIcuLHQKxhAcGGrgqnoR61uiepqGGjkkWhlJtG0UOcQDrNXj51dLqilYosdOo0vyi7t1KthF4MCX5CfSfNi1yXWjuaNOwNsr28sYGzpZHX/ie2JBVhtUiIAhbW8KzS+cMVft1d7tUUWPMPjVStd9iui/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LPFvS06Y; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPFvS06Y"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-462cdb88d01so1671252f8f.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896315; x=1782501115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpJ9R7FSGyOv7RL2p+jsZxGyJ3tPgUVVDKcyJHI+E94=;
        b=LPFvS06YxOwno00u/qxidiiybIS3+RusRD6tdek6Ia7RI3hpon/f4a+l+sfNChXz3J
         fZvpl44ZSaXQw+FbkTPycwj4Y4AmqabyU6ADlsRkeBlKPfGTMZNu+8hs0IysEnwoEsBC
         FH9A80Ten8wCyq8wNiLvCd+R9pHPU3gedPTlHJ83gZ0n4nZ9SGTl+6I2yCt5XWwJIN63
         yIwj79HfCdimFaNekXpGvbonIULk4CPOkZWZ77HnY75yXM/i2u4A0+alpMTMRWDOxfIb
         4HVPZhHWeos1rYt1DHaFWmtnJsxAS+a1VBSfGKv4KgiYDlSK1PWn/YxuIaAJ2+qtBsu6
         qa7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896315; x=1782501115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fpJ9R7FSGyOv7RL2p+jsZxGyJ3tPgUVVDKcyJHI+E94=;
        b=LY2SNxvhJkPaVuC3xr30l6IkqpesBJHoaJEkD6HLNpYUIfRh5uGGvtRNoyE4nCGOSA
         H1mky6bJ2/NUhsHFRVLQ9Me+j2ZsGnchDE554CZaiT6fgfyV5J5DhLD/qOAHxJOJoX4o
         W9mMRSz/D+4Z/FWOPN5cBIPAWc4nSRGnR22uS3Oi/XaytDv+iZ0kA+WjQIHMw8Iv1nmI
         v3whhNBqmgcf1mjdpr1PsonUXKiyfSn9Dp9mbqrVE8bJI/vHYlMj348p7wYImS5Xk9ZQ
         DSRFQ+RoS7bh3ffdhTLXqGrca/RgUDCCtEsenFdHZqwuRIj1RH3DVW+YaXwBkWVOob12
         kbZA==
X-Gm-Message-State: AOJu0Ywr+rsk9HPGU6U+yTtG3VtVol8VwhWnFJ5z1bdZGc5TUI/GbuqR
	INQEXVFdz45NhWcEfleLZdoLidDckC2RjuPrJIC+ywOzQ9mfxVlO8EWnQlqcMmnVii2r4w==
X-Gm-Gg: AfdE7clGkyWKA2Kzh0BOPVaaXOG/qbw8BVaKRxDro/WDgVkT4iHxAO+mgTgMvFYx4AE
	J2tMJWx1KgTQzIG+xomG3bODbbPXjxXeLqMmhh/UioKl1QiZP3sIuQz1VJEc8A23ZcRiLUIFLrV
	cqtvJbFmivS+OEMDgSy5p0vBdN5CrsBU/Fat4wjfoeU4eVcANST1r7YFEqv5KkekemDbbgMJGKY
	/uXzXTWEj5EmcmHdFa3ekCqawGK3EBe5PkySvHWHD3yoZIBEr2YYH9Yb+H2AOGdXHSC4h5qwRuK
	0IDJrnpd+JttDVYYDa7/z5p1IYjwCUDGRH5C6RJoh6vEghEEqcolHci0scc8OWijpp1UI6OtmDH
	1RCfGoPNglb2uIhuI9wPMfVVedbVBvuC5GV7Fv5W2f++XzFMdSmdJvZqBCOZTtXbtN8+J0JradS
	jK4NqRM6Sy2Ah88CJZ/FSI5TDImk3oAd9v/bxyvnNaNIasLDhe+2Jl
X-Received: by 2002:a05:6000:460e:b0:460:2e53:a6f6 with SMTP id ffacd0b85a97d-4651da3b66cmr7073442f8f.12.1781896314522;
        Fri, 19 Jun 2026 12:11:54 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:53 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 02/10] ext4: add ext4_dir_entry_is_tail()
Date: Fri, 19 Jun 2026 15:10:06 -0400
Message-ID: <20260619191022.27008-3-ablagodarenko@thelustrecollective.com>
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

Replace open-coded checks for directory tail entries with a call
to ext4_dir_entry_is_tail(). This helper will also be used by
upcoming changes.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  | 16 ++++++++++++++++
 fs/ext4/namei.c |  7 +------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..9400bc2858a5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4004,6 +4004,22 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
 }
 
+/*
+ * ext4_dir_entry_is_tail() - Check if a directory entry is a tail entry.
+ * @de: directory entry to check
+ *
+ * Returns true if @de is a directory block tail entry (checksum record).
+ */
+static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
+{
+	struct ext4_dir_entry_tail *t = (struct ext4_dir_entry_tail *)de;
+
+	return !t->det_reserved_zero1 &&
+	       le16_to_cpu(t->det_rec_len) == sizeof(*t) &&
+	       !t->det_reserved_zero2 &&
+	       t->det_reserved_ft == EXT4_FT_DIR_CSUM;
+}
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2c951570990f..f47f072a1a89 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -314,7 +314,6 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 						   struct buffer_head *bh)
 {
 	struct ext4_dir_entry_tail *t;
-	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 
 #ifdef PARANOID
 	struct ext4_dir_entry_2 *d, *top;
@@ -334,11 +333,7 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 	t = EXT4_DIRENT_TAIL(bh->b_data, EXT4_BLOCK_SIZE(inode->i_sb));
 #endif
 
-	if (t->det_reserved_zero1 ||
-	    (ext4_rec_len_from_disk(t->det_rec_len, blocksize) !=
-	     sizeof(struct ext4_dir_entry_tail)) ||
-	    t->det_reserved_zero2 ||
-	    t->det_reserved_ft != EXT4_FT_DIR_CSUM)
+	if (!ext4_dir_entry_is_tail((struct ext4_dir_entry_2 *)t))
 		return NULL;
 
 	return t;
-- 
2.43.7

