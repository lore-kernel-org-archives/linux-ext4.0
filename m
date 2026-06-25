Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DADD305691
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416206; cv=none; b=LlLA0dohlDfy8XtaXDUeziTV7aViOKseyKnxs/T5AVYNMFh5P1ir2B7YepHwqLQFlfA4BO4TFNyThOD6+3ppIoCHvDqj0xfYH9zdk76aut4MHTqFym5jnZFD8vOrjtxkMqO6Ri2LbsCrrVPf7riVguzPRMeyK4uEn5C1Tj4wWeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416206; c=relaxed/simple;
	bh=Pk02YPuTUdweloGaaOW78g5tl702ky76X/Wu667Tbb8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KuHRE3x6/HBGmxKQkG+y/rjlzM2Kv1s1pmfg2Jdb0Bvig66HAgp6F530m2ZK9Op1tzRyt6RBiGuR3kG1WY4LGbSapLcW0WghlCA6GqbVl8TAQ33bYjFIc9NJW+91630dqCF49ZTPVmlDOEQth4fQuSLsIc5SrelDrC8esvCkOI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkVizxfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkVizxfg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 16E0A1F000E9;
	Thu, 25 Jun 2026 19:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416205;
	bh=1RghkCMQ8SFjj79olHkIdLTH5t543t3zbBhUHrGFFJo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=PkVizxfg5QHSg/p/jX8BUUoZNOBv9E8ZvSPotZVH5AjPrGtceVBWBK+jPebwWFOHG
	 MfdSqUty3kFFXUMaNEPJG24MtOzQ4szK0/WUd8MRl9wrA5HCr2a/9G/BPFEDNHcPcB
	 o/b7/yE798g1HYsBhtSJzi/16K/z/p3XjNnXjrlAlosiY9/ZXcP5k9rWAw/I4NI2p4
	 gG7dd3gr9tSRLaHzQX6JKyPN1yRW2J1rvj5e6r9UW8jNKxCaxyvYZ+RSA0On8PSzay
	 veQls91h6ioSYcJMcmdFeJ/dfzd+4IErn9VzmQuxx58y0aeNtL/uhG2H61FbuUHFei
	 x518hZwZEswtg==
Date: Thu, 25 Jun 2026 12:36:44 -0700
Subject: [PATCH 3/3] libext2fs: only fsync the unix fd if we wrote to the
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606634.1810243.10857045849869125873.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606573.1810243.8333361812351601871.stgit@frogsfrogsfrogs>
References: <178241606573.1810243.8333361812351601871.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As an optimization, only fsync the block device fd if we tried to write
to the io channel.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/unix_io.c |   86 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 67 insertions(+), 19 deletions(-)


diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 15d6d55ff7fdd4..f4307db0fb2b05 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -132,10 +132,13 @@ struct unix_cache {
 #define WRITE_DIRECT_SIZE 4	/* Must be smaller than CACHE_SIZE */
 #define READ_DIRECT_SIZE 4	/* Should be smaller than CACHE_SIZE */
 
+#define UNIX_STATE_DIRTY	(1U << 0) /* device needs fsyncing */
+
 struct unix_private_data {
 	int	magic;
 	int	dev;
 	int	flags;
+	unsigned int	state; /* UNIX_STATE_* */
 	int	align;
 	int	access_time;
 	int	unix_flock_flags;
@@ -1198,10 +1201,65 @@ static errcode_t unix_open(const char *name, int flags,
 	return unix_open_channel(name, fd, flags, channel, unix_io_manager);
 }
 
+#ifdef HAVE_FSYNC
+static void mark_dirty(io_channel channel)
+{
+	struct unix_private_data *data =
+		(struct unix_private_data *) channel->private_data;
+
+	mutex_lock(data, CACHE_MTX);
+	data->state |= UNIX_STATE_DIRTY;
+	mutex_unlock(data, CACHE_MTX);
+}
+
+static errcode_t maybe_fsync(io_channel channel, int force_fsync)
+{
+	struct unix_private_data *data =
+		(struct unix_private_data *) channel->private_data;
+	int need_fsync;
+	errcode_t retval = 0;
+
+#ifndef NO_IO_CACHE
+	retval = flush_cached_blocks(channel, data, 0);
+#endif
+
+	mutex_lock(data, CACHE_MTX);
+	need_fsync = force_fsync || (data->state & UNIX_STATE_DIRTY);
+	data->state &= ~UNIX_STATE_DIRTY;
+	mutex_unlock(data, CACHE_MTX);
+
+	if (need_fsync && fsync(data->dev) != 0) {
+		if (!retval)
+			retval = errno;
+	}
+	if (retval) {
+		/* redirty because writeback failed */
+		mark_dirty(channel);
+		return retval;
+	}
+
+	return 0;
+}
+#else
+# define mark_dirty(...)		((void)0)
+
+static errcode_t maybe_fsync(io_channel channel, int force_fsync)
+{
+	struct unix_private_data *data =
+		(struct unix_private_data *) channel->private_data;
+	errcode_t retval = 0;
+
+#ifndef NO_IO_CACHE
+	retval = flush_cached_blocks(channel, data, 0);
+#endif
+	return retval;
+}
+#endif
+
 static errcode_t unix_close(io_channel channel)
 {
 	struct unix_private_data *data;
-	errcode_t	retval = 0;
+	errcode_t	retval;
 
 	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
 	data = (struct unix_private_data *) channel->private_data;
@@ -1210,14 +1268,7 @@ static errcode_t unix_close(io_channel channel)
 	if (--channel->refcount > 0)
 		return 0;
 
-#ifndef NO_IO_CACHE
-	retval = flush_cached_blocks(channel, data, 0);
-#endif
-#ifdef HAVE_FSYNC
-	/* always fsync the device, even if flushing our own cache failed */
-	if (fsync(data->dev) != 0 && !retval)
-		retval = errno;
-#endif
+	retval = maybe_fsync(channel, 1);
 
 	unix_funlock(channel);
 
@@ -1388,6 +1439,8 @@ static errcode_t unix_write_blk64(io_channel channel, unsigned long long block,
 	data = (struct unix_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
+	mark_dirty(channel);
+
 #ifdef NO_IO_CACHE
 	return raw_write_blk(channel, data, block, count, buf, 0);
 #else
@@ -1512,6 +1565,8 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 	if (lseek(data->dev, offset + data->offset, SEEK_SET) < 0)
 		return errno;
 
+	mark_dirty(channel);
+
 	actual = write(data->dev, buf, size);
 	if (actual < 0)
 		return errno;
@@ -1527,21 +1582,12 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 static errcode_t unix_flush(io_channel channel)
 {
 	struct unix_private_data *data;
-	errcode_t retval = 0;
 
 	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
 	data = (struct unix_private_data *) channel->private_data;
 	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
 
-#ifndef NO_IO_CACHE
-	retval = flush_cached_blocks(channel, data, 0);
-#endif
-#ifdef HAVE_FSYNC
-	/* always fsync the device, even if flushing our own cache failed */
-	if (fsync(data->dev) != 0 && !retval)
-		return errno;
-#endif
-	return retval;
+	return maybe_fsync(channel, 0);
 }
 
 static errcode_t unix_set_option(io_channel channel, const char *option,
@@ -1653,6 +1699,7 @@ static errcode_t unix_discard(io_channel channel, unsigned long long block,
 		}
 		return errno;
 	}
+	mark_dirty(channel);
 	return 0;
 unimplemented:
 	return EXT2_ET_UNIMPLEMENTED;
@@ -1734,6 +1781,7 @@ static errcode_t unix_zeroout(io_channel channel, unsigned long long block,
 		}
 		return errno;
 	}
+	mark_dirty(channel);
 	return 0;
 unimplemented:
 	return EXT2_ET_UNIMPLEMENTED;

