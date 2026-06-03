Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F38C2BEC34
	for <linux-ext4@vger.kernel.org>; Wed,  3 Jun 2026 13:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780494493; cv=none; b=iv02Azht8SEyNvczbqGufAXm4JUh0YKNwXn3nmH/sou5/tZw8X1C60hgAQ+nMiE49cQu0QiqFJOJ/eGn7BRt84ODrOguwplx/WgNeQHTbBCzH9c28kWNvqx+M2ND4DLS2L82mgKhaF7URQJs5yBxR6BACasJsLyTXwupvM8Xuuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780494493; c=relaxed/simple;
	bh=wEOJcVpjyFiVUjgJyE7Cj+C8g1DjRY2YKiOUM+50wZk=;
	h=Date:Message-Id:From:Content-Type:Cc:Subject:To:Mime-Version; b=BmCrOgEaPHiQqtQKk6+DrBsj76dIwaACQ/dtQzym+6+QUOpYSlGJZxVHDqAIltfuY2nsP+ynLUI002eaXvAMZ/qow9D2DUXnYdL+uCIIND/Xaul4r2SGFLzAKphYaFMe0GY+PaWO7bloQi35/bAJ9/rCOuWARZV92qGk3aN2qr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=oUWn3UzE; arc=none smtp.client-ip=209.127.231.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="oUWn3UzE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780494486; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=dTq2eSzLL9MVyOjpbPIs+8U7SVs8q0XHegyBH6VBzzU=;
 b=oUWn3UzEMapdjTYstDaGbrsd9GNovJ71IiyU32G2xuzSdaqnR9Kgh+6m3fetu1OGXCsM1W
 XV6ROUXYHKzN/qtdWd80/1H/N9Ir5GHQ/Lbe3jVxA5cHdctElMITGz8nX1+TamVE29jBmm
 ETbajs04wTYN2Q5BPb0LNPfYuFzR7kkX2I+DkG5i5aU0+ioQr8pz4KvBDhJP9aj7tMPHWM
 5bw4aq9UsyLZkVvHgH0yz6+/La300w1ZRlKsKUGZOwRLhY0wEmVAeE4mhm9W0u971YqOgq
 3d0grKtkGX8WlD57FNy5UqqcMiqa7aV31SA0Ou+DDaOX/I0zpt+Q1BiJTpl6hQ==
Date: Wed,  3 Jun 2026 21:48:00 +0800
Message-Id: <20260603134800.25155-1-zhujia.zj@bytedance.com>
X-Original-From: Jia Zhu <zhujia.zj@bytedance.com>
From: "Jia Zhu" <zhujia.zj@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, 
	"Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, 
	"Baokun Li" <libaokun@linux.alibaba.com>, 
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani" <ritesh.list@gmail.com>, 
	"Zhang Yi" <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Jia Zhu" <zhujia.zj@bytedance.com>
Subject: [PATCH] ext4: avoid full buffer walks for large folio partial writes
To: "Theodore Ts'o" <tytso@mit.edu>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a203094+b9d570+vger.kernel.org+zhujia.zj@bytedance.com>
Content-Transfer-Encoding: 7bit

Ext4 buffered writes into large folios still walk every buffer_head in the
folio in ext4_block_write_begin() and again in block_commit_write(). Before
regular files used large folios this was cheap, but a large folio can
contain hundreds of buffer_heads. Small overwrites of an existing large
folio therefore pay work proportional to the folio size instead of the
write size.

This is visible when the page cache is first populated with large folios
and then a small range is overwritten. The numbers below come from a local
libMicro-based microbenchmark. Each round first drops caches, writes a
10 MiB file with dd to instantiate large page-cache folios, and then runs
libMicro's write, pwrite, or writev benchmark for a small buffered
overwrite. The writev cases use libMicro's default vector count of 10.

A representative pwrite round is:

	sync
	echo 3 > /proc/sys/vm/drop_caches
	dd if=/dev/zero of=$file bs=1024k count=10
	taskset -c 0 ./bin/pwrite -H -C 50 -D 3 -S -N pwrite_u1k \
		-s 1k -f $file

To avoid comparing this change with an older kernel, the benchmark uses two
kernels built from the same master tree: one with this change and one with
only this change reverted. With THP=always and 10 dd-prefill rounds, median
latencies were:

			nofix		patched		improvement
	write_u1k	1.418 usec	0.342 usec	75.9%
	write_u10k	1.887 usec	0.409 usec	78.3%
	write_u100k	4.114 usec	2.554 usec	37.9%
	pwrite_u1k	1.677 usec	0.335 usec	80.1%
	pwrite_u10k	1.903 usec	0.410 usec	78.5%
	pwrite_u100k	4.101 usec	2.563 usec	37.5%
	writev_u1k	2.285 usec	0.756 usec	66.9%
	writev_u10k	4.655 usec	3.025 usec	35.0%

