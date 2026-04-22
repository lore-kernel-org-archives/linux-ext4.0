Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051451D6DA9;
	Wed, 22 Apr 2026 23:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900260; cv=none; b=Rz4atMf6KBQ0gmHxjMKGwlpNVMkKQmT8ddcw0WT7xXhwvpGadGrxgx/x/NxCKbQEu4SIA9djKaecGFPG92hDyn+yWo5HTLbym1YhLHOUC/AwwrIbUzbDApm1kwrJsOmJXtoc+znrrK/BPIu093zYNIsMVEslmo3M6ukHkhM1oLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900260; c=relaxed/simple;
	bh=NkhOfkyKeLlFOmxSWSlGf6xb4M1S8YLYljkVdi3MaHo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hHVMWHYDE4hGtcoTSbkhaXt+uY/ZES2N40AzTw7CwUWOE1zACL2ug8jIXURGWGBF3dCr6iV8vf4i57cZE3D9KOBOHSzDn43x6ZggEfP7ACtLvBHJrVumXjFj9nYnBxvR8t7DgxJ96wR1ptkUlAConJwETHMnrzRk3mLayhqALpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odUyoTq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odUyoTq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E19C2BCAF;
	Wed, 22 Apr 2026 23:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900259;
	bh=NkhOfkyKeLlFOmxSWSlGf6xb4M1S8YLYljkVdi3MaHo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=odUyoTq7Vp2S9mBWvbF5qFoaOAgbteZHoTrVx5PVBIawj82FhrXenru3gif6sFq6z
	 94zBP8JnIo+J9nHjwo9zz2fjgNYVsguByZ2KQgKZ8XMyquvgVY0Zlpm4WxpBhLM7HA
	 K3XOwgHyFuA1pzMqC44uXhZ+JM8AYmwLVYRJJtBoEja69GaduWY4k5cuNyQzCbIh/v
	 A0kd22K5+OGZM6NHfeAS1+LOzz8asjECepWOSRYLC5jso0QV0TtRiXe2zpiK4684Mn
	 lJPaALs/x3+pruq6SFHFUDKLoEHSS9q4+bqmlkR3pE9KrKWP49pHUL9jLS/sVUYUFg
	 fVVSLyyllapeg==
Date: Wed, 22 Apr 2026 16:24:19 -0700
Subject: [PATCH 03/10] unix_io: allow passing /dev/fd/XXX paths to the unixfd
 IO manager
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, linux-ext4@vger.kernel.org, neal@gompa.dev,
 joannelkoong@gmail.com, miklos@szeredi.hu, bernd@bsbernd.com
Message-ID: <177689989593.3821326.8030762717050212953.stgit@frogsfrogsfrogs>
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

Commit 4ccf9e4fe165cf created a "unixfd" IO manager that allows someone
to choose the unixfd IO manager and then mount a filesystem from an
existing file descriptor by passing a string with the fd number as the
"device" name to ext2fs_open().

That was an unfortunate choice of naming, however, because that could
be mistaken for a relative path to a file whose name is an integer
number.  Let's improve this by allowing callers to pass /dev/fd/XX
as the filesystem device name.  The upcoming fuse4fs service patches
will employ this method to open a filesystem on a block device fd passed
into the secure container from a mount helper.

Cc: <linux-ext4@vger.kernel.org> # v1.43.2
Fixes: 4ccf9e4fe165cf ("libext2fs: add unixfd_io_manager")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/unix_io.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 79bc9219f9515b..a9b1fac62a0250 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -67,6 +67,7 @@
 #ifdef HAVE_SYS_FILE_H
 #include <sys/file.h>
 #endif
+#include <limits.h>
 
 #if defined(__linux__) && defined(_IO) && !defined(BLKROGET)
 #define BLKROGET   _IO(0x12, 94) /* Get read-only status (0 = read_write).  */
@@ -1148,13 +1149,40 @@ static errcode_t unix_open_channel(const char *name, int fd,
 	return retval;
 }
 
+#define DEV_FD_PATH	"/dev/fd/"
+#define DEV_FD_PATHLEN	(sizeof(DEV_FD_PATH) - 1)
+
+static int possible_unixfd_pathname(const char *path)
+{
+	return strncmp(DEV_FD_PATH, path, DEV_FD_PATHLEN) == 0;
+}
+
 static errcode_t unixfd_open(const char *str_fd, int flags,
 			     io_channel *channel)
 {
 	int fd;
 	int fd_flags;
 
-	fd = atoi(str_fd);
+	/*
+	 * The caller should provide a path in the form "/dev/fd/XX",
+	 * but the shorthand form "XX" is allowed for legacy reasons.
+	 */
+	if (possible_unixfd_pathname(str_fd)) {
+		char *endptr;
+		long maybe_fd;
+
+		errno = 0;
+		maybe_fd = strtol(str_fd + DEV_FD_PATHLEN, &endptr, 10);
+		if (errno)
+			return errno;
+		if (*endptr != 0)
+			return EINVAL;
+		if (maybe_fd < 0 || maybe_fd > INT_MAX)
+			return EINVAL;
+		fd = maybe_fd;
+	} else {
+		fd = atoi(str_fd);
+	}
 #if defined(HAVE_FCNTL)
 	fd_flags = fcntl(fd, F_GETFL);
 	if (fd_flags == -1)

