Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5B5340410
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 14:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915666; cv=none; b=ODG/5CtBFUoVUBr2BkgBCn0G07S4wmJXLm+epmX4MQRRm8buXAs2GtQjUzsKWKYCwDpHECObY8Q/IxSfetxr4BdRoGMmKgBneWLkswywqsOmGLEk70u987KIEmJtn08H1hxj4uUFaBZelT7MPabf2Nl3Pasn7LIyy1mSSCG16bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915666; c=relaxed/simple;
	bh=4BNgd14Jic9Qjm/aIRlvWP0ZkCfwyzRThTknF5C49RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ/Ma8Xm9tEIDHPu5u/7QFLTnnnvf28SMQTZ04S9Kcl3n6SKqzTtL/um3Kh/eH2V9SFwigLJ8FEZ0nCHgAMlFcGZULXh4QDP47JZMW7DwX9IDa/GITzp02r30Zw1ljQ09wjE3hesdiggJXEAE5X2NmBsuuSBh6VpUvLSWXzUgbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9rNz5Iy; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9rNz5Iy"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so357927a12.2
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 07:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782915664; x=1783520464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TF7sGPbeyivH8d5psZsdDfGtI/uaouyOVCHLn2DhWc0=;
        b=Z9rNz5Iyu+XRPByJPLkiz+Tme3QwVFjAqKjl1ojhWh8FyfmX/THYBNK7EeTrY8GW92
         WwwH17C2alfqfnw9D5r2U3QFW5BRcxpOtWZJU0vcPBhi3l0eVktYb8inJfw7MeyOeWou
         LUbMU6IAVTtWe8FBRVOd9LS7IN7D7lAlWWTPk9bG8E8MfUFPvx2zJQ4KAfKqUne6BNwU
         spfWN0UWRJbAYlqiifwT6MhFr3Zy/A9CYFKAIMS4Yqg4M6lsotKtEpd5R54UxScUHoXE
         ZxKdeaPjcSlZHpD97lWbx64+6EWfsaN7Ah/jbjixp5TdHsYawhkRgZ4fzNByflA4sZP0
         v0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782915664; x=1783520464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TF7sGPbeyivH8d5psZsdDfGtI/uaouyOVCHLn2DhWc0=;
        b=oBP0NfiwTWz2w9FOTwP8S8nR6xEUee1Z7ig2zZnlwH+aRc3wstPbw+J6A7FGgPje0O
         kDLLK/zoNlDf9WZZAE0wn8iiT6jYlEBs7H16lMvtRfRja/4QNv/LiiufN/KHmR4Thc2U
         q2QIwDnp6bhVrIKbOZ88SXlSJBYLl7d9Q+9U5sNcZZ2GMVXajCSNIe390erh9vphW1p8
         jNnjJpo2fHNTTVWaEW+PEXOco94JOWywsvDEy6MxZ/HaBRt7dCoLHU+jJRrN7e+jVm4k
         t4bipGJwOZWApiJW9A3ZpfPGHYl22VST7KHqpi93rt/m1ZjSoDg8x2SllGj5+/al5CfY
         8Q2g==
X-Gm-Message-State: AOJu0Yzw2E248Z6D6tVEA58ZLrtNmJRGLEHhMduCPvc9IfbSCgBYaHM8
	WF501e/QKmZE1m4o7qnVHq5O6L+SdlWolwxxPXLCT3TvWMWTDZoyUFdf8iRIICjoUm0=
X-Gm-Gg: AfdE7ckrp/4ZEE1vqxBoLgmal8XaqMXmI46umW9ikvxam0v+rPxOjxiiqZq4Ha1SmBh
	pOUG//gsdyJ6eAh+QsxlERPgFHLVTqfZqh7G/6X1YYqODuJmnEtd3vzJLPxlMHtf9gG2Zb4cAp5
	rzshPPkokuDepvzfHpNipsJau2U6EF0twJCkSN/RO6lD3vGTee6qj7MYrClYhxFlQ/KTH7qttK5
	qtZJP+KJv1zWA03NufITjZjGDOY6In+g3rozXEsu+ugEpbK7x4BpbX3krHSkKRfkBlvq5xp+kLz
	idlhdTakaFrV+FBXgIFz4zXsXKlKeLh0e20F+R6TTX8NdzSOO+gHsKl/gztruGpqZstWzYaUYNN
	IkBMYuSc6JRvEo6TOgtkXjBM8hf1gxbaxRJiOnk1DUCRI7verbj60hGhDmFEYPseMVDA9LSiASO
	dq3wCj0ESpEVAewqmk4PtMMsL+H9ge3Txo6WIsFA0ghXg=
