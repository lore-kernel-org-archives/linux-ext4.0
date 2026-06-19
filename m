Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A37D54652
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896319; cv=none; b=et/4EuIjyXQKwiobKBcH8tzfPJkSBCglQVSxaqZwYFDbqD6dqfq9VX4jrwNOkDG1U6a82Qi9+zPI9XuS4RRINy6Vk9mU90DTWGLvR2G+pEsmk/Ky8qoBZYb03yyUysqiWu/72GuZzBojeuIXNewZKeIQzxn6ifCHVIZXltXvngg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896319; c=relaxed/simple;
	bh=QeckxND3nDN3zl1CIjxV5NdBBJfjUh2RIIbcEkShKrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=or4F9EeSYowyOF6S/vG5wKASPmaw5rCzpsoRCLf6ZFmZecvzQrk4hd6SgCGOhPMFkl5drVcYY2ukakBEFiVg1Uj74LtnZSKrcKXLvZF7p0mUm03C3UYHdUhNZ4yc+GIfgAySQbdA8U6BKp32NThDDmeMgcE0/XyD1maSpWqNWxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P1CVZxLb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P1CVZxLb"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4922244f7c7so20453725e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896316; x=1782501116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzkM0Q1hFcFf8NoRp32si9ptcicnnZIjZIxXDx0tujg=;
        b=P1CVZxLbfK6/kBkoy6OuBApBmukbasyh+i8aKEq3wIQgnZoAWZwWaQ3flHhX1obCA4
         +O/sWZbwAKTtafiVSlC4zWf0Jtmvzvo+2Y1md88iLY7ubgy2NHEwZi+djz4JE3QmJ+Or
         GuSJHG6b35vCyHo2BlyhWOQyPwkkhpaGW1VM5KeIRwLFpvFEIhx+ad9j5Yp4IxEFcLY4
         jfBUWBAfoONEywWXZmJxuiyARD+u3FcCJmtnXHuga+2TM2WXbrRCt9o4tgXEt2x4Z9aM
         xyxeth3gtcaUMuSDr6kC4Wv3FLd9vm+s4BlT27KVTtoOHrjugLy4lNvDhpBX8elgl5mP
         FeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896316; x=1782501116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IzkM0Q1hFcFf8NoRp32si9ptcicnnZIjZIxXDx0tujg=;
        b=dHSKoiOShEitrAOSbdthfsDaOKdfpD9v9f4TrPqS22tvvLUevTjKyEAxJfjbpWuFZw
         fOQqwpoB+On+IF9xJyGn/mBI2Fi6riDcIuzyWrm8+1qO2vXC6Sl4zmG7Sp/Z9aUqJmNc
         doG4425vMhZZGmkYyBFKAOaVFstxq6Vvh4TPygQTBjT0M8n+vN9JCn+lK/lVMFSvAkW6
         o64aHF1S8fT1xhOmr9CkZrFK7PZrc/1G/HxQ2qIg9M13j5a1J2YQb3N5dZbIra3orbBD
         Jc0+Sptv1Q6wjQJWACOkHNKG7AUbiUspfhqRjM53oqsqvl65EQ3BOZtRH9equxB7TI3m
         hkkw==
X-Gm-Message-State: AOJu0YzPrWllxegsiG/l8AeBEhIrSK4WdoJoYQiGV1EOeozWGtYl1Swf
	YChG75hkwt0IRRlSJVOS8oHWl+ZbjXwwxyF58uspjr14yU6ecWIjRtRiGtA+GV8YGZdhFg==
X-Gm-Gg: AfdE7ckP+nyHFt6F+ue0Ioh1SLcJLCSdyMkWIyYu0fL0Bl36Znjp3bSQpY/deAqsnTf
	8NaGgLoMvp/Frj3/YE6qR4V/U68GDQGqdMo+w7MKDtr8kqT/pYI3KC0VTG80iQDOYhgT4I7RJAM
	0AlKOLhyvudXN++/R/yF2mCykIXYaJ20TVOwsPHEtFgTuF1xmgjbwTtmlIg9lJO2SASiHKyhyYj
	VoPrRNuM9JvhNU/LdAcvGbvEM0wTvKkqxdvD0Paaeh7shvUCQWqonBf/ttU2M1jmrW8HLy+jfWh
	lypDYj8MW5HJARC9IvMJH8Bh1MdAdd6Yjv7zH7nHLQ0lJqgvZ4FvxHQKkT4rIZ6z+DCmu6GYiww
	6we8dw/1tunSl9fkKb+DYkG7PADcloWDto80NCqZ7BMEEwSoe1KinaMuc0yoF5CDkuyEk3vf6uW
	ibuv+D+Z+G/0P+7AQ2GMq9o/XYR2nIMmFIdRxs9Hck2A==
