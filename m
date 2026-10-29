Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280549;
	b=jOAEASAqDzd8J5KBVGJ7DNKFqhbbJ3lkdSBNOa/psALXGI7+AyEDNMmq3bPvoUF/F/dp
	 L8YiH9g3INnDbFiVgctGYbFttEoDNLxLRibyWU5wPALHmJLKI9glkuNT4W5sEt95mJkfF
	 5iNKmWFzIn3ujy2r/6FpntO+wJ0uhuOdeYsxz3MAbZnw8GnZJwZrpXMoDY37DatohKrle
	 duWBOOFFxo2yQb/dfKuWeiMxWyFJr1jxxhxmiSGwLuH6Dp0A+ILMZOWDsSJ6NE9lJFXKd
	 /h9GH/xUV6AWfmYemQSxW+onzyVtzzHOH/mOk5DOxIMUNrD/7cDAqwFIJI3Pe74UyVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280549;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=NP04BR1GJ8ygGDyruDPeAC2QW69LLEwufPTA7Qc63bI=;
	b=PgVB7XVO1SoFqrNkOjMBznXHNHBATR/rLy6kid3COW+HfhXGQj6JpJaDMxiGJt4oNzXu
	 Fvj1IoM+YLShFO2RpOGEWzkLxb7PpvWcXVuElH9FbFktLnb7XMLHc+15OvHerluZhBCRO
	 W29WO0U8PnSyebABW29QLQe6W8wWvb4SlS/t2pWbfRWwmIuPtXOiLTYOrPuAyb08ikmmL
	 1zaACGrd1I1cbHhHu6fMejV25UnPyNYF6q8GbqRGD/AzcAf7gJDfAbdCJ0vEtNIkdAcEN
	 JrIOUGp/tFsqxq8aQ/MluObLn0hcFnZvhRuiuVlILS3sK7nQYtPxuDjeanf9XgpNqEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMLpe3mR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD3E606A327;
	Thu, 29 Oct 2026 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMLpe3mR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757971F031E1;
	Thu, 29 Oct 2026 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280548;
	bh=NP04BR1GJ8ygGDyruDPeAC2QW69LLEwufPTA7Qc63bI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TMLpe3mRdpN9qBDmyG+htSTlbMHha6wK6OkriiIhLAhfzD0RbDbfmSkuMGXR9i1T5
	 /K1/jI54KAYa8grbAX5ijgv4hUSw+A0CbnIScytmPJD9MH6Xvtw1YpoGirIyXWcQUP
	 cnTFP+iz359XrImhLOHKMhBMTeeD4uDDaIA66Lp8jeSIH0PN564scbgDbMZLsMNP5A
	 S/qECtF0Z3DzKAVs/FRTvOO2dWtFuNi8OsSMBmcWdOlE8BEPNwhRya2CyUN/V9ftDe
	 kvVee7e5Wbcpa9p5fVwPNZIxmzzf+b7BQ+3vklKOjid3lWR2ZA2EPXIW6TkfvscQ22
	 35uwxmewBvpVQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:24 +0100
