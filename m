Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276886;
	b=OcY3wYwlD0UDprum7iM3hjhYuuOYcufcA5TelBxxRnl65HbjS/ouJAeTgPCatFedtHFI
	 9UIWLDhAeL4/z5TPdtxh30NdORlHGSw741jNFl4UY0qrI95HeGspK0WaL0Bn35GEzmQHU
	 jfWIXiXMM8/pT8yvfWJlz5EOJ+58F8I2/rNN4ickRdYU8yOZmVNDgTdrVNYhNy+XMeMsX
	 rBA8CMHU0r1yMMSvvCVg/g6r/cBaP+sJhqBI5MRFo2TLPFgAkVXOfrVo6U7e0E+JD65a2
	 8TVvR+XwMfWwmc3Nwd/zq0yY5g2fGHaGetlJKpeFRlLLz0wbFSx+DEQXJmLf/oXUMkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276886;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Oh5wadepJCt4QSXjtXcy/CqSnuwNEPwAM0JuVlA645E=;
	b=QK08/UMB+tM+xrLnFOWz+uFUuJoHOl3TAnoTfg1FSutY9IZ9ep7GTJsHJU+GGzVtPcuQ
	 yYx5kb3fFnn055jvE8mdZiy8flyXvjP+cc75UnUtrrrdTzmteZpC4ifi1YxSiSFU35b/z
	 XavqmLJij3QWYHrVVpgY3C+YTB6Iq/8RrNhiSutfEB9TUM0l/vuLVQ2UcGf3QVCdibWRm
	 d6tt78eY0wOMNjFQmlxg9mQTSk5LRdEwG8xtdSiW92Mx1QDWre2ZDRYk2zk9/7meo7OW+
	 XSS8cXMUfPOzaBb3bBpLV04wwHP3xQQFZHafxyCcMRNx+xEzgZGyuqeaiSiO0HyMUVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XBfqwLtw;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2852606A31F
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2852606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XBfqwLtw
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso21382495e9.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276884; x=1793881684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oh5wadepJCt4QSXjtXcy/CqSnuwNEPwAM0JuVlA645E=;
        b=XBfqwLtwUqywYW0/I6gKg6BfUHue/Sp1IjUI1ZeA1oB0rWCPs4K4jmHg6xFKvw8gkh
         JNj3dsTde3z7RCXbCO2wyLieZpd7bdWOAJ47j5RoglGNHT1/WlS0JOrwoNkADGZScBGJ
         ukYuLwB10yGwDEuAyMnW+j3z/gUCjiyykq+lTbk/9z+UtVMZ6CKskDpCdZkEO3S1eLRD
         1yik75OnoJJGSt4W1pABJEvAMHJo+jSk2Io5j2Dz3peBW12brPVgIsXXoebkcFPp1rku
         kB3A/awDvxHX5kwsQC+cBOV++yVEzLY0M4MCZa+dEVHyD4T/S/xzBuddo9+WCZzOrZLl
         kuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276884; x=1793881684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oh5wadepJCt4QSXjtXcy/CqSnuwNEPwAM0JuVlA645E=;
        b=CO+sbOXnym2c/G4A8hEopX1SYsBygWS6I0gxbvsxJ84+pAdRGkUL7kl7qYxjpjZGgP
         AXVfzHqAvQuhLcdfGe88CFqZipK6LYYoXus+U0mfHUqBuypYFC2qreRAe5FaKYsJ+Q/p
         /ZQ8/niTLcPWfb/PVOwsOSNGDcd6cC5dFNJdda4bld0ZiIu1cDUpsjAcVC8tQWvRqdFA
         p3O3gTCB0ryMrT/9WHTSolzziXpU4DkUgxg/+BpHxEzjqp5tUBhqwedzNBq4++WJWPv2
         +Hb/ljOYxRvojdYe4fYlQlrh1YWHVyuNPCoDR5lNkxTyBwGodK5Pc1ITnbt6BJ0ZpCYN
         wFuA==
X-Gm-Message-State: AFq9FYI82kO668QSu4WC0GBa8HqbrDraG3B1TKAtbHbhAOun9Ipk+95J
	PLxLRwIcmEuGDSrNeku+wLUKlz3AQ0qeA/AabPRKPGmoZ8RDimgWj9gdSYhgCDbW
X-Gm-Gg: AYBFou0CnTy1xHtdG/27I3R7zQsFQR1perpn2pRb7rdF7npHw8FPQV/l6SwqBjU7+qG
	ZEuECImA7tG/ZeXYYg1qO1aYQ4sarogx/IoSg3FkvtzHqR9sA3UzfKpCf61IpNOe2m7Pp348Seo
	0pW5RYRLtFAxth4sYVpVmXQ0sKqwhmtx7bV5Bxsy2IrL6pzvFtGg4aJK6JiWqJwXAzIU3TBNDxD
	0542tksZ8WN1J9Hfgkhj1A5sywv6Y965Odv6t1E/wmnAW2chkVFYox7+MSohezu0PWgD+AwPh/A
	q5dvTQb7C3VOq0FUWARITW9NT6xWtS4XBGcABmimJrezU16hkoGfq5+D/Vn4Dab7oIfnbd7b7HA
	ssMt/jO3JDTaoRdfgoPEJP7TY4zEaVf3tTytRAXJrpzqO4QzcdbDDzlItFD6Yrx63hKtLaMTrv3
	xAe5iMut6/xOr/r03qahF7Tpmk/0crsBlEhOIrUEKkQlNCMqbQqQ4uNoTHStdnQINWpRWEELD6v
	rHKFdOqJd/6sMYwBofZaCv8QGgcglchxQG6NqNSZa4dUze3kWM776Oy610q3LZqKDp1nCSqujT8
	Ro2Zpis7TZvQAVwY8xN2dQc+kllyGaErvWdaykpLXPO03gpS7W0kTWWFEglk
X-Received: by 2002:a05:600c:6088:b0:4a1:742e:3 with SMTP id 5b1f17b1804b1-4a9677ca203mr126960645e9.27.1793276884189;
        Thu, 29 Oct 2026 05:28:04 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:03 -0700 (PDT)
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
Subject: [PATCH v3 08/13] debugfs: add dirdata display support
Date: Thu, 29 Oct 2026 12:27:39 +0000
Message-ID: <20261029122744.230678-9-ablagodarenko@thelustrecollective.com>
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

