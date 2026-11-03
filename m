Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713865;
	b=nRji95c0YABNFQ9rt8mTCbhYepGGIYbdhQ56JlMvY+f/fhC31C75zeNgHqwyyS6tETvo
	 YLsw/bcZlGaorfmqTSLhNwxwW349X/DW11OxQv02c5xGO0UOIQ9D1Frdz+DkYJyOGi0ZI
	 lClWoGmrOBh4d5O/RoZ68u2EhOfVjATJmDDPNnm/1l05JdX0aFzLmx6dMVrzTa6vbU8+U
	 zCubkdCYuEEI8IqAeoVWXyruq2mntZmSkDV30H6cT5Qj9lhGIkPPtt8mygMMxIKY6Ev8W
	 0XvHuMN41Us8UscMvZ1QQVb/jWK1VKgSWTOyskjkdq9wVJnxkq1QfJ1N7h86UI8BT+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713865;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Js0y7dqY/ekA7yLb0N90zI9KYilgQ5G8FIyZ1IdCcyA=;
	b=VzQPUHyp2W+43PBDakrYjZaDd7b8KFPIhnIGeiKgPwDycBvg59K0ivkn39RINoVox0OT
	 dhNPutH5Gp3q8LQy7I6pLCYZf/apvgzkNMZlhoh1kaKar02DXSzCIZoo2e1SwcK8UJcxc
	 U+3nIv2uIBSxbP6BrAhtRF45DYY5GCiky7aYnIguBy0ZFQAGs3pNAXz8rHN0ZpAfOagRO
	 +hN2wEA7nrpQdkX/U13MDlGb2n476N3QGUVYhVsP6ZWTui0SW242r1sYI7hfG0Oa1X9a+
	 8y6MnSDSrDWg7p2m36nsR8bUYivmShslNERO5tT1/rGjm41k5x8umQlPxfS2SoJwwQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=quVpfa4N;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB056082BD9
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DB056082BD9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=quVpfa4N
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so4338471f8f.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713862; x=1794318662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Js0y7dqY/ekA7yLb0N90zI9KYilgQ5G8FIyZ1IdCcyA=;
        b=quVpfa4NNb+uzVdLR1OrtSG0aMG9QIPV6+R/5af+PLb6b9FR2cgcsn8CdoKd39MUq6
         pYkiH/y0BhhttujW/76w0ELAvgi43i0PK/yC/Yr5qafmjmYGbezi3rVrK1YWIUMk9G2E
         FEwzInP+x9REcK/m9Viz6dx+Imw256iFx7YbYoaeOC04NgfORp/LaUeuhi40AePbjpN8
         lsKNwM+PzmF2DTO3CgU9XQEvLlIiamTzRtf8GA+fj0TYFWqQ/1ouyg3KFQosJVdNeUci
         tz0WyYcqewJP/B0lNN8SUzZLXXUhyC2B8N6AVntAUhEFrca1kEhU9l2p5+y6f5Kl8Wkz
         8jWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713862; x=1794318662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Js0y7dqY/ekA7yLb0N90zI9KYilgQ5G8FIyZ1IdCcyA=;
        b=ZfAwo1P/RFpkVxf5qQA3IuM2woKvYmnjy+8AwnuQGSo0Iw4utMbfN+4mNe1hztkMCp
         5tdzUyC3Fz1fbfe3VAT4tM2v7aA6oOMy5kIKGtIzZhH9BEALwEpV0aLKQgSviTQg5yIv
         Ud1VD+7J5s/MKZS4Ss16DJmHbu/nz3AU5as2W0dSRZyfOS3iCjFGBpCpKKAHoH+9KNq8
         2bp2xBmvujYH+XcpaRKadDthc4KNVLHmFU+qr8n0gv54gWrICuyzW1Be63szlsGWXQEB
         /FlnM/LW83HiTg12fN4307ucKcAEg38RuiLFF0Tokb03Z5a3/dNTdObPqknh+2kwb+GJ
         Logw==
X-Gm-Message-State: APuU4Z+uT6POSHSIRKwvVMtkg75vz9CXgn/NTSAOLAjCFA7FaIdyDvNl
	NBdRiWWog440lQSbEBfPZPUnsVxAeRIJ4tBLTVdQC+QFuJhY4tqtegN3uhJH/zPWMSA=