Subject: [PATCH RFC 9/9] fs: don't strand I_METADATA_WRITEBACK inodes
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
Message-Id: <20261029-work-inode-metadata_writeback-v1-9-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6114; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HF3IO4YNDu90CT+WFm2qeiEm8Y9cWwS2PSF9fQe5QtE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vzvoX5sjutMzV+1JRUJ00+YHO7dXOr+LvnDmWePv
 7Of2NbM0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR+FuMDNt7JOpyvbZ5tuw1
 Ku2SN1pj+OXQVb4vK7423zuTcEPGcDcjwwdRyaQDsfZqH7e0e54/z/YsYH7YmlvTZqm77nf288j
 fygUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since commit c474bc56b6d1 ("fs: Provide way for filesystem to wait for
metadata writeback") ext2, ext4 without a journal, fat, udf and minix
set I_METADATA_WRITEBACK on an inode whose metadata was copied into a
buffer that might not have reached the disk yet. Only data integrity
writeback, i.e. fsync() and friends, clears it again. The flusher and
sync(2) leave it alone. So a clean, unused inode keeps the bit around.

inode_lru_isolate() treats every state bit other than I_REFERENCED as a
reason not to reclaim the inode right now. It takes the inode off the
LRU and relies on iput(), writeback completion or the removal of the
last page from the page cache to put it back once the reason is gone.

But I_METADATA_WRITEBACK doesn't go away on its own. Using the inode
again puts it back on the LRU with the bit still set and the next scan
takes it off again. So neither memory pressure nor drop_caches can free
these inodes. Only fsync() and friends or unmounting the filesystem get
rid of them.

On ext4 without a journal this is especially bad because
ext4_mark_iloc_dirty() sets the bit on every ext4_mark_inode_dirty().
So even an atime update is enough. An unprivileged user creating or
touching lots of files grows the inode cache without bound until the
OOM killer comes along.

The inode can't just be thrown away though. An fsync() after the inode
was read back in wouldn't know that its metadata still has to be
written out. But writing it out on eviction is exactly what these
filesystems already do for the metadata buffers they track in their
mapping_metadata_bhs.

ext2, ext4, fat, udf and minix all call mmb_sync() from ->evict_inode()
and that is what allowed commit 972b9dd4e418 ("fs: Ignore inode metadata
buffers in inode_lru_isolate()") to take metadata buffers out of
inode_lru_isolate().

So let the shrinker reclaim inodes with I_METADATA_WRITEBACK like any
other clean inode and make evict() call sync_inode_metadata() for them
unless they are being deleted. With the previous patches
->sync_inode_metadata() doesn't read anything from disk anymore. It
writes and waits for whatever is still dirty or under writeback and
usually the flusher has long taken care of that by the time an unused
inode reaches the end of the LRU.

Handing these inodes to a work item that syncs them and puts them back
on the LRU would work too. But it would be a second inode reclaim
offload mechanism next to the deferred inode reclaim that is being
worked on, and it needs to hold a reference on the inode which leaks
into remount, freeze and umount.

For stable this needs the previous patches as well. Without them
evict() ends up reading inode blocks from disk with __GFP_NOFAIL
allocations from reclaim. v7.3 also still has bfs. It sets
I_METADATA_WRITEBACK too and bfs_sync_inode_metadata() reads the inode
block with sb_bread(). So the v7.3 backport needs to switch bfs over to
sb_find_get_block_nonatomic() as well.

Reproducer, one filesystem at a time:

  #!/bin/bash
  # usage: <ext2|ext4|vfat|minix|udf> <dev>
  fs=$1 dev=$2 n=5000
  case $fs in
  ext2)  mkfs.ext2 -q -F $dev ;;
  ext4)  mkfs.ext4 -q -F -O ^has_journal $dev ;;
  vfat)  mkfs.vfat $dev ;;
  minix) mkfs.minix -3 $dev ;;
  udf)   mkudffs --media-type=hd $dev ;;
  esac
  mount -t $fs $dev /mnt && mkdir /mnt/d && sync
  echo 3 > /proc/sys/vm/drop_caches
  before=$(cut -f1 /proc/sys/fs/inode-nr)
  for ((i = 0; i < n; i++)); do echo x > /mnt/d/f$i; done
  sync
  echo 3 > /proc/sys/vm/drop_caches
  echo 3 > /proc/sys/vm/drop_caches
  echo "$fs: $(( $(cut -f1 /proc/sys/fs/inode-nr) - before )) of $n inodes left"
  umount /mnt

On v7.3-17318-g65ba8f34ec88 in a KASAN and lockdep vng guest with brd
devices:

             without   with this series
    ext2       5001     1
    ext4       4944     0
    vfat       5001     0
    minix      4999     0
    udf        4992     4992

udf needs the flusher to come by first. Its inodes with the data in the
ICB are still dirty after sync(2), with or without this series. When
drop_caches runs after the flusher wrote them 453 of 500 udf inodes stay
without this series and none with it.

And creating 60000 files from a task in a memory cgroup with
memory.max=96M and a sync every 2000 files gets the task OOM killed
after 55524 files on ext2 and after 43222 files on ext4 without a
journal. With this series all 60000 files get created and nothing is
killed.

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

