Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C1F3603EC;
	Wed, 22 Apr 2026 23:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900356; cv=none; b=sh8sIFCUZvXIlTWC6RRlU4TCavjz9cJ3uszjjuuoyn4xa3i3J701E2tDKAMhAGwEA+ykxd3+GTMOlnnx7Vsb/U8RcaPWNC5L/yw72tY5vwgMogtrbKWhncDlFO3Nb+WVMX0JdUB4yyt2RZIn8HE/g6KKH3izRAX2yB2cSHJ8qzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900356; c=relaxed/simple;
	bh=QvSSXDex8smHOkznZ+/6hUxMFthQJek3R92yjQYyDkg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJGMBnfOO+oun0J8+n+Ko/vZ74evBbrWmRB6L5tQOWJU8n2s4czewJb3swnJGQHPgC+OKq2/+AoKhXLfyIJL/kloVFjlbjHRCRiqI5H0pNr+jhfkm9MhZft3KQUyU8OPgmtVDehVT5g6zYzdUMDMcv2w5nmpSUwpyiZC7t9k4Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ro/WeVm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ro/WeVm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B91DC2BCAF;
	Wed, 22 Apr 2026 23:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900356;
	bh=QvSSXDex8smHOkznZ+/6hUxMFthQJek3R92yjQYyDkg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ro/WeVm7axKSDjSBFw0dE23ZOGbyfqkuLBdhS42Wgar7cetc/gzg+gG1+LaQMFKBu
	 4D+BAblkTmlxL4Ermgr0wwy8axHHKcnp016mOwPhWukHeG3QHHg+2w0VEgF7xvFKgS
	 TeYt1gjBQLGnTIHx9eSvnwWCTX3s9W7yghdBW5vriX4Snb8GSTpPW+26Ep+p9VCNgu
	 x4T+pTmpozGOM/T0ORW7eA97Q1OeejrY3HRqAeBifVjIu/vOy4HnGMijYBEI/UT3Oo
	 Jf6FCqqX89aJxZWTRnIjCRdoqtuwkR2DyMSAUG0sNhErHjNEdtGM3iO0a/j/S8bI9w
	 5/pM2/plQx+JA==
Date: Wed, 22 Apr 2026 16:25:56 -0700
Subject: [PATCH 09/10] fuse4fs: make MMP work correctly in safe service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com,
 miklos@szeredi.hu, bernd@bsbernd.com
Message-ID: <177689989700.3821326.9217649391848833281.stgit@frogsfrogsfrogs>
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

Normally, the libext2fs MMP code open()s a complete separate file
descriptor to read and write the MMP block so that it can have its own
private open file with its own access mode and file position.  However,
if the unixfd IO manager is in use, it will reuse the io channel, which
means that MMP and the unixfd share the same open file and hence the
access mode and file position.

MMP requires directio access to block devices so that changes are
immediately visible on other nodes.  Therefore, we need the IO channel
(and thus the filesystem) to be running in directio mode if MMP is in
use.

To make this work correctly with the sole unixfd IO manager user
(fuse4fs in unprivileged service mode), we must set O_DIRECT on the
bdev fd and mount the filesystem in directio mode.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index bf7c8ef9102a7a..dc5a0ede9f5072 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -1371,12 +1371,57 @@ static int fuse4fs_service_get_config(struct fuse4fs *ff)
 }
 
 static errcode_t fuse4fs_service_openfs(struct fuse4fs *ff, char *options,
-					int flags)
+					int *flags)
 {
+	struct stat statbuf;
 	char path[64];
+	errcode_t retval;
+	int ret;
 
+	ret = fstat(ff->bdev_fd, &statbuf);
+	if (ret)
+		return errno;
+
+	/*
+	 * Open the filesystem with SKIP_MMP so that we can find out if the
+	 * filesystem actually has MMP.
+	 */
 	snprintf(path, sizeof(path), "/dev/fd/%d", ff->bdev_fd);
-	return ext2fs_open2(path, options, flags, 0, 0, unixfd_io_manager,
+	retval = ext2fs_open2(path, options, *flags | EXT2_FLAG_SKIP_MMP, 0, 0,
+			      unixfd_io_manager, &ff->fs);
+	if (retval)
+		return retval;
+
+	/*
+	 * If the fs doesn't have MMP then we're good to go.  Otherwise close
+	 * the filesystem so that we can reopen it with MMP enabled.
+	 */
+	if (!ext2fs_has_feature_mmp(ff->fs->super))
+		return 0;
+
+	retval = ext2fs_close_free(&ff->fs);
+	if (retval)
+		return retval;
+
+	/*
+	 * If the filesystem is not on a regular file, MMP will share the same
+	 * fd as the unixfd IO channel.  We need to set O_DIRECT on the bdev_fd
+	 * and open the filesystem in directio mode.
+	 */
+	if (!S_ISREG(statbuf.st_mode)) {
+		int fflags = fcntl(ff->bdev_fd, F_GETFL);
+
+		if (!(fflags & O_DIRECT)) {
+			ret = fcntl(ff->bdev_fd, F_SETFL, fflags | O_DIRECT);
+			if (ret)
+				return EXT2_ET_MMP_OPEN_DIRECT;
+		}
+
+		ff->directio = 1;
+		*flags |= EXT2_FLAG_DIRECT_IO;
+	}
+
+	return ext2fs_open2(path, options, *flags, 0, 0, unixfd_io_manager,
 			    &ff->fs);
 }
 #else
@@ -1516,7 +1561,7 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 	deadline = init_deadline(FUSE4FS_OPEN_TIMEOUT);
 	do {
 		if (fuse4fs_is_service(ff))
-			err = fuse4fs_service_openfs(ff, options, flags);
+			err = fuse4fs_service_openfs(ff, options, &flags);
 		else
 			err = ext2fs_open2(ff->device, options, flags, 0, 0,
 					   unix_io_manager, &ff->fs);

