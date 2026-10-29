Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276891;
	b=laEGGWGyOXl3x91ngDOviz7wgP2Q3touzCUCU4LBQHEmXOUpVa8kqffn2NdLgkIYMdW9
	 z/LjOoZ9jSMVPsO0tkkyrKTQRednJCzPwjDPyFyF/vXuxmKAipDYZVdheB7X8JcOT2bUY
	 MMl1E9bnDDvbH2Y3SWfxsnzjGblVZPwaCy8fB+Mt2xy2s9jPCcLJ01hzwveX2qAZxK5PK
	 2PgT9os6XTeoFE0agX/7HFLoAghQrF/1CWs5+ax6oQKPD9KCD8joi8Frv20wx/NsMtEJM
	 NMmd3LPtnkJf6glYlBvt5/kGjUXF86Df+gyO2e10Rf8CXpzn1hySO0ugujULIjF8pDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276891;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=P2O5gA+9LIMbwoRgFA86YuGcK0SGsHv62DR2WAee+sI=;
	b=lnavVo7BmA07L0B0qPBPz7bV+4wgjukldskOu6B9pYkf9rdn71ni8/PcAik1iATOQloJ
	 +xb7kzIrWfkRqqh6j9JWY0R61Bz9bj461o6naDHoUNVoXLa+0p5a4Chyz7R4AP5DDJk7y
	 Ithjg+CEZu7Ah4zPJ2R/zlTDmzRglYyZSeZzbJdf3pgKCJoE+9bS1Qn0i1ZLzdZUuF2Rk
	 sxhFF6yNEur4NtE4/PvCvfDrl1UGnkSNIk4wN+geHtxDnI1OPGIexP4xe5oFcO12iejI6
	 bEvuuKMC2XiLRNqE83NLI7tTmgT1J9ujmB35KAQXQzDagtLu6qIwUGuFPGK/2ogMrXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jCaA5wNU;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07E2606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A07E2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jCaA5wNU
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49d05d51553so13979205e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276889; x=1793881689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P2O5gA+9LIMbwoRgFA86YuGcK0SGsHv62DR2WAee+sI=;
        b=jCaA5wNUJ72TomcDa7siPtRtlfWCY41m7c2mhfbAoNVTrs1/1/1Wbq8++qFrHkMUft
         YXoOSEI8ABNqYtp4F3FeG2LsRJb3VAFbyduUKecfVU7BIxOd5PtOcryWFLExMQEeNArj
         cJacjOHGyyE+tDdXWFtqmwXnTXkEC6heyjaJ3f37jXoDaCAi5CY4Q1lz3mj2QVscTHB/
         9VBtaxiYim/vr/Rdz2dKz9SuiEiMVasJMH4b15z+2ii//tA9UMP5Qi3xTdP4zth4GdhK
         N41H43wqafeoyycWRLyUBrp010zyGM587EWZmNf0FcfMKeLvLtQku8MbVfqDyRXJ8yE7
         woxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276889; x=1793881689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P2O5gA+9LIMbwoRgFA86YuGcK0SGsHv62DR2WAee+sI=;
        b=C2aE1LN1iqxL/x8SqaY+ALMz1FEmG0EW4d2QZm7Dtnx50FOs+zFgTD3r1w/3RHbTAV
         akUj7scqqbg89oe/Z5ce/e6JHJl+tIbPQGv429xdufAmTzUnyOrmTPZyHhUeFqrFDlTS
         1B4LxUqAOvw5k8U6UxhUliy7Odi3hIYuw5hxfQKDxrhj6X5O01ggcBL5SwD4t8c6QFKm
         3n3b7/6CiA8a1TLWSjq90E71szZucQHJpgRSzoTxbsle/DEx3KAziEZWClH8BrBb3zX7
         imPAciFORNe9R5Zf+rCl/XPqO/B449FzvTKZsZWSUl1URihtODjASZV+vIjcRH/M7Htr
         GS1w==
X-Gm-Message-State: AFq9FYJ5XKkAb36p4ZGJA6f/smX9Aw2W7YMfwrewihC9Ehe//DPQek3U
	s1jaHiTyGB2zvqxrCPGMEOT0m25bG1whYObBNZfDv/Xcmay64vYTgHOAr/Xj+m5k
X-Gm-Gg: AYBFou0LzWwZ3AMRkd5IpP76ElJHEjvvhwp0f+khI1o4SJFUmms0Rrmet+W4+9l8fsy
	5/qVSbOcK/3sF1FQG2407oNq7MjJdzKgYaioTZMMrp1oyQZPv/RXcV+V7z2cSt6ThCU3aqrvbYa
	+OHryfCnOYguZtdE9Z1IE9TNc427jK/Tokbih6j6+yGnVI5H/ksLb9/BaMv1qjsahMeoKvNgJHI
	CKYkpk01kvrXLdoJr6TCjM2gddrJERuqe8+zpLSHCLRErocf+xierYlbqwsYyi4vopA1dvVoIJT
	Oey6Qv/4e94qAxvx46LmSzI9jsMRJAdtqVcc3YBJI7z5xTaf2OWiVSZNvy0tBK4htZpk23ADI49
	EJPhRkosoNTJb5TJbplnXH0rUc7988FsCw0tvKI9JaRyUcAZc4LyDi4oPkL3X7u4mUKTUK0rRWc
	H9PiVzcml7AqmrWjHWtflkvmwtUh62OjiZyIII0LOFeMIygG/TKGjenY+B1mQVzS2NY/Ux2v8sY
	TKq7k1zCzCVNwA6TZxI/qN99weFsE3pHrHsAfY0cZ+bhVwnkJJbR3jGsAwTz0tT1Q9aXHmrpADp
	xGZVzNyYX/L6eDgg0+w7DL0AMkYIPlP2k1lLXmZay6SMPZkvK4JlAagxilog
X-Received: by 2002:a05:600c:4454:b0:4a3:2f35:38b6 with SMTP id 5b1f17b1804b1-4a967017cf8mr124435655e9.24.1793276889055;
        Thu, 29 Oct 2026 05:28:09 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:08 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 13/13] ext2fs: share list_dirdata code
Date: Thu, 29 Oct 2026 12:27:44 +0000
Message-ID: <20261029122744.230678-14-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
References: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
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

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
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
index fa7cc83f..8f1f5ea0 100644
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
+			memcpy(&hash, data + 1, sizeof(hash));
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
index b14ba0a3..b9e02dab 100644
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

