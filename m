Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3873B7753
	for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782833333; cv=none; b=JrtRcNA75ZIfmEiRqPOch+tjK2MCRV04xf2cdKBT4gUdOM96H9xPU39tRTNoYdGrRJlZgQT/9YHJa3Uqo4mCKQu2+0aHpNsBe1WYXKHxawxipPM3O+CuzctRq2ANDG1fiOCCO6frX7jxYIWDcyxmeJ+4dK2KB9dg2ac4bC2AjHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782833333; c=relaxed/simple;
	bh=xquv6/1zmKIN/2mTfcKs1/FdMOLlx+LF57fKWWzyfCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQtFyL9vcTnhkX4X3bxjjxvDE2ieYqI4CPd+9loHNTXcR890r/IJdoR6TFg5UiNE4xi0yfUsnD04lyiOMVZXblXeG7r7yBBvVT9uMx7J2TVPxmlIvIGpG7O5SIEnLAN8yLIMcWVQ57Q0oFwot61TfWbQZNWhebaWF9C7F8PqDj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ys6/+H0l; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ys6/+H0l"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c9e89fded0so23490655ad.2
        for <linux-ext4@vger.kernel.org>; Tue, 30 Jun 2026 08:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782833326; x=1783438126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Szwrzz9Z+aWg8QbD4KtPZAGCdM9gbtLs+u51W0gxvs=;
        b=Ys6/+H0lsjI08r7hxRzRnNxUlGqSbES2eRu5ED6zhipUUkFIZf2+XfP4GEI6IUF+pR
         qLqGsCHiadFPNjeZ2KF7dWd1K/seNqTeIFqsIRRV2PaAUqRSYvlDHezr+pU/8YTjCnq8
         PTugaD2oS4c+nJYcWy6RbZ46DwjNRF3Q3QPje8EUvD1ttUTqKMctBloZIhH9/EBSuNpf
         HRsjdyOrD1OstKkXAo5n6eS2r6QQlkGSU70A0TrZvMAJCujRgLN90p6nwFzbEka1Bt/c
         b22G1DJ6SOEYI/9xHhtZfq3qANqd4tz9eSWyZAbuuIOp3gMbwRDUcxa5tD1DuKucrYlF
         2XCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782833326; x=1783438126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Szwrzz9Z+aWg8QbD4KtPZAGCdM9gbtLs+u51W0gxvs=;
        b=ioTysb8u9T13aDLrseT93P01Lk9w0j9vok6ZdmoiGt2ugYdodjsztsUxh3maxIXM6+
         EQkFopo2Muz1FfCAC6ivNyc/M6udhoCfGVrCB23gO4tB/YXyu6x1L26grhg/wjBYN9CP
         96T3KBJHUAJ5zmqhyvQCoSZY/y8SEhAtYQRl/yPJw0BZejqSjpV5Jriwyh+G2xunQri8
         p675YQ8Ix7TO+5p1VxLE8YSHNbzs6dfINK5NYbm8APNyB6KvgQAoDAkoFgev/j/Kabk2
         oATcJ+s2N8VKmehks+jTAYZj5YXlLN6LySSr0x7lXdf3NGRBbQpMf5vrGMOhFMY6HO61
         4mNA==
X-Forwarded-Encrypted: i=1; AHgh+RqFZ+mMtidsLixyeyZm2asgixPMv6U6vs63Ue8vUqELo9oP+xNBqAswZUXBopqIi8mkypQcvHdQAQfh@vger.kernel.org
X-Gm-Message-State: AOJu0YxCq6Y8BxFyouW1dHHf3KGVq67rsCXaYGW9QsvkEkojuaMtJcGX
	Cy/qPfbWcgdU6tnRc554O+ASQmeRk0FjzCb8vg2bCRShsXiwkKs/1VOK
X-Gm-Gg: AfdE7clfBN24mQF39I9Xn2j+BcPXisKe/dP9bTFZiRMZoQvw1MrwtgKT336MeIWpIkC
	yFKhp9MO61NHEfyZGbyAnoTX9f+m5+jMIFCGNWwQe2O5fZNocP6AyG24Nhfeym6+wSCkdkZYWR9
	iIyqkHsUPWyyyExj/xma2VP+6T6AoKJgPoIrUCl8Iw0GasIeT3uwFPToMYhPWOp7e8fPOrOFYB7
	haeOkAgVgsMvGZemvlMmSNWiHa3c1+PnOUnzKE+Y3pCdNo2z01a+wbMSTue9U8Q2v3w1sJqGteW
	/mbB5U0pYezpryzi738a9cwUh6mbaUCc/eWCGYqSOvRyCYxE2qflR4Fsgcc1bCCbg17/rS0i2sW
	07iq4Q4vQAc8xzU00nda/MpTXnuAVm5Ogews2i6LTIIuaO5wUTK5YcnS3LKWTpFd3r/2QsRvmea
	I96EQnFNKrqChTNxklmpNyTZRBOru+j0x/AkybE88s9rB53dc1dNls0mQVtvPQEr6Yd1vrxMykB
	g6URDNeYUhLxalsJYaUv66QWtnCyQjog+0dczeJ7cNSNuKJbBtHByLTm1hyaRUT/kJUNwh9+eMh
	N2vOtEo40fB8IfqsjGs+uK2UvA==
