Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0053E63A8
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186785; cv=none; b=KSvz7JQvhznQEXmeOIGvJIN0mXdmU6E6RBG8zNnjadD9QcjrHtMoK/BqtxqvPQ51VTjMwIUF/UbTltJLB+QdZcjcqaLiePE07sVq7Pf5G9OBSVo6KqNlbPQseRr1SOZNw864ILgIQuqsBdM3rz7ARtyx1mrF8/LzTto0zJfHYBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186785; c=relaxed/simple;
	bh=HEdSWRdkGojqWxv5yRN+XmtVVmexzJy0Tv9E1rYC2+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxSG0lvw8gl2iRR5UsQbzjYtMgZQHntBS7ha8OVXtwXOv+gh/JWl07t1JVS+2Y3t++L+m6HYAVVqN83H4ZI5aNw1aQ9czLLOVG8GLX2htLF2Icn8zM5N0ceT9nm8I4JGDULtSMNxAvrIg7WTl3pPvZXFIx8Uti8vZ9VAijnRiIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrF14Eb1; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrF14Eb1"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4955158f26aso20368025e9.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186782; x=1785791582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=hrF14Eb1xk3DTPp+4YV5w5Ik2/VK+/KFeHu2d0CDwxHUUtcN5ame/HKRPlYrZ/0MA2
         Srn+bg2DYdTdFlhQMaiQRkgCTQxa90vfwsk6nBUkWVraq1OWqqkGRkE9w+l1FoN076cQ
         MVzraY+iMMm86v1eAh6NB35y2O859j49Dh7QyU+aWApkNtTQP2Z14NRWF/WeeG0IyRKx
         +nlGVqFN5CbhrnRmo6aEyqR8EQxkzkscjyfXY2yT6vuVsua5Gx7109xgfF0heJIYdXwe
         73tOK66Rl3mjY4jA/KEnewxYOKO4Mtnr9grpAyvD8UFPAJK0cXWJ5JiEyZXcQXF8Muyi
         +r5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186782; x=1785791582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=LCpZSYsgZNYLBKGaF6Hr+w5biu2CPuUoCJsHtPZUQgabJ+tHqlJ211R1VPPPFcmGbH
         xIE+OP6S0FReDPZ3JT4Y+y9FK+C0w/tV5pqprP3oOq9t4nGEI46rahiqJP6gCRaYSCA9
         Fx9IQMz42Q3zQxtU0iTAHja1Dt8+iYit/iQBobnVmT8xDjP79qBGgQQD33kE9Gxh2q6k
         P9lWwJX5P+N1JH1fBBP9za3haV/PgMvDyLkeBETPfCVfBYUA3+ruUZjYA58pTkMAuUbt
         KDu3JDbMIyi/wSl+7VA8PIhNqyvtXoe5GjYMw8OsuhYmL2sXKb2ggTgpFWCXwvu4Ujj9
         XUfw==
X-Gm-Message-State: AOJu0YytiRTa9GwoowVY0N7X+TMsB3O0Q5YOp+RNE4L91yH/uDxC/Mrc
	SLGCrWOdP2XsXuPaDujuqdp1thGpL83LVLPQbkR3PxU/CceumoBgktgJl+l47A==
X-Gm-Gg: AR+sD12KnbTHKlRm4x6obLH+ONURCTIr01v2asY5L+KgmLQoIAMtuDCrg0gCAJmrJ01
	64bT0hTjb77KIpOFPHXBx2n8WOvBeOtldbugl6zf7EFO6aert7RFNT1KbyuKBkZ0fpD+dg5rVVk
	/a5afTFLrOPuw58hjZuy/k0HT/1TjWpSgexSNxI4c0O4TV4NNLKSM7H11OotadZPRvMbB6wf5Rj
	DmDbN0RWnkaCQTBU919PVnLKkZJBcnzvSLgKcPez4QbY7Shfe0O/oROvsiqEzylUnqVlZZlMA0N
	pns5lOdD9C+09oCsE2PEBajy8PcWjtKvhDIHFtgZfWZV+YRzpaoBmMtajAMQ4kyFDJJItcxUqh4
	v9IbH2kaVeVI/PEW78xnHU3n+CFsAOjQyniCQXZg3Ooe5rdyUFFedGYKWvsQdcwF14NlxbJRyt+
	xJH5j6U/9mtMDUtuSVZ7rvj0Qq0zVKQ4Oy5w==
X-Received: by 2002:a05:600c:4595:b0:495:3a21:4e5d with SMTP id 5b1f17b1804b1-496b56f461dmr124737645e9.0.1785186782184;
        Mon, 27 Jul 2026 14:13:02 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44afaecsm24910245e9.2.2026.07.27.14.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:01 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v6 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Mon, 27 Jul 2026 17:11:15 -0400
Message-ID: <20260727211125.19632-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
References: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
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

