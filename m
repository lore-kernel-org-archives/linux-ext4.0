Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372B23E638D
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186817; cv=none; b=mZSv1zfbpJFb6nfiTh9JS1Fe6gHrXvFA+NTziijjrphydNgm+6050aPmkwGSZz+WKHjf/1Y3rksEtlRoV1HGI7cvTuUmAbhzorVRHDTfrofoMy3I5ld1uFcoXw739PHzCWJ43m4QDJ1YxJPmXuxgtE8zIe6YwtZZhziC3UxCcB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186817; c=relaxed/simple;
	bh=t3Y8185/1JEhXt641p7pYmtiAhyYKxOj4L4KX/sH5Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYwYzF7imcwHwK5wS7eMjILs7mzKYd6KH7arXZME3VyVbqJgdy5IqSH0CnQ9KIROyGUAOfwG1lYZlpCejwY5RLoltrMUDhNOs48t2ozKlB0CEdqYq7SJmeK2+cie607PJ17JfYw3pQjVdHyItFVt/pHVaM+9wfM/YtQhH0lsslM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHO9jLCq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHO9jLCq"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so16918985e9.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186814; x=1785791614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nu54DzA5DB9fXpva47T5+m0Vtfh/u7tUNzPK4xTBgis=;
        b=kHO9jLCqKyDgzlh/Ovq1PV0Tdi8YKeuyyXjOT71jfb3Qh5NzXBNt1mCNywZF84lAL3
         OzOpZ3hPkqrw7r6yE5GEDR2G6ffsXTQqTIrZGiQAUIPmtsbmhQ3gy8UQSNRI/OmpoHbJ
         UDzMWrB1jIV8uRajBu90hwctoCuvDtWEHdnLUDEdA0RTMuqw8Bg+NHrkFHtyXb+XOuZx
         9DqGFcPwl58tze+H4KJ79qfoa0/QYsBfhlj9l22fNjiFhh/ZW+67rQKmwiBicMV58xeV
         zIUBlq4yDwxpGbYrAIipQYU2ULIhFvx34yRkXhCaZgFOX9R35X+NQHudeS4jbOYeZQyf
         ACpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186814; x=1785791614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nu54DzA5DB9fXpva47T5+m0Vtfh/u7tUNzPK4xTBgis=;
        b=d/0VJ96LJeltCUSegYrx9XOKMsnf2u/TQWJFzZNkvDsoWqZ19fyT8Z6xOeuJjEZ+KN
         dX82I0oU/XSEPV3AfqvvoovFGUR2aXwegVGH7aCuZ8zrUEAJRFtRILHVWXdOcF7/0eLr
         Sti138yhEPJJEmRP6kSOTKou6UHAijIauUAtOIgmqV0Oe4IxIE77fQQ+ea4l3ML5lMpi
         top/QzVsEtqCt1cuu6vnr2OCg2SQBIy3z66sFm+I2vfi0+qvaP4qDLLxQA+8Flt14T5O
         7HxrE82hoPzNaRVCPN6T3ncE1kryMZwHnC3SSTzOitr8GqBXILubm98glPP8JMCfn6+C
         hDMw==
X-Gm-Message-State: AOJu0YzHIlxlPLgLq0rRJiX0siF3t21e2aLf+9irTw+CHtCv11GKYYTi
	7rGJMCX67DX13CZ9Cul87v/wilYurRyCFY6xuFXXbITDZKsqCnxi5C1B2kjCMLUd
X-Gm-Gg: AR+sD11GFJft7642CzCGasJjdmr8SeJz3jgGoa73eO7lR5KHg6MXTZCivfFOVoxZ1O4
	nPm8YV4nI5r9i08Tgq5OznTAuumE8+GSpQxvYPUvQvRA7WOP7D2l/EVvRwy9rhOu937I9/P95H/
	2w9pOQ7//Bmw8whWB0axHsgN2P4jTdzvrw5ATThOe/bHnuk0YvJakWIc86lHUHFmZq4xAJlTQS3
	37hJCdV1FH0nr0NIIH26GBTEHT2s3e6QUHEkvh6yFlBkHSMTupq/gJcFyFr7/Ru+2vRQ/EJeJlU
	c5Eo4jBYGTtBeEOlEy2c5VY/APSPcQB4Ju9VFCrPv2ETixpwRnc+z6F8Zg6hlxmQNfdqbKG4PxD
	G9UZcL0j10NlUTm0XyuQFhhPOY0kdDgglehyMp7RkwcvEw5Trcnn2mmWNykGa8A7XQskua8WnHO
	5fX8pV7+UctG0vl0zjShwdGuiTgBGMW2QvtQ==
X-Received: by 2002:a05:600c:6089:b0:495:6482:9d8c with SMTP id 5b1f17b1804b1-496c4fd630fmr6172635e9.37.1785186814419;
        Mon, 27 Jul 2026 14:13:34 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm270073775e9.1.2026.07.27.14.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:34 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 06/13] e2fsck: dirdata message formatting and pass3 support
Date: Mon, 27 Jul 2026 17:13:15 -0400
Message-ID: <20260727211322.19686-7-ablagodarenko@thelustrecollective.com>
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

