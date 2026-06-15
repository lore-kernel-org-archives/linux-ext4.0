Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574DF30B535
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781550327; cv=none; b=r+Kh73EI46iN9QzbGU/CbxzH0svVIdHgZW9WXN92PkGN+fL3i3o8QYsWDzyGBm65hpVuKbkFPSg0xmxdxHFm88QbrRgenjWPeI5q9DQoOSAxk+6MZJ4Dn/ujS26IZ92itE4Mg2n9xNZ+2ZSrs8ZELzEQK0upyhZZ1kip/uRa6vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781550327; c=relaxed/simple;
	bh=hnjTolU8MTgELXi+LDR6qjGF2dRIkT8uB11R+3nznhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eGzulA6yOPhwG5vJSyG2kAE2/ne0CBoeuQH+eRvIj+tpHcqLWvykEl+SybGs3VWUxgXQoM4RHvRGA7RglLvJSo2VelOiw0Psg4VJj/mh9FdRYEGABM6ZjKeufbGYhELMUT9NFD0pjeE51nP1igwbzYPsxTtdJ5KJMtpaKm04DGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=Yw8eNLiZ; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="Yw8eNLiZ"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8423f52af13so2949611b3a.2
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781550326; x=1782155126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iD4hUkhpRLhFMkjs3XRG0rU53Q2Xcbo6WdcyBCLy5nI=;
        b=Yw8eNLiZbam9FfI5bE1kB94Pp1SBzpNzPvRdMh417pRrsP5IB5qkaNsONcmrl02O9w
         Ko0d0rqv8k8jgX5210xFFQkPD+Y9QUMEmwzVOQYvyBXggTVHv2LUH4XYzwb1jOKkvoJF
         +9u6SnktQtq6Vo3wn2tjE8zuz3QN2z29BYnGKLDIdAX+0Wx26CxwjG+YH9q3u5bVl4p6
         v4TPi9KcLp6I7C1tYPjxuZzcZxTx7oqPMi1K/MzsJtI3TQ+o1yqJfOApeJSwMBufnF5G
         0Uc1ErecYTS7bZWklvLZpn9OLk4pEl53TE2Xy4PTAcBQ/TqQ9KD0QzD2N53LPX9EBrhu
         EkDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781550326; x=1782155126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iD4hUkhpRLhFMkjs3XRG0rU53Q2Xcbo6WdcyBCLy5nI=;
        b=eybExYnle6ELqgkkPZZoS2n29NxM9omIJeLewl0NvjIa0zYR1NnXqKaYqRKm+DurFa
         mtDTbQjCdeGRlMsalOTrvFeaG2H18do9L+4d56sSQ2lXP7ixp4P9D2DvV0Ad+4GvgiVw
         uryY7vnWCM1UE36gZ8DGup6n5N4EiGDo7tyhA5WVdfoyc2AIr8NBfSKvm/GUzw90hTy7
         Iu0uuhzd6oeIwQjDxGl7CWtXsV2cnWINKMap925L7QYVeqeqAji22Cqq3cjOd6DsueOy
         yM97K9PKMXHRYb91MsuqnLskYfSpCfr14sltaGCmoT0CqPae+HCSb4sD2yRQBi6Hon6u
         WzcA==
X-Gm-Message-State: AOJu0Ywryd8HA/AzOYASD8fSdp/INwkZ+Xukq2ewxqD0tITLf/Bt0AAW
	96Es7hYQz2ikiUqSf3ClIlcmuL5n/CIGBQzLyq64IIemRtBPRCDqZF2JrZ839z4eYDZPXDTGS6T
	33VbYGw==
