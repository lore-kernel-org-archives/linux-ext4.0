Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280517;
	b=wJcq4jPt0fm9/9xnML50TjiDOD4/oKK/UmVJGFkye+ES+3WElrKJiRURWIsUJKw0JRfg
	 iKyktdZlsztyg69UIB3EM9g1CDWkHLEFIWpwaKXbMHKTuIG/hpOzLcXpYtxdNgwhel1qm
	 yoGybzX12kkOnOxEvxz+mxc0mYVKtN4FQj0k5FLPNe2BvKvxnv+ZOmN1QOo/nkeVUYg1R
	 FA/LXMvWbcMTqSAeNcvTN1WKWaIWsWGbCdFYimtojqvFOkJFjIZhrP8yfQHJTB5F0NQ0c
	 AMy6XDddrS4IIPoMtf2pfzYK6JwBa/VDM8OHG5wXXClEcM/BP3/UqwfXgZkqAbh0iIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280517;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=z6mg7wAzFnmaWRt6hE1pzBzW0UyDhIw3HcC+TnSh0DI=;
	b=bHPcdCtfXnjbVUFVJygZD+jZXfqjnbYCJ1Mngr+wATGOlZZsFrR9kPUWWDaIMIGwrlNu
	 +2QR8CFhSVRZ+mBHy2iBjnOq8zRfTXNJ0b/BGF2zkZ7BP7AfSwYVbpwocAKKztU1kmwWC
	 T3DehyXhO7YqHytt2kec9xNTtLsVcBQUqhxSeAhruRf3CGpBwu/nahf3FvqzWYnsAF47H
	 ESD3d/bemgi84qDx4+5o+wDeAnzANaaYtyO60j4z+eGIEnXRHnfRVySiatHYIhvgwphKm
	 q3cPm+z8IJMqLgp0ov6Z4SUf6vYjoVSNcuShn2s5sVAl59CEhCEYLqsLRNfTEwMnzfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ItBrC6jf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB724606A31A;
	Thu, 29 Oct 2026 13:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ItBrC6jf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782271F01828;
	Thu, 29 Oct 2026 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280516;
	bh=z6mg7wAzFnmaWRt6hE1pzBzW0UyDhIw3HcC+TnSh0DI=;
	h=From:Subject:Date:To:Cc;
	b=ItBrC6jfKbp6uLtA3Y6h8evXvwylbC7FHTipdiCSwyfWKyyGiN/ibv2CYdDQoKCIj
	 b7jlSwWcMPu7z5yht4ZMIQrEBSnDXuaN1JJsybmRTBDq7WsPkbizS5u/de+U+JMOcs
	 g+3BuRmQyZnLPKGUfnXumoJht2K8TyZ1FJfVQ5wrlPPj8phIIByyIQDrkL65Q4DDv9
	 gb36WCGPRPJY+nDFxsrnH1MqlcLJiSLkKW/fUHnCbxtyK2rsvTlzEYU3hrUukMlJec
	 d/idKAhtg5BgCDoRQgV9d4bFpCwptqBW1tbDZMumAAuTDhNhty6LESfzxZUlACwVId
	 NngEfb8UolmCQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 0/9] fs: reclaim inodes with I_METADATA_WRITEBACK
Date: Thu, 29 Oct 2026 14:28:15 +0100
Message-Id: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WNQQrCMBBFr1JmbUIaijRuBQ/gVkQmyWjHYipJt
 ELp3W3q0uV/fN6bIFFkSrCrJoj05sRDWEa9qcB1GG4k2C8btNLbWmkjxiH2gsPgSTwoo8eMlzF
 yJouuF75tFapGG2oMLI5npCt/Vv8Jjoc9nH8wveydXC7mcrOYSNiIwXUFlYZcG/K/IcsZ5vkL1
 UeYKrsAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4285; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Ln2XyPd2UpicXc9VGlQk6KnFjqMNtlBUcBY3nf8Leiw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vzHm3pHKK1rS6yToeZ+/vkcVU9d47Ufbt93/mED2
 8/WznUWHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOpzGZkuPm1P7irap2N6pkX
 pyILf3d9rQ/hT/zUeGmxw5yIYwfLqhn+V2kXaBeGefHdPMB2me9HQZSI24XNv97el2v5qvxLtfQ
 JCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since v7.3 ext2, ext4 without a journal, fat, udf and minix set
