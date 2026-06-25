Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B823126CA
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416268; cv=none; b=f4ochMwDvC7os3p/HGjcWS+Hae/D16vgqnnz6071p3FrYzKWHynsLDZb9NsRKh9aACXK8NSNVF/sbghnXoGQYmy+a6EG9Jh48QluuOmOJSyxzuCopt445IUzI1o7pN5YroHZWRgRmcbbIL3xEQesHDwzoFEoS6fAi//RAcVvQ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416268; c=relaxed/simple;
	bh=n3hiKEVglNnaTzGKlSiTXniL2rk1+rBKTzXjMnfRhdY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGCaXp1DElyYK/BeqNKtEWDLIDVeQ6kWVkUgkxNP786ab0+A+ztIPH7KfP/wKcNFr/D2Z0faJQDpeIYFlqtVBx4rqfBwFmf48XFdcKtK5s4rBjTWO/Z17e9wfqjlYH5l2jA38p9tF0jA8fv2OjN9H756ONrgiS1ALin8C1Q9clY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmcYCwrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmcYCwrL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1D9701F000E9;
	Thu, 25 Jun 2026 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416267;
	bh=tVlwmVi0eoAxD7e+9VpI8NojxdwOdIFl2WkHxOf1HOs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=GmcYCwrLoLES75U+lnTgJdNH2mjK2pT/k3ZGqmbeFaNkTOS8vj1hgQ0HP0+zYLnSm
	 /kJ6eugm8iyjU2n2K3Bp7M7UeOiMBa3Q3OZyLJXUGq3UV44UpMa0dYmRT5DDuwhnFG
	 ZF1/buD3RQ5muOG1yEijInHSicYWvQrHR3+FdoLQ3hrAyQG0z5J/h7tnMdeWpKIiMs
	 5v2jA24gcwJeSYVIVrS5iBhUCiyzqx6Vdz0gYXAO9p4hBvmfY/nczfARrkoOZWDwjd
	 WW9Sf5VGltbN4NWffbnMS72CyvyrAXI6cGgVhaox9AOIc0J/eryVqzxZpwRZxnlxuw
	 v/wWF9/sdzxqA==
Date: Thu, 25 Jun 2026 12:37:46 -0700
Subject: [PATCH 04/10] libext2fs: fix MMP code to work with unixfd IO manager
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606883.1810414.13833811845162394107.stgit@frogsfrogsfrogs>
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

The MMP code wants to be able to read and write the MMP block directly
to storage so that the pagecache does not get in the way.  This is
critical for correct operation of MMP, because it is guarding against
two cluster nodes trying to change the filesystem at the same time.

Unfortunately there's no convenient way to tell an IO manager to perform
a particular IO in directio mode, so the MMP code open()s the filesystem
source device a second time so that it can set O_DIRECT and maintain its
own file position independently of the IO channel.  This is a gross
layering violation.

For unprivileged containerized fuse4fs, we're going to have a privileged
mount helper pass us the fd to the block device, so we'll be using the
unixfd IO manager.  The enhanced security posture provided by the
service definition file (minimal /dev) means that we cannot reopen the
source device.  In this case, MMP can only duplicate the fd and use the
IO channel carefully.

Fix this (sort of) by detecting the unixfd IO manager and duplicating
the open fd if it's in use.  This adds a requirement that the unixfd
originally be opened in O_DIRECT mode if the filesystem is on a block
device, but that's the best we can do here.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/ext2fs.h  |    1 +
 lib/ext2fs/ext2fsP.h |    4 ++
 lib/ext2fs/mmp.c     |   95 +++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/ext2fs/unix_io.c |    2 +
 4 files changed, 100 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c4fcb10bea0fb9..02c3cbcea92482 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -225,6 +225,7 @@ typedef struct ext2_file *ext2_file_t;
  * Internal flags for use by the ext2fs library only
  */
 #define EXT2_FLAG2_USE_FAKE_TIME	0x000000001
+#define EXT2_FLAG2_MMP_USE_IOCHANNEL	0x000000002
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 428081c9e2ff38..bdc92991e7dda0 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -218,3 +218,7 @@ errcode_t ext2fs_remove_exit_fn(ext2_exit_fn fn, void *data);
         (sizeof(array) / sizeof(array[0]))
 
 #define EXT2FS_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2*!!(cond)]))
+
+#ifndef _WIN32
+int possible_unixfd_pathname(const char *path);
+#endif
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index cb15a18fce5547..188cdb68900e97 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -26,9 +26,11 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <limits.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fs.h"
+#include "ext2fs/ext2fsP.h"
 
 #ifndef O_DIRECT
 #define O_DIRECT 0
@@ -48,6 +50,86 @@ errcode_t ext2fs_mmp_get_mem(ext2_filsys fs, void **ptr)
 	return ext2fs_get_memalign(fs->blocksize, align, ptr);
 }
 
