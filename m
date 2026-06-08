Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3938E397339
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 21:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780952854; cv=none; b=PtaYf7rCOFThepc4dhDXgXY+0fms1VMLBnJ1z+/ECE0bkShkiDslbklJ2GTWlXF5gr54hBYGQuxRTp9zeISZ33m6VIMRfQTdGVIDuN9joXiMiHiNmgLeW+uvQ8aQDsrjhjg5mTWmf015lTkvFhT030YCLWJS1wTlfi9jLufASEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780952854; c=relaxed/simple;
	bh=Xiw3z903L8laNK9MI0pEDyHAbeFBBdb/lmp1GAEv9M4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NYHHO9VHNBxfpBWCKKyZ8ev7FlOXBY04SLJSg5mJoYB3Z3rwNnaNu4D3oP8ws/wK7S4vf4wL4qCLcE/8NxugjC8WGmSG1odLpA08n62s2fNRIPLfGNmoaK1XYQjQCEesjRnW0q6UT46RLiYhpOIOZWbt3RBp/4wmyGueCVZ8Zx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=RUyLWUAN; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="RUyLWUAN"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3075ce9c05aso8848570eec.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 14:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1780952852; x=1781557652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gdz9Imld3H25TN0tIkZm/+2Mb+7jmOrkdQ/Z6A5Fzek=;
        b=RUyLWUANlxuc57Iisr1K/eFfGy/cD3yPJVM73qvEj8enJO9xeSInY0SPNLVQHzLGjg
         vBnG8XN5zPy7JltYZCms9weh4/6wGrIhgkTo0nuFHDOzkTbHawdpJpuuJpgP/vMWtJk1
         vGD1MsaFC32WZQ6R9YdLfQoW0LMekpbk/jwAnalEE7obproAfwrjwj1n745bCL62Aq/W
         6r8QDbNjVbUumfD2iTNiAux1MHZmsbNHtDmQNuXoBGWV1ywr4TteFxomZRlKb5mle/6c
         jsVKb137teuebzIS3M2nTXYRTgW+E/iT6vYNDuxS9ojCc7JLnEOI1LJov2YMeV+2ucta
         XlIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780952852; x=1781557652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gdz9Imld3H25TN0tIkZm/+2Mb+7jmOrkdQ/Z6A5Fzek=;
        b=Y04QVfWIHkOMuxeIjY2q6w92AqNz+AjaXnlb6rFD0CHKmz7w5DdZij+RivET7Cg+y8
         Ko925WRlf1VZdelq1kdMTG3JbK3M9HqIUrxEXUhhzJR90I/x/RzqFsTvD2AXwi0M5Gm3
         5+oIoGVX0lWlb1pti0uRNsHf9+TB0Il0Gvxo7Zt7Gc6rNOV465SeIpcDmURjXSR2prN3
         S4KVaBpbW5Zjc+eW5WSYNw+dc6cdrnWnlQmTuB/BwXF8qSPBuWbq8aRJqRajw3nfUld+
         KfpZNO/EdMJmxXskOF1OKHkPOzpgb72FW+LWDdi+joczKMLO3VKoevIh8Ik8WnNuKM84
         PoZQ==
X-Gm-Message-State: AOJu0YxPSQoeggOeKQnbtIQkp2+8PPrMrMbl8AMOpumjhCFGfYaSkGLJ
	hIKUvox40JxUr+a9tdWit0jOrZVe11EJ7/iXq6PjIuMfm06eqkdKeM6Xdy4OWzkkhmMUG3KmU6Q
	JWPn96jKJ
X-Gm-Gg: Acq92OGomXy63YUKAvu7SajrD+PUnsLH4JdsZRUWUeeHdk/GyK7HsWbx72+71u9HwIT
	cBc6BVdHXkQZwPyOidpfUrBKoZ1jszSxwM6yNT6jvZeIHZCE8Amxn2ZWGbPRPExBKCjBH7Pb/9s
	szd5ErtEhtk5FMn316bQzx5kUsJ7S3DMBb+S+J/yvaeY4Yv+Ky0SSlIjIO3bEAY9kLXAa6JBKuK
	MTftV2IV20Wh7VfqZcjo7FbtUNUtVO1zKQf/5zYy5L39s7LZ/kGXdpGR0hOO+ScrlwBQyMXD1A7
	4bEsuyMUtKdVmDm2dY/q5Z83ELcVwF3zb+e9Ff0mlxcCqtfcJh9axALdViJH9irHNGGwgBPd+58
	Vcpv8csXZhOmrqrcuR4X62oQWI6sx5a/sQCmbvUBDDR+06rUVjiFrU9T08bbfGDjPL1rps1o/yT
	v1Pa+ocJgbLBKq7bX8jw==
