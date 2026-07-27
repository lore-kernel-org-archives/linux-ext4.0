Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AC341D106
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186820; cv=none; b=oDUaEpaN0byfUsqcIgeCYQa9ubqi8zJa3Mpf+ZsqlvFTKAHOa8yErqfCQQDWXwnWy9TORzB78seRIYNOCNUGUMNHNWVAWJTspP5993akQnjoZvQCpsCTrvORAykn3mUSqBQHNLbRl+Wc3K0XFSJnar+hph0hfM0CMbKRhAmUi6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186820; c=relaxed/simple;
	bh=+oeFW1DmkVqvu+3hVu1+uap4LwXBiuEgFZSHln5nQc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiX8Fek5GHW9HjvRf5BPEmkEP3vDIAYDbgai9s5o4f5ts/tEc3wK/idccNkA8q7MRByEIRkefCo20HvLb5Y0XZkqKEzw62ki5fAgIOVppIkgOh+uZItPp8L172lZBd4bZ1h6h0FI8sqtqZsE7cYfOim00zZKKPByL6LLoobUlAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjsXzZE+; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjsXzZE+"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so15366165e9.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186817; x=1785791617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=der1zuKX3pmJbhC3qdVXpiE+D0+l3knqrj8w7NikdA0=;
        b=jjsXzZE+6zmPWTdbic0aUD8jW3G5lAHY2NZF4MkG1uv55OrDjTqubHaxT83o7ms2yY
         sWIfLo5z46gHSaVx8PmtdXdkcJmWBUXuPGF/59wvw4vALPWAeBOQBW5XZLqVsOvY2HIJ
         pzClGXd+bDhCpTaS3FQb44bR7r0dFZhZW82vD5EjHA/70YDNnvkkhrBgurYiQCjJefTd
         H20hPijYRw1+Gx/n6qocswbDbyR5GNZ1hXhQZ4ROJ9P5aUg+GJBZlw0CXlONqX4eaGQl
         OocK4VQ1YtTfGPEIhP6JU3JRGdRylYRPLl7KNidpU2Lvgb7G53eS2t1neiRyB/HoMrm8
         mPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186817; x=1785791617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=der1zuKX3pmJbhC3qdVXpiE+D0+l3knqrj8w7NikdA0=;
        b=JJY48M1uioUpxiTJ6f804/gTRpG1hCBfmR3+5sV+soYXMbthe5mo29OHvEXjFPPXJi
         DQUmz/kDByJLUEWE1IU4ajhz1d72ppK98pNJJTSwVmIW/8DIF6xX2r9Wm0OiGfIwnRF6
         Xlp/TQHvzcPzwh1U2oSoGv80X3ef4Hi9XCqQNSoWWgeXaWTVvPBlH2BWYxrhdtCdBIxv
         Te2yuoO+EUV80vjhCYKNwmRbgujpx9SeXX976vjql8xIRlaI7cD7zZHhS5tz4p5CgaL2
         4uwsY7KmnSMnyNNsZ2WuUc5sr6E/XnX8WwvR/inBPaKUkW4+ngINv6u2kY/dCmWn6JL9
         wOsg==
X-Gm-Message-State: AOJu0Ywfy8SHTCqoRMY8ZCjE1UZwDkrNT48ULd+BMMY2g1H5DGBtDX/h
	efXe2VIyX37GViHQWoSiUXqD15e0zb0QRMIZO3mMEFS05/tPB1bBXkQZdm6RocMO
X-Gm-Gg: AR+sD112LZof5R0FLHjMCMSSEfCK5VVxtoqHN+FR/VDr1TfiVyd4nO5CcqDZYOLVlkw
	Ff3i3kl+v77kMWK5OyuI6AOm3DtVjwJzOy6BO2DihdNLPI69dLPGL5iRiev2E9/vIGGjFtiHjN3
	YbvyWgb0icbou5xtt1dmS2tkmNeEbiNjM5gToe3PrZMZaAvlgESnoyb25TaQn8oX+rt65HDEYTI
	r0OFIcpPm8LVPicVsS+7YKjEelJdfgaADWQAG34QLDkm9Ib30O8jV18s2IfrzJIDckSCIJQVtg7
	AKlubF9Q3GHkVSUVVjtyruE4aG7xbFthm4WMNOwzgQxtKlNKwebfC/vM2iTEvzeMbEW8K8PKgmZ
	3eTemz4sAyEtoRLlmbzsZj1QrkJv5UHmz8UKfK1AN2EUNVHCWpqtSL//23N6enQKHJgUo2nErcP
	1plB20U/IecyYE8S8sKNRs7zKkEzMKpSy3hA==
X-Received: by 2002:a05:600c:253:b0:493:df5d:6ca6 with SMTP id 5b1f17b1804b1-496b571c5fdmr102298995e9.25.1785186816762;
        Mon, 27 Jul 2026 14:13:36 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm270073775e9.1.2026.07.27.14.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:36 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 08/13] debugfs: add dirdata display support
Date: Mon, 27 Jul 2026 17:13:17 -0400
Message-ID: <20260727211322.19686-9-ablagodarenko@thelustrecollective.com>
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

