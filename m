Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713825;
	b=gxXLyNFLwSgLVcokW+Jr8S1/NTT2UR6lFQvQIE0erMPCJR9es2+B4tAdNEMf8ocuVjkA
	 U4vUMw7AQJKYcoExVGBZMZ1y6wlqIUzvNwIecRNwvWNFz8damHzPlAnXcoo3FwnBC80PP
	 DOlP7iIMFt249OKnWg84TpVPRk08n2z8EoK3oMqKUYuntZ9o/PNmkyADINEnuIvBkKO82
	 syVm5Wxq+DZ4Wy9eMyD0seD6+nOYH61gUYoxTFL5eDbPKnRp8jMthHndeDDw0hSrwmRX8
	 nwrFhzzVTFl2O0OXqChtdOuJn3Iu9XcgSvvZ02MV05Xm0Rq6akqP6CX/WQBjGdx1MFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1ciFdmiF3aqOX3fvFtGfnakzo3lxm7U6LI/fQcw0WZ0=;
	b=FazqTDFhwFbBYbApGR0+pX9ywgfp6OApwMYTIzK/6IrNYq0ETelxyF1lHSQNkGjRbpbd
	 f66/dORnidoVpyECNB3UM2sdUzwcIe3AjfueWvegi4apF8chraykePts/jAcMd3CNKtIF
	 mnFoQ8q3UIOTpGhdPaFIk0xWOGcCw969KpFBxQizBTkzekkSkt+H28FQpSg0TTs1VOpER
	 3RZrpHef2OFeqkXWLLVysREAdp7wF8VJNUg2J+35bx1iV0DBBM1TcQ71mnw4zhTvhoa/3
	 QhUNtgjw5oUQoPzEBc3ILZicEu/CqSDFjUYsEV9gOyph/uk1De1YDolvjwf9reY5YYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VDppaqyC;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE46606A334
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DE46606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VDppaqyC
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so42497485e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713824; x=1794318624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1ciFdmiF3aqOX3fvFtGfnakzo3lxm7U6LI/fQcw0WZ0=;
        b=VDppaqyCmI26mMZv1vi0Ei248UISt0RPZqKtGilcYdKSymFQkqlbZex9uiOeiDquWe
         GB3vjA9HX2kPNpmpsfIzk01ssCOfhdMJ09ATzWsgSt+KIvF28hhYejTUOxILgSP1Wwn0
         xTzQhPo96UPEyTRsCBLF+b6ai2J7v5rGu3dSdl9KXs/OQHx9JnQgedYMVUr1Z7RsnoI6
         EKw6CRN5OWtDWjz7ECtRQiYoX+/q0717l9U9y4Zr2CeCrSMyIe5+1+5l0IG64aWfvJQg
         itDafJwAqd/XhdZPvxg/9+/whgI1v0ZUAKBRhxGdYZJ+5J/Mo6i+KvIef4MUSGyueb2u
         mKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713824; x=1794318624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1ciFdmiF3aqOX3fvFtGfnakzo3lxm7U6LI/fQcw0WZ0=;
        b=IwWhhz+7oJyAQjE/8zgdh2QadMruVHsF1UOz4qLsaMpBxuOiOkElFqvG02vz4/529f
         NXcK1H6/4U4XwF0AQpPmETS6heDAeVCU19PUbKLjmLFUn6FVms4wmbRr3DIoRYzjlmpm
         vVTg3F8Z1YcGXyChWCAhDl/5IRXZC1RvZCHs8nBCWp83rq58O3mV/eBo3dnWhKjhnWBO
         97tyQmQg9ajDLlmRnhjqoNN/+ovdf0wIQOUTupXULRYFJ+TfGrelMqtb7ClMsLInOHi4
         jkbrMciudRbF81tcI1NxRR+J0HrMtS5hgtaAKq7PCBQ5oqf75LbIN3FlRWGGLw3wOvJ0
         8MXg==
X-Gm-Message-State: APuU4Z+5x4Xi1YY9RYTNWzX0wBC4xOaKEw7f5+C/iy9WDOnraLush2BE
	94NmsTlTrJ8M6RGWKjvhGeaS7L5M1yB3f5riAdH/z+ZyKrJAJQ/dn5byzVfRxjEFrGI=
