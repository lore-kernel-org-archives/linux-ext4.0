Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713829;
	b=v73m9cdqeTnlXNEvntT4jc4Kfb2Wud0yt1BbUkQh5C1tHzvdy+HMlHr/QwXNDSdeOsih
	 oASB1ZB50spiKaVx+vKyd/s020RbJLwAQu+B4a3M+Jt7J8w+E/S/LKci2BgPD28tcWvP4
	 EsTA2tWF13tIJoXhG20DFnvuju739D1T1oI4KHVz6HoYuFQY7xmecE5/iCvZo6YayuQ/H
	 m1LOOA9WMm6GJ80GagG0vvpE+tVeQTGk6+fblRAPAawLbOfLQUtDEoVnIFLRXK3Iq7Nk+
	 T3HU2Es3bPGO2MHrrKE76IFy7DYyht5YzmIrDQ58zsWUdsAwNDvtxb2VmgJdscxezaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713829;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=REh8jeZijumdf8M6Ze3imf/DLl9bx2yTpJbjpjYy9fA=;
	b=0PdN6tZGjIHm1EP9IYg8Ni2Xs6tpcc1u/+5bGddyDtwF5Lrb/9jEm6SOwfKK6kBYie1K
	 1/+GQunx9sBqRhiHvATlHiT3o2N127Qf7nPi5hTP0zlteZbaAmy8qwWSklVDq/T8VC3bU
	 yMpyI5ymmOzxZqbP0LG6Ej/nhwq1agd5j0D3BQ/itoAmz7iswMdFET4dGwkoxhPet66Xg
	 meBxGQCuTqsedIyhj+LSLloLAPz4RmBPzmv/g7JZQDjEEF4Q6+lkC5bmebVz/uYm00QQC
	 Uu9HIdX1QKKicWigICHIqv6GCerYZFTFlK9YwkC8Ek0ITVi/DxOjeHl1mhPMWP5fSuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b7G1fGd7;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E26C606A33C
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E26C606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b7G1fGd7
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48e47347279so2636055f8f.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713827; x=1794318627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REh8jeZijumdf8M6Ze3imf/DLl9bx2yTpJbjpjYy9fA=;
        b=b7G1fGd7a5+TeVNcMm6tibQfVH6aB+cWOWotRDLR4V/exrJPu0vYKfJANxSfH334Vc
         /zPIONH88aLZ9tYj+3XyyF9wp0YBckT0I8BaywFAPO4svOLIdx7HlQqu9Gs1E11d+XyR
         dB6l+cR0NxvqJXXPNsKBiVsjDlEzzzc7ze5wcNTtdKySQm+76fJT1trmQJB9tMY5WG8c
         R74iufIXXsB/Xa3b65+oFUO0fbNR/b3t/0Rs0rw/+9S53ten/I2QTuLTo5WDGgkjUaf8
         9NoQZO9b7XlysCJHYDLmte+y03BZKz1WseCxgHglJy6dXAtfNe1PG/06ptUJbln3bJiB
         xc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713827; x=1794318627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=REh8jeZijumdf8M6Ze3imf/DLl9bx2yTpJbjpjYy9fA=;
        b=C8Ccju50RMbMNYUWBPXWcgJymTCu2Dmk6+fZw72qkzwTTD6E8bwqXhdxvK5MwjwovD
         5e/YpY1QOSfM+XZXFFa0UelPK46LFptghNTkxdO1GX/VK9ky4j/znO3IaE+m40DMhlQV
         1NipHBwG0gLYH3OKu3AgPZfTWtTZz9Rps15dZ/8or7i0LOhcwlhzx37e+4J8Y6sFRF4b
         zXAwE2CYjN0c1fmBbACv8QTds9JRKxKJ6mGHsx5No2+laBX0iTTyn85F5KYSn7Lknkbm
         eDbYfnYErPLcoQMA+pdEIlFiTMNXxUou3wgz9er3wt/dvTeB6iLavriX74LKY2W6TnPX
         v5Lg==
X-Gm-Message-State: APuU4Z+/Xxnf3HBlASTtHm4PPIcHrNXjMzx8+xYKIvJJKjVF4sZko1cF
	eyHk8CJqrxdN+GXQW35VoKmQmi/PwtFXwDKoTNjQmEyU1ZFt3mvr3VLSiSUg5wqQ07c=