X-Received: by 2002:a05:7301:5f09:b0:304:819f:502b with SMTP id 5a478bee46e88-3077af4c61dmr10326843eec.9.1780952851986;
        Mon, 08 Jun 2026 14:07:31 -0700 (PDT)
Received: from p1.. ([2607:fb90:ec95:a47:31fb:2ecb:8319:54ea])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074df64eb9sm16535849eec.25.2026.06.08.14.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:07:31 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH ext4] ext4: fix out-of-bounds read in ext4_read_inline_dir()
Date: Mon,  8 Jun 2026 14:07:13 -0700
Message-ID: <20260608210713.1940288-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_read_inline_dir() reads de->rec_len / de->name past the end of its
inline buffer for a crafted or corrupted inline directory, triggering a
slab-out-of-bounds read during getdents64():

  BUG: KASAN: slab-out-of-bounds in filldir64 (fs/readdir.c:371)
  Read of size 8 at addr ffff88800fd3da3c by task exploit/146
   ...
   kasan_report (mm/kasan/report.c:595)
   filldir64 (fs/readdir.c:371)
   iterate_dir (fs/readdir.c:110)
   ...

The payload is copied into a buffer of exactly inline_size bytes:

	dir_buf = kmalloc(inline_size, GFP_NOFS);

but iteration runs in an inflated logical position space, extra_offset
bytes larger than the buffer (extra_size = extra_offset + inline_size),
so the synthetic "." and ".." entries land at the offsets they would have
in a block-based directory.  A real dirent is therefore formed at the
physical address "dir_buf + pos - extra_offset", yet the loop bounds and
the ext4_check_dir_entry() length argument are all expressed in the larger
extra_size.  This mismatch lets two reachable sites dereference a dirent
before confirming its physical offset is inside the allocation.

In the main loop, ctx->pos is attacker-controlled via lseek().  The entry
is validated with extra_size instead of inline_size, so
ext4_check_dir_entry() accepts rec_len/name_len running up to extra_offset
bytes past the allocation, and dereferences de before its (too-large)
length check fires.

In the cookie-rescan loop, entered when i_version changed since the last
readdir(2) (or after an lseek resets the cookie), the walk restarts from
the beginning with i bounded by extra_size.  As i approaches extra_size,
"i - extra_offset" approaches inline_size, so the unconditional read of
de->rec_len runs past the allocation before any validation.

Both are the same defect, logical extra_size space versus the physical
inline_size buffer, so fix them together.  In each loop, reject a dirent
whose minimum-size header would not fit within inline_size before forming
and dereferencing de, and validate the main-loop entry against inline_size
rather than extra_size.  extra_offset only inflates the logical position of
"." and ".."; the dirent itself always lives in the kmalloc(inline_size)
buffer.  Entries that legitimately fill the inline data still pass; only
accesses that would fall outside the allocation are rejected.

Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 fs/ext4/inline.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..0ec85cfcc859 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1454,6 +1454,9 @@ int ext4_read_inline_dir(struct file *file,
 			/* for other entry, the real offset in
 			 * the buf has to be tuned accordingly.
 			 */
+			if (i - extra_offset + ext4_dir_rec_len(1, NULL) >
+			    inline_size)
+				break;
 			de = (struct ext4_dir_entry_2 *)
 				(dir_buf + i - extra_offset);
 			/* It's too expensive to do a full
@@ -1488,10 +1491,21 @@ int ext4_read_inline_dir(struct file *file,
 			continue;
 		}
 
+		/*
+		 * ctx->pos can be set to an arbitrary value via lseek(), and
+		 * the rescan above may also advance it.  Make sure the dirent
+		 * header lies within the inline_size payload before
+		 * dereferencing it: extra_offset only inflates the logical
+		 * position of "." and "..", the dirent itself always lives in
+		 * the kmalloc(inline_size) buffer.
+		 */
+		if (ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL) >
+		    inline_size)
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

