Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D0F48989D
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 23:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785541866; cv=none; b=MphfiPvrhSxa8WWdvkQPHLE6v+ZcmG5glM5xGhTMlG6k3xwYILuWXMc6EVW19vOQefR5FPQv53JdFbVV/3lp4+0ApQJRPoUfbd9eSIPZ/cDa0WRT63y3Lc6dY5BvzOvWoqkWDahvOGoszAiyNBg1F3mU9z18v3jy63huH9by50s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785541866; c=relaxed/simple;
	bh=HEdSWRdkGojqWxv5yRN+XmtVVmexzJy0Tv9E1rYC2+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdm2C8fLAKsBpupmxR7uHI4BLaGv1nq0LLQzjhwvnjoyoEfELp3SZuXSDlgt27LNKlF2tupr4sp3JSmIHYdst6Cij1J61uLC73hzsYxRTETbxxhpYljdZSebH81SJo1OFDS3Cg4RjWlqRd8GD0S5ITjL6BIayBylJFe5gJOqSG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rTwfX0Lz; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTwfX0Lz"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so2928495e9.2
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 16:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785541863; x=1786146663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=rTwfX0LzJOP874KUibShFbLHBx6cIRC3GPmn4fIajgb3uzya6SO/NmTa7wRD8H1qiN
         QUxEzOsi4j77T1qBK3gx9fU8WtgdwIfsJa7o9ITKExrbVko2lc+HJagjIE7iK58dMpc9
         8oCmQKM65WdNYr5vfgutQBs31iukFK96CA40/mG65BdwOiuNwrOqGZFi/9q9E0oKhr6B
         XR6gWpaQsIuL57LVPJ/B8xK10NxqpbBjqylGTbvhuqslBbGHw6Jp4rl2ws5KLtOCV/27
         BGYRJVYEc8i4yMXkjZXE1nAV4ScJk+aCmnu9xpUhvtS9lMYtOTvvWjRZOHWah/y3wZTW
         9NYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785541863; x=1786146663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=ItE5SMbok5CKzoP0EFeF5frqxIX0sdKd3KrmwNY2AFhA5r8r8LGv6pIHK5/bZxIb8W
         aYoqCc/4vDfI4s1sDFo3mWSHKXncMUkupWoCU2xwhlfO7MmBaKyb+om3xY+4e5Qhp9/r
         MgO3RDNxp7JxqVe6UpBtT8trpJHXPs0gUWNBRcTHIOgh08h0/t+keNsr7Uip/hNXSdCj
         H7DPLE5z/uuCIlnw59lXIGlm806jM/HxQgpJod3BufRGQSfhp9fOtXfdkKhpqr0FcIsc
         pABeyavgmji0RAzZfN6Gh200hsgR/OEEQ2y2ex5UB4fMoXzDPgxpA5w1IA8PRMRPRu+T
         OwBQ==
X-Gm-Message-State: AOJu0Yx4I2VhCFKJNTKTzuy66SzNZoX4lO8jWgFm/DQ9bH0UqI6Eyi1/
	AZphBMn1hjTTxHD3unkS1FWsAl310gcd/6qo0w7Hw4SYwnEcYFCZSxo4jJILeVgG
X-Gm-Gg: AR+sD12bJAqlX6Knxfsq57VJdw4sRTlatwh3qpH1RNn+PhMwNvjB9zzEbL3tyG5XsdD
	WQ5fkg3nyGBXazf47hr7fgXl8qN0xE3Xhmk5G9uHzma0RjxZtspL3PyUV8f32H4vZkrH3tjZX3/
	pCz7W3/JBc3uamhY/B/hRcNuG2oUNlsmf2DOv1S6XPzM1D5L/VCGDacX+xgScsNn3ocmlTcdler
	ow71HHdX6QAC9Bnr7kGVBtRdMX1uxKT50vPahuM9pX10NS6EbygjAfSEkrkkQFyif5tPfCXkxzS
	bFxmi2TF/2U2ZACe0Ww78pG2BTCjSGYjTq9NcdmAICMGKJLL2KwySf69Yu5rk1EXJJ61e7yl2hg
	9llt6cV6oz1u7ZLMfQeAtFIITHQEdsNSN3zSnBuDg9vWEK9rbjLLXDu/bv71pI5o2UiYaPdmZ6h
	RGHmY9J3widEM73Qi6SyhHwoZFvGlODkdu7YJGCVYxwWc+9SdFG4SDYdmn6M2f+oTzSqYscG2BI
	6lSX2c2JGdGgZl14Es/
X-Received: by 2002:a05:600c:5359:b0:495:3f48:5df2 with SMTP id 5b1f17b1804b1-4980c6a015dmr1454995e9.29.1785541862721;
        Fri, 31 Jul 2026 16:51:02 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b85be7sm5338715e9.2.2026.07.31.16.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 16:51:02 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v11 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Fri, 31 Jul 2026 19:50:33 -0400
Message-ID: <20260731235043.44068-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
References: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
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

