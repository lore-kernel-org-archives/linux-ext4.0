Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882533;
	b=ziE7gzg36hRt2LjFogYQIk07cnmjV3VmR8cGGsPqAQYRZtztJBnzN2Zxc4wk9Mf3qkPf
	 LPyIXuuhNd4+RinCqzDnnR8D0umd+y8/iIJRu4EFBZMreoL1VjueobBXDvzq9HoSpIjJt
	 kxDNdkz2bYabDz6BHi+6Ha5tEMnygeFie2ogcIu4XoKDGs2z9Aq4o8igMgZFdLeJJCrM8
	 Uqhu8rg/EiuMaEUPPOSat0hW0tMT4i+D6b/7/s1OLpuWreXNtOXEDPkWWMamBgpYNuQUk
	 z3ATY1f+dZYOFFPjaKDDiUAQ0GdXggZCClwIZLMO2XPYXpMY1zUKSGRlCNgPRt4zB1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882533;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=nM5hBUgmQ4tb8GHjcirsDkjY00WoXR5OB1egkzqMA+o=;
	b=BFBi5G1S21GrbyXt4ARxULNio3QfvN1n+TVkAwW5pRRT2KoZJZh1+A722cIlq57xVX0i
	 Ev0Bq2IHGqUaAQtAIwzAdqW7xG5h+g0BuzX0rn4uQ4wUxtLZQ/3L1l6IkiubS8phHqDdA
	 mwVu3m0irct8UYzLUH3zoB1+LUXWfKbx1/P8rnYYAZk7mb44R4Na+Pmi1Quo3cn+veusy
	 Kfzx014J+7k2Ll4kGmuhqPcy7SlBqCMUoo6Pd5M6I4TVqfipjO5JBH9x4rYmD0OjnZHN8
	 VueWT3AxZGzpf8aUrVkSB2Xb0twrPZfiCIP3Q5lsdgFeavpjrDaMSS/TYv0qTag2qyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kMkWivCV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D2606D81C;
	Thu,  5 Nov 2026 12:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kMkWivCV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7258D1F00A18;
	Thu,  5 Nov 2026 12:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882533;
	bh=nM5hBUgmQ4tb8GHjcirsDkjY00WoXR5OB1egkzqMA+o=;
	h=From:Subject:Date:To:Cc;
	b=kMkWivCVf96kVot7zp354BO7seU76SVT2ZIl/SyYyOYQwNjebRrrIy0jejACeFL/E
	 YSz5rrS2qRDPHDSporYYpE7VCOaSEKk4DNJVUo0oxzfI5mfGRa5AN0i4mQvQOS/ihm
	 eO3msGIqKvINQgZh13D+cZuaYnftHs6MSR3Gl3yMPSdsZvfu+Y2gDNGYgTKn6tCG+W
	 R1N1WOYIitHEjDksF6WJBvYugBccxq7MTBXpEZc5Dq3Cl4yDYeQbwle7PWVh4kYqKY
	 y/rgkvzgxAQM/giJLl/BLTl7/vpQbIB/xJ7/l8KEoneV7GYuiHYotq9CY8CcZhnX9g
	 eS9fyQnCHnBBA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC v2 00/13] fs: reclaim inodes with I_METADATA_WRITEBACK
Date: Thu, 05 Nov 2026 13:41:29 +0100
Message-Id: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42OwQrCMBBEf0X2bEoatLaeBMEP8Coi22S1sZrIJ
 lZF+u829ejF4wwz8+YNgdhSgOXkDUydDda7QajpBHSD7kTCmkGDkqrIparEw3MrrPOGxJUiGox
 4eLCNVKNuhSlLiXKmKppVMGzcmI72Oe7vYLtZw/5rhnt9Jh3TcorVGEjUjE43yUqMbGRkv4wsh
 VOpsSF6fo3Xu3wk/Pmyy4UUC1PoYlHivJybVUvs6JJ5PsG+7/sPTy1ZIhcBAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4730; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uQAcmMCc2w6/ikGhiBGNpUYRNBeUrnmrDu0mIbBH36g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZzwau5RLuX1fV5spwr8wx5l7rj+qENtusvEj/q3Z
 rmceal+u6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiWmsZ/ru/bnh3tTMuTWup
 5Ku05z1ls49Vma+MWX3O8rVa6EPWpToM/wyj37+/rzx5WmXUirq5f98tSMpnYl/6/+Dqo4UtUZu
 9+5kB
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
inode and make the filesystems write out what I_METADATA_WRITEBACK
tracks in ->evict_inode() unless the inode is being deleted. That's
what they already do there for the metadata buffers they track.

The first twelve patches do that per filesystem. ->sync_inode_metadata()
of ext2, ext4, minix and udf looks the inode block up in the buffer
cache instead of reading it from disk, the way fat already does, so
that calling it from reclaim is fine. Then ->evict_inode() of all five
calls it for a linked inode that still has the bit set. The last patch
is the actual fix.

This still writes and waits from reclaim if the inode block is still
dirty. Once Jan's deferred inode reclaim lands these inodes can go to
his workers instead. I have that on top of his v3 (cf. [1]).

All of this is meant for v7.3 stable. v7.3 still has bfs which sets
I_METADATA_WRITEBACK as well, so the backport needs the same two
changes for bfs.

Tested on 65ba8f34ec88 with KASAN and lockdep: creating 5000 files,
sync(2) and two drop_caches leave about 5000 of 5000 inodes around on
ext2, ext4, vfat and minix without this series and at most one with it.
The memory cgroup run creates all 60000 files and nothing gets killed.
Blocks the flusher left dirty get written out on eviction on all five
filesystems. No splats.

udf inodes with their data in the ICB are still dirty after sync(2),
with and without this series. That's a separate issue I didn't care
about.

[1]: https://patch.msgid.link/20261029-work-inode-metadata_writeback-deferred-v1-1-7e49f6c12b60@kernel.org

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
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
Christian Brauner (13):
      ext2: add ext2_inode_block() helper
      ext2: don't read the inode block in ext2_sync_inode_metadata()
      ext2: sync inode metadata in ext2_evict_inode()
      ext4: use sb_find_get_block_nonatomic() in ext4_get_inode_loc_noio()
      ext4: don't read the inode block in ext4_sync_inode_metadata()
      ext4: sync inode metadata in ext4_evict_inode()
      minix: add minix_inode_block() helper
      minix: don't read the inode block in minix_sync_inode_metadata()
      minix: sync inode metadata in minix_evict_inode()
      udf: don't allocate the inode block in udf_sync_inode_metadata()
      udf: sync inode metadata in udf_evict_inode()
      fat: sync inode metadata in fat_evict_inode()
      fs: don't strand I_METADATA_WRITEBACK inodes outside the LRU

 fs/ext2/inode.c   | 69 ++++++++++++++++++++++++++++++++++++-------------------
 fs/ext4/inode.c   | 33 ++++++++++++++++++--------
 fs/fat/inode.c    | 11 ++++++++-
 fs/inode.c        |  5 +++-
 fs/minix/bitmap.c | 37 ++++++++++++++++++-----------
 fs/minix/inode.c  | 24 ++++++++++++-------
 fs/minix/minix.h  |  1 +
 fs/udf/inode.c    | 45 +++++++++++++++++++++---------------
 8 files changed, 150 insertions(+), 75 deletions(-)
---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261029-work-inode-metadata_writeback-d880a0429e49

