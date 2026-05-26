Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32513211A14
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 23:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779838723; cv=none; b=HYvzfs1pfViLLU7/YJctiL00JqjgIkcO7qVVJDSA4ogw3F2eIgj0bwmXr32Ysht15yQj3b919PfpW2c9JFnaNqaF1Jeqfew9kTBjgxIb5YtVBWE5MBAQj8DW7/eMEscwjxag+YKwJgpLUaENUHRfy2iAMBwYMPg5cqLLv+cuyGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779838723; c=relaxed/simple;
	bh=a9so3WCnOK9Pfzz8juIm7BGsW5ItlMNvWJpJQFztyI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U9DjkOmvNqxy+7lF4mUt/Uis1550NkeWLPxWIlFaarn0j1kejIhy7jNSgCLMPUefsWgeQZFLAqKP8zqj9z1wdPvjWWzq3YXYmvBuvmhD9Bkzl2H1qmLbR8sr8Kik8EOUfOBL+Mi9WPWbcOW4NtYEqIfDdzlL/sAvvVozdwnuEmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R04Hgx7W; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R04Hgx7W"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490426d72f7so44417595e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 16:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779838720; x=1780443520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5PejWmo1BNTC3++aIRnqd/BV28i072NolJmOExMYGkU=;
        b=R04Hgx7WC0bUeU3ERIbk0wVc8iddtA/fgWfFCJ4uSNktEWqDlK1tGvNm6I8Lvl1AOO
         YYFJi6a/JW6DnkUun5mbWEbkF69zgHrQdYu2hb/TKyeMH5mLeMM8QloIX4dPfZThWiV3
         ZFWWHgDgvI3NZXjqhj6o43tIuY1gWYEc6nWHJYWZQp54U4bXiflWHGyMSokkhi/4I4Zr
         HviLryLxfwmItbiFO4atXwCBVI0NeJhRYI46GpZIE6Ze4ryekdR61+cM+XKReSTWmMmi
         YWjwljjiB6IwBPzKnzXg3qrarEEydDxTUrd2rLeJwyp9V3y7d6OnzmAZRETcUK3Efykz
         T+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779838720; x=1780443520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5PejWmo1BNTC3++aIRnqd/BV28i072NolJmOExMYGkU=;
        b=EOKEZochlEIRS3uUs330ss5Te2ahMU/JsuUUpnzgM2IBbL4+GcwP4Hhezs5NTp2eFU
         VWHYZle/QK4jcaTcrgbI9iIzs1j+IrUE/ShYgY2B2oFlLPsNidOqPN8q8fHaqsD/ff8b
         4pmuFkJsayRaLDnne8YO2wdRZTqhKCiTNvEyzoQeHp9X12F47j+cZvLEcz2WMImMUFZ8
         t+IFYE43vKhnKRVy1Ne8qRIyUNRlEhOqoKM6b9cWk2XnhhkNnICp5TCatSFP2y8M+TMU
         0SsQyIQg4vIXIkKsZYCTx4L2/bAVei4akifkt/10c7o9aVS4jBMoBEXmEAB2nakIUsId
         pjww==
X-Gm-Message-State: AOJu0Yy3W91GNlc0H3kSeMVThsbmF3U8eHAYqyyEnBYHW6r5tIVWs/qh
	+PVsBhGzxnzqr4c3l3INecVvNDBHPxqqnwy2EuRYh3yz3DQZA5pkA5dYhzrZQItO
X-Gm-Gg: Acq92OGmyuwBnpX10dpRaKnS5WhVdvvrpmRihlG387PwwAHEgznEtcFCgUSJ0dGL2G4
	e5+ZNgIfv4i5pprh3yJ+yuNlrlupnCR6HmWnZlB8LnVRt7E+j+LzvIKU8QA8uO+yjRrzllphcyh
	3EqbXoyBz+arpZebi3U5Puu+6Y75hErJrhzPSVlplSd6anjJK21KPBoMfF5pEQETltP9kRLHJbX
	MY6Gyka+QRfG0X8vupNCucrt9gYGcgL3j7ZnJQZxmNoNo2eGIIkIkek32+MVPUeMkWzuV/CX+7k
	c4smqRZ4UR9dUW1eq4XdyZ6Vu5PwxMK2HMWAa6+VwD8oqCNBBcXdCJ64gXZjAPot0QqrGITL/lq
	rtcXPFBi8p5vI4bz5Ix93/T+mDkTSUBydJWhT5eK2iOcybDT4Hx6vJKNSannMUXBsoMwR7RmOe2
	ikJ8eCDvG5H7TKa1OUsvjgfzTRVNDk4Ym2K4XBpN0EZ0ICCcV2J3ULLP03qJfTSREuFBzPNvaLe
	Q==
X-Received: by 2002:a05:600d:6450:20b0:48f:e245:394e with SMTP id 5b1f17b1804b1-490426dd0f7mr240197585e9.27.1779838720385;
        Tue, 26 May 2026 16:38:40 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904561f682sm381248805e9.13.2026.05.26.16.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 16:38:39 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] ext4: add ext4_dir_entry_is_tail()
Date: Tue, 26 May 2026 19:38:16 -0400
Message-ID: <20260526233816.7654-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
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
---
 fs/ext4/ext4.h  | 16 ++++++++++++++++
 fs/ext4/namei.c |  7 +------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..01b1222b1454 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3917,6 +3917,22 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
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
index 4a47fbd8dd30..accf63fbbc79 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -314,7 +314,6 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 						   struct buffer_head *bh)
 {
 	struct ext4_dir_entry_tail *t;
-	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 
 #ifdef PARANOID
 	struct ext4_dir_entry *d, *top;
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

