Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882575;
	b=A6OHSKqWvPdvA32Xd9RTYkydhRMy3/4gw81sIbRQOOG5USnxJY2Q7RqaR38UMZ/FmAwK
	 G8kXr/BGJtoOMmOa7c6L7XXPktLjODx33dtY/4/25AJIcm984z1exUkV4k8cXpdFYOHQw
	 i8sphetVl7YH5nCZCFtqyKmFEGHHrh8d0zwL7FfDzw98x9G+CW4dL+6EKhLTwo6pqLREm
	 DcnyLPUBcb7KgKqZsrPt5sC7IGxPC9bUefh6fG/AlQAqzcR417wM/DIkNCS4ysN/6ujPa
	 H8UTfWvm3iQt2m1xrlOF7Cil7JvkZx4UOxsU7q2MomgauPKlzhz4wo9kEewhvJYipmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882575;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=K6Ri0qtC2TZ+UbqKoC8MWHbiIEXXv5E3r5euD3d+bfc=;
	b=E9Og6S24CL2q+3Ucem+GoLje3fL8v1j3aNF6V/Mg4m+GUJeyw+SM4Al36AFFtXO7KD8D
	 2PutJrq1VYB51fRNRhHFK/hTeGcMpDNbWiAHE2J2jnkZomqY5k2fIlpzUUKg+7Grext+U
	 ympmD3Kz6FF0GLKquf9cjaI11uwIkZs7MwK1PcU1lbM4qJ/te6dvbI2w8cTRyGPNymM8O
	 YkSLIrFaxlzt8T7BVBEt8IzHXwJJsNnK8ZiYwI3AV0DElGJOPsYfHu4kKpgGyEX2qKXj3
	 YCY0z3WHzUGKzghrMFm1YZTeo3YzgsgJJyWgXzGKPNFjBcb0llGlsnguy30nfH0CdDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPbNOgcP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD73F6082BCB;
	Thu,  5 Nov 2026 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPbNOgcP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEBA1F00919;
	Thu,  5 Nov 2026 12:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882574;
	bh=K6Ri0qtC2TZ+UbqKoC8MWHbiIEXXv5E3r5euD3d+bfc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JPbNOgcPBP/qB6nddtqmjVkTczKfNhewVbDkinZN/95DHFm8W9g7a11Iq7dy7slBO
	 qfA21AVfLrfs4cQh63236A2VrJikBVEEC6+12GjxC098/+K/cZg1+qzm8eliRjOtTi
	 1/596GlYrx0HRXtxE/dnKEMZiwPkSRKomjcbSPS39OtropweSFqAIO4oEOQDjWIRBf
	 s4sUgDV2mrZsz3QzM9C5yOIfyvUX8LEMZD40VUce4V7AeX4Nec6lN/hGjuQNyOyezs
	 uQKEqXMTOl8AVpozo1+7SKscliZdbVcg7liNiUYJSYSyNpvc4w8JGA2QfSxlfF+57M
	 UqUBGstaHV1CQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:42 +0100
Subject: [PATCH RFC v2 13/13] fs: don't strand I_METADATA_WRITEBACK inodes
 outside the LRU
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-work-inode-metadata_writeback-v2-13-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Namjae Jeon <namjae.jeon@samsung.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3745; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ScKcfHJ2kOm//RjTYsJCJLY94DE/ixNL/682C0B0WlQ=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGrseZ+jHtSaGG30E14lZkXr/DY8DALKS340bB6W282vGe9Zu
 4h1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmrseZ8ACgkQkcYbwGV43KLUqQEAkReq
 hfjjihoz5lexyrz6KswBfzuJtQv02W37FTagNUUA/0FYGztI+3JLiYQVL3RbGBdIaifY/2jGu6a
 tOvfi1dQD
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since commit c474bc56b6d1 ("fs: Provide way for filesystem to wait for
metadata writeback") ext2, ext4 without a journal, fat, udf and minix
set I_METADATA_WRITEBACK on an inode whose metadata was copied into a
buffer that might not have reached the disk yet. Only data integrity
writeback, i.e. fsync() and friends, clears it again. The flusher and
sync(2) leave it alone.

inode_lru_isolate() treats every state bit other than I_REFERENCED as a
reason not to reclaim the inode right now. It takes the inode off the
LRU and relies on iput(), writeback completion or the removal of the
last page from the page cache to put it back once the reason is gone.

But I_METADATA_WRITEBACK doesn't go away on its own. iput() puts the
inode back on the LRU with the bit still set and the next scan takes it
off again. So neither memory pressure nor drop_caches can free these
inodes. Only fsync() and friends or unmounting the filesystem get rid
of them.

On ext4 without a journal ext4_mark_iloc_dirty() sets the bit on every
ext4_mark_inode_dirty(), so even an atime update is enough. An
unprivileged user creating or touching lots of files grows the inode
cache without bound until the OOM killer comes along.

The inode can't just be thrown away though. An fsync() after the inode
was read back in wouldn't know that its metadata still has to be
written out. But that's no different from the metadata buffers these
filesystems track in their mapping_metadata_bhs. Their ->evict_inode()
calls mmb_sync() and that is what allowed commit 972b9dd4e418 ("fs:
Ignore inode metadata buffers in inode_lru_isolate()") to take those
buffers out of inode_lru_isolate(). With the previous patches
->evict_inode() writes out what I_METADATA_WRITEBACK tracks the same
way, without reading anything from disk.

So let the shrinker reclaim inodes with I_METADATA_WRITEBACK like any
other clean inode.

Handing these inodes to a work item that syncs them and puts them back
on the LRU would work too. But that's a second inode reclaim offload
mechanism next to the deferred inode reclaim that is being worked on,
and it needs a reference on the inode which leaks into remount, freeze
and umount.

For stable this needs the previous patches as well. Without the
->evict_inode() changes an fsync() after the inode was read back in
misses the inode block. Without the lookup changes ->evict_inode() reads
inode blocks from disk with __GFP_NOFAIL allocations from reclaim. v7.3
also still has bfs which sets I_METADATA_WRITEBACK too, so the backport
needs the same two changes for bfs.

Fixes: c474bc56b6d1 ("fs: Provide way for filesystem to wait for metadata writeback")
Cc: stable@vger.kernel.org # v7.3; see patch description
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 1cb6293b237a..16ebd686d681 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -947,9 +947,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	 * they're already on the LRU, and this can make them
 	 * unreclaimable for a while. Remove them lazily here; iput,
 	 * sync, or the last page cache deletion will requeue them.
+	 * Nothing requeues them for I_METADATA_WRITEBACK, ->evict_inode()
+	 * writes that out instead.
 	 */
 	if (icount_read(inode) ||
-	    (inode_state_read(inode) & ~I_REFERENCED) ||
+	    (inode_state_read(inode) &
+	     ~(I_REFERENCED | I_METADATA_WRITEBACK)) ||
 	    !mapping_shrinkable(&inode->i_data)) {
 		list_lru_isolate(lru, &inode->i_lru);
 		spin_unlock(&inode->i_lock);

-- 
2.53.0

