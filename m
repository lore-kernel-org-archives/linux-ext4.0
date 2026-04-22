Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3D61D6DA9
	for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 23:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900212; cv=none; b=SKBjTVFRhYm21Kilhx4/uYxvaZxXDIqW4ujxsg7ajCkEJS79k6ZDRCBVxhWQpd/uH6bfCUD8AuNWDHOPmMi82S12RUnIS+G9Q4exi+skLIt/UP6AFuMQtKaAshJuNPOmQR+D/O/XfpsEsKlLeHFI5V2YErde1rYjHARa3Yy14Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900212; c=relaxed/simple;
	bh=Pk02YPuTUdweloGaaOW78g5tl702ky76X/Wu667Tbb8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3G9DHhwmJ8U4mK7sYfMVjyjPxnHtuJzSFDyfPFoLDvGd0DDyThzLNkhtaXgEA90uQeXq4svsXlABBPjpbZvPG/AUKQIeia1EnsWRqS+MPih1vhhBFF3ky1KR2iJm65JvsQtpC8sGwTAHHBASWNjxfaORVL/bsSJULxUg+xkoCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CAKqxZZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CAKqxZZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B99C19425;
	Wed, 22 Apr 2026 23:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900212;
	bh=Pk02YPuTUdweloGaaOW78g5tl702ky76X/Wu667Tbb8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CAKqxZZOz/8Xkou8qH4qP3z3dHT2rYtGWMXXaGVJ5ouqmQ7/YWQw50CGl89K6q6Xp
	 cAS34sXqZXO8ORNYyAg7fRoS4tdPJ89cE//owq8/pLSMRzVTLJMSJ8plRG9PI+3VWh
	 2WFo1cMPKHHlwBYaSMhnrSKGe0T1cPsMyIBRQQCqK8a9hPf0HWTHw4Fyio6gOtREhg
	 z0jlsUkm6ThQTORkG5fkP0E5u+p09mgonnkmyT8O769R7drQcbCeK7XclghxrnWl0D
	 P4otuzrOfZ+vLK491KGktERgpA54uR7MHvQVVw2PFim0rPPFFtBoMKkPF8fJZbVcpl
	 1L0TbeL/IoHjg==
Date: Wed, 22 Apr 2026 16:23:31 -0700
Subject: [PATCH 3/3] libext2fs: only fsync the unix fd if we wrote to the
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <177689989365.3821152.8925862475853227905.stgit@frogsfrogsfrogs>
In-Reply-To: <177689989303.3821152.12873703999139555043.stgit@frogsfrogsfrogs>
References: <177689989303.3821152.12873703999139555043.stgit@frogsfrogsfrogs>
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

