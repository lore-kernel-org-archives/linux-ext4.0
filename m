Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBE73E274B
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 12:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033624; cv=none; b=tBdNTK8yaS5EfCWcd3sXBLyfsM6AHIZtZi3X9N0NNBxhgGyvdRL6G9OF+faRzBDrkuiNzWkLoRS3ZljozJB7I6jqPmk1on2+Lv976Tko+ApXKBKNhGPoMzbgHLRTlp5rr8cydjBBL1Lfn1hhEs++i1VMPZFgZr3fknbpqO9VCBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033624; c=relaxed/simple;
	bh=r5DOiA5fhyqNS8ifS1N0eso/Neoca8a2Q8hpldss3eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyN9GV/m5ct4E66K97n5eLVsl2KOfnGbNJIaYwC2o2djIkGZqoRzGLwcgtzPew8BinuuIbYNam+gKt2rnJzQGvdQYnRUijAI1xrOkvFZDQtWLrjKXbVERrVoQznGGnDU8GTiKZewNoWipZKoOVx8efVkIAe18JVyBvDDv+kpB5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESbSquGp; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESbSquGp"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493f140ca8eso26089045e9.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 05:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784033621; x=1784638421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tTSguTZintpdI0WxPR7sP6hRjzFfcYR1PdBBm3JZK+I=;
        b=ESbSquGpr5tacO3/MEwHRVutfAkczkxpkcQij/Dx5yCDgkTlC9c46RVGkno98LjhoF
         ZlQg4prgsAEDd84AA9tRpAPMRAJJlwJJD6aFwxwuXdhjmna9Bh5ArY8kljjmh7/z1731
         DDcqu9551i3ChMnALh8g/PMk4lljOwVe/HDoU1oGNUbMd/h3BOg2dbSF05VjokLp8lZc
         9JyB/UBpIohE56J00RuQvyK0tJtQsbkZjKgWXPB/92Vob7YuwYaqR8ECyb3ETBjsCdXu
         Y7cYlBvHULM44qD99ZWjQEfqcJetxPzhbPJERDiHlxZ5tY98aIJ6Ebz6x6CSJJKZ2XwZ
         pLSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033621; x=1784638421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tTSguTZintpdI0WxPR7sP6hRjzFfcYR1PdBBm3JZK+I=;
        b=e5Yh/SJNFLNEgkIEdcG9V7I3wYzUBGCKjBFjK0wiMg0d8XwfqabJ0bPWtjzg5cu1Fr
         oklL/1DLCr4hdRAVKVO8T/nu6yPClZXDO9Qcfb6AgqmRF4KGHlrE67SHHINGNq3/He/B
         auTzp3UkASMZ20mit7vUxMKnoG6GlWnHhlWOWDXGPWqCV2exNwa+BP3Q7jxtBZXoLeLd
         kkFYEwXOeR40j0cdz9viQ66bvjuT+hjK0tw08205+Z/tWw8cfIy4EuXPrrKJhI0mUlQv
         hbVIUAmu9CjL/KGQzoo+ByLNg5b6iDY/xYHsL+G08CK6lcdkyeiRATc+JGD0icgpwLPK
         ZSbw==
X-Gm-Message-State: AOJu0Yw4l1JYUHHiktLKSX9JQMEORrqQ2giyg+VNjVXr3WQWSz6zn5OU
	MP2yAXANFGGapIqupfhm6yp5dbOLc4/qvcbaA8qytKn+TyuhsrTq5V/D1m4duoOE
X-Gm-Gg: AfdE7cm1x6zBY9a97gR8n8sBC8yB669222kBPhHBszN7cW8OY+WjjcfxKZboteN+hbL
	BqqPk5SksE3ZXMRWzeH7yE2GUFz1BBsOzzggqCJPx9F7joFFj3KrZeguurIGJx9LHlhhQ9zFMGP
	PMFUwpsbHZjKYhZhTNXPvBjshYRfGyGA2vrcsHEIugtKaPpXZyNH3Yf0O4hT32LSynBNddbgXeT
	zHnvj3+ZtmiZh9MKDm2xKATRbar9K5OgYIcpOOpId/RTG55fXC/+GNkIWhNHn5k4LrAWPk6qL/k
	tvr8bhGvzXQhS5cdqcbjnf5/vyS33LeC9kNVPMwM3x5fc7xKPxvRaxEmwiDszhw8Dwz1SHMGCzp
	/IlzxGQGDyylAjWKdL2wfO4ttiWrMjQgO64baXqmwslYxjWONHZwDW4KkyZORXfJm06BljUSd0M
	/imIq+UzkY/rby3hhVHbtKe2feFiUi8fjLPL1YrT3+2WWb3g==
X-Received: by 2002:a05:600c:3488:b0:493:d216:ed8a with SMTP id 5b1f17b1804b1-49539651463mr18541855e9.16.1784033620990;
        Tue, 14 Jul 2026 05:53:40 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:1827:2101:7130:c718:1edf:8590])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2ed840sm70052405e9.10.2026.07.14.05.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:53:40 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v5 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Tue, 14 Jul 2026 08:51:01 -0400
Message-ID: <20260714125111.14699-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
References: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c | 13 ++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

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
index c2f330c75c81..28841bc6b9f1 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -314,17 +314,16 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 						   struct buffer_head *bh)
 {
 	struct ext4_dir_entry_tail *t;
-	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 
 #ifdef PARANOID
 	struct ext4_dir_entry_2 *d, *top;
 
 	d = (struct ext4_dir_entry_2 *)bh->b_data;
 	top = (struct ext4_dir_entry_2 *)(bh->b_data +
-		(blocksize - sizeof(struct ext4_dir_entry_tail)));
-	while (d < top && ext4_rec_len_from_disk(d->rec_len, blocksize))
+		(EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct ext4_dir_entry_tail)));
+	while (d < top && ext4_rec_len_from_disk(d->rec_len, EXT4_BLOCK_SIZE(inode->i_sb)))
 		d = (struct ext4_dir_entry_2 *)(((void *)d) +
-		    ext4_rec_len_from_disk(d->rec_len, blocksize));
+		    ext4_rec_len_from_disk(d->rec_len, EXT4_BLOCK_SIZE(inode->i_sb)));
 
 	if (d != top)
 		return NULL;
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