X-Gm-Gg: AYBFou17eVh2UbsvDmoPeBsqVUpXw6TwFglFiBaXcuxhSKNX/Xws1IoiWa2OoOJbcB/
	QjqqIO1WQEAsKdU4K9KL7lraL1oUjl12swWg0K+9LsgZKyiSB9iREAi1cL0lSihddxEgZr5loAK
	hFfgXNwKr1vGPN8YzG13sTsfjG6eLUdjKszCe1ttoUmcK6olOgxo4syIp2qIXLRCmRW0I1KuqZc
	cgl68If/tHejByV8aYNP3RKyUNkoLVU7SMTKoHCpsCYjnmDOo1oinWPr2TUhQHtsMSgR1XEXQsr
	kldHWaC6nriDHKwD+DUJ6ryXu9YeiV0iqYQzb/aFeHiu8ZY3RfXGbKE88vQxXZObpt4Btssrvkz
	VVtuXq2TVKZNXOvVb/k1bp4epPREf3/32PbGmaA8+zy60rjykqiQj6rJyCJ4lchcmtbghlpIyVi
	lLc+KM7JUzWVWsWfxIGfjZqpjUJnUn/KncXA1AQ4AhBHxpEZ3PU2YZKiWZXXWF209Z2nAq5HiQk
	ShzVgIFSpgpH9kGJaax7C9P6eO4xdiVBg5i+TjWgR4nmsrA75xUkaO29Qn+xyrKXiUIlzkpLvXJ
	mkGdCkNxXvK4ANSdaNqrQs8qutm3dMy3ft2KXcoEu0nE1f6k7NP3Ay+ZPtMF
X-Received: by 2002:a05:600c:37cc:b0:4a2:1cc:6551 with SMTP id 5b1f17b1804b1-4ac1980143dmr267854245e9.35.1793713827035;
        Tue, 03 Nov 2026 05:50:27 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:26 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v14 07/12] ext4: add ext4_dir_entry_len()
Date: Tue,  3 Nov 2026 13:49:14 +0000
Message-ID: <20261103134921.610047-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
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

ext4_dir_entry_len() (added in the previous patch, where
dx_get_dx_info() first needs it) computes the required rec_len for
a directory entry, taking into account dirdata and casefold+fscrypt
hash space.

Update dx_root_limit() to use ext4_dir_entry_len() instead of
open-coded ext4_dir_rec_len() for '.' and '..' entries.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/ext4.h  |  8 +++++---
 fs/ext4/namei.c | 28 +++++++++++++++++++---------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cebbfac05fa5..fe6b8fe4634e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3085,12 +3085,14 @@ static const unsigned char ext4_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
-static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
+static inline unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
+	unsigned char fl_index = filetype & EXT4_FT_MASK;
+
+	if (!ext4_has_feature_filetype(sb) || fl_index >= EXT4_FT_MAX)
 		return DT_UNKNOWN;
 
-	return ext4_filetype_table[filetype];
+	return ext4_filetype_table[fl_index];
 }
 extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c221bcd562cc..9953583ad6c3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -611,14 +611,21 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
 	((struct dx_countlimit *) entries)->limit = cpu_to_le16(value);
 }
 
-static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
+static inline unsigned dx_root_limit(struct inode *dir,
+	struct ext4_dir_entry_2 *dot_de)
 {
-	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(1, NULL) -
-			ext4_dir_rec_len(2, NULL) - infosize;
+	struct dx_root_info *info;
+	unsigned int entry_space, used;
 
+	info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(info))
+		return 0;
+	used = (char *)info - (char *)dot_de + info->info_length;
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
-		entry_space -= sizeof(struct dx_tail);
+		used += sizeof(struct dx_tail);
+	if (used > dir->i_sb->s_blocksize)
+		return 0;
+	entry_space = dir->i_sb->s_blocksize - used;
 	return entry_space / sizeof(struct dx_entry);
 }
 
@@ -919,10 +926,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
 	entries = (struct dx_entry *)(((char *)info) + info->info_length);
 
-	if (dx_get_limit(entries) != dx_root_limit(dir, info->info_length)) {
+	if (dx_get_limit(entries) !=
+	    dx_root_limit(dir, (struct ext4_dir_entry_2 *)frame->bh->b_data)) {
 		ext4_warning_inode(dir, "dx entry: limit %u != root limit %u",
 				   dx_get_limit(entries),
-				   dx_root_limit(dir, info->info_length));
+				   dx_root_limit(dir,
+				   (struct ext4_dir_entry_2 *)frame->bh->b_data
+				   ));
 		goto fail;
 	}
 
@@ -2372,10 +2382,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		dx_info->hash_version =
 				EXT4_SB(dir->i_sb)->s_def_hash_version;
 
-	entries = (void *)dx_info + sizeof(*dx_info);
+	entries = (void *)dx_info + dx_info->info_length;
 	dx_set_block(entries, 1);
 	dx_set_count(entries, 1);
-	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
+	dx_set_limit(entries, dx_root_limit(dir, dot_de));
 
 	/* Initialize as for dx_probe */
 	fname->hinfo.hash_version = dx_info->hash_version;
-- 
2.52.0