X-Gm-Gg: AYBFou35ZZYpS9dWZWC6A7xQIm9Xzm1mLsphSr8Mt7LPWlJgUHzuqOfnQgo5ufdHF+6
	kYXNNsglhfFDhSHnOafbCmX9F8+0yglqdarYg9Eye+9/QXgCVdoZZ7HNTf5WzRjmvA+2taqhnaX
	oFcraiNH4tFmLx41CkmzkFA8u+xqOwOQR7QEkjg2kgPBuhJQaWld2ixhSkgU/ahwyvExqWb04aV
	l7KYujJmrO8yvoKxbVH1mVO7ESXBbAF0UpFPY0ji2yG8XhnTX2j+y/jpoEjaottjypWWNyc6/r7
	S/Ok1oSQUy+KUxOzgbfwh3Ous9LhILRLZpfJbDniU21PMfhUSou4/EdytTu6kAfld8DQYHOtEMx
	T+oed8rMFz8QGlEKyc6jlh5DXQiQZHx44QLUEm8bY8QaRdwfzWxJtTlImZfjcueq5T30elX9m2m
	wnMl94KdbLwMHPMbwrkOPTq07Lm0cPUC8JW9UW/h2wLuBmTk6uiFbjQtLlh69Pld+8ga2zDW4ja
	lblE0rBSLuyks8SyvMa64n95hC4DyEMYYeRWgL2rPw8GAVatjpDhAxdqhQ+g2kYaE9TQnVUvuxq
	nMwhHnuwaiiVLRioDLpKA5i4F+aQDFruH4n+LVSxKZuKwrRoS5PoysUKlU4i
X-Received: by 2002:a05:6000:1841:b0:48d:dfff:fe6b with SMTP id ffacd0b85a97d-48e6e4ff6c9mr29032189f8f.34.1793713861620;
        Tue, 03 Nov 2026 05:51:01 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:01 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v4 13/13] ext2fs: share list_dirdata code
Date: Tue,  3 Nov 2026 13:50:37 +0000
Message-ID: <20261103135037.610132-14-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
References: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
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

debugfs and e2fsck format dirdata output the same way,
but each currently has its own implementation.

Move the shared code to libext2fs and replace the
duplicate implementations with a common function call.

The CFHASH record is copied from its length byte, as struct
ext4_dirent_hash starts with it; e2fsck's copy started one byte later
and printed shifted hash values.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 debugfs/ls.c          | 51 +--------------------------------------
 e2fsck/message.c      | 55 ++-----------------------------------------
 lib/ext2fs/dirblock.c | 55 +++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h   |  1 +
 4 files changed, 59 insertions(+), 103 deletions(-)

