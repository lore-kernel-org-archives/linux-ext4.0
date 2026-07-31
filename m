Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019E1443AA7
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512333; cv=none; b=lKcsVg5Q2boHtNM4e6w2DuYZV3Z8IjDtLB8zK9PMUALpxo7I9KgNn/pigWLE6dBa7aK6JUFxIS+NAnnkjquDqzmrvMvonP/HJkKHkb4E8FwGMIWP7Pa3xPQ5z65hl9JnbtHTjrvoFGibDJ078/+FINjYJviDXHDhX6W51L1ieSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512333; c=relaxed/simple;
	bh=HEdSWRdkGojqWxv5yRN+XmtVVmexzJy0Tv9E1rYC2+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4mrW8CwSeS6pQ1D//OOMzlH6nq0jj3LWmBnxMGS41Klxx838vlNx6CGYAea9i3BOrkxWAVG+sUZ6a1kj+UJPHdLTNw0N+d9on+VrYlGsGNM6/8p16RKRbxaEUCrKcRWDnBZs2EuQwga4QS93Fd9w9OEz5j9b5Aaqz93O5FKozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BiOgH/bf; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BiOgH/bf"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-471eeac43bfso1209083f8f.3
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512330; x=1786117130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=BiOgH/bfvw94/DuvN3ykROZa9mFxre0nFCFwXEJE8Rb+34ahVJzgfuOiUjUu6EvMqK
         g0qjqF68pvJaIzBXRklZNS5D3bYd9h0u8PVMpyXjccLSwsjnFrpYIQgdMCgOm4HF9+Do
         ln6ogfXFx9XkvBZTLpjmk9R3tOuPG0BLfihhI+Cy2yOLJNyN5Py37q836vPHb/Kl2PeB
         TOEl3vvSvlfHtputTVtZV9Bp7oGsC1jtYSg4q3JFSf5XFz/XduvkT0aTZcVMAHHHLuex
         oKSju7gYRnd+XvcyBC+AdGlzDAbCzw5ANQ9iE2tXrSYy1OyQZ18v2wH6wFMGTkPAhVhT
         VfQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512330; x=1786117130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=ovrCRsUFFD5asS0NtPFQWaHcqg55qVxSKZXpJehuOnPNl1ZlrsYTiD0uMVQwfv/OUY
         mE3lgngaeSQBXjbdGvc+idPqfeoz5xwBCR9KTXKOvZ3qOymE1jzzNFZNQSFufpj+2L6d
         sRPONL434Sy1iTVFTI9Hi7V0N8plo5PfqWg6/ZQXtCAUr7FuDJdSrE/L1EtUZC4iZZ1P
         ehvI7EPl0sl9MA/wzM6KWJ4v/m5dobAckdu9jYD8HzCDTfMKTuD2qvwv5iCH4jyxaquM
         NGr0LczgNv9YvvP/KZ0zECDZNehwFJg6Kgjt6r/eoQccJiwv8C96R/JcUr3OmBinO3G4
         Haqg==
X-Gm-Message-State: AOJu0YwUVwET6hYo4Yqy5NzFFD+5wzRptX7pj+7UCjjvQOV1tG8YDnAQ
	vvufyzjkceVznZo0BrFGKM5aRUmbWOBy+66jBldRJSt9wshBViUE19RvddktLiwl
X-Gm-Gg: AR+sD11iPGZ+PVpyq5kkGodiTCv1jo1MOTagTmi8bwFV2SccQCJpPVcgvC7+zR5CQDi
	q7cQcQ9qo5jobv/yxYlOdP2ymj3PFChnxeMGTluZMDROjm/rArfl8dsHU8dtXj+PvidLo6+z8zm
	jTNFe9cx4hgC7zfcP7U3SAm+8fsDPHZ4KcsM/hRs6YyIoLZYWWQTbEUagmbaO/JgAOiuWle88Db
	tHXQmVzFmK/TeshOz0LaP6xnIKXPhATNjZ9R6QZsCvHjK6HR0P9aIj2CHMd9KO9LqPc1ovDJUqw
	5X1LpfKtpM5TCMtVtxTuN2xQf/jTaDrXELsDZemqJ7vuBDsEkU4WF/MFwFwk73dp7IXlUxlKHhm
	8rkFBuDj6e/63rZzfubYR1O3FWrdtfGOK3LnIZSjxgdH2+YTftFyTGJ3DPWa3J0bm+xBd+YYk0s
	YtQZxeObXg6ahUlJ4bhk00FIMxIibKw5Sv//wRvkgj8O6OkxQ0U/1y7GqudAP7UBKfJ0XUL752J
	JFaUOAwuuE+CBqlBCo/
X-Received: by 2002:a05:6000:1951:b0:47f:9446:95a8 with SMTP id ffacd0b85a97d-47fd7307505mr167365f8f.59.1785512330285;
        Fri, 31 Jul 2026 08:38:50 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm5098345f8f.3.2026.07.31.08.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:38:49 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v10 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Fri, 31 Jul 2026 11:37:37 -0400
Message-ID: <20260731153753.28309-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
References: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
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

