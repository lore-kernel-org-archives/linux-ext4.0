Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A46B27E1DC;
	Wed, 29 Apr 2026 14:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474296; cv=none; b=scSv059k9yb6L/nNnD1Dwtkw5YdgfvxJ0TgF6SeET0wyDnHT22IZZoxNEg31qTBEUUCCHGetpCKd1X1RoFQw+S3YnENz3eutQ4EDlBEJ1TRmesU2YSgyos/+1qidGFD3aYY1xqcXqW62jqXAMv+eLXQvR7eExQJGhWAGffQ7bvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474296; c=relaxed/simple;
	bh=yACd6LsSm+yczj8Cb0haT/V3Q+3be26U7DXQ8HLbJZE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fy9uVouXyCdjDzXjK7O9+Xrr/OoE2VcHCE3HSpJ/ykxlzhA1h/OdYmrOtWJ4+IpqknlsRumvZFEPycAf7bpJWacezVaShwPOVn68awJvqpQ0jA1JxhFLnPI5oUzQUcXL4c9zXTero/RVmxl4Csl3EPtQkfUlxugMbDkuJQ5SyOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mq77mi+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mq77mi+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE407C19425;
	Wed, 29 Apr 2026 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474295;
	bh=yACd6LsSm+yczj8Cb0haT/V3Q+3be26U7DXQ8HLbJZE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mq77mi+He4p0EJ54rRic5SbwmkZezHhq2x4iF+BuqlC7KcVahoV32Vl4p1ChF+ez5
	 d0bhC1BmLWots4R5ThIgmFexdejp3gliZ46BmoNYgKUT2cCsBJiYpFMcf9TCOiwsap
	 avhbiy6iFchZTwDkCv5zaF5DsrfVcrbyxFxIySVcSOV4sTV2FA8PlK0UGS4DHic5Co
	 K5Czdt9+7rDtKujmRMGz4mtp/GaYSBWDVphZ+iavHPsJjLvdxfiCzGilnEiSS/4WgF
	 8nirHBGdPvquJxUtEAnY4UCyG3e/mciwJlA2W9vmR/wjsBYRrR4LPvW27bVy2UI570
	 QyDTt7rt5ycaQ==
Date: Wed, 29 Apr 2026 07:51:35 -0700
Subject: [PATCH 1/5] libext2fs: invalidate cached blocks when freeing them
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214256.4107228.6015018056447082705.stgit@frogsfrogsfrogs>
In-Reply-To: <177747214224.4107228.16300103064218258692.stgit@frogsfrogsfrogs>
References: <177747214224.4107228.16300103064218258692.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're freeing blocks, we should tell the IO manager to drop them
from any cache it might be maintaining to improve performance.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/ext2_io.h         |    8 +++++++-
 debian/libext2fs2t64.symbols |    1 +
 lib/ext2fs/alloc_stats.c     |    6 ++++++
 lib/ext2fs/io_manager.c      |    9 +++++++++
 lib/ext2fs/unix_io.c         |   35 +++++++++++++++++++++++++++++++++++
 5 files changed, 58 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index c880ea2524f248..0148492caf63b6 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -104,7 +104,10 @@ struct struct_io_manager {
 			     unsigned long long count);
 	errcode_t (*flock)(io_channel channel, unsigned int flock_flags);
 	errcode_t (*get_fd)(io_channel channel, int *fd);
-	long	reserved[12];
+	errcode_t (*invalidate_blocks)(io_channel channel,
+				       unsigned long long block,
+				       unsigned long long count);
+	long	reserved[11];
 };
 
 #define IO_FLAG_RW		0x0001
