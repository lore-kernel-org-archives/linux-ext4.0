Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531BF3DBD7A
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105137; cv=none; b=OL6MRaBUmmNXWPZrewl35ntHg8pZ4txi1Q2PsR0aTubDa9+T4V7whXbpFMK6r9HAJrckFPYlf3AscVDzl/S4qLuFCA1I51WqF4QnUOmDvs+WSONnQA+M5eqfEo/wWhKqxfx9q67K3GoSnTU8YdEq/EUS+QhTFjGVPcCsqfoMAps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105137; c=relaxed/simple;
	bh=/hfHMY/a31E0dURp864pbsms9/cwcOck7I0ynRjsYCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3DxUKYHLwAM/oF6XwxP5OM4ISMyJfRUtlPe7TVxfaj4HEgYp8xUUfQ64z30UKnYf+B3tjOHU5GS3yxxNmBuAjPscrSiggAwBjKYaoOj8PuGVEoxsOLbE/L3C8dqxaTW+DzGC0Kop5nVPtopO9Yd2TfKbp65s59Pd7K8NE9fKCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KaCJLgPI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KaCJLgPI"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490be29c1c5so87986935e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781105134; x=1781709934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=guFgs8MJd9JAwh43mH0r7zG1rJ9EBTZkoC14doqwn24=;
        b=KaCJLgPIEA5YX6xnwU02G2+HmJZe5z1eTiPKQveMn143WpiwBXTbbi3yxVGrvQpg1z
         MyxVU+/eqahliHcO88mFVv3RDGrmj01QG19a7NEe+lLeTj6BzvvAAUXehnLQWy7i/oiK
         ML7xkL+Tf4hyO3tlacaJQHlJ0voftJ+fDSZ4SffYbRm2GOHdNOwo6gyn3zljD1Ndr0ty
         gk/vb+hngPD6Py3cwx0bAMgfnZ2OAOEANcfAZ5sYBouMJpNUy/t92CvP/fiWLBSxgihZ
         2dcjyagWPUoAEfjX32T0TLRWTt0ogPnTkeUEx/HyH7b0pbGaHUzNGUMxSayTufWBL+0E
         CdDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105134; x=1781709934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=guFgs8MJd9JAwh43mH0r7zG1rJ9EBTZkoC14doqwn24=;
        b=UrV2q9LlFOgjevejlan5gUUTKggoeX7iwUlelGDd6uPSPMHDlgfkOCvvlwY5M3SQGR
         2CNMm9Qw7Mq1ak2C0fTkFbDxno6v52sQgA3Hc87/yZCHRiU+0TInPDXPcAbDBL3bpKYM
         MuBdllJcFzfuzAHYZwDRRSgfqhV/JMHtMkYuJEdCv30/j1SnSbjqwfZ0Nr2K+HqSQD9W
         V1x/fzr2BM3s77EpAcsa0GIgjHORw3tSB9gNzroh3oq7LmldFY+7jXjDHPu0rNB8/g9n
         kn6+zbpiHzMkXQ5h0DsrbrCrlYTAUyOxc476vMFXMgNhyW3DTS/SxjWndlC/dvvbmN9+
         iEfw==
X-Gm-Message-State: AOJu0YwVxR3tuzzCsKdmAuU/R0IKXFh8g1G+zjavopfadZ5cX/qnYWnk
	ANDLe2HetJCOt2Uoy8sjLpnvPIsCHhkiKkgx+Gi0CQGwkHufpHiKurC/MFsGE3jf1o4=
X-Gm-Gg: Acq92OEnZsYGlxPBmAvTMcBfyhewO04SWf1yY42A8ozJ0GTfuH8R+AJBhoWNYxpu2dK
	3Sq9SEcpm0Fjw1EzvkgxzzDUZhBs3f9ro0zfhdDRITrYregxjr3t/2SKDUrm/A7Ejvx0cHgSdiY
	wn/QXvAXpYFzZzfZrk54TjK+LCQ0Pp4FrDy4gl9LVGorEz6bzZqvkHn6f0kB/zp3PS3jxf5X1A8
	5NqD+CHUH4iEs87z2jvebn5Sbrj+3FdYbit4dyENfz8RuaCf+MDD0kyY5xNHJsu24B8HxSm/tx9
	5GE3/hDbea51x5WraIl3FFyxQrHuw6WYo/OOgjAndBJHshsCiwZNqnj9bB8yvwhTsnrxpa3wJ8/
	/ucDyTUFvrSJdja9eLIzS/3keuUo9w1Nlgrot7pitLnNw3Ap7g/h8mCFqi5kHKFipBPEN/30VWz
	bNdshVkMOfXC8r6S6xb9RrclMCNQZumNUk0gKryH/akakrMwSImp7Esm0djtEUgdK8YeF0Sj71l
	A==
X-Received: by 2002:a05:600c:8486:b0:490:e196:6574 with SMTP id 5b1f17b1804b1-490e196664fmr16210575e9.13.1781105133553;
        Wed, 10 Jun 2026 08:25:33 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm559103835e9.12.2026.06.10.08.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:25:33 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 02/10] ext4: add ext4_dir_entry_is_tail()
Date: Wed, 10 Jun 2026 11:24:05 -0400
Message-ID: <20260610152417.13576-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
References: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
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
index 5805001ff1d9..0196d954cba1 100644
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

