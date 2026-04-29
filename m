Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE102727FD;
	Wed, 29 Apr 2026 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474764; cv=none; b=sLmh8fVFzkdeeblgYbQkW8pteumA8J+B0mYaozUxMQZVVWlX6+af8V3AzQv5D/nIBHCVGIE5x5n2G9uiigkxaWR4oRXhR1WpQvEQwVu/KQ+tUNiMq8hfTzd41JXfKTWBi74e7/bvGuccszjJQRUNhzT4F76dU13FC4luwv45uEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474764; c=relaxed/simple;
	bh=sAg+jMx6YD6eqoJX5XoZZzpPwJpwojUTRHRoaD8KCU0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6B03fT+ejn/OVmupVleryZSla/K7T6UTon8e07Jai+Ayw7Y/7xXpdCCUrZex72TRz5xbbMCNYd8bKpdPLraCENhd84logPEf8Ipy3JCJ4RmnSicPFCXJ53GJu68ub+ybp70r7oKI2dYix6s1SGrpNAoGTIQHFkwKG/3XIgu3xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXEBIZYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXEBIZYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9781DC19425;
	Wed, 29 Apr 2026 14:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474764;
	bh=sAg+jMx6YD6eqoJX5XoZZzpPwJpwojUTRHRoaD8KCU0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HXEBIZYzWtKWatb/JlcmI3VRXq5Wd1kpnXGQrpxutSRNLOz/kfYChQ5YZex8VHxaX
	 QvYvGcHUYJC9KUqs+ciSk69oJ2Ufp8mTr4kgSA2iIuSOA2UMQOFMkBtfllAVG9g0Uj
	 Up+k4EW0+HcVTacFK5XPfZsbq0tnAbB8JQXM+U01jz+/GllmqiHJXiQc+hKhvi/iMT
	 vCnjD07GpYsAMojUK34Qu/e+eHMiPR41mqTEfAzvOAbuUzWnBsXIvNxkXG838BVd71
	 3/EJRYzHZGEp8Ev6ti6LQL24FPxnWO9jtETBkT9VlCCTIYhc1PvL6C6Gpg4dNvvDeA
	 Jj5Htj9Vbz/tw==
Date: Wed, 29 Apr 2026 07:59:24 -0700
Subject: [PATCH 03/10] fuse2fs: let the kernel tell us about acl/mode updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215436.4110156.1482399150715502059.stgit@frogsfrogsfrogs>
In-Reply-To: <177747215344.4110156.17216553139316774040.stgit@frogsfrogsfrogs>
References: <177747215344.4110156.17216553139316774040.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When the kernel is running in iomap mode, it will also manage all the
ACL updates and the resulting file mode changes for us.  Disable the
manual implementation of it in fuse2fs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |    4 ++--
 misc/fuse2fs.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 7163c440c9ee66..2020c6bc1e55db 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -2784,7 +2784,7 @@ static int fuse4fs_propagate_default_acls(struct fuse4fs *ff, ext2_ino_t parent,
 	size_t deflen;
 	int ret;
 
-	if (!ff->acl || S_ISDIR(mode))
+	if (!ff->acl || S_ISDIR(mode) || fuse4fs_iomap_enabled(ff))
 		return 0;
 
 	ret = fuse4fs_getxattr(ff, parent, XATTR_NAME_POSIX_ACL_DEFAULT, &def,
@@ -4210,7 +4210,7 @@ static int fuse4fs_chmod(struct fuse4fs *ff, fuse_req_t req, ext2_ino_t ino,
 	 * of the user's groups, but FUSE only tells us about the primary
 	 * group.
 	 */
-	if (!fuse4fs_is_superuser(ff, ctxt)) {
+	if (!fuse4fs_iomap_enabled(ff) && !fuse4fs_is_superuser(ff, ctxt)) {
 		ret = fuse4fs_in_file_group(ff, req, inode);
 		if (ret < 0)
 			return ret;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 670411c1117e44..6e19f5ae796127 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -2316,7 +2316,7 @@ static int propagate_default_acls(struct fuse2fs *ff, ext2_ino_t parent,
 	size_t deflen;
 	int ret;
 
-	if (!ff->acl || S_ISDIR(mode))
+	if (!ff->acl || S_ISDIR(mode) || fuse2fs_iomap_enabled(ff))
 		return 0;
 
 	ret = __getxattr(ff, parent, XATTR_NAME_POSIX_ACL_DEFAULT, &def,
@@ -3645,7 +3645,7 @@ static int op_chmod(const char *path, mode_t mode, struct fuse_file_info *fi)
 	 * of the user's groups, but FUSE only tells us about the primary
 	 * group.
 	 */
-	if (!is_superuser(ff, ctxt)) {
+	if (!fuse2fs_iomap_enabled(ff) && !is_superuser(ff, ctxt)) {
 		ret = in_file_group(ctxt, &inode);
 		if (ret < 0)
 			goto out;

