Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11B9330328
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779655058; cv=none; b=H4CXbLPXrACYhiW1QhZl6H9LGcZoaejbs/8db20E56FA4tgcE6tOqrO0Kp+85a3iOlJtRWjqU62DCgzWgfjp9IaoEPOKNpSQbnYoe1Vq5TWrl+u3CTkXhutOQ2mplvirVWA1KOO+UIUPc6sYRsBpurz/CIc/6UkT7tbZqnGgYbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779655058; c=relaxed/simple;
	bh=P2wecXVBg4pSSSWA8N0UmDU3gYvUuUXWZXbtNR+gUpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJtGhYSxLpSDtQIEMtNwlQKUNJZFRDLk/GRBkoy68TMtMVfPkAQRLaxQfCl2DQOZXRMtOgieITvt/XoBZkowW8t00Y7JW8Y2nwHFr0sKqHJUo7HqOfAt7FAnJGvZLGTGClAYPt8T7r9B+oPbStY4hg4BDKcqwJ1NNfiyzr7WhAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iFiiuDmo; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFiiuDmo"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490388fd0dbso33578325e9.0
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779655051; x=1780259851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JvD31AvfAtKgLNy40UibGv5gtc3KJ4h49nYRj9L9ks=;
        b=iFiiuDmohF1oo3+6Kv58urf5SeXZgR3VvfkYm5BeghMKO5K4giey7viad79zAamXdD
         GvE11tzOG1u0mY0JAF1YuWBVg9Q8NfwzkGYUJuulVz5Qz1jk9HJL4+Zjvss45b+oN/xH
         Cv5ndCqGzSUbTarhZN2bOV0UfaFXaWkkRkc9HIV3zdJc7oor//BI32uLpS0wQ3WfzbkC
         YFD9wOhCNpHtlY1coakjDilC0o7AfjD4/GSu2FpKSAdtuw6R5tQQuZXahxXZwm6CehP5
         HJMB/xUREz+lBYrSVuv7WZT4+zuWtYOqLOwcAiuU3+u46B4a2WSJ11ARJq+CNoNhkg0R
         dFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779655051; x=1780259851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0JvD31AvfAtKgLNy40UibGv5gtc3KJ4h49nYRj9L9ks=;
        b=IkrTXx6nEeCCMC6PQF0/zamYbDm7hr9iqYvVj+HA2zKq9h0piYBVNZBh5FE+ntbEzw
         0+aFEvW6nZT4iJE9x030LcM50rO0Yg6KB5VwPHZDDfAY9Ll+OrkgJCceKNCcdgb37V2Z
         4i3L3omSjASV61hpvj0e1WZ1GbNnCPnaF8s50tSHjOwv0j65UCR8oGRSwU6RxGKgui+u
         VX1MsyX5TuxG7dFV7+gJOile6023weL0D1tcaXtaJQ67o+Fd9pWteS3CESosXSxFKEKg
         mAPtvFtGEwc/7IY/Gu5y7yQJpGshrx0pEYunFSgLLC9Otolhj3KAVhcF1ywaupQNNEnL
         Va7Q==
X-Gm-Message-State: AOJu0YzVvcnGmFrF+hgjb3kKcuWm8bGKlbqBcb4oDGTiVg8IUuoqCLhM
	Rhlvj1yGsQDl0m0aDPSatl4S6T9UBt8hxcquHCMDj7+nbhaiPPsxyPeqDB4pxc7i
X-Gm-Gg: Acq92OEqZTJ3jJFsW4JDCgGR6GTOS/olRDvs7K9CpIF7tj6VMTbTI/WywugdftPeuuA
	xWCXUUnO3NNzdWl1sLBfDlhaiQwOl8I/RxS8BNwP6UVNGXIVCFxrTDLaWzIFnN8bRP3skuF4lFV
	pn/Aayd9LxZdPwXu7fIn0a+EcnWpDPTy461NX4HOwtSJ47tJA2ZyTSNLnuW3xS99UfUP0zafR4D
	cwvBOPm0v1YKhpBsSWDWgK5J/ou63G70224AjAhgeVnHuC3vx62VhxAZastT120wdCk0xgTd8Ju
	6JJnI2JhP08+jmFS5mm8HRq5CiX++fsHGXIgfRbmVD3KTiV6qrt8eTDKODI1dTb0ov4wbz5MG49
	w7MmhStlsPUmVPDZwC+demDrjilS6CbSIdlWLmr4uQQNOmC429zuFgi7WtcoV3/8fQ3wZ3nkTXj
	qU0IFcP88m++D1jHkMKMnFzBYn54i562tju5sSGQhBZeXSpmNh17g=
X-Received: by 2002:a05:600c:4510:b0:48f:e230:c3fa with SMTP id 5b1f17b1804b1-490428ddc9fmr184004335e9.32.1779655050985;
        Sun, 24 May 2026 13:37:30 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526ca50sm187279145e9.2.2026.05.24.13.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:37:30 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 08/13] debugfs: add dirdata display support
Date: Sun, 24 May 2026 16:36:53 -0400
Message-ID: <20260524203658.12406-9-artem.blagodarenko@gmail.com>
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

Enhance debugfs debug utility with dirdata display capabilities. This allows
users to inspect Lustre File IDentifier (LUFID) and checksum hash (CFHASH)
data embedded in directory entries.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.8.in |  7 ++++-
 debugfs/ls.c         | 63 +++++++++++++++++++++++++++++++++++++++++---
 debugfs/ncheck.c     |  3 +++
 3 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 08f41fdfa..5a5dd32b0 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -575,7 +575,7 @@ Instead, it will stop only when the entire log is printed or after
 .I num_trans
 transactions.
 .TP