Start the ext4 write_begin walk at the first buffer that overlaps the
write. For already-uptodate large folio overwrites, add a partial commit
path which marks only the written buffers uptodate and dirty. Leave
non-uptodate folios on the old full-buffer commit path so BH_New cleanup
and folio-uptodate discovery are preserved.

Partially uptodate large folios remain described by per-buffer state, which
is what block_is_partially_uptodate() and read_folio use for later reads.

Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
---
 fs/buffer.c     | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c | 21 ++++++++++----------
 2 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496e..e0c5868b088be 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2092,6 +2092,44 @@ int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
 }
 EXPORT_SYMBOL(__block_write_begin);
 
+static struct buffer_head *folio_buffer_seek(struct buffer_head *head,
+					     unsigned int blocksize,
+					     size_t offset,
+					     size_t *block_start)
+{
+	size_t nr = offset / blocksize;
+
+	*block_start = nr * blocksize;
+	while (nr--)
+		head = head->b_this_page;
+	return head;
+}
+
+static void block_commit_write_range(struct buffer_head *head,
+				     unsigned int blocksize, size_t from,
+				     size_t to)
+{
+	size_t block_start, block_end;
+	struct buffer_head *bh;
+
+	if (from == to)
+		return;
+	if (WARN_ON_ONCE(to > folio_size(head->b_folio)))
+		return;
+
+	bh = folio_buffer_seek(head, blocksize, from, &block_start);
+	do {
+		block_end = block_start + blocksize;
+		set_buffer_uptodate(bh);
+		mark_buffer_dirty(bh);
+		if (buffer_new(bh))
+			clear_buffer_new(bh);
+
+		block_start = block_end;
+		bh = bh->b_this_page;
+	} while (block_start < to && bh != head);
+}
+
 void block_commit_write(struct folio *folio, size_t from, size_t to)
 {
 	size_t block_start, block_end;
@@ -2104,6 +2142,19 @@ void block_commit_write(struct folio *folio, size_t from, size_t to)
 		return;
 	blocksize = bh->b_size;
 
+	/*
+	 * Large folios can carry hundreds of buffer_heads.  For partial writes,
+	 * keep commit work local to the written range; partially uptodate
+	 * reads remain governed by the buffer state.
+	 */
+	if (folio_test_large(folio) && from < to &&
+	    folio_test_uptodate(folio) &&
+	    to <= folio_size(folio) &&
+	    (from != 0 || to != folio_size(folio))) {
+		block_commit_write_range(head, blocksize, from, to);
+		return;
+	}
+
 	block_start = 0;
 	do {
 		block_end = block_start + blocksize;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d1..e58bba0289eba 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1180,7 +1180,7 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 	unsigned int blocksize = i_blocksize(inode);
 	struct buffer_head *bh, *head, *wait[2];
 	int nr_wait = 0;
-	int i;
+	unsigned int i;
 	bool should_journal_data = ext4_should_journal_data(inode);
 
 	BUG_ON(!folio_test_locked(folio));
@@ -1191,17 +1191,18 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 	head = folio_buffers(folio);
 	if (!head)
 		head = create_empty_buffers(folio, blocksize, 0);
-	block = EXT4_PG_TO_LBLK(inode, folio->index);
+	if (from == to)
+		return 0;
+	block_start = round_down(from, blocksize);
+	block = EXT4_PG_TO_LBLK(inode, folio->index) +
+		(block_start >> inode->i_blkbits);
+	bh = head;
+	for (i = 0; i < block_start; i += blocksize)
+		bh = bh->b_this_page;
 
-	for (bh = head, block_start = 0; bh != head || !block_start;
-	    block++, block_start = block_end, bh = bh->b_this_page) {
+	for (; block_start < to;
+	     block++, block_start = block_end, bh = bh->b_this_page) {
 		block_end = block_start + blocksize;
-		if (block_end <= from || block_start >= to) {
-			if (folio_test_uptodate(folio)) {
-				set_buffer_uptodate(bh);
-			}
-			continue;
-		}
 		if (WARN_ON_ONCE(buffer_new(bh)))
 			clear_buffer_new(bh);
 		if (!buffer_mapped(bh)) {

base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
-- 
2.39.5 (Apple Git-154)
