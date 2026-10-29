Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276884;
	b=wLKY72DFrxukn6dfNnMYyEgm3FbwUgh2WyoMfrM4CvfE11o9hm5P4HL3LEAP5wBo6DOD
	 DSxmg+eCpHTEXMew42yQIGckrQdEhOEmewbTH1yGoqC2+Z5rSAL32ptRXmu2KKOmiQP1L
	 SS03VHyPbEk1kgDHx0qEixWf9dJbNCR+bbyT6xd5M+lcyhcpEgvsn+7G2owfTiwP8F2Wp
	 yAZtCQbdvJMHKWDkgoU+5z2ouHKHrt9IRtod1RKSZUs1aE4Gpn9tO1567FtJCnNCakGVg
	 caXt7NMBC42eD91XbEQadXx5V7CnKcUxAg3l+W29vkASCjhaSLDBBvmtIueXO8KLdeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276884;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ym7MIvvLpDnTQvUzX/h2cq4LGiGmyickiAuayp4EYSk=;
	b=fYdj++WPEzibSA4EGcWs2pOgGB5hE+6+JAIDOW8K4flM9pWjzsyp6rYnFbDxfIkOMCt/
	 DEaAtiy/0rhNMLQlLjZtHU/ifw0gwW7pmFtnwIYpYQRZhQisErPtG6rbe2CMGbIoGotiL
	 +rkBM8TiXYYVo4Tqb3EFsDsgDHMStwov7kuyB8MDFGPg+SW/bA8Lm40XB5MMGetnFlbQC
	 1fimlCmmUzC1G6yJ/AjyDQKIJlgQC63XsVg5T2L0uljStWacvHkMpt1HedRTcWK294Osl
	 /CGqnIHTSAGGDHmhFHnh3oftI4jMkc7f2Y3dbsTZxbhT10mJyU1QJ92TBi53eoS+ZOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FwA2Opbj;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A004606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A004606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FwA2Opbj
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so17446015e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276883; x=1793881683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ym7MIvvLpDnTQvUzX/h2cq4LGiGmyickiAuayp4EYSk=;
        b=FwA2Opbj/vSBYGjVsSUy9lAPS7vLQF5ndSNSecjz/fCWiiK7D9IfJiBGwPUhkKiGJ7
         x6o/0XAjYCZXL8FuHR9X9SiOiPeaSnuDSoxJc26JUe6NCCmwYclOv+73pJPV76BN9ZVb
         njEjxGnQd7+CUviGCz879aQW6X+IAs6buaKDSMjhanu9yMzArF7HRvJ3LygA2derMMTE
         oTxaepz4GuMQCxSesfRqFXXy/Fa5aSyRibjVPe9lZh5WvZBtzY3/EHbYO54EAQ/MqwN3
         pjDwJfQmu2hwa2gadZrqHKQvmbZgQQpMqvxzJRT4GrTGXnUOWxigfVYRL8ZxZE98WZkL
         fTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276883; x=1793881683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ym7MIvvLpDnTQvUzX/h2cq4LGiGmyickiAuayp4EYSk=;
        b=m9gl/J+MNNlx7h5rA4FHt1x9zMA4344N67I7C/Jr3x8UUb1xVPONnO8XBMexNdDtcw
         ZhSTnk0s/HUvrqwU12kruUV73EAsLZXv3H8XNVtyl+5OF6F/wKp95qYyhbxXhTHhVsvg
         pu0ABAETTdnBip3XzmNbDyKpVoSIKXyHNWMOZe7/R7KpUOO2h2mOgHaXcQ4kdDQG07Nc
         bQ7DBimRdcd7D1yooButnAViNRJ0rUiQVM75YONwF9ljfqPVBVS6Rer1WFadfm0qsinb
         anWPLG4b88xi+QS8FesV0FEVwPHI+H+HiCOkUsEIUou9HBKWqhO5aDhnoo8L0JkiZ5nK
         cJxg==
X-Gm-Message-State: AFq9FYLPJjY7eQ/yhoZ2Y/n+gZf3V1Tl19BRn+htt/Ssp+LjfZW/22RU
	GYUu49vrKraTg4yKH9nunQJOIN2NoeyRVohvWfIrcOcBJcQxWX6zN+A+PIg4FmjD
X-Gm-Gg: AYBFou0G8iA+UfvvPNFrs04ah63OdeyfYFeIMZblo1e9/mQZyml6BaeBa7m+DE6AhPt
	J49vdP7/OWtSfc0fuQAs9CDo9XF2TTxcPji0w9U62uTb7fRH6OlXu35ePLJM5yKYg78Q/KDjxPj
	3nRqC4ZNTKtOWBfbgE3bsfgC5Va8CgMRIcqk/B/DjK2oYbzz5cFabOlKNQezlxINdhD/C0njKRJ
	7pJHqGUFRTlxutg3cCUEkZw08w1SW8DWTB/DUhNR1bzigmkUx3vgMNcM7JPv+axbO1lKz6J1lLB
	vmXvrZ2xBUL2mO189f532IOUIRkZlsBTPRQrOe4Qnq6Osyk6S+t9d3P1cXIUvn8ZzM+2Eyx9Caa
	bYHJ5y+D36FHdQRXlg0SFmKdHOM61W6EdlI5JTYyLzX9wJWa2aAGjF0xbFH4uCwuaEIQhYf+bcW
	ki97SFCcAMjpW1H4llzXpgE021N+Z73Dmet87a8I1J+tqJ+QJwJGl1zbNkY26sZzm+Z+CaqHWMg
	8l2o9R2SGU9imSEpW1uK+dbg8zoTFxTfVcgrBiV7QcVheF7oVvY1Y4iM6Mi3oC/56Z4NtG50j+7
	PjQRhse0Rp+cnjBSQPl7j7Xug5TnbjPT5y92EmZlOsIknNW8ZpbXyHoD0lth
X-Received: by 2002:a05:600c:4f89:b0:4a1:ac66:6059 with SMTP id 5b1f17b1804b1-4a967e8d598mr111612675e9.26.1793276882592;
        Thu, 29 Oct 2026 05:28:02 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:02 -0700 (PDT)
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
Subject: [PATCH v3 06/13] e2fsck: dirdata message formatting and pass3 support
Date: Thu, 29 Oct 2026 12:27:37 +0000
Message-ID: <20261029122744.230678-7-ablagodarenko@thelustrecollective.com>
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

