Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9313E63A8
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282251; cv=none; b=t5PXa8ziiuFTKZuTPSBTLxZzUwYTv7LT6XP+xJbKunm/MiuIuTQ7Kvd/jZFZL8hVrnfHrv8XKRDXuS1kPz6mMa/3faNDrIvKRQAzueaMnvSX3gLXTkswOJhTLzKJWQ6j3yEKbbRW3ElM2d6lnL0UGa6qEA9rJYrCBHQiuBwkkRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282251; c=relaxed/simple;
	bh=HEdSWRdkGojqWxv5yRN+XmtVVmexzJy0Tv9E1rYC2+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Og+Kc0ylYjPd/d4ApX/XQWiQD5fywT7TnpGzFjAiPH/0B/MnTxETcTVicQoxPwGNXnOFcfiM+753bQCNJgSmpLRTNnE+0QY6dVx/+xgO8fyYcvM51yMljaN1OhdJaeJdBgKXe8Dhz5l7lBDC3fzGxTLonz+HXUTMBHS25v8yplk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LHC2DLU+; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LHC2DLU+"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-495590dde14so3786085e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 16:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785282248; x=1785887048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=LHC2DLU+UtL4/6eEzD7ZMJdyzrJk4PMKS4/yHJ4ozir3uKGwp9f6tNXye4FQtnjh4S
         jxBXSujEXzRJskqghPLnrRY9Gnpn5DAeONeLKolZJKgi/sf/U5BSpxii1WD0zWIaeiBH
         wS0EEC1to+gFsSOASkYrZT6blmTfVfk09c/b4uF+v9nj2VKBRJULL/WICmKp02wzmdvW
         wDNgxYakvNlgmTXqp4s8AtcuyD5YcRAS+pCocEQQ41S1X0nTNzwKbxMLco9FzSYg+0P1
         dh5cbQsapmrGEkc8RiT1GBXs5FRlH+KmBWxc25zxT6dA1x1Y1l5fNJE2YPiyxV9AW6Ag
         0N7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282248; x=1785887048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M8QWSBxpjTEhrK1+a9oV08Vs2y7teNLCY6FNVgxrG4Y=;
        b=DwrHAdO612ZeN6iEsZ17NJWJwBBdUFEF4RRWd4UcZWd2LHZJsIifUPPPJG96qOmWrA
         H0MXQZjrg/ZijMcwF+yl05TYc2nIttH6m86Wl9CWUvF5NLyH2mpvHmYDyrVGhWOKNLOG
         XSuBItAA9GszOEpgrRZvXVbo0fw2OisNWDq7me9P4Y8S57eFIXPhQPnYmb89JG6JR/yJ
         JXq9he7k/pcutQqjt538uxOSBJH/8X1m0WTDVQKEq25EhQd8+FXrHr8mLkL7mbQhPdl0
         qSsI8sbISWC6DzRRPQStrg+rTof6LHaln/CO1qdfeptmPMuj/NxhS/ZHQfeGeF8nJ6of
         +Ssw==
X-Gm-Message-State: AOJu0YzUgsvC5S9td0ttlTOoIP5e57hV5CBBmGzEn6jgLrmA+3dV++ht
	2leI5km11h4R5HTE4Yu9H0SyevBL3tfd6qql+UlFwVqYyEg7yYK1DZAcHcCktzdH
X-Gm-Gg: AR+sD11KlFo3fzk27GnENZ9T08vzlb7zyzTUJ0snRQrkFsFAMHN6Os9u8WnRwH1Cuua
	dvSGLEtg69CNZZUnidblOIwRimyXC7yuXslWpzgIUrSARJesVbM4H3M1r0nqBIykuvuy8YmFNkt
	s+FBQ2SsSsXcmXnhufS9s6jxaI9qM0HE+/p/oMTH6uE6PFJZFkJZlK71CNCRKYosysBvaww/d62
	YvzJlU5/XGG3YJpF8uJC9b/S4mxJCpO8X87d34l17jPjH4nkn9ZTCn94aTClRQ9ZKyBL7lahpqT
	x3vHWP1h9vBlIoXZ643cjVLlgVKAGpzn/6qPr/zWQsHu9+MxnQ50Gp52yuaxPq5hndnFIjZ/UmF
	YJhdSN239mDJG/jPo1vubbLN4Y2bWnjq+RXGDBOGxD5M82fagWv/jbScLsOLU2rQ5ATdeAOw+hP
	xo1hg5AQ/0WmmZnUbCvEhKVdys8/JfmIA++x+EgrbeG2Vw0LKbxLoTG/bzAAsLJt/aK72ALCCfW
	3HbQxzekzcP+C+Kx+dP
X-Received: by 2002:a05:600c:350e:b0:490:44eb:c1ea with SMTP id 5b1f17b1804b1-496c656e4b7mr50025765e9.24.1785282247758;
        Tue, 28 Jul 2026 16:44:07 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496fa499a96sm13980365e9.3.2026.07.28.16.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:44:07 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v7 03/11] ext4: add ext4_dir_entry_is_tail()
Date: Tue, 28 Jul 2026 19:42:14 -0400
Message-ID: <20260728234226.51753-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
References: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
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
index aa8a37566a38..f8d8d92391bf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4002,6 +4002,22 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
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
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c2f330c75c81..da12911bd754 100644
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
2.43.7