X-Gm-Gg: Acq92OGg5QIcakQrGMU3S8ehZlx4yQ+bNo0sUKpuSJs/6o92TRqXF1Y2YJoPgbAdtiO
	wtcb4e6RKtJn1P8u/b7q8YOIWBE66n0OA79y6mC4QMv66vr3FXv/0Q3sBMYZG4x0UHSTYks1jVi
	7JkHn2fRLfTqLSTKFk+WQFB8tYueYke9VsNsSAfbNNheobeQ2g3NeUdWLxEJRPWxaloPwKw5xcx
	Hxuw9bAwHAv+rxu8eGK20FfaoavjrjFfDXAnHqGmBYBaA5GagkwXYUeDwTOaIM2PfFlanIu9BCG
	vFp1ppsSgoOQNE8WrKPP8LeRhungO3loUJfSPcB2sRy/ZTsIjh1BurLJ6mGTcBu5IGw0e63ftXX
	7o9oK+CMOhA5jnE7booSXC+PhAhRS/mwJQzTwG5sNWz/mIobmkTNzWxGTZhf6uQngDEVGOKghvV
	sh6cAgCSOo
X-Received: by 2002:a05:6a00:a220:b0:842:48ae:1d6c with SMTP id d2e1a72fcca58-844e1a28ea1mr13665128b3a.24.1781550325622;
        Mon, 15 Jun 2026 12:05:25 -0700 (PDT)
Received: from p1.. ([2607:fb90:ec91:a443:4278:864b:f5d3:440d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434aca3041sm11153453b3a.5.2026.06.15.12.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 12:05:25 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH ext4 v4] ext4: fix out-of-bounds read in ext4_read_inline_dir()
Date: Mon, 15 Jun 2026 12:05:19 -0700
Message-ID: <20260615190519.946736-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_read_inline_dir() can read a dirent header past the end of its inline
buffer, triggering a slab-out-of-bounds read during getdents64():

  BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
  Read of size 2 at addr ffff88800f3dd23c by task exploit/148
   ...
   __ext4_check_dir_entry
   ext4_read_inline_dir
   iterate_dir

The dirent payload lives in a buffer of exactly inline_size bytes:

	dir_buf = kmalloc(inline_size, GFP_NOFS);

but iteration runs in a position space extra_offset bytes larger
(extra_size = extra_offset + inline_size) so the synthetic "." and ".."
land at their block-dir offsets. A dirent is formed at "dir_buf + pos -
extra_offset", yet the ext4_check_dir_entry() length argument uses the
larger extra_size. A position whose dirent header would extend past
extra_size is therefore accepted, and the rescan loop's rec_len probe and
ext4_check_dir_entry() dereference de->rec_len before the entry is rejected.

Reject a position whose minimum-size dirent header would not fit within
extra_size before forming de, in both the rescan and main loops, and pass
inline_size rather than extra_size to ext4_check_dir_entry() so the length
check matches the physical buffer.

Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
v4: use Jan's suggested logical-space bound (i/ctx->pos + rec_len >
    extra_size), consistent with the loop condition.
v3: dropped the unreachable ctx->pos < extra_offset underflow check.
v2: validate against inline_size instead of extra_size.

 fs/ext4/inline.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..f1f7104d3dac 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1454,6 +1454,8 @@ int ext4_read_inline_dir(struct file *file,
 			/* for other entry, the real offset in
 			 * the buf has to be tuned accordingly.
 			 */
+			if (i + ext4_dir_rec_len(1, NULL) > extra_size)
+				break;
 			de = (struct ext4_dir_entry_2 *)
 				(dir_buf + i - extra_offset);
 			/* It's too expensive to do a full
@@ -1488,10 +1490,17 @@ int ext4_read_inline_dir(struct file *file,
 			continue;
 		}
 
+		/*
+		 * de lives at dir_buf + ctx->pos - extra_offset, within the
+		 * kmalloc(inline_size) buffer.  Make sure its header fits before
+		 * ext4_check_dir_entry() dereferences de->rec_len.
+		 */
+		if (ctx->pos + ext4_dir_rec_len(1, NULL) > extra_size)
+			goto out;
 		de = (struct ext4_dir_entry_2 *)
 			(dir_buf + ctx->pos - extra_offset);
 		if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_buf,
-					 extra_size, ctx->pos))
+					 inline_size, ctx->pos))
 			goto out;
 		if (le32_to_cpu(de->inode)) {
 			if (!dir_emit(ctx, de->name, de->name_len,
-- 
2.43.0

