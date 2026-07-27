Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB753E5EFF
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186826; cv=none; b=LkFRacUdenU3I5PBKirA3GcEqjtIv+rd7WP9YnwysSKojAqKZWkkrJ8e+qhKsWwJgt381ms2HunqcucAt+W1pfkvSG5dyYzHiJTfo8Utl7+onQ4R0840A3sBQ9BFe9hj6kAOqlzvj6WOREJFZV7LzDpy7lfD1426EoPpRZgyJlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186826; c=relaxed/simple;
	bh=EA2AHm3M/h+Tu4QSIhHOqn8u4tw1LJk9cX5R53s1230=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlNcMTeSiSUKf6zvLiwwz/bB/EchnRIjWvyisUp8NyPy+uTkDmdYZ1B0MqKSmBs3szgD02zx3bgDu2QBBglQWpI6xSyktI/ma8TKGFDdOLbecxbAfnrFU4Qgc8CR7gGVvTmONGp015wzSQp5aVSdkLpC82Zget75aLcPwPffJoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8nICZIo; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8nICZIo"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49550ec592cso2101885e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186822; x=1785791622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0TPMt/hXYQN7Txu1N/rhpxeo8vSH+U4KkgT/0soV0XI=;
        b=g8nICZIoTt6fXAKbrbCCHccQmwk/7h6Z28K1avafeIrhoQm8TKKUR/anVS+D9thuuG
         jk8R64BoP6bvuxeq4CycffFOSuXDcV+0BzMsNDyEkuY6JoVhAE5DrLeoPzw0TEjDJ2gv
         ScO+0cBJHmOh6LmOuWrlTLZ8WoI6AWzC+ReS67txqT6Khw3kgPa1ql/mYkX1APbtpcNl
         /ci7c0jCIKFNpmB46wfMCULlqIau12Uq3QTlrVSl2D7D5nH9u9FZSPuyg9K2GGNyCI5h
         2tPkKCDJ3cMRs3Z5sz6qscWvobs6LnjN0CQJx6tdK7cmIWUdqIp2pW8zwBUXPVaF1pKQ
         Cy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186822; x=1785791622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0TPMt/hXYQN7Txu1N/rhpxeo8vSH+U4KkgT/0soV0XI=;
        b=MrexMQF8YaGUvr1gszq56Qnbwl6CFJbFvakkiRZU6nqZfSCV46AkGLuaaJwPmZAzyJ
         yJ16RlEP8PsI03n0iZ5J4IskLYUoxBkoumGgXrJXLPf/2t25BxUHHuoK8AepNx/R9udj
         6+NYy+ONnx6VuaDkHrvr8T9NEzcgM/WRf7VlkLw5tQ/8KpYyywmEj8SRZyUO8ZsuOMXO
         o/etcjdjDfJbzZKvoy8sdU7opH1tDXnMTmg2JfXGZBo8MRXpAVnyuj8S/bA9sQbk0Ky6
         iSpkJvwdAw0+htufyaX2SLlduAXQ9qdKvYWAM2NnAgWhuO99tullDEBT766lZxVCS1VD
         hI+Q==
X-Gm-Message-State: AOJu0YyyDWbDBv7BaPEK5u1OJtFnArvYmGYItWObfRW8Pni5YFhfWyoS
	Q4wFtAwW//KzgxgUnH3SW5xJZltUBVTD7JFbxV+AWR6l3a1sshOoKoDFH9leNTCC
X-Gm-Gg: AR+sD12Iu0x7nrI2cn0TkvCz0K9PP42o20/n8PG6t2hYRJ/++hYlPYdvELA4/agCyea
	2kq827C/1v42hxu8U1DsypsP7L3paiGNxKn4kcYBaW8fMbJQ/L/eVDwhPlqFkYOzRdVMujrCxyy
	4ZYgTqAsMY4HwgonOLfOZYgGdrG1K4wmFArTRYrxUZpgJAUPW7P8ALe+j+8vVkqCHr5A3svG30r
	XYacnKPTrBaL2YPtGONT/8uLWJR6NtK86utofFZlL3ypLIE6hhUzAAvFwJbRfkYwX9+X5BRKs3w
	6wQfWGZUxggF1jhiZliDqRHUa+9DNWR0HzbjKT8N0Ji0Aedj/SbuuVMTzQqZeO5h4vdhxGYLZfL
	qQWYqHlYbiQ1aEem/zbcI77EP+I7DrezE2DEu5oFth/FSISuYr7DUPjxCVMBALL0JlRQorcTGgB
	5ROITfXiZZeqWsjCMEDMK2DRlqkgBFpdnmHQ==
X-Received: by 2002:a05:600d:644e:10b0:495:3a52:71b1 with SMTP id 5b1f17b1804b1-496c5666d31mr2104945e9.5.1785186822435;
        Mon, 27 Jul 2026 14:13:42 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm270073775e9.1.2026.07.27.14.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:41 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 13/13] ext2fs: share list_dirdata code
Date: Mon, 27 Jul 2026 17:13:22 -0400
Message-ID: <20260727211322.19686-14-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211322.19686-1-ablagodarenko@thelustrecollective.com>
References: <20260727211322.19686-1-ablagodarenko@thelustrecollective.com>
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

