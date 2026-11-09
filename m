Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243116;
	b=XGzmXf1f7aPNOM+aGhW0xI51aLlj1s3whrXgrXLZIflbZ4Rk0Iva/j/sqQ/q8mRcz76g
	 UkMUUbmMsbNSc2BeJAzrS5+qWyQJZ9+GLvy1NKdKo/916IeEX7TxzLBK4EUgAHv+ZCFDL
	 0C0r+1/2Xfkj76L5yhV9DIPHd4jCdi9y64u/tKx95QmzHQaTxOXf0ev1zNnmRzlcQ0Deg
	 Vymn/i4TR5lnClkMSdO6NZXjI+JAhoEvDPnJBgNSsK3215ubaM0o7yqOPHi48Czq59mkj
	 KjEVx7wJHAO+k9NMnx4vR9+oVEkRb4geMQOXrV45zDccnPFzJaBLMsvq+l/NpcogCyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243116;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=YM/eWIWarDTVQ/8neO1uxCR1E4E/AVgij6D7YNJ2pZ0=;
	b=cCbL/6253G07dtj+1jZTUipjNZSReA4N4+xw1/V8bJzRwn3JXYhEPz/0Na1FeEPjjAZN
	 7HHX5kkYw+0tnoTCEckCnGpOFIpm8vRvmtof57Qzv/GpkdmR29adAmRH+0Eh/IlCl12qi
	 7MmBZHJBGKKFLtDl/eKIukFNtD1bb+29QJZ7Nxc2oaXncXb3vxnYzPYaTxIbKdgxJqcHd
	 0bcbc8j2DYhTTijCbqnj1tbDH8Sii6psLkN7PaiRaFVB+mM+Z2s7UyWWp1r4DEv+Z/D98
	 2tPxk9A/C+v0FKhC8erotsvthijV3PAwV2DSlrs8DchRg8wVZ0ivu7gA9UitgrOwXAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dT28sRGB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDFE606A332;
	Mon,  9 Nov 2026 16:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dT28sRGB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B677B1F0089F;
	Mon,  9 Nov 2026 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243115;
	bh=YM/eWIWarDTVQ/8neO1uxCR1E4E/AVgij6D7YNJ2pZ0=;
	h=From:Subject:Date:To:Cc;
	b=dT28sRGBJafHIiMHfAuoVbO3Fh47htkR2Wj9Fev3kYKjmGDeTgRNaPQnsIpLqSBc8
	 f5mCIcJMKGNAq1j7JCTzrCT0tGC3DmyxuMloWSexqDrttYDjGRtKWcRBb5O1S3J/Hz
	 dxLa8xnemS+rHY1oQSeCTHY2nohbzacTbWxwdjzijlGfptjEqJapOV09TlUvTZNIwT
	 AdTlmO4BMkUiwkgWgtljHHMUPvEgoxpZvqHHAu7fvYpTfd9SfUGryFeOI476lO0WPR
	 4KZ7ORlew3Kq6HdnC+79VDT9HripL4OGZZ0qqen4bRuT+wBVkgzzkb3H5gHsQn/Hyj
	 01885al/OKsfA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC v3 00/14] fs: reclaim inodes with I_METADATA_WRITEBACK
Date: Mon, 09 Nov 2026 17:51:15 +0100
Message-Id: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42OQU7DMBBFr1J5jSPHSVyHVaVKHIAtQmhiD41Ja
 6OxSVtVuTuxWSDEApb/a+a9f2MRyWFk95sbI5xddMGvobnbMDOCPyB3ds1MCqlqIXt+DjRx54N
 FfsIEFhK8nMklHMBM3GotQLSyx7ZnK+Od8NVdCv+JPT7s2fNXGT+GNzQpk/PZABH5QODNmKvsq
 Iqj+u2o8nF+Gl1Mga5l+lwXwz9XzjUXfGuVUVsNne7sbkLyeKwCHcrCWX7jatH9hZMrrtVKaqO
 EaRr1A7csyyeOl0E/ZgEAAA==
X-Change-ID: 20261029-work-inode-metadata_writeback-d880a0429e49
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5265; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rVdLYDpXrFqy7gxyWrRksjyNClYacW5ej+Z/tpHlsi8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CXC8uD6ozu6u5bNerRkj+7P0I1tfcfmTeoKfX227
 2jlea/TKztKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAmMl2R4Z9dlrGFzYeKBtZP
 7yrqozMcBR+y9L03mJVe0f/m0ZTkR0sY/ll92n3F9v7W222GBfoOYdHhzzIi3C+6hiY7LZot3+E
 zhwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since v7.3 ext2, ext4 without a journal, fat, udf and minix set
I_METADATA_WRITEBACK when they copy an inode into its buffer and only
fsync() and friends clear it again.

