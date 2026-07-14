Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD86F39EF2C
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 06:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010715; cv=none; b=jphxctkggWDkvUlCFiaZcZuz89UkqBzpK39dV+31tGvU6hcSGmpy84Yc/RjEiWvP4YHVDKpvT7ZFd2vvFWaplAdBLkqwZJyai6FcDLoO8oPFpOgZpOLpa293cEmobGmF3lOhHse+5mviOikcpIs2I/ZpWilPW1goUef1R4A/Oi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010715; c=relaxed/simple;
	bh=T8NuYkAJv4rx9c5ET2RBW3TqxBX9dkY9kXSYw3q0h/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8hFe77vSQqdmILW5kiTw3e6rwoHhzjRmhkivqSEi7M9pOU51h5hqetvLA200+DUwMfnjYnKKOaCiPgigIrDLVuj5i42cBAGvo09nL2H8DtsGG42EB/uInEYlT7hiYqVBckAs711jbP7kU+woIKIYQlpnS8IoPF6PmlNC+X/1jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kIxjcnAT; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kIxjcnAT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784010708; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=NL3u7kA7Y5HxG/BXFSYYsegK37VVkLY7KgH500+VkO4=;
	b=kIxjcnATjrbI32fS8mlUzZDGF/3Ebraga74VONWh9QRbiEWhZfXURtW+3fqy/TExz/jeyLYSmtMXBqwFFQTr3krbQ0j2zeDlj8lbdLrDKPu7LeSsV5C96/MLrzgFxRbbFls3bwFOUi0fB1Tek6eY+4tvvmNxsHa+GbGU2fdBICs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X73IA1K_1784010707;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X73IA1K_1784010707 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 14:31:48 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH e2fsprogs 3/5] e2fsck: flush superblock immediately after orphan cleanup
Date: Tue, 14 Jul 2026 14:31:34 +0800
Message-ID: <20260714063136.1284287-4-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714063136.1284287-1-libaokun@linux.alibaba.com>
References: <20260714063136.1284287-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When e2fsck aborts after processing orphan inodes but before the
final superblock flush, the kernel reports "bad orphan inode" errors
on next mount. This happens when e2fsck encounters fatal errors
(e.g., bad_blocks_file open failures) after orphan cleanup completes.

The root cause is a timing issue in release_orphan_inodes(). For each
orphan it rewrites the inode (updating i_dtime from the next-orphan
pointer to a timestamp, and for a delete also clearing the inode bitmap
and freeing blocks) and zeroes s_last_orphan in memory. The inode
writes go through the io cache and may be written back to disk at any
point as the cache fills during later passes, but the superblock update
(s_last_orphan = 0) is only marked dirty and is not written until the
end of the fsck run. If e2fsck aborts in between, the on-disk inode has
already been rewritten while the on-disk superblock still points to it
via the stale s_last_orphan.

When the kernel mounts such a filesystem, it follows the stale
s_last_orphan pointer and finds an inode whose i_dtime field now
contains a timestamp instead of a valid inode number. The kernel
interprets this as an invalid next-orphan pointer and reports the
error.

Fix this by flushing the superblock and bitmaps via ext2fs_flush()
(which also flushes the io cache) right after a successful orphan
cleanup, keeping on-disk state consistent regardless of what happens
later. We only flush on success; if release_orphan_inodes() fails, the
filesystem is already marked as needing a full fsck.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 e2fsck/super.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 22af1b72684d..e8e4239fc037 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -570,6 +570,17 @@ static int release_orphan_inodes(e2fsck_t ctx)
 
 	ext2fs_free_mem(&block_buf);
 	pctx.errcode = e2fsck_write_all_quotas(ctx);
+	if (pctx.errcode)
+		goto err;
+	/*
+	 * Orphan cleanup is a consistency point: force the superblock and
+	 * bitmaps to disk now.  Otherwise a later abnormal exit could leave
+	 * a stale s_last_orphan on disk while the orphan inodes it points to
+	 * have already been written back, which the kernel rejects as a
+	 * "bad orphan inode".  On error, fall through so the caller marks
+	 * the filesystem as needing a full fsck.
+	 */
+	pctx.errcode = ext2fs_flush(fs);
 	if (pctx.errcode)
 		goto err;
 	return 0;
-- 
2.43.7