+#ifdef _WIN32
+static int ext2fs_mmp_open_device(ext2_filsys fs, int flags)
+{
+	return open(fs->device_name, flags);
+}
+#else
+static int ext2fs_mmp_open_device(ext2_filsys fs, int flags)
+{
+	struct stat stbuf;
+	char path[64];
+	int maybe_fd = -1;
+	int new_fd;
+	int ret;
+	errcode_t retval = 0;
+
+	/*
+	 * If we can't possibly be using the unixfd IO manager, open the device
+	 * a second time, which is the historical behavior.  This is a huge
+	 * and historic layering violation!
+	 *
+	 * It's also broken if the unixfd IO manager was passed a string with a
+	 * file descriptor number instead of a /dev/fd/XX path, but the
+	 * internet thinks there are no users of the manager outside of Google.
+	 */
+	if (!possible_unixfd_pathname(fs->device_name))
+		return open(fs->device_name, flags);
+
+	/*
+	 * Try to get the fd of the open block device.  If this fails for any
+	 * reason, fall back to the classic open path.
+	 */
+	retval = io_channel_get_fd(fs->io, &maybe_fd);
+	if (retval || maybe_fd < 0)
+		return open(fs->device_name, flags);
+
+	/*
+	 * We extracted the fd from the IO manager.
+	 *
+	 * Skip directio if this is a regular file, just ext2fs_mmp_read does.
+	 * Note that the O_DIRECT-clearing logic in the caller might not have
+	 * cleared the bit because it is path based.
+	 */
+	if (fstat(maybe_fd, &stbuf) == 0 && S_ISREG(stbuf.st_mode))
+		flags &= ~O_DIRECT;
+
+	/*
+	 * Try to reopen the same file descriptor, but with the new mode flags.
+	 * If that works then we're done.  Note that these magic symlinks do
+	 * not have to resolve anywhere.
+	 */
+	snprintf(path, sizeof(path), "/dev/fd/%d", maybe_fd);
+	new_fd = open(path, flags);
+	if (new_fd >= 0)
+		return new_fd;
+
+	/*
+	 * Reopening didn't work.  Instead, duplicate the file descriptor and
+	 * check that we actually got directio if that's required.  Note that
+	 * we can't change the mode on the IO channel's fd because we already
+	 * set it up for buffered IO.
+	 */
+	new_fd = dup(maybe_fd);
+	if (flags & O_DIRECT) {
+		ret = fcntl(new_fd, F_GETFL);
+		if (ret < 0 || !(ret & O_DIRECT)) {
+			close(new_fd);
+			return -1;
+		}
+	}
+
+	/*
+	 * The MMP fd shadows the io channel fd, so we must use that for all
+	 * MMP block accesses because the two fds share the same file position
+	 * and O_DIRECT state, and the iochannel must know about that.
+	 */
+	fs->flags2 |= EXT2_FLAG2_MMP_USE_IOCHANNEL;
+	return new_fd;
+}
+#endif
+
 errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 {
 #ifdef CONFIG_MMP
@@ -77,7 +159,7 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 		    S_ISREG(st.st_mode))
 			flags &= ~O_DIRECT;
 
-		fs->mmp_fd = open(fs->device_name, flags);
+		fs->mmp_fd = ext2fs_mmp_open_device(fs, flags);
 		if (fs->mmp_fd < 0) {
 			retval = EXT2_ET_MMP_OPEN_DIRECT;
 			goto out;
@@ -90,6 +172,15 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 			return retval;
 	}
 
+	if (fs->flags2 & EXT2_FLAG2_MMP_USE_IOCHANNEL) {
+		retval = io_channel_read_blk64(fs->io, mmp_blk, -fs->blocksize,
+					       fs->mmp_cmp);
+		if (retval)
+			return retval;
+
+		goto read_compare;
+	}
+
 	if ((blk64_t) ext2fs_llseek(fs->mmp_fd, mmp_blk * fs->blocksize,
 				    SEEK_SET) !=
 	    mmp_blk * fs->blocksize) {
@@ -102,6 +193,7 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 		goto out;
 	}
 
+read_compare:
 	mmp_cmp = fs->mmp_cmp;
 
 	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
@@ -428,6 +520,7 @@ errcode_t ext2fs_mmp_stop(ext2_filsys fs)
 
 mmp_error:
 	if (fs->mmp_fd >= 0) {
+		fs->flags2 &= ~EXT2_FLAG2_MMP_USE_IOCHANNEL;
 		close(fs->mmp_fd);
 		fs->mmp_fd = -1;
 	}
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index a9b1fac62a0250..567bbd9493f7f1 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1152,7 +1152,7 @@ static errcode_t unix_open_channel(const char *name, int fd,
 #define DEV_FD_PATH	"/dev/fd/"
 #define DEV_FD_PATHLEN	(sizeof(DEV_FD_PATH) - 1)
 
-static int possible_unixfd_pathname(const char *path)
+int possible_unixfd_pathname(const char *path)
 {
 	return strncmp(DEV_FD_PATH, path, DEV_FD_PATHLEN) == 0;
 }

