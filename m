Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A9E330328
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779655060; cv=none; b=ZSzcRTRUbfsZAV0xwNLKZiFv3M8urhIF7LF9+SgudQbuDoPFiCWS9YXKTYfvO5kdZyO9lDxr/Knd4Dh72SPqUGOWP4XsmUnE+tOtjPdAwLwyGxh/aNiP5iiFKgNXTlXR8TUuRkleojcNPU6frr14pDrRl3QI5eN6Jb6dPYZNCrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779655060; c=relaxed/simple;
	bh=Q+HB1c1C1kW5gpf/b98Yd/BQ+eoNFh1zG1NTlB+cqSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfAMfWOQ6DVtrfQOafwFpgBbNTY1K9ZZChtVZu9OU0LoLCpKzdLHFcDCIqeBeWHGGhq7pdfe131zFkuVEsdFCfg1GsQuT2msTZdnX/xnr06YsuVM/uZKBwRC2zG/RoJ0O14xPKFnuCwtmgfSPPp62unRU8E5ea9Tqg8KM9gjRpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvj8u1Vs; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvj8u1Vs"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4905529b933so8028695e9.0
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779655057; x=1780259857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V2lx6t1zhu/geWXc6cS8dS2UExYFwK1QKtqUCQ74nhA=;
        b=lvj8u1VsPtmzb8yxb67tPopA0kQJ5aPPtcwZ4zLIz3p2f3VEq33oBLPE+F12V2DVuT
         /Ia8HgfKzJRdCGbEYBtspo+SdmnqKJHXxOE4H3TN6iKet0klbsHiysu3NZpEJfJQOE1R
         mVwWbTVPGd02keihmoEONKSdTVgU4HWQX4x2DN6a5mgvwH5JMkb+C0gBpo/hrRecIaqd
         Tj63Tbe3z2BNS89uu8aroBbKfkVxbLaPc7C0ZJoar2C3manMjF9PpGKBm0WqDHneuUPO
         cFg2haufyDQfjtezhf9oRYcEICEg2jQa/pZTMalZXKk74TMMaOzLUx8T4WNGCWUpaSO3
         qqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779655057; x=1780259857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V2lx6t1zhu/geWXc6cS8dS2UExYFwK1QKtqUCQ74nhA=;
        b=WdSMGz3ZeCCzDXWaAJ9KxoEGZFLBWisCwhB/cQ4nqcXPxk09FrJyqF1ogSDnTQjLKu
         hKWbArv80ZoXERt026bsy0hq0/rchFnWxOPnOrPg8G5Q4V2SgvuFWCx/CdUftEMYObDV
         Xet496WFQLQRIKrq0SmyOWthhzPnNGDw4x18zOCZjwiUc5ZPYS1U/DK6hVk3rM2Ue9jQ
         2MBNUft4VuQD9/20j1r7py7Vn1FlXJytnF6vlBocRiahTKmOsgKlTG9OxeeaXOfSTazd
         drirgVhr5iBbaYdYZtRw6/Tpw7ILqREsR/fiOJnl4+awNupa2LOGxbyMp77Yn8xiQn1a
         O8eQ==
X-Gm-Message-State: AOJu0YxNgvw1UvWCNOltF2NrRkl8tWFJwPzKTEoTFKZEfB3acLmIjNzw
	4+KGI6ugpjnZs+ILiqNLEQiEVugOtzakrzMOLrU1BiMTiLOZoCYKUMg1iJ4lWqnP
X-Gm-Gg: Acq92OEK7OAAHJlFLKk7sK8PDT210aH6MtYPNjxOQuFMQpkhFl8CqkKrh2RdGfnM7n3
	gCEIXhhUX1eBCADtezTDMj2D5d1KVKT488KBuFFiM/R+j+34ITNunJIaR+bcwHcw4kFzoaNU1qq
	0q3fTaTHjqnTp5wFLqrcYvhG6f8cKTXDffR0od5S8dbpIszEZHllyLacAc4eICeQWoSEUVvo8Hl
	SyrW9bSv26oZ5qam7syAkfFmWIpJacOYKpAAdfOcwFeUg4+KXx7K1wTni0PW18CoO56xlrjRYgn
	Yg0LSluPd2bfj0963rAiJ9p2ygWTSIPHXWzl9F4sIui4lOgTIk12B60ssUKT+BnXFLi8dswhBP8
	Py5RdXaJ99rwajAP1IFhGRNsihSEBwZFyWVXP+3hZda/IqWO6nWfaY2QarqcRBTaoO7+WTx9D1p
	EzbEa2iKOpFFgUdt8md+bogjk3D9THJks2RRRvdooo
X-Received: by 2002:a05:600d:6413:20b0:48a:9540:1a3a with SMTP id 5b1f17b1804b1-49042495183mr145818275e9.8.1779655057106;
        Sun, 24 May 2026 13:37:37 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526ca50sm187279145e9.2.2026.05.24.13.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:37:36 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 13/13] ext2fs: share list_dirdata code
Date: Sun, 24 May 2026 16:36:58 -0400
Message-ID: <20260524203658.12406-14-artem.blagodarenko@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260524203658.12406-1-artem.blagodarenko@gmail.com>
References: <20260524203658.12406-1-artem.blagodarenko@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

debugfs and e2fsck format dirdata output the same way,
but each currently has its own implementation.

Move the shared code to libext2fs and replace the
duplicate implementations with a common function call.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/ls.c          | 51 +--------------------------------------
 e2fsck/message.c      | 55 ++-----------------------------------------
 lib/ext2fs/dirblock.c | 50 +++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h   |  1 +
 4 files changed, 54 insertions(+), 103 deletions(-)

diff --git a/debugfs/ls.c b/debugfs/ls.c
index d225982cb..1ba72eb6c 100644
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
index 193d887ec..60859f95f 100644
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
index fa7cc83ff..b22800406 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -19,6 +19,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "lfsck.h"
 
 errcode_t ext2fs_read_dir_block4(ext2_filsys fs, blk64_t block,
 				 void *buf, int flags EXT2FS_ATTR((unused)),
@@ -145,3 +146,52 @@ errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
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
+		dlen = data[offset];
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
+			memcpy(&hash, data + offset + 1, sizeof(hash));
+			hash_le_to_cpu(&hash, &hash);
+
+			fprintf(out, " hash=0x%08x, minor_hash=0x%08x",
+				hash.dh_hash.hash, hash.dh_hash.minor_hash);
+			offset += sizeof(hash);
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
index b14ba0a34..b9e02dab2 100644
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
2.43.7

