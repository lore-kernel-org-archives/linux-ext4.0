Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB12323ED60
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416222; cv=none; b=YU06/W0I3lQMTyQFX9VsuslukIFgY2JKDvUlYttlGRso2lIcjydC46A8C/zE+uxbFJ6BeMKbUlE87CUNfGpBs7qWCXN9T0YNej24vnp3v5fgaVgTMrt1cHfV9wV3rce3yL2BFm8FCRwNZYZ0Cj4YvaEuqYXKJeFsXihTTP+TJzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416222; c=relaxed/simple;
	bh=A1DRXP6WgoRkW+uXzPhMWN8lF2qZ/i34lqWXZGtaFLY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFx22x8oqdF/DsqzQNT/iLYYEW093W0QulLGLbLXutzGX40NN7rf3H12wdr2g9shqm9BzQMICWl3t27o0TMG0oTKf8LfDwBPR0dXAr5idG/okPOnfqd7YIEfSG83PLCJrLVtZUi+u5s9c4MSMTpvYmk+pCHBAXYHAtzw4ZwzKxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g46utEI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g46utEI6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 917561F000E9;
	Thu, 25 Jun 2026 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416220;
	bh=rNazFuvgn+L1r5GoJaEqpe1bFOVEy9jSNV3KizZLyvk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=g46utEI6cxn+HinFWcusKmkwB2FMrWplJaBrNbWFR85s1iS+f/skRtpvRwb6ycJ7b
	 AIlS/PqKHI0BPqdbiCt9W8zoZvyR/sRlDTG9Ow1/Zthkt2DEmoKBEldnsBHKu6GmLU
	 RglbbDvu/d1PUNsAh/3peniWeswBmYFHMNmJBqpjyJ18osAELNfesYJg39wObyPagq
	 EV8AuLNbgJL9zbobLxEA8Z6rkpvz6nnM64nLPQD0OVWeEqcj0A/iM73J5bBvluebSf
	 8qAw788gmCvn9WqdoKD47+C0WWA/VlufBTK743s4Z2Mua0QtugkdGhXvntc9XzaJM+
	 ppHXweqVK/sBQ==
Date: Thu, 25 Jun 2026 12:37:00 -0700
Subject: [PATCH 01/10] libext2fs: make it possible to extract the fd from an
 IO manager
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606830.1810414.9069545784261735781.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
References: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make it so that we can extract the fd from an open IO manager.  This
will be used in subsequent patches to register the open block device
with the fuse iomap kernel driver.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/ext2_io.h         |    4 +++-
 debian/libext2fs2t64.symbols |    1 +
 lib/ext2fs/io_manager.c      |    8 ++++++++
 lib/ext2fs/unix_io.c         |   20 ++++++++++++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
index 61865d54d82490..c880ea2524f248 100644
--- a/lib/ext2fs/ext2_io.h
+++ b/lib/ext2fs/ext2_io.h
@@ -103,7 +103,8 @@ struct struct_io_manager {
 	errcode_t (*zeroout)(io_channel channel, unsigned long long block,
 			     unsigned long long count);
 	errcode_t (*flock)(io_channel channel, unsigned int flock_flags);
-	long	reserved[13];
+	errcode_t (*get_fd)(io_channel channel, int *fd);
+	long	reserved[12];
 };
 
 #define IO_FLAG_RW		0x0001
@@ -155,6 +156,7 @@ extern errcode_t io_channel_cache_readahead(io_channel io,
 					    unsigned long long count);
 extern errcode_t io_channel_flock(io_channel io, unsigned int flock_flags);
 extern errcode_t io_channel_funlock(io_channel io);
+extern errcode_t io_channel_get_fd(io_channel io, int *fd);
 
 #ifdef _WIN32
 /* windows_io.c */
diff --git a/debian/libext2fs2t64.symbols b/debian/libext2fs2t64.symbols
index affe4c27d4e791..555fbbb0c98878 100644
--- a/debian/libext2fs2t64.symbols
+++ b/debian/libext2fs2t64.symbols
@@ -701,6 +701,7 @@ libext2fs.so.2 libext2fs2t64 #MINVER#
  io_channel_discard@Base 1.42
  io_channel_flock@Base 1.47.99
  io_channel_funlock@Base 1.47.99
+ io_channel_get_fd@Base 1.47.99
  io_channel_read_blk64@Base 1.41.1
  io_channel_set_options@Base 1.37
  io_channel_write_blk64@Base 1.41.1
diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
index 791ec7d14adbba..dff3d73552827f 100644
--- a/lib/ext2fs/io_manager.c
+++ b/lib/ext2fs/io_manager.c
@@ -166,3 +166,11 @@ errcode_t io_channel_funlock(io_channel io)
 
 	return io->manager->flock(io, 0);
 }
+
+errcode_t io_channel_get_fd(io_channel io, int *fd)
+{
+	if (!io->manager->get_fd)
+		return EXT2_ET_OP_NOT_SUPPORTED;
+
+	return io->manager->get_fd(io, fd);
+}
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index f4307db0fb2b05..79bc9219f9515b 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1786,6 +1786,24 @@ static errcode_t unix_zeroout(io_channel channel, unsigned long long block,
 unimplemented:
 	return EXT2_ET_UNIMPLEMENTED;
 }
+
+static errcode_t unix_get_fd(io_channel channel, int *fd)
+{
+	struct unix_private_data *data;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (data->offset) {
+		*fd = -1;
+		return EINVAL;
+	}
+
+	*fd = data->dev;
+	return 0;
+}
+
 #if __GNUC_PREREQ (4, 6)
 #pragma GCC diagnostic pop
 #endif
@@ -1808,6 +1826,7 @@ static struct struct_io_manager struct_unix_manager = {
 	.cache_readahead	= unix_cache_readahead,
 	.zeroout	= unix_zeroout,
 	.flock		= unix_flock,
+	.get_fd		= unix_get_fd,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
@@ -1830,6 +1849,7 @@ static struct struct_io_manager struct_unixfd_manager = {
 	.cache_readahead	= unix_cache_readahead,
 	.zeroout	= unix_zeroout,
 	.flock		= unix_flock,
+	.get_fd		= unix_get_fd,
 };
 
 io_manager unixfd_io_manager = &struct_unixfd_manager;

