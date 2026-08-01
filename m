Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BF33BB695
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607998; cv=none; b=ShAm8jIy8nCVdRuCTNmZpwvm3NCLs6EMvwRs4bj7UWVjN/2hNHDEZkX3cFdPsXJRB0cg1l0hAb8Fc45fR8+PbmSgbUf7GSaoWu6XNh1tMropU8r9wz2zehevEWhKHEjPspn8utc2+1p3md14BZxph6vWcKd1sL10ZnGqwLz4hvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607998; c=relaxed/simple;
	bh=HEdSWRdkGojqWxv5yRN+XmtVVmexzJy0Tv9E1rYC2+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvTCv26LH3F70yGSrDBR5dbOBGAcH4UefUx0E/yerrYdB42CL9zuHAQgZ8lAce8uy/8ypfOyMh+UY2b0qLoB3E5rHf7hsZhoe5KpQ9uxLrUzRnTNKvHHWHBc/bj00p0gz31nMwaomqGtURg3oFkwZo6MIs8Orn4kluaFYCQO7gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hCcaL9bc; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCcaL9bc"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso9191535e9.1
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785607995; x=1786212795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=hCcaL9bcD6sPz+BIwQxUAbFFLIJasMw8VqU3ANvx7bd2utdWjxB6cT4BOZ9S7CL3n9
         WPw4MMKPge/T/SasugwRMwxrd738EGepDOAb1ohAbeFqLQGpeAspgrcEVZRxk9CtItYb
         /cIbPrZ5FWCPPJKmjlMj7K9JpSEKSAmbFp+UeHGeo9K7GoiDiXOKelOxxeIFc1mj8SZe
         iAyJWE3j+Fa7vqky5uenaH50ndc7WBYCzzUbCVth9QvffEDJ5iUatxDZ3oL91ovstTrc
         G75cDqcR8N3Tm+p8XiRDFLrNf/udTMkU7XFvjvw0U9vGKeE8xK2tyxLnHWbcqgIaalP+
         cOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785607995; x=1786212795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=jx7+rIN9RFTezkDjikVUCzkYyS3cGaxyVMXrIT535U9/bxGfOaEltpilpzc7VYmDU0
         rkRpKPGj4dLssnukKk8bYYKKCA8ahfxwK0Jy3vIgB9VL8SB2hfEcC+5SjJHMqzgoMXnz
         udJrPfNOkryKPkjwZfQvbrqjVfi1HRRjgHKvrUXUv1t3+me0wP9R1yCG+CNgWuczF40I
         tYbpUmNwdL+KOBssXt/fZlBpDB3heIescZsvveVQx0evZ1JEuLPL9sPIO3CyywPHVrbi
         v/L1eWAQUlqIUeGGZ2X3aJVy7D7KnBDDkMtFoKVaMY+f8BU3OWQdlw39AIZyrhW0cL8h
         7uRg==
X-Gm-Message-State: AOJu0YwxOaiky//HZ6Qhc5i55gqkMzfNgsdF8kl4qVRJBCiZicZirhG3
	DaHmgDaIhCHxlPCDNEt9gcNNyuFGyAUhMmCHsG4vYbaqX9TMTXGEOnfxz7F80Q==
X-Gm-Gg: AR+sD12b4mjOYxxtdlda6UEZHuXM5PKnVmxp1zqiq6dM5cyq8ruToCr65z9ms64HFyr
	VOYIE2zejqjkJYrhx88Ol/FrIWsEAT8lLKQr3nGFNgf4ymiyhc3nb8w1QVlkvcqTKYLgT8sBSF2
	OIIn/Zx0duZ+7rxAVz8zpE2jspRAekn6GkMmfOsuukFBhUJh4iG50UDop5TBCnGMJuo40zZrrjA
	MOeoZPBTxKboREwZngMUqiFVxXi700oC9EUrjy/0MZdxPKgyq+Y59H9Goh1bdjSa7EAFwFsFPN5
	aocmdpx/YqZIRwdpm620xsBBzzlcFr+2YvyEmF0r8KbSylwT+FNFXubpvNi6B9fNMuAjFJ1BzaR
	qjMeugSbB9SQICRKve3PiEkizIcg1nE3wBi8W2Tb6Cjvlt8hHH3cmsMnYaa4cFswvB97ULF6wVo
	AjBFlyuhmkwdsZ2S+h/iSVg5B/JNGalDAXGYGR6uFQh9q8TVo4yCwBZQGseEa8OBrrJNWe7ZidW
	Tk2HKkaUdr84vRHBCjN
X-Received: by 2002:a05:600c:d5:b0:495:6713:9a40 with SMTP id 5b1f17b1804b1-4980c6950a6mr51226745e9.18.1785607994711;
        Sat, 01 Aug 2026 11:13:14 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:14 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v12 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Sat,  1 Aug 2026 14:12:17 -0400
Message-ID: <20260801181227.5198-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c | 14 ++++++--------
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aa8a37566a38..f8d8d92391bf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4002,6 +4002,22 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
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
index c2f330c75c81..da12911bd754 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -331,14 +331,10 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 
 	t = (struct ext4_dir_entry_tail *)d;
 #else
-	t = EXT4_DIRENT_TAIL(bh->b_data, EXT4_BLOCK_SIZE(inode->i_sb));
+	t = EXT4_DIRENT_TAIL(bh->b_data, blocksize);
 #endif
 
-	if (t->det_reserved_zero1 ||
-	    (ext4_rec_len_from_disk(t->det_rec_len, blocksize) !=
-	     sizeof(struct ext4_dir_entry_tail)) ||
-	    t->det_reserved_zero2 ||
-	    t->det_reserved_ft != EXT4_FT_DIR_CSUM)
+	if (!ext4_dir_entry_is_tail((struct ext4_dir_entry_2 *)t))
 		return NULL;
 
 	return t;
@@ -478,7 +474,8 @@ static int ext4_dx_csum_verify(struct inode *inode,
 		return 0;
 	}
 	if (count > limit) {
-		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		EXT4_ERROR_INODE(inode, "dir seems corrupt (%i > %i)? "
+				 "Run e2fsck -D.", count, limit);
 		return 0;
 	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
@@ -511,7 +508,8 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry_2 *diren
 		return;
 	}
 	if (count > limit) {
-		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		EXT4_ERROR_INODE(inode, "dir seems corrupt (%i > %i)? "
+				 " Run e2fsck -D.", count, limit);
 		return;
 	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
-- 
2.43.7