diff --git a/debugfs/ls.c b/debugfs/ls.c
index d225982c..1ba72eb6 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -46,55 +46,6 @@ struct list_dir_struct {
 static const char *monstr[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
 				"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
 
-static void list_dirdata(struct list_dir_struct *ls,
-			 struct ext2_dir_entry *dirent)
-{
-	unsigned char	*data;
-	int		dlen;
-	__u8		dirdata_mask;
-	__u8		file_type = dirent->name_len >> 8;
-
-	data = (unsigned char *)dirent->name +
-		(dirent->name_len & EXT2_NAME_LEN) + 1;
-
-	for (dirdata_mask = EXT2_FT_MASK + 1;
-	     dirdata_mask != 0; dirdata_mask <<= 1) {
-		if ((dirdata_mask & file_type) == 0)
-			continue;
-
-		dlen = data[0];
-
-		if (dirdata_mask == EXT2_DIRENT_LUFID) {
-			struct lu_fid fid;
-			int offset = 0;
-			fprintf(ls->f, " fid=");
-			while (offset < (dlen - 1)) {
-				memcpy(&fid, data + offset + 1, sizeof(fid));
-				fid_be_to_cpu(&fid, &fid);
-				offset += sizeof(fid);
-				fprintf(ls->f, DFID, PFID(&fid));
-				if (offset < (dlen - 1))
-					fprintf(ls->f, ",");
-			}
-		} else if (dirdata_mask == EXT2_DIRENT_CFHASH) {
-			struct ext4_dirent_hash hash;
-
-			memcpy(&hash, data, sizeof(hash));
-			hash_le_to_cpu(&hash, &hash);
-
-			fprintf(ls->f, "hash: 0x%08x, minor_hash: 0x%08x",
-				hash.dh_hash.hash, hash.dh_hash.minor_hash);
-		} else {
-			int i;
-
-			for (i = 1; i < dlen; i++)
-				fprintf(ls->f, "%02x", data[i]);
-		}
-
-		data += dlen;
-	}
-}
-
 static int print_filename(FILE *f, struct ext2_dir_entry *dirent, int options)
 {
 	unsigned char	ch;
@@ -199,7 +150,7 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 				(unsigned long long) EXT2_I_SIZE(&inode));
 		fprintf(ls->f, " %s", datestr);
 		if ((ls->options & DIRDATA_OPT) != 0)
-			list_dirdata(ls, dirent);
+			list_dirdata(ls->f, dirent);
 		fprintf(ls->f, " ");
 		print_filename(ls->f, dirent, options);
 		fputc('\n', ls->f);
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 193d887e..60859f95 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -347,41 +347,6 @@ static _INLINE_ void expand_inode_expression(FILE *f, ext2_filsys fs, char ch,
 	}
 }
 
-int get_dirent_fid(struct ext2_dir_entry *dirent, struct lu_fid **fids)
-{
-	unsigned char *data = (unsigned char *)dirent->name +
-			      (dirent->name_len & EXT2_NAME_LEN) + 1;
-	__u8 file_type = dirent->name_len >> 8;
-	__u8 dirdata_mask;
-	int retlen = 0;
-
-	for (dirdata_mask = EXT2_FT_MASK + 1;
-	     dirdata_mask != 0; dirdata_mask <<= 1) {
-		int dlen;
-
-		if ((dirdata_mask & file_type) == 0)
-			continue;
-
-		dlen = data[0];
-		if (dirdata_mask == EXT2_DIRENT_LUFID) {
-			struct lu_fid *fid;
-			int len = dlen;
-
-			*fids = (struct lu_fid *)(data + 1);
-			for (fid = *fids; len >= sizeof(*fid); fid++,
-			     len -= sizeof(*fid)) {
-				memcpy(fid, data + 1, sizeof(*fid));
-				fid_be_to_cpu(fid, fid);
-			}
-			retlen = dlen;
-			break;
-		}
-		data += dlen;
-	}
-
-	return retlen;
-}
-
 /*
  * This function expands '%dX' expressions
  */
@@ -397,26 +362,10 @@ static _INLINE_ void expand_dirent_expression(FILE *f, ext2_filsys fs, char ch,
 	dirent = ctx->dirent;
 
 	switch (ch) {
-	case 'i': {
-		struct lu_fid *fids;
-		int i;
-		int fids_len;
-
+	case 'i':
 		fprintf(f, "%u", dirent->inode);
-
-		fids_len = get_dirent_fid(dirent, &fids);
-		if (fids_len > sizeof(*fids))
-			fprintf(f, " fid=");
-		while (fids_len > sizeof(*fids)) {
-			fprintf(f, DFID, PFID(fids));
-			fids++;
-			fids_len -= sizeof(*fids);
-			if (fids_len >= sizeof(*fids))
-				fprintf(f, ",");
-		}
-
+		list_dirdata(NULL, dirent);
 		break;
-	}
 	case 'n':
 		len = ext2fs_dirent_name_len(dirent);
 		if ((ext2fs_get_rec_len(fs, dirent, &rec_len) == 0) &&
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index fa7cc83f..0610cfb6 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -19,6 +19,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "lfsck.h"
 
 errcode_t ext2fs_read_dir_block4(ext2_filsys fs, blk64_t block,
 				 void *buf, int flags EXT2FS_ATTR((unused)),
@@ -145,3 +146,57 @@ errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
 	return ext2fs_write_dir_block3(fs, block, inbuf, 0);
 }
 
+void list_dirdata(FILE *f, struct ext2_dir_entry *dirent)
+{
+	unsigned char	*data;
+	int		dlen;
+	__u8		dirdata_mask;
+	__u8		file_type = dirent->name_len >> 8;
+	FILE *out = f ? f : stdout;
+	int offset = 0;
+
+	data = (unsigned char *)dirent->name +
+		(dirent->name_len & EXT2_NAME_LEN) + 1;
+
+	for (dirdata_mask = EXT2_FT_MASK + 1;
+	     dirdata_mask != 0; dirdata_mask <<= 1) {
+		if ((dirdata_mask & file_type) == 0)
+			continue;
+
+		/* data[] already advances by dlen at the end of each iteration,
+		 * so offset 0 is always the ddh_length byte of the current
+		 * extension.  Reset offset here so LUFID's per-FID increments
+		 * don't carry over into the next extension's reads. */
+		offset = 0;
+		dlen = data[0];
+
+		if (dirdata_mask == EXT2_DIRENT_LUFID) {
+			struct lu_fid fid;
+			fprintf(out, " fid=");
+			while (offset < (dlen - 1)) {
+				memcpy(&fid, data + offset + 1, sizeof(fid));
+				fid_be_to_cpu(&fid, &fid);
+				offset += sizeof(fid);
+				fprintf(out, DFID, PFID(&fid));
+				if (offset < (dlen - 1))
+					fprintf(out, ",");
+			}
+		} else if (dirdata_mask == EXT2_DIRENT_CFHASH) {
+			struct ext4_dirent_hash hash;
+
+			memcpy(&hash, data, sizeof(hash));
+			hash_le_to_cpu(&hash, &hash);
+
+			fprintf(out, " hash=0x%08x, minor_hash=0x%08x",
+				hash.dh_hash.hash, hash.dh_hash.minor_hash);
+		} else {
+			int i;
+
+			for (i = 1; i < dlen; i++)
+				fprintf(out, "%02x", data[i]);
+		}
+
+		data += dlen;
+	}
+}
+
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 61029689..3a1edb83 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1318,6 +1318,7 @@ extern errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags);
 extern errcode_t ext2fs_write_dir_block4(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags, ext2_ino_t ino);
+void list_dirdata(FILE *f, struct ext2_dir_entry *dirent);
 
 /* dirhash.c */
 extern errcode_t ext2fs_dirhash(int version, const char *name, int len,
-- 
2.52.0