X-Gm-Gg: AYBFou3GyTUFhkMuCZQtd3H+gF2NuMcBkzNKfm0K0o7Gve59tU0N+tzRf2xFm0kFzh3
	OIsqYoktyvy1uA/NFFC+6KFmh9wExizzkFq+3cooax69k1eaq/wdR6p9WNqzcAQcEQwznxmoSdH
	8oOc7aAJJXGd4wfJqBjw+H9he/J+cCljsZYTZZxx0or4QaDYcA2R/mXAuYiS9WRFZN1K669fAeF
	1Q5bbgGaaMC3NIGJHgfBgntmaYxLKd5N/H7PFqT8nHO9WhsagriveVtuZPWWPa9DhSavC5GJJGJ
	VrcwSGmYpeDKFo7D4lYmvIS/uHbWSZPQYIAb29dx1WruBrd6whMVBHSdS44h/xr4Nfjvp8vqdPh
	2usRmc31bmb/Y5ixVmZpWPq9zPUJqHGGdcVckt1l8s5AxszoS3SNTc9VVvmOS2eG2Aw0ig54Ai7
	wR9tO1q+aqvyF8qQ33P3fNoBntg8TQJUomCF1cp2RMQHzgPaG1GC3QVpYF4pjliGbLEiO6b+vNO
	tQF50D761WY2GWwpiTVabdDpz0L88TthW9DDVWd4P9hxzy27ZccJmN0N9rrRWvOVT8s7iAdlB7g
	gP8MRBTrykTtvJ4Ib0fCKFrUdYIC+BxxTt0Yd6yrI7LwNzZI51d5SkEwRgWbO/cImNSThReTn6j
	SjvaJKAM=
X-Received: by 2002:a05:600c:468c:b0:4a3:59c9:a750 with SMTP id 5b1f17b1804b1-4ac17d168bcmr305849585e9.9.1793713823831;
        Tue, 03 Nov 2026 05:50:23 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:23 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v14 04/12] ext4: add ext4_dir_entry_is_tail()
Date: Tue,  3 Nov 2026 13:49:11 +0000
Message-ID: <20261103134921.610047-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
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

Replace open-coded checks for directory tail entries with a call
to ext4_dir_entry_is_tail(). This helper will also be used by
upcoming changes.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  | 16 ++++++++++++++++
 fs/ext4/namei.c | 14 ++++++--------
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 16df13874559..41152914aa6c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4101,6 +4101,22 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
 }
 
+/*
+ * ext4_dir_entry_is_tail() - Check if a directory entry is a tail entry.
+ * @de: directory entry to check
+ *
+ * Returns true if @de is a directory block tail entry (checksum record).
+ */
+static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
+{
+	struct ext4_dir_entry_tail *t = (struct ext4_dir_entry_tail *)de;
+
+	return !t->det_reserved_zero1 &&
+	       le16_to_cpu(t->det_rec_len) == sizeof(*t) &&
+	       !t->det_reserved_zero2 &&
+	       t->det_reserved_ft == EXT4_FT_DIR_CSUM;
+}
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 extern const struct iomap_ops ext4_iomap_buffered_write_ops;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index dc8035707feb..6e934e2732fe 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -331,14 +331,10 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 
 	t = (struct ext4_dir_entry_tail *)d;
 #else
-	t = EXT4_DIRENT_TAIL(bh->b_data, EXT4_BLOCK_SIZE(inode->i_sb));
+	t = EXT4_DIRENT_TAIL(bh->b_data, blocksize);
 #endif
 
-	if (t->det_reserved_zero1 ||
-	    (ext4_rec_len_from_disk(t->det_rec_len, blocksize) !=
-	     sizeof(struct ext4_dir_entry_tail)) ||
-	    t->det_reserved_zero2 ||
-	    t->det_reserved_ft != EXT4_FT_DIR_CSUM)
+	if (!ext4_dir_entry_is_tail((struct ext4_dir_entry_2 *)t))
 		return NULL;
 
 	return t;
@@ -478,7 +474,8 @@ static int ext4_dx_csum_verify(struct inode *inode,
 		return 0;
 	}
 	if (count > limit) {
-		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		EXT4_ERROR_INODE(inode, "dir seems corrupt (%i > %i)? "
+				 "Run e2fsck -D.", count, limit);
 		return 0;
 	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
@@ -511,7 +508,8 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry_2 *diren
 		return;
 	}
 	if (count > limit) {
-		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		EXT4_ERROR_INODE(inode, "dir seems corrupt (%i > %i)? "
+				 " Run e2fsck -D.", count, limit);
 		return;
 	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
-- 
2.52.0