X-Received: by 2002:a05:6a21:4d8e:b0:3bf:a0e5:99a1 with SMTP id adf61e73a8af0-3bfed4e5912mr2024732637.51.1782915664079;
        Wed, 01 Jul 2026 07:21:04 -0700 (PDT)
Received: from DESKTOP-DK6PUT8.localdomain ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e32ef8e49sm383894a12.19.2026.07.01.07.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 07:21:03 -0700 (PDT)
From: yizhang089@gmail.com
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	chengzhihao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 3/6] ext4: track partial-zero outcome per edge in ext4_zero_partial_blocks()
Date: Wed,  1 Jul 2026 22:20:06 +0800
Message-ID: <20260701142009.1510104-4-yizhang089@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701142009.1510104-1-yizhang089@gmail.com>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

Replace the single bool did_zero output of ext4_zero_partial_blocks()
with a bitmask that records which edge (start, end, or both in the
single-block case) was actually partial-zeroed. This allows callers to
distinguish which edges have been zeroed, preparing for unaligned
FALLOC_FL_WRITE_ZEROES handling in later patches.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/ext4.h    |  5 ++++-
 fs/ext4/extents.c |  2 +-
 fs/ext4/inode.c   | 36 ++++++++++++++++++++++++++++++------
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..b2e55876d0e3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3099,8 +3099,11 @@ extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
 extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
 				  int pextents);
 extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
+
+#define EXT4_PARTIAL_ZERO_START	0x1
+#define EXT4_PARTIAL_ZERO_END	0x2
 extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
-				    loff_t length, bool *did_zero);
+				    loff_t length, unsigned int *partial_zeroed);
 extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 27ca641e701b..7a8f9f188a29 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4715,7 +4715,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	loff_t align_start, align_end, new_size = 0;
 	loff_t end = offset + len;
 	unsigned int blocksize = i_blocksize(inode);
-	bool partial_zeroed = false;
+	unsigned int partial_zeroed = 0;
 	int ret, flags;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0b31fa873743..d68f7be4ff02 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4256,13 +4256,26 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	return 0;
 }
 
+/*
+ * Zero out the unaligned head and tail of the [lstart, lstart+length)
+ * range.
+ *
+ * On return, @partial_zeroed records which edges actually got
+ * partial-zeroed.  Set EXT4_PARTIAL_ZERO_START/EXT4_PARTIAL_ZERO_END if
+ * the head/tail block got actually partially zeroed (in written, dirty
+ * unwritten or delalloc state).  Cleared if the head/tail block is a
+ * hole or a clean unwritten block, in which case there is nothing needs
+ * to zero.  When the head and tail land in the same block, both bits
+ * are set together on a successful zero.
+ */
 int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length,
-			     bool *did_zero)
+			     unsigned int *partial_zeroed)
 {
 	struct super_block *sb = inode->i_sb;
 	unsigned partial_start, partial_end;
 	ext4_fsblk_t start, end;
 	loff_t byte_end = (lstart + length - 1);
+	bool did_zero = false;
 	int err = 0;
 
 	partial_start = lstart & (sb->s_blocksize - 1);
@@ -4274,21 +4287,32 @@ int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length,
 	/* Handle partial zero within the single block */
 	if (start == end &&
 	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
-		err = ext4_block_zero_range(inode, lstart, length, did_zero,
+		err = ext4_block_zero_range(inode, lstart, length, &did_zero,
 					    NULL);
+		if (did_zero)
+			*partial_zeroed |= (EXT4_PARTIAL_ZERO_START |
+					    EXT4_PARTIAL_ZERO_END);
 		return err;
 	}
 	/* Handle partial zero out on the start of the range */
 	if (partial_start) {
 		err = ext4_block_zero_range(inode, lstart, sb->s_blocksize,
-					    did_zero, NULL);
+					    &did_zero, NULL);
 		if (err)
 			return err;
+		if (did_zero)
+			*partial_zeroed |= EXT4_PARTIAL_ZERO_START;
 	}
 	/* Handle partial zero out on the end of the range */
-	if (partial_end != sb->s_blocksize - 1)
+	if (partial_end != sb->s_blocksize - 1) {
+		did_zero = false;
 		err = ext4_block_zero_range(inode, byte_end - partial_end,
-					    partial_end + 1, did_zero, NULL);
+					    partial_end + 1, &did_zero, NULL);
+		if (err)
+			return err;
+		if (did_zero)
+			*partial_zeroed |= EXT4_PARTIAL_ZERO_END;
+	}
 	return err;
 }
 
@@ -4437,7 +4461,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t end = offset + length;
 	handle_t *handle;
 	unsigned int credits;
-	bool partial_zeroed = false;
+	unsigned int partial_zeroed = 0;
 	int ret;
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
-- 
2.53.0

