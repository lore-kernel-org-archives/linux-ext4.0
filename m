Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713858;
	b=lGvZFKBntt/u2h6WkeFGuwSbh+oU+1euYCoQrdm+7aqgS0AFmMUumyjo2vGGUxCQyTh8
	 4lvMmp2V2DeDYW29YSKmgT1O++YGTxyhlvyrkPVaOVW7WfQsskZRdyoIRM0yZsLpMNFmX
	 98ViqkvEVINM7vdUwoNdpi++CJJOg5E3BmPAxo6m1IXFLPHXYtJGqZ5YWCNn1pVPn1/G5
	 JJ3L+E9KqXIAgO1WaD4ul8bu2ittos/fr6a0oDYCn3UhlY4P1xVFL6vrcz9hL749aiDxP
	 B4636yk/cQpPYOjlzRyxPPU1RJ27dy/nxWKnNjd3ymwQBL/GcVCODCV2baLEVhPz3lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713858;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Oh5wadepJCt4QSXjtXcy/CqSnuwNEPwAM0JuVlA645E=;
	b=vI3qCc5e1s69NUiGIGadVnFaDKP0u3PADaUFX/FNlxvtClMkdN7XvqxgV3aIUdMcHWeW
	 RrtDrtKzLznvu255oD7+Fv/yTp4n8PRiLSMPEHSBV7qVgfV4DDqMvSp/xvoWFwoD3Y/nF
	 0nFqjUTHgzUYJ7afu5A6FFWMvIPIq2LHTjM5r2zjsFy0zqojtwj9AJrJ9YwhPU0pjUJw+
	 rex13uqI4revgL+ObBvDOlyeKWScYUAWfoNEDFZDvlzhxm7H94THJ0z+6HKubB42D9a0W
	 XGuJztak5LcsIyky0gz67rgrDb7Z6jct/ZKuA43V8TnLVlaCmQMArB/5y5N7hhGtZ0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NL2rjL8q;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041DB606EE9B
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 041DB606EE9B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NL2rjL8q
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso39764505e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713856; x=1794318656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oh5wadepJCt4QSXjtXcy/CqSnuwNEPwAM0JuVlA645E=;
        b=NL2rjL8qI8mh5LrgbNru9A/KkzhPYmG3xPt6uvZQanWUqZWCMjEFeEsP+XygoXkqhw
         l7YbRdi9TZu4eC4vdDrqfQAqZ0ldMd8/iaJgOukgijtGnig0d4I5o9xiMRGXTG7lN04q
         B3SwWisfLpOLgBfkQggSbVg1M7/V2WwEJiDoQnNcLyINyUDjH4m6jEdqsW1CY2LildyT
         ruU6BwJauS2CsHa3Psr3uBfSNpxWeyiKg+Mg/Ikc2s2x7XcxsBw6yasynDFPFVa8T1UY
         6XAsGyh+UyvDyHMClO86vdlpuLfnAToE+ehv1ypze89oOdUGWaW2vuuU774c5JOioq3S
         cSMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713856; x=1794318656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oh5wadepJCt4QSXjtXcy/CqSnuwNEPwAM0JuVlA645E=;
        b=o4IZ+haKSN+WajEXAfREvBHCdvuBEb5GU1Mo7qIg1RdGmKZBs80fpPrMSwwPM5JUWs
         ivSKgDbpAjHRNOyhvRHo9yI044vkVJfsaVKNGTyXk2euDw6e/V7VCACFJcv2hNyYwFxo
         0kleGJ1TJz0+KAvvnRSiXJfrq6QIFMT9Fk7KVnp+5YEJGkR2U+ejIV/fhMGLUTtmkIrs
         9pUn9pZyLHeOATeEyJxPsWt4IPywyWtLlIDJJWstGQIZM6DNhyxpUQRHb26AlBCsLbM/
         oghlEjBxP3hfnt9ZRKxSubjeGTO8l2dyOru8Xk8CKLzLOCtzuqg7y95IanhHuq2K9NPh
         mdHw==
X-Gm-Message-State: APuU4Z+ZKlOpMy658AFlnLPmBG8g+a16dJOLUygd9nQdRHbi7rsGLRHL
	ubnrE/j9eplHWLsYd7/0OXpguSHpjQXxddM1PKtdoAT/wR4g36x1rYZEfE8lEKB3nXg=
X-Gm-Gg: AYBFou3dD4AMXiK3UrZXH6L5t7gsfntxsdR0vdSNpCL4k/P2PI1XYZ2M7kGOJE/K0PT
	ELD00HvALQAW2uazM42P88LMJVN0vtW3Tj3RL/SSJhSuye8j7o/9tWee/O8j7+kwyD/RYkS8QAb
	0tLQAm7rxPLL+zLxraCjaDVVQWFQOdLYgTNJphBCgM51SPoDsVPjoBDVycdo6zL9Q37qiSbTxGl
	LkszGCUBJEVq0DoaD7IaLujkgbNAi8qD0TlMAaowdFXx3m2rHZeMKczP9IXS5ijYdI0w0N5a9tk
	M/xKXIhySOLMsQa/mtNu7uMjoxXTAMqdYc5h1T2woBFGYL6E2u3m8fyJYb9guBpe9alv9uQg34/
	e9dVbqSeqTAoyNAMRDGbMelAQ/88ZuC7qHJxWdB1x4WNMxZ+1W6cnHXW/qvMSI6D2B333UOKv0T
	kQiJEOuy48L9CdGOmuTQMhFm/CYPLV79HFbtRnmFh57mh6UeoWsFJ3o3925b3teJb4DWuGd6u0Q
	cwpfAA7QLJMIvmwA5Dq6Nzz1uGTLc210jzteH4zlqAoXfTcfhREWIO3THu9IZLG8brp7+Ht5GGc
	b70GWWNMsVsXWggg9MDahgky+i22lcLvUDXMlHcPx3pMw5Os1Owu4aCL6NZW
X-Received: by 2002:a05:600c:4e50:b0:4a1:7d9b:d4ae with SMTP id 5b1f17b1804b1-4ac16fa3523mr312084455e9.5.1793713856311;
        Tue, 03 Nov 2026 05:50:56 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:55 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 08/13] debugfs: add dirdata display support
Date: Tue,  3 Nov 2026 13:50:32 +0000
Message-ID: <20261103135037.610132-9-ablagodarenko@thelustrecollective.com>
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
index 08f41fdf..5a5dd32b 100644
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
index 613ad738..d225982c 100644
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
index 1410e7c6..03d1e49c 100644
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
2.52.0