inode_lru_isolate() treats it like any other state bit and takes the
inode off the LRU, expecting something to put it back once the bit is
gone. Nothing ever does. So these inodes can't be reclaimed until
something fsyncs them or the filesystem is unmounted. That's a DoS.

On ext4 without a journal an atime update is enough to pin an inode, and
creating 60000 small files in a memory cgroup limited to 96M gets the
task OOM killed after about 43000 of them.

The original provided fix was quite ugly. It handed such inodes from
inode_lru_isolate() to a per-sb work item with a reference held, synced
them there and put them back on the LRU. We've had discussions in that
direction for unrelated reasons and we found that quite terrible. It's a
second inode reclaim offload mechanism next to Jan's deferred inode
reclaim, it needs a new inode state bit, and the reference shows up in
everything that looks for open deleted files.

So instead, let the shrinker reclaim these inodes like any other clean
inode and make evict() write out what I_METADATA_WRITEBACK tracks
unless the inode is being deleted.

The first seven patches make ->sync_inode_metadata() of ext2, ext4,
minix and udf look the inode block up in the buffer cache instead of
reading it from disk, the way fat already does, so that calling it from
reclaim is fine. The eighth sets I_METADATA_WRITEBACK from
mmb_mark_buffer_dirty() so that the bit covers the tracked metadata
buffers as well. The ninth is the actual fix. The last five drop the
mmb_sync() calls from ->evict_inode() that evict() makes redundant.

This still writes and waits from reclaim if the inode block is still
dirty. Once Jan's deferred inode reclaim lands these inodes can go to
his workers instead. I have that on top of his v3 (cf. [1]).

All of this is meant for v7.3 stable. v7.3 still has bfs which sets
I_METADATA_WRITEBACK as well, so the backport needs the cache-only
lookup for bfs too.

Tested on 65ba8f34ec88 with KASAN and lockdep: creating 5000 files,
sync(2) and two drop_caches leave about 5000 of 5000 inodes around on
ext2, ext4, vfat and minix without this series and none with it. The
memory cgroup run creates all 60000 files and nothing gets killed.
Blocks the flusher left dirty get written out on eviction on all five
filesystems. No splats.

udf inodes with their data in the ICB are still dirty after sync(2),
with and without this series. That's a separate issue I didn't care
about.

[1]: https://patch.msgid.link/20261029-work-inode-metadata_writeback-deferred-v1-1-7e49f6c12b60@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v3:
- Set I_METADATA_WRITEBACK from mmb_mark_buffer_dirty() and write out
  what it tracks from evict() again instead of from every
  ->evict_inode() (Jan).
- Drop the mmb_sync() calls from the ->evict_inode() of ext2, ext4,
  minix, udf and fat.
- Jan's Reviewed-by on the fix isn't carried over since the patch
  changed.
- Link to v2: https://patch.msgid.link/20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org

Changes in v2:
- Drop the ext4_inode_loc_block() helper and use
  ext4_get_inode_loc_noio() with the sleeping buffer lookup instead
  (Jan).
- Write out what I_METADATA_WRITEBACK tracks from ->evict_inode() of
  each filesystem instead of from evict() (Jan).
- Drop "fat: sync the inode in fat_free_eofblocks()" (Jan, OGAWA).
- Move the reproducer out of the commit message.
- Link to v1: https://patch.msgid.link/20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org

---
Christian Brauner (14):
      ext2: add ext2_inode_block() helper
      ext2: don't read the inode block in ext2_sync_inode_metadata()
      ext4: use sb_find_get_block_nonatomic() in ext4_get_inode_loc_noio()
      ext4: don't read the inode block in ext4_sync_inode_metadata()
      minix: add minix_inode_block() helper
      minix: don't read the inode block in minix_sync_inode_metadata()
      udf: don't allocate the inode block in udf_sync_inode_metadata()
      fs: set I_METADATA_WRITEBACK in mmb_mark_buffer_dirty()
      fs: don't strand I_METADATA_WRITEBACK inodes outside the LRU
      ext2: drop mmb_sync() from ext2_evict_inode()
      ext4: drop mmb_sync() from ext4_evict_inode()
      minix: drop mmb_sync() from minix_evict_inode()
      udf: drop mmb_sync() from udf_evict_inode()
      fat: drop mmb_sync() from fat_evict_inode()

 fs/buffer.c       | 16 ++++++++++++--
 fs/ext2/inode.c   | 63 +++++++++++++++++++++++++++++++++----------------------
 fs/ext4/inode.c   | 22 +++++++++----------
 fs/fat/inode.c    |  1 -
 fs/inode.c        | 13 +++++++++++-
 fs/minix/bitmap.c | 37 +++++++++++++++++++-------------
 fs/minix/inode.c  | 18 +++++++---------
 fs/minix/minix.h  |  1 +
 fs/udf/inode.c    | 33 +++++++++++++----------------
 9 files changed, 121 insertions(+), 83 deletions(-)
---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261029-work-inode-metadata_writeback-d880a0429e49

