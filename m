Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4938B2E285C
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472982; cv=none; b=kJ06gQwO0Q0damNe3x5JSYKp4/2caAMF53VkDvPzuIpFm+FurgSUdRlNOFAJlXEFvhfUCxw7ReGFJyMl+CbneBX2W4NHeRD54rpKecFFED5bwAK2ZXcTId+pveWV8CkmUBd164bojeKqmVCmTB9QNIpFEjBStSJtcRofd/lCLNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472982; c=relaxed/simple;
	bh=EA2AHm3M/h+Tu4QSIhHOqn8u4tw1LJk9cX5R53s1230=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7WJ/efGyzx+4UJf7ewSyZyFzbbYnXuIAkM7+NNA9f2QrmnC+2sgd29XD3Q/wVMrWshj0uDfbx0548AUjQqlJvp4u/CpuNTFBtgTv33IStHPMzUn4sASR67ka0zxJICUu1i8bo37ikSbEPWjJp9R/Jvo0HKdrpEZvCvN9Qr0Lns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ILsfZTyE; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILsfZTyE"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so8541145e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472978; x=1789077778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0TPMt/hXYQN7Txu1N/rhpxeo8vSH+U4KkgT/0soV0XI=;
        b=ILsfZTyErgn93+6uil/blz0hSBG0sAzh7B5nxA4mej0WcKaxj27x+JZzFJ31BdLXS8
         ZGf4Bx64af++pIA5QMwDeXmF250dLQfPyumizDzkRYsP4BWcugG1gkxOWB4/01N4Y7Zk
         6vrPrai0n2M3noIe89yB6kM2yaIISu8k6j3tgW49HHwrnpIQz31c7MreoH3NPEBNLJ6A
         xu7yVLhV4nWpUZ1vX0UsTk7oUosrFsAKyAekwm/++rlPPOpLSw2M8FXGDgquJDBNDrTk
         jYH/7oUOacsLnWPtBSsSmJ4XzI6IECwg8OJ/ouN3GamCFnQ5vGV2Fk5+ONJJ9rjar+wv
         gktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472978; x=1789077778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0TPMt/hXYQN7Txu1N/rhpxeo8vSH+U4KkgT/0soV0XI=;
        b=MvxtIt8L3FrokgvVuy6wVMdahry9XeUV2Lwm6Dbsh0xhUfadiBA+N6oGIyb0XG2mO9
         kLxOqXAiTw1QV10rvnMRjBcVGThTA6pupJ91zF0yvLSiJF0k7xCy5f2d+tPdQ6DsPeAu
         qB5bpZHk6XWX+ajLPbsPfWoZg97UBXd636avUJm1HoUlk9nzTkpwhNEt2i16IjZwfweY
         d7kQeYfUiV4bDxzJt0pRhpoLd5dO59GqmJoKt5eo3qjbUOmdwmmhjRjvI47tFSEAk4xd
         1a63a/JJ6vCa1n1tEB27vmYRijsJ9ekF7v84b1wo7ZJVyvskswptPjRVtssO1FSZoSkn
         TwHQ==
X-Gm-Message-State: AFuF++kndUalxY7DqhTTF3nBr3zncg061z37v9F3mvyrYpJ1YZg20T/+
	KT+rz48OW0unxKcSF2mJtCsCoMNP9uR+2SR2hYJaXvGXj913uGLRJQEWk013Dz6Z
X-Gm-Gg: AYBFou2OS0D8uwjA1LPfTnp0pyP1bVtahACBEMQLPD/qP922MAOMOrYvYxuv1qycvD8
	0fxtC6iyXYSrWfyBfTcsu4oe7IPK8fwvURW8tuItuSbzwFJ6ZOdYLrp8T+v9+pW9Rmr7Fh5P7rS
	7I23QSRrUgGcKMB+UsFSwSdOBASyd8ugHj043hDFX7FgmPzf8PYdWO7tbzIEzC2czDoFQySI9mG
	UejvdhxLONhTtQYoOq/912A25HzOxjZHMOxiCdrsaGuoceTw/qc34KyOhGA7RUSHOZZQAXExVmX
	CKjUgV23m1axvqChZE/dxBNhJfh4dd0UWTNfI+QlJroRD9bzd/7r7+fB58KIBbN5idoc72blxrI
	geo2z3Jx/hCdhDd8RIQWKr3f5mUPV7dn0GFAjZZztOV27wmKO4PIapR8/Jay0d2vdIzG6s0kuiz
	MN/Q0phhmI/nWXiapZMz8lqagklCBWibOEI/fx4j4XVM/O+HIz4s2tn5EUEa7acwrpQE5miW4Bs
	M00HFYZYKSs76Jasaqm
X-Received: by 2002:a05:600c:8b8c:b0:49c:f13e:e52 with SMTP id 5b1f17b1804b1-49cf893b58bmr6790355e9.15.1788472978232;
        Thu, 03 Sep 2026 15:02:58 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:57 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 13/13] ext2fs: share list_dirdata code
Date: Thu,  3 Sep 2026 18:01:46 -0400
Message-ID: <20260903220146.19752-14-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
References: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
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
index fa7cc83ff..8f1f5ea00 100644
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

