Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11CB514744
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472973; cv=none; b=uDwwK8jHZbn9GdqtIG68BPVHVW20gELNh9q8iXLMLY2NUAv+odWOBFxAPnDRNExx7Jbz0IbiBxhzKbbM7gMcOKsNnrRGR6sxXtCYpgI2XYB/xup8/lLa9iw4bmvliRR8hypJvNj7RVSzSLn9IaKxUAqUYYUm8rQ8PAoaTYIPkCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472973; c=relaxed/simple;
	bh=t3Y8185/1JEhXt641p7pYmtiAhyYKxOj4L4KX/sH5Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujPQybKz4/fwu5fQyOEtqGu0k2omMb8io5x3EMKGeHZQYaPeDIXJr8F667U90+het2lmjeHRMaGh96aiWX/d9dt4PN1f9g0mzFqjQ1XtWwDk/iKe0kE+Dv+pRsoT4ik9PFwrIbskoHuxfm7VC4do0rTBswPt3Yv7KChimAUH0cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pKAuqB4i; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pKAuqB4i"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b0dd3c9a0so3243815e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472970; x=1789077770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nu54DzA5DB9fXpva47T5+m0Vtfh/u7tUNzPK4xTBgis=;
        b=pKAuqB4ix6ItLeHEtH3rSwiUEkrt0yRjALJR/OuBm9aADYentJYXDwtW1jzG4mj6VV
         bGb95c9m0pcu/v/ThJWnyTyfvlHk+UmKQweWv2alig21EADpjNgcXqSg91iYowpC+Si4
         tTbpqFwS1F7dtZGgeen70apac46/bA3NtVn7I0wl4XndeGY7ObwZ2o/sj6zHpzgdgc9y
         90hjPovsodCxyRegrEZEclGqty0b4bbUTbdR+Uhra7cLFBz2C01/VWWo7XagkwJwt9Dx
         vtvJ9KQFG6/Z9LFTCieXpc49+QW6zzUBgv0BxseCgkDmiWiQzfLfRE/as+7nTZRIAz1W
         MnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472970; x=1789077770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nu54DzA5DB9fXpva47T5+m0Vtfh/u7tUNzPK4xTBgis=;
        b=c/xbLOZQBOrEnnbFWnxvnmVxaYhmHBYwKY6w2zCScNG8lbmLl1ChiYebhhIZ+xF/Og
         hfJOdt8oq8fCGlX6sTUsO7OJYDz8c1tcB3Zsjk5fZNBf8I+a682Vm3Pmit794I8JOEQZ
         z0m3HC/rGATuswyGczb70E6dUHWf3n/92ATGi6UACoudRg4VTpg9/zZhUwsRJzI9Vm6R
         /PZIc52RjgkJVIocpeivnw6CM9gp1+sZKVxI7F7gRg+3c3XOSFOW//9ruIP8WnvPfZGZ
         m9Gf18N3WA85pOjSdECRXVD7QeSnf7Q0nFA8GNfo3AecToH9lVanYLRmeMtPXXuWkOG8
         ZyXQ==
X-Gm-Message-State: AFuF++lkFSnBRzGClbazk3zZ/9rw2apXGP/JyGP4w69jkxnctZKXSd/y
	wU1GKzyxrrR+CdSPGQMXcAJAicnuTXVa/Jari5fta5c99jrCmAWHMeTwwidk42ly
X-Gm-Gg: AYBFou1nVHvrSx2LsP4tAsoD9N3HevvJGdwDt4X8/duUhtm3RlmOgOUm+AeBq0/I4zi
	M5PX7V/eG3Es7ygUDFRHvqFbKX0wEF+EtgYXLFcpD6KOz0pxT2o5s9QtnEKrMOeswza9XCcDlFw
	y4R9X5BVpDQE9lMINKYPByW3CkJshSerWNv29Z2KQHK6UAn3Qtqz06P3mjDAMOQC6aqzSXlgVh1
	Ajju3zmFlyvSj4JVvEqzunrYdBLguWE12E9gecmB323YwIaCk7oeQfxJzgCzNO/S3lju+LESZdN
	AVZ+5hlRX+eFO4RabNSQpGTwYmQBJUTY/pz8hGISzsgetE12RUoYGo6AESk1IhjdrZrsTNtHuD2
	0QOmQn9RBdT6iikblB/Fq1CI1eEwajrDEfUC/lmlAdmJOs9qmFrvsO0iqcutdmm7+rMu1wE27Kc
	k6IGL/HMgtitvWTnW1eP3xF2Irl/U538FZLwqaSEniTd2OqThDmbwMEISmvf24KIinCARdxL+kb
	1QbnmCM5/bNprupV+Qa
