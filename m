Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243147;
	b=Bwcwj/FX25XIYXGZtBbVXDfHVdF9SkcCV7d++Q5LrRdV5W12Q34q/s1i0iIUC3qlZu4C
	 UAVybNOTjB4luPFDbv8ebjDBGmZ6aj0T5CEv/9IZB88gbxNM9UyhtNElOypw39ol0GUjm
	 m5fbfc6CgbsItskLrtuVbT7pGkACAuEcMFXtdNksd6839ddL3A0hwTI9PBiH/9tnVI3PZ
	 rKJGEvy3mFpdkqGsCSvr4/K5QDklhWu5eul6T9IQqeg0Q+y26jztwp/EXuKZbwAY9q9Cz
	 YvF2OtESbo5JvPKev+FuUjGW5/JMdYNHmbBLS1oCl9Z0R2ogZf/CJeGSleIrPC7CagA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243147;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=zLH4QKXddQ3PclwzGKt2MypDy/RV4BppD4h97Ydd0V0=;
	b=uiQj/fpG8vpQGI3TMGe75DMkcEoPzUO1H4TUtf+3eLmLcjLwFSZKnyDcs3EpzZn/1FpK
	 TsnwlMRQi8O+ms8xb5IPdM6axzhh1aXwyIP59I/e5kYWC7+MK37f1kc8x14MLqAMS5U68
	 Z6Kgc3lzZBDW8JsdG4DzPSn4REYQC8oMwenhNGPpc2ZPre8vXypnagGOcvzg8gKfY126l
	 5vdBlZgjlFYwGPV/Ib0Ne9IQ6wZOWnX4Q0pMV2Y1zyd4b9LKBqrRfYweYbjnWcf7rI9ND
	 KwcdsyVyp/k9/YKN2QhQTindVFFTuwrFX2hk90lceLFQrR2OkMREc101cn+d6JY8QtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="NLBr/lqH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D8060A3838;
	Mon,  9 Nov 2026 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NLBr/lqH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74091F008A5;
	Mon,  9 Nov 2026 16:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243146;
	bh=zLH4QKXddQ3PclwzGKt2MypDy/RV4BppD4h97Ydd0V0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NLBr/lqHzDwHBZwdkQYQTv5SZI9MDm1lb3sH4h3W6TsRn84GvzsqP3YOWEq+rj7pz
	 aOwDBkhFPmww/EMskWuLByuz8Fkh4/9wqrNQNg9sZwWGK18T/+PDZFvEUYreFux7TD
	 j8kvXO1CvVZmB9+t6K49HS1b6q95gWRQoEVWtRipN5qwxZ99rSPVGe16qRUaEd2qwF
	 +HO/LpI4DivW4lqh9slU2UITlltLIR6GvDbHLGxujNWFWj5r3eD2S/ONuNo5Rcvn7a
	 cVxdopaXA7+rLctXkKPzHHdI8gv+12khyP6smzqXIDACQAjGUWpn47ONYmAalhpArL
	 IveQTGIHcFOsw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:24 +0100
Subject: [PATCH RFC v3 09/14] fs: don't strand I_METADATA_WRITEBACK inodes
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-9-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4176; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/5Yqud61+lj78SWSAuygp0D8ojyhugiflBGlrR92oMM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CX/VLR9xneL7MosFcfLnAmN6xi95kf7//qguklAR
 /MG149VHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPxOcrI8FPqkt3ev8Eej7sm
 pp+6cv3yzujcOcx+O+3XM0S0BkceNGL475shXPl8e9d6eUeulotid7mmSlecfnLvsPDLpTcmuSa
 wcQEA
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
written out. So let the shrinker reclaim inodes with
I_METADATA_WRITEBACK like any other clean inode and make evict() write
out what the bit tracks unless the inode is being deleted. Since the
previous patch the bit covers the tracked metadata buffers as well, and
since the lookup patches ->sync_inode_metadata() doesn't read anything
from disk for that. It writes and waits for whatever is still dirty or
under writeback. The mmb_sync() calls in ->evict_inode() are redundant
with that and the following patches drop them.

Handing these inodes to a work item that syncs them and puts them back
on the LRU would work too. But that's a second inode reclaim offload
mechanism next to the deferred inode reclaim that is being worked on,
and it needs a reference on the inode which leaks into remount, freeze
and umount.

For stable this needs the previous patches as well. Without the lookup
changes evict() ends up reading inode blocks from disk with
__GFP_NOFAIL allocations from reclaim. v7.3 also still has bfs which
sets I_METADATA_WRITEBACK too and reads the inode block in
bfs_sync_inode_metadata(), so the backport needs the cache-only lookup
for bfs as well.

Fixes: c474bc56b6d1 ("fs: Provide way for filesystem to wait for metadata writeback")
Cc: stable@vger.kernel.org # v7.3; see patch description
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/inode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 1cb6293b237a..332108961df6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -818,6 +818,14 @@ static void evict(struct inode *inode)
 	inode_wait_for_writeback(inode);
 	spin_unlock(&inode->i_lock);
 
+	/*
+	 * fsync() can't find what I_METADATA_WRITEBACK tracks anymore once the
+	 * inode is gone, so write it out unless the inode is being deleted.
+	 */
+	if (inode->i_nlink &&
+	    (inode_state_read_once(inode) & I_METADATA_WRITEBACK))
+		sync_inode_metadata(inode, 1);
+
 	if (op->evict_inode) {
 		op->evict_inode(inode);
 	} else {
@@ -947,9 +955,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	 * they're already on the LRU, and this can make them
 	 * unreclaimable for a while. Remove them lazily here; iput,
 	 * sync, or the last page cache deletion will requeue them.
+	 * Nothing requeues them for I_METADATA_WRITEBACK, evict() writes
+	 * that out instead.
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