-.BI ls " [\-l] [\-c] [\-d] [\-p] [\-r] filespec"
+.BI ls " [\-l] [\-c] [\-d] [\-p] [\-r] [\-D] filespec"
 Print a listing of the files in the directory
 .IR filespec .
 The
@@ -595,6 +595,11 @@ non-printing characters at the end of filenames.
 The
 .I \-r
 flag will force the printing of the filename, even if it is encrypted.
+The
+.I \-D
+flag will print the extra data found inside each entry when the
+.I \-l
+flag is used.
 .TP
 .BI list_deleted_inodes " [limit]"
 List deleted inodes, optionally limited to those deleted within
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 613ad7380..d225982cb 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -24,6 +24,7 @@ extern char *optarg;
 #endif
 
 #include "debugfs.h"
+#include "ext2fs/lfsck.h"
 
 /*
  * list directory
@@ -32,6 +33,7 @@ extern char *optarg;
 #define LONG_OPT	0x0001
 #define PARSE_OPT	0x0002
 #define RAW_OPT		0x0004
+#define DIRDATA_OPT	0x0008
 #define ENCRYPT_OPT	0x8000
 
 struct list_dir_struct {
@@ -44,6 +46,55 @@ struct list_dir_struct {
 static const char *monstr[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
 				"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
 
+static void list_dirdata(struct list_dir_struct *ls,
+			 struct ext2_dir_entry *dirent)
+{
+	unsigned char	*data;
+	int		dlen;
+	__u8		dirdata_mask;
+	__u8		file_type = dirent->name_len >> 8;
+
+	data = (unsigned char *)dirent->name +
+		(dirent->name_len & EXT2_NAME_LEN) + 1;
+
+	for (dirdata_mask = EXT2_FT_MASK + 1;
+	     dirdata_mask != 0; dirdata_mask <<= 1) {
+		if ((dirdata_mask & file_type) == 0)
+			continue;
+
+		dlen = data[0];
+
+		if (dirdata_mask == EXT2_DIRENT_LUFID) {
+			struct lu_fid fid;
+			int offset = 0;
+			fprintf(ls->f, " fid=");
+			while (offset < (dlen - 1)) {
+				memcpy(&fid, data + offset + 1, sizeof(fid));
+				fid_be_to_cpu(&fid, &fid);
+				offset += sizeof(fid);
+				fprintf(ls->f, DFID, PFID(&fid));
+				if (offset < (dlen - 1))
+					fprintf(ls->f, ",");
+			}
+		} else if (dirdata_mask == EXT2_DIRENT_CFHASH) {
+			struct ext4_dirent_hash hash;
+
+			memcpy(&hash, data, sizeof(hash));
+			hash_le_to_cpu(&hash, &hash);
+
+			fprintf(ls->f, "hash: 0x%08x, minor_hash: 0x%08x",
+				hash.dh_hash.hash, hash.dh_hash.minor_hash);
+		} else {
+			int i;
+
+			for (i = 1; i < dlen; i++)
+				fprintf(ls->f, "%02x", data[i]);
+		}
+
+		data += dlen;
+	}
+}
+
 static int print_filename(FILE *f, struct ext2_dir_entry *dirent, int options)
 {
 	unsigned char	ch;
@@ -146,7 +197,10 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 			inode_uid(inode), inode_gid(inode));
 			fprintf(ls->f, "%5llu",
 				(unsigned long long) EXT2_I_SIZE(&inode));
-		fprintf(ls->f, " %s ", datestr);
+		fprintf(ls->f, " %s", datestr);
+		if ((ls->options & DIRDATA_OPT) != 0)
+			list_dirdata(ls, dirent);
+		fprintf(ls->f, " ");
 		print_filename(ls->f, dirent, options);
 		fputc('\n', ls->f);
 	} else {
@@ -195,7 +249,7 @@ void do_list_dir(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		return;
 
 	reset_getopt();
-	while ((c = getopt (argc, argv, "cdlpr")) != EOF) {
+	while ((c = getopt(argc, argv, "cdDlpr")) != EOF) {
 		switch (c) {
 		case 'c':
 			flags |= DIRENT_FLAG_INCLUDE_CSUM;
@@ -203,6 +257,9 @@ void do_list_dir(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		case 'l':
 			ls.options |= LONG_OPT;
 			break;
+		case 'D':
+			ls.options |= DIRDATA_OPT;
+			break;
 		case 'd':
 			flags |= DIRENT_FLAG_INCLUDE_REMOVED;
 			break;
@@ -219,7 +276,7 @@ void do_list_dir(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 
 	if (argc > optind+1) {
 	print_usage:
-		com_err(0, 0, "Usage: ls [-c] [-d] [-l] [-p] [-r] file");
+		com_err(0, 0, "Usage: ls [-c] [-d] [-D] [-l] [-p] [-r] file");
 		return;
 	}
 
diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 1410e7c6d..03d1e49cf 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -51,6 +51,9 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 	iw->position++;
 	if (iw->position <= 2)
 		return 0;
+	if (current_fs->super->s_feature_incompat &
+	    EXT4_FEATURE_INCOMPAT_DIRDATA)
+		filetype &= EXT2_FT_MASK;
 	for (i=0; i < iw->num_inodes; i++) {
 		if (iw->iarray[i] == dirent->inode) {
 			if (!iw->parent && !iw->get_pathname_failed) {
-- 
2.43.7

