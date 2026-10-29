Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276834;
	b=vQ9fQ/Tsal0LIpi4TafMPUvMGI2N3mclZZvXrxI5UpMfcxKKDAyCqWJl2yb4HudCj9JH
	 26vcnOLuuBlw7QzPvotAOBvakPkaT5OhaohHpEon5XOolWcOFzS20oGQixclHT0LMOxuJ
	 chqbp5ezuFqHP062J74ez0m+X+k4heTl2mwNBAXQphuU1lv9vi0PQdoJPRT3Cf2J4mw/8
	 kI2ChYUhVP3IuJC2vHgaSAY5jDlhH4VarNvSmz9uljk+VqCcdt3Eo4C5Botbg81NWazj7
	 nBSra1drHZqutQvRN0UO3lpLfhy246/yS2w1Bxhy5ju1EVH9eDmgazJHX3C3seOmsVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276834;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=x4+u0y5Q2WVRp2KOscLawHKQ16TsS7I/HebHT1tzVSE=;
	b=5uFeNRG97Q+RAz4xhvIJoaYLmlBw7J/2eCgmwmR4tAz2++kngXZIkBq7ypSWYyt5E+1m
	 V7txrEm7r8jpdSLRgiyPrmJkdMcBFlqdcw+fnOj7v7yZFfVrQGqqcVuxEuJfojngZSPEH
	 9GHVsddrxwaX/do6fyhjvBgCyQIJq9dsUt/C+WxoCrnKuuNWIeDO/H4qFfIYfP2u3NySu
	 CBbs1hfZ3284tjUyWjaza0G+YdqzIUmGwgo75f+0MHXxPicB3dBIY1pUMcyfwggVLK4Ch
	 OqB0+IaRh8PNSdCowTuPYQX/y7VdaYmhQBSmA+nLIqxjYK94alqC7cvyMuwPBAoNrKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RrwMWXs9;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0CB606A31F
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D0CB606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RrwMWXs9
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so1706245f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276832; x=1793881632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x4+u0y5Q2WVRp2KOscLawHKQ16TsS7I/HebHT1tzVSE=;
        b=RrwMWXs9ZB6r6mP2QLoj19LumQWmtV1s+N4jl4pBxTitSgC4hiONhRplyhncWimvIe
         hSUl9kAxGHqT6Ezp2b2YCX2O36su4iHm4fS5fWSUZeRNhNcn4oT4h7MnzLExF//NR/XY
         5B/oLt1RfIqt5/Keb+s8ais6shQdnIcSWmmmqSjlT7m5a7ioli2G+xOg2fjVtYH2jJNI
         uJL6dVbGHMNGqPM0CGdnvpx97hz7l8K41mh7l1pNH72OeUEqK+XS/UOGxLciL0lM996n
         QHTLWiXwCsVzGBsvlZvELEdFsqRbpsDnWkcT9+SplGuvxWaNxU0QLsUFS4S8K+8qBstg
         Gneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276832; x=1793881632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x4+u0y5Q2WVRp2KOscLawHKQ16TsS7I/HebHT1tzVSE=;
        b=iTVhKtLB30iuLb/9+1U6POJLl3DD+IyOmYPjyh4GX2n3SPFmMcSGbMS5rIwLZHDqbg
         M0b0yDyRsARnWUsr9aClyyfXGFrgYo0ZpV8rg5tOBMkdxLCP3c3kgkfzHE68rAfiz8p6
         eVzbc3MOowwSF8v1JyAYiu7Vy/CEzHerrh4iPUqjKscx8cvexopylmuluRvnUjAQUr7F
         UJ+AH/N8hffoadLYlcmsiXfsEugnejl6FFyT9mcZPNC5SBhXdI3Q4nEIGLMq5OYUkEfF
         eOlfljJBK1FoykxqowY5OJ0YXN7tXumSDWBObH6zr6Oca98hzHvGJpYSWvOOU5QP33sq
         3IPg==
