Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93FA1D6DA9;
	Wed, 22 Apr 2026 23:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900227; cv=none; b=dzQnURHTigZH7Clvc2G5T6XNeM7mapQdAr4Emx9KBg8bCVMiOVPm0NesG2BpiPR4W6fRLhbrtSrJqLKasutQLTAClX6x09TQVR2FXhf8wtncr56LxVEsyE4ghj1mNxzA4GfmjdnbqdUjx5DgRVWuE6xy5aKGNAZgTjqe2cL/Q1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900227; c=relaxed/simple;
	bh=A1DRXP6WgoRkW+uXzPhMWN8lF2qZ/i34lqWXZGtaFLY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nNRdAowRx7ZcbNArHLRi0rR88V6PY9F1of4Wp/EAgSVZvNkzc1pyn7YtRCaq8qEVcMDwLMCY36vO63aUEm0cqGt09CBdxB23bQao5RngNwEzIIXGxPHV052YjanLoUOGcrG/V9DqxpRnGZu9OsN0O7TXY57MR0wvfqXgdnFad24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rAOSrP1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rAOSrP1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9561BC2BCAF;
	Wed, 22 Apr 2026 23:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900227;
	bh=A1DRXP6WgoRkW+uXzPhMWN8lF2qZ/i34lqWXZGtaFLY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rAOSrP1G4TpH1vYOoMFYlAw5kJzlDFL2ZneWF1J8AR5qU2K1VuTu1qmIB02wNj70c
	 nouLuD33e7TB34se6SLYATZ+ZQ/avRfdCYyV/GO+aYhy0sR98tDQ6JnPX/Oogbe31C
	 LpdvwBHjtq5/3CPuvlmpKvnlC4OidXPDGf3UWgUT4ojrzc/J+EW/FlcCgxdSW6Jux6
	 hYazt9c0qhNguLF034TC+GdsMMzTELCcpSSRuLjKJoO/rGVOZDnP4eCXRZN9zuH/zr
	 SHLi+tN1CFCCiJAP1WMN0oTw9b/uag7hek+9ESkLXZNzIjsyjFcez/wWt8sKjlDfMJ
	 y3PTETCsgPdnA==
Date: Wed, 22 Apr 2026 16:23:47 -0700
Subject: [PATCH 01/10] libext2fs: make it possible to extract the fd from an
 IO manager
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com,
 miklos@szeredi.hu, bernd@bsbernd.com
Message-ID: <177689989558.3821326.5811207681918955860.stgit@frogsfrogsfrogs>
In-Reply-To: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
References: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
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

