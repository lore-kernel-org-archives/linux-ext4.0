Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED53F3260
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 06:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763254; cv=none; b=mOYJ4f/seJLIW3s8mOJCeJwwGJNANUG4vmmK+NLsTyzoofgvWs1AGfgV6VYGzuu7gbdkezQqsFzmc3YAxzMdYVDmv/ln9i/91EXIp9MIzm0SsBWbOgwcfsGdh7UeW8Fmd0TTNFj/wL1a+3hVWMXJOsxm9pCkEhi3/DSKRv0O00A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763254; c=relaxed/simple;
	bh=zECSL8mnlm24myrmAvLalG+mV0LLL/8FWL+o1Vt9amA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qLNtR7cWWe5tNZ3za9F8816KiBY2vY0i6+9E6xtgGwkMtaZwdZCkNCK0Vv0poH8kgIDelt5Faopfx3lo7NgKBa9euM+RskHfmB0D3+izmB02UNBkKWyM3AnspalseBU7LhAADA8bit8pg/937SSkNS8omsr56LHjEbUVRzNb1iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bF6qOaSc; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bF6qOaSc"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-398a5aad413so2308578a91.3
        for <linux-ext4@vger.kernel.org>; Sun, 06 Sep 2026 23:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788763253; x=1789368053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jzhAqXJ9vWQk0Vlafubd998WTycCm4mOzi94WOJ1k/U=;
        b=bF6qOaScE1cOWWpDDRthBmN0e1HGSBO7yXejvGGTdhLqJ4idLkWYhHT4RBooANz81W
         TU0F+PMKgeXFLnYWa13LxU6i/GxIhX+MjfIkhHtYhxOB5RRJo+hmh3ti9Lfl/Z4F+ot/
         7yWAMpW3yPDzeYUfDIp8KwATPWfDwcvwL14WmOFn7oIffQy4J70/h2YwRG3zioxEQ2Ae
         AMN1GREuE08JCvXOVlSV0bD3gu0K27ymT4kmLixo9jdAeyLn8Rw6YAoAfKVRTJ71Ilcl
         HmwXE0lCa7adf4vbbSgK2ONRxVUgz3X5l4qWOg0zrNaA+J82st95/Mgi9/GLXwdDHRYo
         j7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763253; x=1789368053;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jzhAqXJ9vWQk0Vlafubd998WTycCm4mOzi94WOJ1k/U=;
        b=gOQrHl/oX7HO5ICLblAmVm+dtczfRRbiae89XKk3Wb6huHdOdC5Akg8g385eOAGv7r
         Y6cEL/sYYRcYxSz8w/R2/nPXxiugD3Br9YI0JHlLNPZQDBLYZgu038B5iof41X0+cgPP
         1BA49WCq1RrnEKywtUqT4BJr2+gwy2mlvLboMwKRC/V0/6ybQEyxdvr2vgPYrovlKBaJ
         KnqS2w1wCDuCwqW4GI7YSGo9VzVRol4NCc8N8NIJWZofhLNvALouT0ahpq3go/ku8GLi
         QNOID1OYixUMJMgyNvLyq9TYPmiICKO34FPqIviV7wKK8BuRI94P1Wy48mpBjlCD6GYF
         EhSg==
X-Gm-Message-State: AFuF++mQZlqEC6ktNLzD5hkHUOhjrFwlBb4UbrruNQxUNeOj+PcwDqEC
	br3Q1+EyZKHTmb2qI1fDgkyBhxgvFENzmnZp0T9mQ15n+0Vg87FDr1gQu9kFRVLtpE8=
X-Gm-Gg: AYBFou2OVMRgjqr4G79mpA+1q4iVL0o2g97ibfExPx5SpuJ1v1hyUZWYnEXh+Ua2QX6
	JN4fR+conqVe1IFelyQYkhAXT6IMssh/fLTj28GWwmdR3zpzOyIeD5dSORyGMybRq9zYOrt6eSn
	BvNmFz7hqc8C2NfXmGs2jzDMalFRM81fRZXG6ViUxGLouNZ/UL/TA84M+0/W2MjG1sHQmk1kL16
	iOWMV5qW7Cm+DqJlmwQoDS2TPWqzjXdw9ad45DdaOuBR5jxsiBvAfz0YYTUn8cdcXR1kYIm1F+1
	20bdn2XP6KlIWGxvlPHXhY/9fFukbKNgsxV7IuQ6flmB0mZ5mSMKe76fSSGC/tEf7nBx2GH9mHQ
	DJzrjyHBo3lY4OT0bOzNDgTvhjnuGGjxPwNTJXAoXbq1jzDI44cuzAbiFuPe0uAnINzDEkSLgmN
	dfyxeEvRjExGKGGUwJQdJXxGXKJH+HDZz4NzYBIByY1DdCuLugG8QiZtcq+PDeBAxHdD28QOMDC
	KAO5UX5Xnuvkw==
