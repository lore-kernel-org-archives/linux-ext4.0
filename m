Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91523C8CE
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308288; cv=none; b=Nbk3OiziGz8PGUxj6pcKxMgbleCZVs2QScPKiJ7SkJ+jTzvnrWu9Rkv4vRALoOLpyGvBJwTxAXwdDgKYXhStjsjsSErRk+XlkInxtxPD5/Lhm37NYlhTHtucISWkvmgAKx4InG5vf2QFcomH3aWciUPKR+13q6piLkR+Wi9cUtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308288; c=relaxed/simple;
	bh=b/vT1Lpc542vra+G9Z3v4icrJqnyf2L8BADxjK1/Lyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9guaCjKVN2HN1q3yM5/PP05L/YTQc5hs3DN/ls6KiFzOYA2zThiJsTOjJNrdBV3M3Xh3e+J1f63CdvGU7xC4R8CQdzige5wOfNvuUSDm+SupGMUnq5vJJ7FOVMute0G0HNmGCf4wAZ9mBkhByE5Y4FfgGpTCKDLR420gzOtQFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQSf89Uk; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQSf89Uk"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490b3637b90so7164665e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308286; x=1782913086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onob3Y84Mt6dGRaYdQRsFuUPzcHbVBg3vqps7nO5s5g=;
        b=mQSf89UkPmjKJxM7nFUMGY3to6NQM1VXpAOQZsNRk7+fVjqFSf/OczwV2Ztjr+4CW/
         xiR4e+g1+qEDeO2A7e/ATEoYk3WHTGhQz1Ye9kiDeC6WrpifBEXxJeR6V+xxobsUGiKM
         awGS47Z3VHdtAFYFRnYJ/MvLR2AMChTxcnYSSBwP8QyVNIBs+X7hA6kDc1TF6h1gHjA0
         DHvINhIRdktSF64EasTQtPknsWKGjtNR29ZX/vO0CxVsbRkA8P6XhhfEpsimKNeDupDg
         3XZAtevF9Z7ObYv6C7LAMHAUIOO00DkLfMyH1kDtxC25TVhi+xRsdfuAVnULZxtqiFbc
         MfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308286; x=1782913086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=onob3Y84Mt6dGRaYdQRsFuUPzcHbVBg3vqps7nO5s5g=;
        b=cuda+zlZljN30+ZE2UU9VDGmF/JpupfaK8S1G6ZsSyf1lMosDCJHK/bbfc7TMhZSLo
         PKzk6rIUOFG0BBCoqDl2Oy2D+UKIzv78M4Mha4h9djLXnSKRL9U/PgXTcmx2MReCuM1i
         XhGfXm+KwZpF1OSazBKfFxMQ5w450WyT1NeYiI8kL/LfRAMK5y2oCNlRU26msc9MYjzw
         MQWRw5l4v9bLWkTQqonptDv1zwgvCXOIqEM9qJEHr0mljWTusoPtBlT0F6aTM5TtwHAI
         MHDOufl1gZhvm1ULTe6xXM+f+YmBOrYZzStm1r31vOzP3EN6/9mc51xpxfcU8dUjT3GH
         toUw==
X-Gm-Message-State: AOJu0YzgB2iaFfl7dIPUUPg8NGlz52HRim1Dmm/xBcENcYY1U9VGHaIw
	9Q1T4z4egXxsQ5DYvnMbrDVkFr8ZNeBhLsIWvsidojgA3vxFvwVAFDz8Um0K1MM2/XU=
X-Gm-Gg: AfdE7clJH7sbOnw3+2tSb9ZBvemczc4sHczRCHVbddx9VBb9akF7L9z0H6vuA/VWxCZ
	xrw2fKvss8owUHxPl3sHyGnZqHfIIQuuC//03N+/E7ge6J2EyvH34Fdb7rYquD8WIHBVGZm/msn
	9CVEUxMAY0UlALkXBsaJNTfLKplKVVEquQzH2T44acrxN/CEJvLnG7u5YTgUFe+HGCxHWKqVUzA
	KJmaHw/0zkK5XwvLdgCuwA8lzM3nFG9C0gAx8QA5btLxznAu5diHpgCkp14K5DFniSXY71rVy1l
	5X+yqvDhANu/W0+6Kw+0mXaSGWpjJkY7hKRQzYXbedtqtf7/fZfNdIKW1emKSfrZtpenG7tF0wY
	9GQQrKuc2xUqmN6B8jwXy53zy7XQz/1UuzFcCP0MxTmYdJLDHN7xGSHairzYjIZTR/NcFH5macG
	uaMQQ4LiBsyL+fAcgHxB7StNWjeocWm95xOMILT59SSOvJ
X-Received: by 2002:a05:600c:6308:b0:492:4c60:bfb8 with SMTP id 5b1f17b1804b1-49260878547mr43157545e9.28.1782308285871;
        Wed, 24 Jun 2026 06:38:05 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:05 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Wed, 24 Jun 2026 09:36:32 -0400
Message-ID: <20260624133642.18438-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
References: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
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
index c2f330c75c81..2fc14332fab7 100644
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

