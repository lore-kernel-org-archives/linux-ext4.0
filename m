Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99223331A66
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779655053; cv=none; b=rfjws54Gh5c439h9tvoTKvz+YAJLOBFa3N0WBDV8J5cBj0sYEs0DvUudSbXrlCOcgo/7qXZ+0xi7sXpc3LENhBtX0V0/rCH6MfhoxxISX7kykeGy2+jm2UowEtoLzBVd8y8K45qHEJkChKc1OzyfibShqCA8U7e/6gopq8kT+Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779655053; c=relaxed/simple;
	bh=oQr0Lve5gRZisEvqQ6NnV90iV9WNdPDC51xjbOc37AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJZus7zVlemR+2A+yohDBhPEuWcacWvmkhnJUSM5KAEjYtks3UTwgxrNOGkpdAuqPabts5O2shpz0K4cIZyfwSnkIAwP+mv324yLSLQnFFQwhX8OP9XqumnZRcUcc712MsaMnnnDArb0HHc9UzOZzihv9kC86cLQZLaozY2wYpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rKJv2QZ7; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rKJv2QZ7"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so23271165e9.2
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779655050; x=1780259850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s+0Pp/QSVD0JZ5QfLBNCFE3lAE38FtcgNDJNdqTOQe0=;
        b=rKJv2QZ7WF6drt+J7+wxD8EYYyZt8xj6BskGQ10K95lN0l/MNgMu1b4tL4Zhi41DyD
         yTlyK4wNDIRmcBbf4V5AbFh2iWgZMO5GiBSNYJwxjcjH+QkQ5wEcACBkmHT3DxFPUTvY
         0SimDzVHZFtzQOwZNSoio69+3qIBxYQNLDJLt8z6VCGi9so0wZy3fty6eBNVtj3paxQq
         UbDwO5NbWP/Lz1KbPCqHC/WpkP52QQmxZeNcfFsnBUv7ttoD+/YbdtRMQX6Ve8iqIulM
         ZL3bYJ9ZHfIcbPdr+mMUbtboNMlwFWxXHTXl97eENZsXrVjjVVB+55ToXMBn/p71Pn+X
         kvRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779655050; x=1780259850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s+0Pp/QSVD0JZ5QfLBNCFE3lAE38FtcgNDJNdqTOQe0=;
        b=BMY+cGzSq8z8GFxah18/EB8wtVurjQwTpqYJO0Jae62Jagi+cyd7/LHJ8XBETSRA5u
         L0rtbNo8UOZYad9sU5Qf3cJnLoSfX1ndTkVFtrx0rZY07bSs6ZWvBkPQhGY4/A5HD95W
         ss6KXPUDdQndcSg4zp6FUp3WIGH4M+NuJv8kRX4I7Wbdh0klpuloidmBMggLlwfkUNmy
         +hzMmTpKSHfTNoiYR4Ezabwt6bqRoAZyLmMcjPOIBo+MgVDAsTWHLvyJlCCYB/gzh0cv
         xafSXpMhkrwWxrcYD+Qx8oOq0CS4gE/DGUVatHTbxLlaRKSa9Aso1MjnCDChrPN7OrWg
         lxfw==
X-Gm-Message-State: AOJu0Ywdjddr23yY1SHf7fff3iz5piNI1ufy3pmSjHL8lKJUSEpcV+U6
	ETFJql3U2zBjyeP+LQt/cMfA0RO+wnk8edRMWYtI9/tNpeQNkAQ7hdPSCHtY3lQT
X-Gm-Gg: Acq92OGlS+UDX6gA3qhIgvHc0z7/pf+57UwIQ02zDCefi0Q7aR8XlUZFiTb3aKKRSom
	SPKT2EQ5aVnuvK3fA7dDZuLWBayMXC03DICKUG5HuNkedtRSfPSQaNKgiBrwy8PaNsQz8fLbhZR
	h2Xu91Z5rzJ93bhF0gc8dhl6QiBauyBKDpeCZWX7n1HqD8nOHgwwT1ffJLMdQ78QLu4ml4MKjDP
	nLWQyJcxzoW07CZxOae8vKoCHa0WRdRyb9bPZpXZDKUOf9GQw+XypBQ7vy3N9WQbdtANlCxwgue
	trq6fPisF/Me0/v4ekKsCRVvaiV1wfq/2V+U3IUgRudbL1ByqjQplGXSxQulpYnTSsL5ciTF1P9
	aScV9BYyFuYQD8h31PJzw7ZfElBS/qODRhKr5khluOY1jDO2a+VLb0da2ZOGu+TSsxk8Wd7JKBf
	nqDVIxjNSUyQcs2VgKVsxaJuelCEGMLRzF1gTOcKPY
X-Received: by 2002:a05:600d:8444:20b0:490:3b8b:6ba2 with SMTP id 5b1f17b1804b1-4904249af9amr142377265e9.8.1779655049778;
        Sun, 24 May 2026 13:37:29 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526ca50sm187279145e9.2.2026.05.24.13.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:37:29 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 06/13] e2fsck: dirdata message formatting and pass3 support
Date: Sun, 24 May 2026 16:36:51 -0400
Message-ID: <20260524203658.12406-7-artem.blagodarenko@gmail.com>
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

