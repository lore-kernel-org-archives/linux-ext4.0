Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54214314D15
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416346; cv=none; b=UP9yhmSJGxCG6OPcJv45PZqSoEzHXiEQH4LbqWl84OZYVWfqrOUaipm2CcMta6VNB0ILQH7eT/nejUL8EbsgTLHqxrtoIe+ugS8YRo94hNA6OvYfXrb98iBktVG5KxPKZKeePSKbTE2UPEpJB4S4Aygw6ikLdMJpQKXHbSOeF8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416346; c=relaxed/simple;
	bh=nug6uKHKCkkX9fFAcDoGMR49piT6uz7YSUyAStDmX4c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKUm5ipYsyXT8TkOsiLl8E51kcLk9aojvkfPrtOJMgLYETkNz8Y4uvi2MWu7zolmlUTNwTYWcSSY49FwFbkCS+KjTe7G8fI5qcDie9tjGQoMuOeg2EYTIa5yzOyk/PHBnWsps1e39nw0zX/h4edWzlAKW9xN2VuUIeMr4q57LFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UG83Uhi5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UG83Uhi5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E858D1F000E9;
	Thu, 25 Jun 2026 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416345;
	bh=0YZ8apnokee7fkYkKU93Wc/Qq4LAGQg6SNX0EVmsFwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=UG83Uhi5C03PJcG81c2w2Zyv2lGqVzrXiUkNeeGTBdfoTcsy++LX4LVFn8zTMm39q
	 QlJOJS5Cquy/oRic582RqTE0WTXpI0YTa1HJL7xvim5eVxqZ1lQo/bBrKUsgEVjlau
	 ep0PZXUYCX/yKLWi63WoPhevprbR0jMB7TgFr0nSBNLUhO28K+TMdjHXuKGcU0th8x
	 UdyDXLbniPIaKgxZozVc3jc6RJb0gQywPN/tdaYe/DVcBoxFsxB+ObfOSGFDoZXZSF
	 Qf1pgD1X4sJTymbR6TzLE3BI+Ah+hIdOjaElw48B4kG3QgBLNdDVzLqVP9vm66RZUU
	 br8DlKNyxdKTg==
Date: Thu, 25 Jun 2026 12:39:04 -0700
Subject: [PATCH 09/10] fuse4fs: make MMP work correctly in safe service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606974.1810414.9246244817707238835.stgit@frogsfrogsfrogs>
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
index 5fa51569a1167f..fdd4327a4c0907 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -1423,12 +1423,57 @@ static int fuse4fs_service_get_config(struct fuse4fs *ff)
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
@@ -1568,7 +1613,7 @@ static errcode_t fuse4fs_open(struct fuse4fs *ff)
 	deadline = init_deadline(FUSE4FS_OPEN_TIMEOUT);
 	do {
 		if (fuse4fs_is_service(ff))
-			err = fuse4fs_service_openfs(ff, options, flags);
+			err = fuse4fs_service_openfs(ff, options, &flags);
 		else
 			err = ext2fs_open2(ff->device, options, flags, 0, 0,
 					   unix_io_manager, &ff->fs);