X-Received: by 2002:a17:90b:2749:b0:398:d292:e6d5 with SMTP id 98e67ed59e1d1-39b26304385mr33393164a91.24.1788763252559;
        Sun, 06 Sep 2026 23:40:52 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b8f44d7sm24475545eec.22.2026.09.06.23.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:40:52 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: fix typos in comments
Date: Mon,  7 Sep 2026 12:10:46 +0530
Message-ID: <20260907064046.36515-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 fs/ext4/extents.c | 2 +-
 fs/ext4/inode.c   | 2 +-
 fs/ext4/mballoc.c | 8 ++++----
 fs/ext4/mballoc.h | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 76038b6c3655..d5d7ee229e4a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3186,7 +3186,7 @@ int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
  * @handle: the journal handle
  * @inode: the file inode
  * @path: the path to the extent
- * @split: the logical block where the extent is splitted.
+ * @split: the logical block where the extent is split.
  * @flags: flags used to insert new extent to extent tree.
  *
  *
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bd4b778df9eb..e719fa3cbaaf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2163,7 +2163,7 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
  * @bh - buffer we should start processing from
  * @lblk - logical number of the block in the file corresponding to @bh
  *
- * Walk through page buffers from @bh upto @head (exclusive) and either submit
+ * Walk through page buffers from @bh up to @head (exclusive) and either submit
  * the page for IO if all buffers in this page were mapped and there's no
  * accumulated extent of buffers to map or add buffers in the page to the
  * extent of buffers to map. The function returns 1 if the caller can continue
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 06171a11db12..47156ce9e5c0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -234,7 +234,7 @@
  *
  * there are two types of preallocations:
  *  - inode
- *    assiged to specific inode and can be used for this inode only.
+ *    assigned to specific inode and can be used for this inode only.
  *    it describes part of inode's space preallocated to specific
  *    physical blocks. any block from that preallocated can be used
  *    independent. the descriptor just tracks number of blocks left
@@ -2326,11 +2326,11 @@ static void ext4_mb_check_limits(struct ext4_allocation_context *ac,
  *   stop the scan and use it immediately
  *
  * * If free extent found is smaller than goal, then keep retrying
- *   upto a max of sbi->s_mb_max_to_scan times (default 200). After
+ *   up to a max of sbi->s_mb_max_to_scan times (default 200). After
  *   that stop scanning and use whatever we have.
  *
  * * If free extent found is bigger than goal, then keep retrying
- *   upto a max of sbi->s_mb_min_to_scan times (default 10) before
+ *   up to a max of sbi->s_mb_min_to_scan times (default 10) before
  *   stopping the scan and using the extent.
  *
  *
@@ -3029,7 +3029,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	 * is greater than equal to the sbi_s_mb_order2_reqs
 	 * You can tune it via /sys/fs/ext4/<partition>/mb_order2_req
 	 * We also support searching for power-of-two requests only for
-	 * requests upto maximum buddy size we have constructed.
+	 * requests up to maximum buddy size we have constructed.
 	 */
 	if (i >= sbi->s_mb_order2_reqs && i <= MB_NUM_ORDERS(sb)) {
 		if (is_power_of_2(ac->ac_g_ex.fe_len))
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 39333ce72cbd..571d9bd93810 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -86,9 +86,9 @@
 #define MB_DEFAULT_LINEAR_SCAN_THRESHOLD	16
 
 /*
- * The maximum order upto which CR_BEST_AVAIL_LEN can trim a particular
+ * The maximum order up to which CR_BEST_AVAIL_LEN can trim a particular
  * allocation request. Example, if we have an order 7 request and max trim order
- * of 3, we can trim this request upto order 4.
+ * of 3, we can trim this request up to order 4.
  */
 #define MB_DEFAULT_BEST_AVAIL_TRIM_ORDER	3
 
-- 
2.48.1

