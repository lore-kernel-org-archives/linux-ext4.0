Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E56634F27F
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306846; cv=none; b=rbL/i4BcKNs8BhV3h+lN0uSWwIquZMw99sNss8ZF0THeMtEcVUy14p0LN0txgUS+iEnI20zcZWTaMhgZx1kdSXCQVs1BGPanve1Wdf8+frPHrwysqEypylYcpNSwfHIPwIWAKw6StXLW+LOrV/5xgqUpkXL5lboEMEXWTe886hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306846; c=relaxed/simple;
	bh=WroDfzPqTURMv0iDm0VUPBMyksj/JhESZ+u0Y7pNEqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n/Qwn107H4MM3abYVK0LZcLmY/43Nuza0/dokLpVsuRzF3C+nC+tDVmzJ3m+wVS4WrASmvgr+faiQnIBQMW4KbNoDliiMAnSqJYnk6QoV93T5wjTVhg+Q3P181SNGRc8f9fvrd5OLVC4YihNsRhOrABPZbBcjreXGvLSTK4labQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rq7lY7ac; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rq7lY7ac"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35fbca04006so5238185a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 09:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777306843; x=1777911643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vxA6MQ5WVPMH6RM+iJNh6xzquK0b80JHF1z9HxjdUkE=;
        b=Rq7lY7ac3FJm1V+qUxlnkjICvMkJ8ez9vfJiCrYTnGvpFe99cKwZ/unM9qz3aU0Y0a
         uid2n+rY9hLk3JwBi9Ug58REYW0e80VIpexqoxXMVFZInRtuHv1YzizxJL4BJASkUYuu
         +pR5LPlApMiI+tUvg8nSEcVLA3ug/oTYqE8PREw3talb9h2K+S+461uaxj5RwU4HyGXP
         D7B2g2VAgq6VSGbsEKZIFyta2aiYeMU2r3yi5o/yVcabhCga6n+M5zaPeKpnymjH/iK2
         Dfut8/RL+r3lU9kIZuPVgUEHvNEZH3tjQyRj/TEfM70qcT2wegpAWVOqMtJHDi69Q1kY
         WrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777306843; x=1777911643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxA6MQ5WVPMH6RM+iJNh6xzquK0b80JHF1z9HxjdUkE=;
        b=M47UiTd3HHcXL1NqYFp0kbJmAHaLlFU0CPUcbqyRztUg/LqRRm3DFd1sw5JsCF/xiF
         CzSWlAOrTjoU2Ki7QKTaWfAx9Iltf1TJaFdKUyCR5pGE5Rh3UdZdqDjt2XsqotiwLk9y
         FKJUNkfBAd/Gk/W3Sgd5a6ZuZdYadazbYCs50+aq7kFxS2N8E/nqJ1xGKyhdtr3s00ix
         W/H/QJMIzFI5ZeJGxUx5QW5PUo4oyXTd35z/46rieNGP5hRsA2f2/D9Sb2FQWP6VfKUt
         iUaHI/a50TIebw2CizBsL9lR2JgMDCKovpfqLyBTWbKtVN5RU2J9EeBCqCQdOeVDF7MY
         xgoQ==
X-Gm-Message-State: AOJu0YxCNijQiwXAlZ/Isq3ubeUEfuAg3YscWEI16CayF2DskK98BUeD
	XHSgyGLPbhDp+9+N3ssFaH8zA92RJ1KXqON8VHQM6jC+V/em6UOmXA8EaHCI4rPkMiuqcQ==
X-Gm-Gg: AeBDieujy28cfs3mYMv2Z1lsxBx4qGGVxr5ViBPlMtNl4rPfUOstxtnVxif9xjIz8ab
	XTOTKMaPbYxjERJvIX9sADDzr4aUfE0kPQrC5TsUHeGtw4JiqhesKkHYpJsaoyfDgtWQz/8EaTV
	q7nER0fHU18shChtcqgQG5G63vSq07yK6ChC0tTBHe0hJh3z4uLfZeoO2nDw7zj0OJlxyTXnNpr
	Z9wENeLGBo3+sxX0Ie9kLJdKNUAqQn1agZpAVMy4Ar538uekyjW2IH6Pgw2zea3OCa4tIGNXqmC
	YWmZNHx493/QdrWGYo2nAZa7hRsbi+kNnWhtfJiEInG4q8jF4R2euZPLKFNZ+tajRct+gSCmI5A
	rq/mXv4vN0SXbo0DKBjoFIfaJCJf8nqyESm6K70XAxJBLLM+ZcyIvk02Rco/qfP25NjkirzJ10l
	X1FB5UuIctix3JkuWC5Bt9XJrgLc22CfHoGyJEK65J
X-Received: by 2002:a17:90a:d4f:b0:362:ef3a:a153 with SMTP id 98e67ed59e1d1-362ef3aa62cmr9842448a91.12.1777306843438;
        Mon, 27 Apr 2026 09:20:43 -0700 (PDT)
Received: from vini ([2401:4900:8fca:e7b6:f223:6319:a79e:7616])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab28e35sm307352625ad.64.2026.04.27.09.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 09:20:43 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun1@huawei.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH] ext4: avoid BUG_ON() in ext4_get_inline_entry()
Date: Mon, 27 Apr 2026 21:50:20 +0530
Message-ID: <20260427162020.49723-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Corrupted inline directory metadata can cause offset to exceed
the inline data size through rec_len processing in
empty_inline_dir().

This triggers BUG_ON() in ext4_get_inline_entry(), causing a
kernel panic before ext4_check_dir_entry() can handle the
corruption gracefully.

Replace BUG_ON() with a NULL return and handle the invalid
offset in the caller by emitting a warning and exiting safely.

This prevents a kernel panic from corrupted inline directory
metadata.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 fs/ext4/inline.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..bca9936ed6d0 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1718,7 +1718,8 @@ ext4_get_inline_entry(struct inode *inode,
 {
 	void *inline_pos;
 
-	BUG_ON(offset > ext4_get_inline_size(inode));
+	if (offset > ext4_get_inline_size(inode))
+		return NULL;
 
 	if (offset < EXT4_MIN_INLINE_DATA_SIZE) {
 		inline_pos = (void *)ext4_raw_inode(iloc)->i_block;
@@ -1773,6 +1774,12 @@ bool empty_inline_dir(struct inode *dir, int *has_inline_data)
 	while (offset < inline_len) {
 		de = ext4_get_inline_entry(dir, &iloc, offset,
 					   &inline_pos, &inline_size);
+		if (!de) {
+			ext4_warning(dir->i_sb,
+				     "bad inline directory (dir #%llu) - invalid offset",
+				     dir->i_ino);
+			goto out;
+		}
 		if (ext4_check_dir_entry(dir, NULL, de,
 					 iloc.bh, inline_pos,
 					 inline_size, offset)) {
-- 
2.54.0