@@ -157,6 +160,9 @@ extern errcode_t io_channel_cache_readahead(io_channel io,
 extern errcode_t io_channel_flock(io_channel io, unsigned int flock_flags);
 extern errcode_t io_channel_funlock(io_channel io);
 extern errcode_t io_channel_get_fd(io_channel io, int *fd);
+extern errcode_t io_channel_invalidate_blocks(io_channel io,
+					      unsigned long long block,
+					      unsigned long long count);
 
 #ifdef _WIN32
 /* windows_io.c */
diff --git a/debian/libext2fs2t64.symbols b/debian/libext2fs2t64.symbols
index 555fbbb0c98878..b19a362967f00e 100644
--- a/debian/libext2fs2t64.symbols
+++ b/debian/libext2fs2t64.symbols
@@ -702,6 +702,7 @@ libext2fs.so.2 libext2fs2t64 #MINVER#
  io_channel_flock@Base 1.47.99
  io_channel_funlock@Base 1.47.99
  io_channel_get_fd@Base 1.47.99
+ io_channel_invalidate_blocks@Base 1.47.99
  io_channel_read_blk64@Base 1.41.1
  io_channel_set_options@Base 1.37
  io_channel_write_blk64@Base 1.41.1
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 95a6438f252e0f..68bbe6807a8ed3 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -82,6 +82,9 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 			     -inuse * (blk64_t) EXT2FS_CLUSTER_RATIO(fs));
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
+	if (inuse < 0)
+		io_channel_invalidate_blocks(fs->io, blk,
+					     EXT2FS_CLUSTER_RATIO(fs));
 	if (fs->block_alloc_stats)
 		(fs->block_alloc_stats)(fs, (blk64_t) blk, inuse);
 }
@@ -144,11 +147,14 @@ void ext2fs_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
 		ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 		ext2fs_group_desc_csum_set(fs, group);
 		ext2fs_free_blocks_count_add(fs->super, -inuse * (blk64_t) n);
+
 		blk += n;
 		num -= n;
 	}
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
+	if (inuse < 0)
+		io_channel_invalidate_blocks(fs->io, orig_blk, orig_num);
 	if (fs->block_alloc_stats_range)
 		(fs->block_alloc_stats_range)(fs, orig_blk, orig_num, inuse);
 }
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index dff3d73552827f..a92dba7b9dc880 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -174,3 +174,12 @@ errcode_t io_channel_get_fd(io_channel io, int *fd)
 
 	return io->manager->get_fd(io, fd);
 }
+
+errcode_t io_channel_invalidate_blocks(io_channel io, unsigned long long block,
+				       unsigned long long count)
+{
+	if (!io->manager->invalidate_blocks)
+		return EXT2_ET_OP_NOT_SUPPORTED;
+
+	return io->manager->invalidate_blocks(io, block, count);
+}
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 567bbd9493f7f1..54bd4b5597ea9e 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -672,6 +672,25 @@ static errcode_t reuse_cache(io_channel channel,
 #define FLUSH_INVALIDATE	0x01
 #define FLUSH_NOLOCK		0x02
 
+/* Remove blocks from the cache.  Dirty contents are discarded. */
+static void invalidate_cached_blocks(io_channel channel,
+				     struct unix_private_data *data,
+				     unsigned long long block,
+				     unsigned long long count)
+{
+	struct unix_cache	*cache;
+	int			i;
+
+	mutex_lock(data, CACHE_MTX);
+	for (i = 0, cache = data->cache; i < data->cache_size; i++, cache++) {
+		if (!cache->in_use || cache->block < block ||
+		    cache->block >= block + count)
+			continue;
+		cache->in_use = 0;
+	}
+	mutex_unlock(data, CACHE_MTX);
+}
+
 /*
  * Flush all of the blocks in the cache
  */
@@ -1832,6 +1851,20 @@ static errcode_t unix_get_fd(io_channel channel, int *fd)
 	return 0;
 }
 
+static errcode_t unix_invalidate_blocks(io_channel channel,
+					unsigned long long block,
+					unsigned long long count)
+{
+	struct unix_private_data *data;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	invalidate_cached_blocks(channel, data, block, count);
+	return 0;
+}
+
 #if __GNUC_PREREQ (4, 6)
 #pragma GCC diagnostic pop
 #endif
@@ -1855,6 +1888,7 @@ static struct struct_io_manager struct_unix_manager = {
 	.zeroout	= unix_zeroout,
 	.flock		= unix_flock,
 	.get_fd		= unix_get_fd,
+	.invalidate_blocks = unix_invalidate_blocks,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
@@ -1878,6 +1912,7 @@ static struct struct_io_manager struct_unixfd_manager = {
 	.zeroout	= unix_zeroout,
 	.flock		= unix_flock,
 	.get_fd		= unix_get_fd,
+	.invalidate_blocks = unix_invalidate_blocks,
 };
 
 io_manager unixfd_io_manager = &struct_unixfd_manager;

