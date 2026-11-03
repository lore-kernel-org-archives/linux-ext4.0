Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713856;
	b=Lz/I48l2WEPLlnWHyF7c2tfRCUXh2NoHm2FR/M5G73A++CgYc19MTyz7ExD9yj+ziOlW
	 tN1PJsy7aOqte7OREPmL4k5SLtt8MLXBekTsY7mX/yIX5cDcAyHnfxYbY8nlMUq9JCaDl
	 /7/FhA8a/aVJ5u3gS+OH4OCEvjAtPO2l3ZqIdY2yt/Ez66I/rQYbevVg5eU26KdcsOkU2
	 6Yb7mG3Hwx/iMZ6ynQJpYOJSe2NNgQZW0VguTUlXJHpKHIiUntyEkHb0DxtFV8V3KAwTi
	 uj39j4LTt1A4rETf8h333aq1Py/OwIbFVd7lL8flgXfudJGKRkzQ0DPJTn/FEjEh+lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713856;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ym7MIvvLpDnTQvUzX/h2cq4LGiGmyickiAuayp4EYSk=;
	b=lM3JxrSAI9VfcCEuxnQOgRUEWkn5JCJOOles3T/WWof6zr7di9l+LZvi/g48byzNtZAV
	 pCQFWkhPl3eCftOshbxQsYIIxckoUy46bFJmFHM673fEkZMF+D3Ebm6o1pjyK5x0sxsMh
	 ED4uB6VbX5ZZ7tzni158pgRVBpqZ/+iLNfJjUCiaIXrzP7w4wGFzeFAbojCter8DRI8Ky
	 kjelN3NMfg8Y9Xc96jCYJfJFJuCbg6QDMK71GKyzuVMRuFgQI1gpiLE2Ahn3rWDCQwOpg
	 2nbRmHMyn74M4R4JmZwIaGD4tQNKG4PWzuU1bza9NfUG40k2JYhjx3S4jopeX4Al0rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LoSuqH3n;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34573606EE8B
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34573606EE8B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LoSuqH3n
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c45551fa84eso605618566b.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713854; x=1794318654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ym7MIvvLpDnTQvUzX/h2cq4LGiGmyickiAuayp4EYSk=;
        b=LoSuqH3ntwMaUVkwWyeYKRJrPhD46q6bYvTzxUDkOYJDwpqIDEW6C5mJX08x2obxV6
         /4KsYC7Szkr7619OTyJDDbKkd3krMys1fpnqv2DN6p2CnFRxQ/7njDSr1T6jaHgqCfOz
         uk4WDCSMJwgPuhJBRVhmmQeEZ64ej3agPg/4COs+yPa8CchQ9tSlwiLI2HOL+CWDNnCR
         8y2Ttc8P5T1W11/BceL7HxpsqrhFAJjphVgQ0y6+zyLhV/RfZyDq74uB9ZQd0WnlUUi1
         kR90PptevqIMylrxSmN+wT7HleNoZtj4SPSaRM3XBgRed9eagC1yDOF2C8VFBZMBBszE
         wROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713854; x=1794318654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ym7MIvvLpDnTQvUzX/h2cq4LGiGmyickiAuayp4EYSk=;
        b=0Nc2eDwx8+pOPqLnchvoTRhUThScL/lv377k3EhP7zTbrir7V/21YW6HLMHn86n5R2
         l6Nwak2gBQS9Pazllbv75oDmebbaa7BqxVH96/TyCW9f/NVoDRZ4gXVpPPSJAIaVxtru
         /qSpWcCbK118unVza+QCR9oZ/UAQcRqlc7lC8yLkshaItEmsn+596nv/Wlk6nA8K6IRN
         sZpaESToSPTmblKglwk5w7pkH+enP0fUq7mZC2CLA4jdWJaklP+oMQxSK5JAt4XKUTth
         ufyWfOoPbojm2rwlxOtxVeRqPgFteU3wZmysAflfZmH9/gzCTQQ9FFCCPTLa9DoeLLZN
         VhLg==
X-Gm-Message-State: APuU4Z/GZzku1GpXWJC+7MATxV44bfpwFiMAIsHhNcXoYRmeQ0ZNrdsd
	UrzWKfI3NN2YzTZntmUQbWu/90j+ynrvp2JCjFc9XPrDPMuWJZheysDQx8b4vZda6F0=
X-Gm-Gg: AYBFou2fCQO+SjZTQCXPrZ2CeGNfJH9qXbxyeMvmV4nXToaJ+GovnK9yrfWZf3jNCU5
	z0rg6rt5Yy4RlNN1XvTxex6EjUfY+hVlJTrIasWDAoZ0r4Xmp1RdMn1Uyx05jf81jE66I57rcis
	IIBhDXvevn3AdoLw5Ag5AKhv6rQzCbaHyiYziG5O0qZneKrLD3rK2Nt00SMQ5Bw/sZjNyhEHpF5
	oxUrtmu+9KozUPDIYPb4OJ/2GLDKgm0Ne7sYrPHzTUWpUgaUUDCgAPoh4hOHKblXDTN7Lv6+nhz
	EccoqJ4aVDtT9kIVttgqUtKY1ABir4vOaMYObmdAhE3mPJ1jxK3IImocNHqtrpIs8iN1Lw/4+bT
	YMTy3yfQSsLIJQtNpuTuZ6d28r3VUM/rziLdSv15m2h8jUQO+UNyY66taXe/NVQnpp8l1f+qxeW
	3Be98RbvCcfRVww5bDhm8sIjOiX/FYdrqbs+Wci4i9TWBtdBFeoRjox1wNY2gTEfmGwHvJfqxS4
	qsE/CFV/BK6arWDSoS1XkFvX2N5/oQ9P9deF0ZCOuAOySc/3M+ptkXMLxwea/BUwRhQWVmLPnzy
	2k5nMIfcs2u5Bo3e31TQDnZ93Q+nzBU9gFrKw9jogi9TkeIlCpnOCW0+56CV
X-Received: by 2002:a17:906:f5a1:b0:c42:4750:8d33 with SMTP id a640c23a62f3a-c4ca7a669c9mr1121847766b.28.1793713854497;
        Tue, 03 Nov 2026 05:50:54 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:53 -0800 (PST)
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
Subject: [PATCH v4 06/13] e2fsck: dirdata message formatting and pass3 support
Date: Tue,  3 Nov 2026 13:50:30 +0000
Message-ID: <20261103135037.610132-7-ablagodarenko@thelustrecollective.com>
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
index 9c42b13f..193d887e 100644
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
index 56798b1b..34360983 100644
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
2.52.0

