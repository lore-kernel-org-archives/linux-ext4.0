Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276832;
	b=tv2x4Q7UDQQA7QPDUpcUdIJU8aQRJ9Iesa1jE8CdM3fSVqizRK9FP1/JsWl7ooff2CAm
	 pj5a8jPjOJXDcQJ2RH9YEyOx3NXsesfaRInDpULnGomAFzhmup1S5Bz8ISBEsjIbZggrN
	 qrUdjmx+eX0qWh3aJitGhHRELMNQmqJntTaAu8iTo4mbeIMqBulfCAdlYCHZpVFewhbZF
	 3v70hsDsQz1qRUr9ixE0pFn1A0+mxBnTGQiWrshJft92mX3i9l6Z3BPAIM/gyqmSPGKqJ
	 peh7w7LKE9c84+rHRO7d2OZRGQkdgDJZEyFt91NcsV9Eod6whdT2mYKTAQgK8lkvlTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276832;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RWwy/GFyvPziHvR3j12blbm6yPrQhNI+aFn/52auoYI=;
	b=0AOi6mw0xs9FiHo1XqvMdQKPe7LrBcvIrfxiI/HykgDn0gA8ZLWmkoLvBfM3nBrylcHq
	 3DmdJqCVpdTCcsWPPDCtdmkUsJoPKeQ92AJ6OuCOqGTO3HYFInbmjIkjVZZN1ZBjzM17p
	 dhoox4JUAzyWzrpI8SuZjsaeaof+sXVpjvVYbGP/A7v+wfNdVsRz/SUM6i2TSmP3utI1s
	 HEgKQi5rZUe5QHFRJ+p2/ERX/qCAd1O0Lu9iq0pJ0n3wWECS5GIdIYnZaM8TddJkVIHCY
	 v2LSQnfbiuwyUPAGRFm1hVdW0P+jd1Zd8FTyhcp4f6VVZ5gGItxWwEAySKeMPEvs1dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jBu0Gytf;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D27606A31D
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7D27606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jBu0Gytf
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e47347279so1414715f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276830; x=1793881630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RWwy/GFyvPziHvR3j12blbm6yPrQhNI+aFn/52auoYI=;
        b=jBu0GytffS2eW/IKzndcsRbL4yG/73cUossV2ua+z7mfV7jKLRenzk48J3KHsKmHhz
         b83p7MAfZdqCilq32UrAk7OUgQvZodXzdY6hn9k2QKzJy+Qjr5406KWt0Mk68DS+7D7Y
         5FHEL6uTGeFyiMCjclwM9uovjMuDDDHYzWOyE2ljtmcUaSQURei2uyDX/ZBuaYdNw+bA
         uCdYh3POJ3FuuGJ30HaHKCd9iHiv9KBQczQeXnamKSn9lKt9P6Wc3ck7pKtRAuOJN6PG
         vuXW9Ox6CNa0mC/yur7ZfaYljO770puYhV0Jd0qHFE6SOEmWbtcewIfiK8fgaxBu6VKM
         S94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276830; x=1793881630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RWwy/GFyvPziHvR3j12blbm6yPrQhNI+aFn/52auoYI=;
        b=tOiCOsaER3MwSQrXfsLLPSShHMfJWCNjxRuBzTq7zeyjC0PKhjZDrQKMwDtvBVOD4U
         3p8hb4HdxojU6HYS2vOMeWUPti4ROsZzXH3kr3laKSFNi0+Nny0IC95OijJO5rnb3LWF
         Qza8Qu23O9dPMx6SJ3R9aJBcN7YQGWMzqgr8vb6NtjTS1pU3NpV1SDhOdBPxFaX0fk09
         0zRwjfNf8pNtBVbSjKMezlI9RNszEDumAiisNyEvh15YnfWfLPeyLN/7EvKtJSZQj9cQ
         Unc8EnOlkeuvcihYUgN1kB2R5CWrgaFuMbFrUbOwtXW9h/Fx8l3hLwheP1gJKnpHjHJS
         ZybA==
X-Gm-Message-State: AFq9FYLnyjPXj1YuDQEf2SRxndMJcmFht1h6Zk4NFCBM/vABkjBiM4Wp
	anVMd0w+z80pTdS1gqXdW5uI33yjbUwhboRm0Xg2ypY9i2Fh4l+krBu8BvphWnHn
X-Gm-Gg: AYBFou36vnw6ocTJDkSSIT+145lk2HA08mm7GGghwm4/Yc96fXgR9IcXAf2OcewsSRa
	MQe6OpaMu0NKdrhBlMBssCti+FSrDQnvLGE0NzPaSRVlx2cOwN3nWTfHp1F1NfOGEW0c0ZPcXwb
	qGtaKUD3qjtxPWIkhu8Jx45x09CyfIhzeyivjEgYuftCP4/2QfOuowqt3cPiSuRQT/53MHbLPo0
	bZ94e8PYE6KQ6nYjJmo1iT+nMwqmFMze0FA5n4GzTezZHeKcYd6YfdK+a+391zpVLEb7XdkuBW9
	w4GU1hqbRO7oRIRRTWWE7ollCsgA+NTPT/GPzsqKI57sfOkBJh2ZMAgQHfXc5m21P0bHjfFIY1g
	awP6l71Ag9629Aa0M/zp4boSTCugN4jwlH6SVkGLpflOv8BllPWEPZC+GV31DuhRcu18xWGnKdm
	vFjGCGABeGku/RUSIK5wHSHziSiDjladY/zyuHgwaSv68vdsMhUIUxbEDTdBI3HN733DiYO4mHW
	iowsWxOXRGYrbU7ZR7Iv9o7eotgOzgzY5ianMjbz2Lp92NsO2fXs2KUqZIU61PZSzeLQYkU74qe
	V9YbRYT4ZalmtvyI99upsxuwBtnH1MbzjjGZ5+6iMz5ImApKntUHEvsurcMN
X-Received: by 2002:adf:ec49:0:b0:48e:1f08:4f05 with SMTP id ffacd0b85a97d-48e5d5d0998mr9340994f8f.33.1793276830193;
        Thu, 29 Oct 2026 05:27:10 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:09 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v13 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Thu, 29 Oct 2026 12:24:02 +0000
Message-ID: <20261029122413.230409-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
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
index 16df13874559..41152914aa6c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4101,6 +4101,22 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
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
 extern const struct iomap_ops ext4_iomap_buffered_write_ops;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ec23e72cc422..533340c5dbc0 100644
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
2.52.0

