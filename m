Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11D5309F08
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354874; cv=none; b=tJTg/L2yedHf+OpeHKOf115tLRrizoyA1yp64Oj1dsyCo5pRETivmFoMnHsZlHXZfPLQUrv8SiyfwDy1gqK1TDYRtlaV+gMpIc7o6V7HfI7sH1FbiogB5W6AsIqZyv1wH8yTVcLyOI3qDGoCszW6LV0ioOdVEuhMgWRBqBVMdNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354874; c=relaxed/simple;
	bh=HEdSWRdkGojqWxv5yRN+XmtVVmexzJy0Tv9E1rYC2+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDW8BtaLpGvYvEGJP70vZXoWLDUe0YWzvG3MQ5oPB0ACnGy9iuZ2cONA7adj0d816CLEVHMKbbakaDpM86A92e+d3Fll9iWlT9eatK99/6e3Ff4TkXuh27TN39ljD+i+MFppoByBtdf6MqcBkF8llXzzh60k5YytCarME50+u/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Okf8Rfvm; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Okf8Rfvm"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-495635a85d2so10809165e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785354871; x=1785959671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=Okf8Rfvmd+H2+UZIXpatomHYPDC+AO/Jf9rS2Jn066xJ/+vbrdlGzOZdVamLRjmv0v
         kgD0aCn9VMAImhTWEM/CSUi7hwYmjbqpl869D9Au9ZY0rW2Mdxm0n0L7pEpioai9wWLi
         DD9LGu/hHhkrl+PzFNILXtNPDmoVXndUOYtF1bEu7L4nx4LmGt+n8nQxkEGWTyX6fWj2
         qiX8Mxj9e9RVdXImy+3DVghhphwacFvQ7m7HE2tZBCe+NnEKg8wrEgtQW/4cPYdJosNt
         J1C09b8PaHLsPkwAgCVstfqRoXgHKukCwZGSFqOGVOSLp7LF2tTkWx6XhJ1ZifI8SlxH
         3Q3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354871; x=1785959671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=Tc5pSQBOknFjpqN7hjiX/rybfWseTSrSovKsb7gcN4n1OXqNpa1ZfFC4jCUzpLn7i9
         JPoVfbZ/9VrWj459tPLTLDG7zqmN6Ak2qrOHbRwp6CwLVSbq55FOM3NUE1t5i79X5oNb
         PpPh5oQBqZcZX+7rZZZAUzrta1QZM66d96zInml5FZQiBmJ2SUVJEkB3rIHvOu1Absmc
         IK/Q6IKefeTjSWp0aBiwYcNWRQtbC2Ei3IyE8HJ7UQIwG4/yV+RuMlPcHdg64o0dH9F6
         urBGd8+XIlQvZLqHwJTdrdGZhHRI39WntaCFi7cLJw5KR1nPDGRcFdJZ29EGyF4ScTN/
         qPww==
X-Gm-Message-State: AOJu0Yy9Or3UjfYFLX9nF5mXtmPBN3lEMSz/Hkvyc66kHobeqJWzAcxC
	qphuqdt55JElDQbZiVhI4cA5hMH3EmsBFoWBhZvNu0dwB2+X/d5cmFMQS0OjvTye
X-Gm-Gg: AR+sD13ftT9BuGjQMImeFofOIc9e5kP75ScAGHT29RPp+KAkJQGpW/Mguy/JGYda1zM
	MqqSwT1S+uPu8Nqi8AFdExEddi+pq2CaxqCuZe7WIJiTvOx2ufl/hjQyCtcQfyGVkYwNDbLK827
	qDgbHf3JS5mh1rPKWcZc44+myVrr+HVXFdAvcvcTNyClI51JsCEnJbMg33JzHMZ+uTcC8QzEqMZ
	djLqBITPaYyzk9xBAroq89b7qOBky1HOQa5+bYw4CoC1UVQcWI7TnApyFv9X056aqc/I75TLXn9
	BfX/+HF61uzVF2QC5ctyDvFC7QZ9Y3olt/6qur0tJnCM9A9VHnlWgfRuD3Db94zEoc8S+xz9OlV
	YJXjZerbniseOirRhmn4cuxNieom3YJ9jGBYOl8szwP6bT1uU0glnzXqAFAfnUIwkdaHSeawPXm
	8lnT/X6jyyMcWe57FbB9rJbS0OhsOv9aeLpH/SWVm7OhzskgJoiPJjARcxsHrzDevwxBLueM7mr
	Sw05pmMCfSBtQoHHcwr
X-Received: by 2002:a05:600c:c162:b0:493:c8c6:4989 with SMTP id 5b1f17b1804b1-496c6414fcbmr96045375e9.6.1785354870683;
        Wed, 29 Jul 2026 12:54:30 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6d226sm82076865e9.10.2026.07.29.12.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:54:30 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v8 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Wed, 29 Jul 2026 15:53:21 -0400
Message-ID: <20260729195333.20626-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
References: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
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