X-Received: by 2002:a05:600c:5252:b0:490:bd1d:4732 with SMTP id 5b1f17b1804b1-4923f579333mr87686615e9.23.1781896316019;
        Fri, 19 Jun 2026 12:11:56 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:55 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@diliger.ca>
Subject: [PATCH v3 04/10] ext4: add dirdata format definitions and access helpers
Date: Fri, 19 Jun 2026 15:10:08 -0400
Message-ID: <20260619191022.27008-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Define the on-disk format for ext4 directory entry extension data.

The upper four bits of de->file_type indicate the presence of
optional data stored after the filename NUL terminator.  This patch
defines flags for LUFID, 64-bit inode numbers, and casefold hash
data stored in that area.

Add struct ext4_dirent_data_header to describe variable-length
extension records and struct ext4_dirent_hash for hash storage used
by casefold and fscrypt.

Provide ext4_dirdata_next() to advance to the next extension record
and ext4_dirent_get_data_len() to compute the total extension data
length associated with a directory entry.

No functional changes.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@diliger.ca>
---
 fs/ext4/ext4.h | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9400bc2858a5..98603aa44693 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2556,6 +2556,49 @@ struct ext4_dir_entry_tail {
 #define EXT4_FT_SYMLINK		7
 
 #define EXT4_FT_MAX		8
+#define EXT4_FT_MASK		0xf
+
+#if EXT4_FT_MAX > EXT4_FT_MASK
+#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
+#endif
+
+/*
+ * d_type has 4 unused bits, so it can hold four types of data. These different
+ * types of data (e.g. fscypt hash, high 32 bits of 64-bit inode number) can be
+ * stored, in flag order, after file-name in ext4 dirent.
+ *
+ * These flags are added to d_type if ext4 dirent has extra data after
+ * filename. This data length is variable and length is stored in first byte
+ * of data. Data starts after filename NUL byte.
+ */
+#define EXT4_DIRENT_LUFID		0x10
+#define EXT4_DIRENT_INO64		0x20
+#define EXT4_DIRENT_CFHASH		0x40
+
+struct ext4_fid {
+	char    fid[16];     /* 128-bit unique file identifier */
+};
+
+struct ext4_dirent_data_header {
+	/* length of this header + the whole data blob */
+	__u8	ddh_length;
+} __packed;
+
+struct ext4_dirent_fid {
+	struct ext4_dirent_data_header df_header;
+	struct ext4_fid                df_fid[];
+};
+
+#define EXT4_LUFID_MAGIC    0xAD200907UL
+struct ext4_dentry_param {
+	__u32			edp_magic;	/* EXT4_LUFID_MAGIC */
+	struct ext4_dirent_fid	edp_dfid;
+};
+
+struct ext4_dirent_hash {
+	struct ext4_dirent_data_header	dh_header;
+	struct ext4_dir_entry_hash	dh_hash;
+} __packed;
 
 #define EXT4_FT_DIR_CSUM	0xDE
 
@@ -4004,6 +4047,12 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
 }
 
+/*
+ * Advance to the next dirdata record header starting from @ddh.
+ */
+#define ext4_dirdata_next(ddh) \
+	((struct ext4_dirent_data_header *)((char *)(ddh) + (ddh)->ddh_length))
+
 /*
  * ext4_dir_entry_is_tail() - Check if a directory entry is a tail entry.
  * @de: directory entry to check
@@ -4020,6 +4069,40 @@ static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
 	       t->det_reserved_ft == EXT4_FT_DIR_CSUM;
 }
 
+/*
+ * ext4_dirent_get_data_len() - Compute the total dirdata length for an entry.
+ * @de: directory entry
+ *
+ * Computes the length of optional data stored after the filename (and its
+ * implicit NUL terminator).  Each extension is indicated by a bit in the
+ * high 4 bits of de->file_type; the first byte of each extension is its
+ * length (including that length byte itself).
+ *
+ * Returns 0 for tail entries and for entries with no dirdata.
+ */
+static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de)
+{
+	__u8 extra_data_flags;
+	struct ext4_dirent_data_header *ddh;
+	int dlen = 0;
+
+	if (ext4_dir_entry_is_tail(de))
+		return 0;
+
+	extra_data_flags = (de->file_type & ~EXT4_FT_MASK) >> 4;
+	ddh = (struct ext4_dirent_data_header *)(de->name + de->name_len +
+						 1 /* NUL terminator */);
+
+	while (extra_data_flags) {
+		if (extra_data_flags & 1) {
+			dlen += ddh->ddh_length + (dlen == 0);
+			ddh = ext4_dirdata_next(ddh);
+		}
+		extra_data_flags >>= 1;
+	}
+	return dlen;
+}
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 
-- 
2.43.7