X-Received: by 2002:a05:600c:6214:b0:49c:dca4:94c with SMTP id 5b1f17b1804b1-49cf825115bmr17981545e9.13.1788472970155;
        Thu, 03 Sep 2026 15:02:50 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:49 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 06/13] e2fsck: dirdata message formatting and pass3 support
Date: Thu,  3 Sep 2026 18:01:39 -0400
Message-ID: <20260903220146.19752-7-ablagodarenko@thelustrecollective.com>
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

Add FID extraction and error message formatting for dirdata, plus pass3
support for proper error reporting with Lustre-specific metadata.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/message.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++-
 e2fsck/pass3.c   |  7 ++++++
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 9c42b13fb..193d887ec 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -99,6 +99,7 @@
 
 #include "e2fsck.h"
 #include "problem.h"
+#include "ext2fs/lfsck.h"
 
 #ifdef __GNUC__
 #define _INLINE_ __inline__
@@ -346,6 +347,41 @@ static _INLINE_ void expand_inode_expression(FILE *f, ext2_filsys fs, char ch,
 	}
 }
 
+int get_dirent_fid(struct ext2_dir_entry *dirent, struct lu_fid **fids)
+{
+	unsigned char *data = (unsigned char *)dirent->name +
+			      (dirent->name_len & EXT2_NAME_LEN) + 1;
+	__u8 file_type = dirent->name_len >> 8;
+	__u8 dirdata_mask;
+	int retlen = 0;
+
+	for (dirdata_mask = EXT2_FT_MASK + 1;
+	     dirdata_mask != 0; dirdata_mask <<= 1) {
+		int dlen;
+
+		if ((dirdata_mask & file_type) == 0)
+			continue;
+
+		dlen = data[0];
+		if (dirdata_mask == EXT2_DIRENT_LUFID) {
+			struct lu_fid *fid;
+			int len = dlen;
+
+			*fids = (struct lu_fid *)(data + 1);
+			for (fid = *fids; len >= sizeof(*fid); fid++,
+			     len -= sizeof(*fid)) {
+				memcpy(fid, data + 1, sizeof(*fid));
+				fid_be_to_cpu(fid, fid);
+			}
+			retlen = dlen;
+			break;
+		}
+		data += dlen;
+	}
+
+	return retlen;
+}
+
 /*
  * This function expands '%dX' expressions
  */
@@ -361,9 +397,26 @@ static _INLINE_ void expand_dirent_expression(FILE *f, ext2_filsys fs, char ch,
 	dirent = ctx->dirent;
 
 	switch (ch) {
-	case 'i':
+	case 'i': {
+		struct lu_fid *fids;
+		int i;
+		int fids_len;
+
 		fprintf(f, "%u", dirent->inode);
+
+		fids_len = get_dirent_fid(dirent, &fids);
+		if (fids_len > sizeof(*fids))
+			fprintf(f, " fid=");
+		while (fids_len > sizeof(*fids)) {
+			fprintf(f, DFID, PFID(fids));
+			fids++;
+			fids_len -= sizeof(*fids);
+			if (fids_len >= sizeof(*fids))
+				fprintf(f, ",");
+		}
+
 		break;
+	}
 	case 'n':
 		len = ext2fs_dirent_name_len(dirent);
 		if ((ext2fs_get_rec_len(fs, dirent, &rec_len) == 0) &&
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 56798b1bc..343609832 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -706,6 +706,7 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
 	struct fix_dotdot_struct *fp = (struct fix_dotdot_struct *) priv_data;
 	errcode_t	retval;
 	struct problem_context pctx;
+	__u16 dirdata = 0;
 
 	if (ext2fs_dirent_name_len(dirent) != 2)
 		return 0;
@@ -725,11 +726,17 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
 		fix_problem(fp->ctx, PR_3_ADJUST_INODE, &pctx);
 	}
 	dirent->inode = fp->parent;
+
+	dirdata  = dirent->name_len & ((__u16)~EXT2_FT_MASK << 8);
+
 	if (ext2fs_has_feature_filetype(fp->ctx->fs->super))
 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_DIR);
 	else
 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
 
+	if (ext2fs_has_feature_dirdata(fp->ctx->fs->super))
+		dirent->name_len |= dirdata;
+
 	fp->done++;
 	return DIRENT_ABORT | DIRENT_CHANGED;
 }
-- 
2.43.7