X-Received: by 2002:a17:903:46cf:b0:2c2:62ee:5a0d with SMTP id d9443c01a7336-2ca2d567ff9mr34948525ad.14.1782833325996;
        Tue, 30 Jun 2026 08:28:45 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (126.60.158.34.bc.googleusercontent.com. [34.158.60.126])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca4bae1e2asm10501645ad.73.2026.06.30.08.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:28:45 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Tao Ma <boyu.mt@taobao.com>,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH 1/2] ext4: use fsdata to track inline data write state
Date: Tue, 30 Jun 2026 15:28:11 +0000
Message-ID: <20260630152812.1706-2-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630152812.1706-1-aditya.ansh182@gmail.com>
References: <20260630152812.1706-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Instead of checking the live inode state (`ext4_has_inline_data(inode)`
and `ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)`) in the
write_end handlers, use the `fsdata` parameter of the address space
operations to explicitly pass down the state in which `write_begin`
prepared the write.

A concurrent thread (such as `ext4_page_mkwrite()`) can convert the
inline data to an extent between `write_begin` and `write_end`. If this
happens, the write_end handlers would previously miss the inline
write_end path and fall through to extent-based write_end logic. However,
since block buffers were never allocated in `write_begin`, this resulted
in NULL pointer dereferences or data loss because `folio_buffers(folio)`
was NULL.

By defining `EXT4_WRITE_DATA_INLINE` (3) and communicating this state via
`fsdata`:
1) `ext4_write_begin()` and `ext4_da_write_begin()` explicitly set
   `*fsdata` to `EXT4_WRITE_DATA_INLINE` when an inline write is
   successfully prepared.
2) `ext4_write_end()`, `ext4_journalled_write_end()`, and
   `ext4_da_write_end()` rely solely on `fsdata` / `write_mode` to
   invoke `ext4_write_inline_data_end()`.

This removes the crude race fallbacks and makes the write_end
determination unambiguous, simple, and clean.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/inode.c | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..521bd5d6321c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 void ext4_set_inode_mapping_order(struct inode *inode);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
+#define EXT4_WRITE_DATA_INLINE	 3
 
 typedef enum {
 	EXT4_IGET_NORMAL =	0,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..e2e8ac5fb8d8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1302,6 +1302,9 @@ static int ext4_write_begin(const struct kiocb *iocb,
 	if (unlikely(ret))
 		return ret;
 
+	if (fsdata && *fsdata != (void *)FALL_BACK_TO_NONDELALLOC)
+		*fsdata = NULL;
+
 	trace_ext4_write_begin(inode, pos, len);
 	/*
 	 * Reserve one block more for addition to orphan list in case
@@ -1316,8 +1319,11 @@ static int ext4_write_begin(const struct kiocb *iocb,
 						    foliop);
 		if (ret < 0)
 			return ret;
-		if (ret == 1)
+		if (ret == 1) {
+			if (fsdata)
+				*fsdata = (void *)EXT4_WRITE_DATA_INLINE;
 			return 0;
+		}
 	}
 
 	/*
@@ -1450,8 +1456,7 @@ static int ext4_write_end(const struct kiocb *iocb,
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if (ext4_has_inline_data(inode) &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+	if (fsdata == (void *)EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
@@ -1560,8 +1565,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode) &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+	if (fsdata == (void *)EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
@@ -3161,8 +3165,10 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
 						     foliop, fsdata, true);
 		if (ret < 0)
 			return ret;
-		if (ret == 1)
+		if (ret == 1) {
+			*fsdata = (void *)EXT4_WRITE_DATA_INLINE;
 			return 0;
+		}
 	}
 
 retry:
@@ -3299,9 +3305,7 @@ static int ext4_da_write_end(const struct kiocb *iocb,
 
 	trace_ext4_da_write_end(inode, pos, len, copied);
 
-	if (write_mode != CONVERT_INLINE_DATA &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
-	    ext4_has_inline_data(inode))
+	if (write_mode == EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-- 
2.47.3

