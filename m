Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A0229D267
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 00:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459336; cv=none; b=VIF1LlGY/yleo4OJPIcxZhvS24D+XWkqIVALByWXMUpDlHq0wM8T8P4tEKak4LAJin2k9T4SR5MEN/pug+tTAQqRmyr3+j6Hj6n6HsgwmD5ix16qsgF+dsOxB8B87warFuhxjjKCI6tzAjjFps3FrGwdQ0Zj5mwbvKqQCssEuXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459336; c=relaxed/simple;
	bh=HEdSWRdkGojqWxv5yRN+XmtVVmexzJy0Tv9E1rYC2+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrkSS0tqRGqnCl7/qSOf9LhfuIoI+NiOoCGV0PL61hCIYi3IGaSmsYscWultF4ql1mITHUtt18SnSSdHtG97lFVRDNlb0994VE0oeQOy1ZRyaHKkMmCmltijdjwZ0EPY1z1GoLGQuOG462QgqhzoLoeRv0KlZwhmVKvz3yK1HAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/oIHvXj; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/oIHvXj"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47640541585so202585f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 17:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785459333; x=1786064133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=H/oIHvXjWtXLlVAu3+mw51WPbh8/iG7G8YSaEBHwGmi4qmHhyeNOw127ySQyvcXkJa
         ErxvBPYoOdYEX+xLV3KROC54z8P+EXf4xbtzmeuBq6NmYWgnIrsUf8vdUrQ0ff/9KayX
         7k3Nf7kdTNRSPQwSOQtrpqFuSif8ZWYR1qas4wxP5B5c5HEui3Ug353Ws7rB0YFgzgdE
         /ajP1LJXVzQQKNK8phCbivP+zQN9AyvV43qwtKplFh/EQnBwPT8kyRSmTtjqA8MXbABY
         YcANP3345LsE1Y7SZfag98KPj6KQH/+Ba3/y8C5617XU6yujkrQtdx2RbcXrdtKNxcxM
         3/Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785459333; x=1786064133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=IhmjOTE/7dYbOvAGKD9ygoqoAa2Yf8k8PfuRTk1egXMsvd+huvoXY1kg4cW0L8IaBB
         wjNoLNqbfyzIr2B1UXI8KGXkOR9kpgIienZVV28ruQgITPTBsHLqHkK+m1l5XdSmn0iU
         /H+4UKnwEdt36Gc4FgtxugYakoVCgjHhC5S2lQOBvbmXlGaa/ppCnKEJIEvJiLGv8fIW
         OQNxVPF7qa4+LOJrvV1AxWTcdF9xn/OAIrUYOg48whPm7NhEhz8zomRWH6efhIPtX1qx
         C3f16EHgwookG8wsVCEsTljNhIWK1/9o64PQdzq32CQvxFaQzwcluRFytc++OmvDFDIg
         9A3g==
X-Gm-Message-State: AOJu0YxtgYuxuzUSzkyhbp8q7efQi1TyLlGCmbUF6bmwQWHuy9uJfGv/
	vVMoE7+Y/jTWzZw6Z34IsLC83R8Ybec9x5d6nagsxfmJnIcG1UaIB4jbBwmivw==
X-Gm-Gg: AR+sD12dFWc/GIBZV2yq8+NjbTXcxgwH4qeYOdlQd3xvy1TzS1oFWK4sQix80jaYaTM
	4O5LxFW8qmvdhfgBc0w8uL+T1AmyinF8xfw9EVRAWwtpZZsoXmXZJ3O1EOySYbx1bSyNk8HPsM1
	3qAmTr92pR8dtA98JwmHHadg9WovvbiilgI2FP3WReiTv33CvqorPgUiy4uPh58LpprVawLUkye
	5JErDAk/jZHq3i22s5XTY9Y/hg0ze5uY/QulrlBNYY892oiT4ckNYVwrct9k3WriVtcijD4zxUW
	iCVJNS3qhCa8ic0zDegWo2OMgkkF6Q6PVMZwIUlCTrjVv/1HXXQ1QDx4PC+sj8af38WjiPvnGZ3
	vyxVNfT6ocsmEIfVywQRK4Y3gMEGHIbsf0I9A0NWQS9T22M6f2fvQIFRtKWOPfjz6qlLAc7IHaG
	f/gkE8ZbzW/PAjMWhy9JJbU7H5tt0XAzSG/iai9lfd0/QQPeX6kB2qAYjYQQs9zE2nYDLlvre3u
	fJOj1XS1iXWfeYF5UuX
X-Received: by 2002:a5d:588a:0:b0:47f:6f9e:1e86 with SMTP id ffacd0b85a97d-47fd2adc361mr347360f8f.27.1785459333257;
        Thu, 30 Jul 2026 17:55:33 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88d6f4csm11975801f8f.2.2026.07.30.17.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:55:32 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v9 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Thu, 30 Jul 2026 20:54:20 -0400
Message-ID: <20260731005430.36801-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
References: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
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