X-Gm-Message-State: AFq9FYKUJs4ClzkwVMR4DsiLaGM4ReoxpcDFCZahWLNhfFIVTVWw0mDD
	LxWh+04P1mTyIc805Otlvsg/9TXMNDtBzNxq2bgxae1lbtLwGSXcJaAiEDPQzx2B
X-Gm-Gg: AYBFou2ySBBccMBFdLX34z0hb/Vpg1ikKwIGAKBn0W8EZyc+xXlO9klR2MA2qESawdl
	vFXOJkByxNPPr5sUqQPhpl5xjr4j2LZx+ou8ah21t9/orbaXBtShBo+clt0UOFJoR5uRd1eGFNT
	RebhNNW+KbwXHG/sSBcvnk97Qi+x3WytEL+ZdbR1uHyktkefRjfJxHbMSZQD6LXaskaI/2YYccm
	IEtsLmtgpOuRK6c/XR97bISuMmt2ja3HUuIQhzci9vFdEB6El5eSgv9l1iqH7lNYg1ocmwv/lW0
	sJ1ppagvfAlfrsveo7vamYaHbVIG116qHfsxr1jGA6zpGuu1rTNnJbm+xlba1wKsl4nh8e/MKWD
	DqcKBpU1e3CPkaR45kAtHR+4s7HvSQ4tdajuXyz4lMYgGV/BYWTFgKZjzX57mc9GkjX+DYFIjqa
	/B1NSTYNlSY3kzvl2cJmUc1yRek1Fdgo/XmOk+kHPukRAC/9MoThDB9kFhwOp9aqQDd/y2qAvUf
	zTqq/cmkenmMCegZLkhofnOzJcT4Gbgm1lsNCbvlb8AhrK+V9bB5N9NU91ek3zefLGO2klo82/7
	8FiybaOppJ/EjF1g6iWZkQTIhB2GM+oGewizCy46KOi1ikpf5VQnRkt3TztZ
X-Received: by 2002:a05:6000:98e:b0:48d:f5ba:fb02 with SMTP id ffacd0b85a97d-48e5d564c27mr12166690f8f.49.1793276832504;
        Thu, 29 Oct 2026 05:27:12 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:12 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v13 06/11] ext4: add ext4_dir_entry_len()
Date: Thu, 29 Oct 2026 12:24:05 +0000
Message-ID: <20261029122413.230409-7-ablagodarenko@thelustrecollective.com>
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

ext4_dir_entry_len() (added in the previous patch, where
dx_get_dx_info() first needs it) computes the required rec_len for
a directory entry, taking into account dirdata and casefold+fscrypt
hash space.

Update dx_root_limit() to use ext4_dir_entry_len() instead of
open-coded ext4_dir_rec_len() for '.' and '..' entries.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  | 18 ++++++++++++++----
 fs/ext4/namei.c | 25 +++++++++++++++++--------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index edb95cbc4439..2d6d3be4ef7d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2655,7 +2655,15 @@ static inline unsigned int ext4_dir_rec_len(__u8 name_len,
 {
 	int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
 
-	if (dir && ext4_hash_in_dirent(dir))
+	/*
+	 * Without dirdata, the casefold+fscrypt hash lives at a fixed position
+	 * after the filename and must be reserved explicitly.  With dirdata the
+	 * hash is stored as a CFHASH extension and is already counted in the
+	 * name_len argument (via ext4_dirent_get_data_len), so adding it again
+	 * would double-count.
+	 */
+	if (dir && ext4_hash_in_dirent(dir) &&
+	    !ext4_has_feature_dirdata(dir->i_sb))
 		rec_len += sizeof(struct ext4_dir_entry_hash);
 	return (rec_len & ~EXT4_DIR_ROUND);
 }
@@ -3079,12 +3087,14 @@ static const unsigned char ext4_filetype_table[] = {
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
index 59cc01b91c41..b3acab0689c9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -596,11 +596,17 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
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
+	unsigned int entry_space;
+
+	info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(info))
+		return 0;
+	entry_space = dir->i_sb->s_blocksize - ((char *)info - (char *)dot_de) -
+		info->info_length;
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -885,10 +891,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 
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
 
@@ -2336,10 +2345,10 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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

