Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0EA514749
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472975; cv=none; b=dfVWZG/ye1X7YoZdbCf2IPt7bcox1XQGypPzv5rxMmaTGEKIzWoVf0PdOxSgUfuTJb7lnqLUQo2uA+FyUrba2zw4RpoIdJqkE8PX2aqDlx8rm/ZGoPF0oJ0c5JVo4XJokdBS92sgossvt6r5KpKqBkKCP3DyuNZ0IC/oMGa9KWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472975; c=relaxed/simple;
	bh=+oeFW1DmkVqvu+3hVu1+uap4LwXBiuEgFZSHln5nQc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9y6aB8uLDT9h13nHVdDZNosvZ/hpj4gI8YI1XdTPrOydzp1ZrrX1Nlch1VjFDucHCOODP0TWCH7cryoYjQ0j3TEJ1KrZVDaPWvEJIz2zn/8c+XfNlVhN2FVvGMqIfFLX12usiFBEpotJA3tvHK8LitOT3m9pEq7mW1FDapew2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUVHmYB0; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUVHmYB0"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso3567595e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472972; x=1789077772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=der1zuKX3pmJbhC3qdVXpiE+D0+l3knqrj8w7NikdA0=;
        b=TUVHmYB0fYctkWWDmFBccKioqyduTzOvRMocDYzA2ew5hoznY7OFFzhcG5BD0EU0hH
         /1ECRwlaBvcFpU6Rw5P/Yqp7noW3eZ/RY+jxciStmF6XZ/GRa06dKkpKP7eDsKClEg+/
         XNnjVC7Eg9aOQojSZbJdlG3UpkVD58GFqrkEY3h5rTBviAeuJ37wFyfusALCvxMSksh1
         HmZSwiCoIzlJSY6cnMS5DRegQ+9Jnd0R+v+H74r7NFSu6zvGI+VlxxXSYtZH74U8pZtK
         HungszOur5PLajjZUszu5duXHV6xBOO9kTfodp/N+MhGttrYEANZ5mNCWWDVKzaSnsUB
         F4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472972; x=1789077772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=der1zuKX3pmJbhC3qdVXpiE+D0+l3knqrj8w7NikdA0=;
        b=kMPXEp5hgc/kZNbHgm0mvRk7rofQW6SWZCFfNelcKS2+o6+yeExuSa2eD36Z2RT6ZB
         eQb4arCjPu0E4eb6xVeiDvjJaiN+IdN5LTm/6vWSgJDiy4nQo/JjGchiPi70b4OnI5iB
         80DyryWGmzrohoPmneW7mzZoQby9ZLEHdyAf+sTd6DozZomQ2Y5PZP+PYmIQbR70HNmn
         JilTLjIDVFffMNASqPUQ5eYmemNkFcMgXyo5cW8TtCZ/i79Jz7pl2GXIC85YZ3o6lNZb
         NycXU0S0j0dayqyjlJBEQUpHLVrSXyEqZaDD+0HcZqwgkzVz9ne5mcdpvlad1mKcAgo4
         9HlA==
X-Gm-Message-State: AFuF++lbyCIM2yHTk1H3j1yflaJr9GlH49yvOuQ79uyS7EnCJqPQEA0y
	h+x+y7t74Ieyn6pv2s0cX3TGwXJO2bpV7aVBhpAwzQCGNd12T+9qOYcLZS1sEPlP
X-Gm-Gg: AYBFou1SfLpccGDjOEzMX8kXCotNKQDvjHiqB3rnxuHQeiZgfsow3bsrnSnZ4avYHFo
	rWhdKWWmsnD3EM41kkBdVPgdcErtYaq+ARczfN21LXYRWm7IYmTIBR/LtY/DoefzaEclf6ZOQFN
	DiOoDATgHZrsxCfOk/WNUt7vhtUVZslGxF8SzPUko5Q317NCghoHn3tqAutZfhlX5aOQ+iRG9IX
	hRNcpH9mQPsrj4Rg2bhe3DEwLGEVz1uP1+dydFnseFdb9YApTvDSONX1zCDlPUmN6FyaigoCYyg
	6sS9l6EKmtDDydCr9Gvm8DgQBvQ2XwcRILHrY1POqKVeppVYsUPt0esPW0Vi0ie1N+Zx/tEt6rI
	BEdEyd81lruJPku7nuY25Sjuwqm32UGXFIhh+cGSt6FWVUU19iPF9uRpOXFxXzgpz1aM5RQ1OKv
	5VtpXfCeXRX+ociyg3IFq6fVySQFgnIq89PoAyWZ9v5uxd8AKShC7Tt5I+kdVekY1duf5G+NGm0
	eYNC85vCtW2h2kGBdfd
X-Received: by 2002:a05:600c:8b29:b0:49c:ee22:364c with SMTP id 5b1f17b1804b1-49cf824743cmr16457145e9.9.1788472971556;
        Thu, 03 Sep 2026 15:02:51 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:51 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 08/13] debugfs: add dirdata display support
Date: Thu,  3 Sep 2026 18:01:41 -0400
Message-ID: <20260903220146.19752-9-ablagodarenko@thelustrecollective.com>
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