I_METADATA_WRITEBACK when they copy an inode into its buffer and only
fsync() and friends clear it again.

inode_lru_isolate() treats it like any other state bit and takes the
inode off the LRU, expecting something to put it back once the bit is
gone but nothing ever puts it back.

So these inodes can't be reclaimed anymore. They stay around until
something fsyncs them or the filesystem is unmounted. Which is
effectively a DoS.

On ext4 without a journal an atime update is enough to pin an inode, and
creating 60000 small files in a memory cgroup limited to 96M gets the
task OOM killed after about 43000 of them.

The original provided fix was quite ugly. It handed such inodes from
inode_lru_isolate() to a per-sb work item with a reference held, synced
them there and put them back on the LRU.

We've had discussions in that direction for unrelated reasons and we
found that quite terrible. It's a second inode reclaim offload mechanism
next to Jan's deferred inode reclaim, it needs a new inode state bit,
and the reference shows up in everything that looks for open deleted
files.

So instead, let the shrinker reclaim these inodes like any other clean
inode and make evict() write out what I_METADATA_WRITEBACK tracks
unless the inode is being deleted. That's what the filesystems already
do for the metadata buffers they track in ->evict_inode().

The first seven patches make ->sync_inode_metadata() of ext2, ext4,
minix and udf look the inode block up in the buffer cache instead of
reading it from disk, the way fat already does. A block that isn't
cached is neither dirty nor under writeback so there's nothing to write
or to wait for. That matters once evict() calls it from reclaim.

The eighth patch is a fat fix in the same area. fat_evict_inode()
updates the directory entry of a file with fallocated clusters and lets
the inode go without writing it out. So the freed clusters can be free
on disk while the directory entry still points at them.

The last patch is the actual fix.

This still writes and waits from reclaim if the inode block is still
dirty. Once Jan's deferred inode reclaim lands these inodes can go to
his workers instead. I have that on top of his v3 and will send it as
an RFC in a minute.

All of this is meant for v7.3 stable. v7.3 still has bfs which sets
I_METADATA_WRITEBACK as well, so the backport also needs a cache-only
lookup in bfs_sync_inode_metadata().

Tested on 65ba8f34ec88 with KASAN and lockdep: the reproducer in the
last patch leaves about 5000 of 5000 inodes around on ext2, ext4, vfat
and minix without this series and at most one with it. The memory
cgroup run creates all 60000 files and nothing gets killed. The
reproducer in the fat patch finds /a pointing at a free cluster on disk
without the series and a clean /a with it. No splats.

udf inodes with their data in the ICB are still dirty after sync(2),
with and without this series. That's a separate issue I didn't care
about.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (9):
      ext2: add ext2_inode_block() helper
      ext2: don't read the inode block in ext2_sync_inode_metadata()
      ext4: add ext4_inode_loc_block() helper
      ext4: don't read the inode block in ext4_sync_inode_metadata()
      minix: add minix_inode_block() helper
      minix: don't read the inode block in minix_sync_inode_metadata()
      udf: don't allocate the inode block in udf_sync_inode_metadata()
      fat: sync the inode in fat_free_eofblocks()
      fs: don't strand I_METADATA_WRITEBACK inodes outside the LRU

 fs/ext2/inode.c   | 61 ++++++++++++++++++++++++++++++++++---------------------
 fs/ext4/inode.c   | 48 ++++++++++++++++++++++++++++++-------------
 fs/fat/inode.c    |  2 +-
 fs/inode.c        | 13 +++++++++++-
 fs/minix/bitmap.c | 37 ++++++++++++++++++++-------------
 fs/minix/inode.c  | 16 +++++++--------
 fs/minix/minix.h  |  1 +
 fs/udf/inode.c    | 27 ++++++++++++------------
 8 files changed, 130 insertions(+), 75 deletions(-)
---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261029-work-inode-metadata_writeback-d880a0429e49

