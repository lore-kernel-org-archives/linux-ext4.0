Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2B62727FD;
	Wed, 29 Apr 2026 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474780; cv=none; b=Fiwx55n8PTCuSQZIZLLxPIEF2xzc5KAeXhhKW4Q3yWTW8Ji7MNCKtUSrU2Q4ld2ACRv650QKAUXjaU1RS/5AOY3p89u/CPNTYKbzn5nr3swi2pnZVzI5xmYjZeFaQ0xO+C9gKXubZPm/fLLk3EtOzR42h/Q+t1GNVT3+Y6U9APA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474780; c=relaxed/simple;
	bh=hEP8fOPKq3QT+M6toifCIzWnr8DQVR+aVNgkMEhoEY4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CanzSxOYEG0sEYhnMy9CpW6Amr6MaD35o52GnxhvQ5kKE+UzZcHR7Ui0Mogauzo6RVqI2Jr2iWmIeTZqOjLiAs6EkYCBBJYgiKs1zzZZxJ9V9T8X19JGQKZIqD/ldLaS4ULTwRUhP63Gfs7BM9RMr5eVwMz0V0UaoILo4Nckt3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUQHZ6GT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUQHZ6GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7BCC19425;
	Wed, 29 Apr 2026 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474780;
	bh=hEP8fOPKq3QT+M6toifCIzWnr8DQVR+aVNgkMEhoEY4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DUQHZ6GTbCJQZldoZmuLCSnErBldnoYe4uDhuOng7iUy0AB8+AfnaDl1OJR+dM46S
	 JTOLEh9WNhX0FK7TiQrr7V/OhUt4ivgg/GIUqmkYXAz8Vsc3RUSZNDbiAP//crH7vu
	 lt59bMuV3otibifAd2kt1nMFpNlm/vje+eZ65NpM3/C/Ze0kHHSeyZFp7iXol376be
	 GlCIKAtH/inGtWfBiNIkFldlJERisklVQCG+Ot1FwEye/NxeXEwI3q0GHMeDatL6df
	 CEl34BP6FVS8PXEFr8GOr5LT3ROdE3eAQIQ4Y89CfZZ/KzPHE8k0WOmAU6sCJZaWvj
	 HEuoHk6RFJ/hg==
Date: Wed, 29 Apr 2026 07:59:39 -0700
Subject: [PATCH 04/10] fuse2fs: better debugging for file mode updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747215454.4110156.18424909699837496304.stgit@frogsfrogsfrogs>
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

Improve the tracing of a chmod operation so that we can debug file mode
updates.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   10 ++++++----
 misc/fuse2fs.c    |   12 +++++++-----
 2 files changed, 13 insertions(+), 9 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 2020c6bc1e55db..567b576e5f5779 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -4193,6 +4193,7 @@ static int fuse4fs_chmod(struct fuse4fs *ff, fuse_req_t req, ext2_ino_t ino,
 			 mode_t mode, struct ext2_inode_large *inode)
 {
 	const struct fuse_ctx *ctxt = fuse_req_ctx(req);
+	mode_t new_mode;
 	int ret = 0;
 
 	dbg_printf(ff, "%s: ino=%d mode=0%o\n", __func__, ino, mode);
@@ -4219,11 +4220,12 @@ static int fuse4fs_chmod(struct fuse4fs *ff, fuse_req_t req, ext2_ino_t ino,
 			mode &= ~S_ISGID;
 	}
 
-	inode->i_mode &= ~0xFFF;
-	inode->i_mode |= mode & 0xFFF;
+	new_mode = (inode->i_mode & ~0xFFF) | (mode & 0xFFF);
 
-	dbg_printf(ff, "%s: ino=%d new_mode=0%o\n",
-		   __func__, ino, inode->i_mode);
+	dbg_printf(ff, "%s: ino=%d old_mode=0%o new_mode=0%o\n",
+		   __func__, ino, inode->i_mode, new_mode);
+
+	inode->i_mode = new_mode;
 
 	return 0;
 }
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 6e19f5ae796127..2e0fdeda963de2 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -3616,6 +3616,7 @@ static int op_chmod(const char *path, mode_t mode, struct fuse_file_info *fi)
 	errcode_t err;
 	ext2_ino_t ino;
 	struct ext2_inode_large inode;
+	mode_t new_mode;
 	int ret = 0;
 
 	FUSE2FS_CHECK_CONTEXT(ff);
@@ -3654,11 +3655,12 @@ static int op_chmod(const char *path, mode_t mode, struct fuse_file_info *fi)
 			mode &= ~S_ISGID;
 	}
 
-	inode.i_mode &= ~0xFFF;
-	inode.i_mode |= mode & 0xFFF;
+	new_mode = (inode.i_mode & ~0xFFF) | (mode & 0xFFF);
 
-	dbg_printf(ff, "%s: path=%s new_mode=0%o ino=%d\n", __func__,
-		   path, inode.i_mode, ino);
+	dbg_printf(ff, "%s: path=%s old_mode=0%o new_mode=0%o ino=%d\n",
+		   __func__, path, inode.i_mode, new_mode, ino);
+
+	inode.i_mode = new_mode;
 
 	ret = update_ctime(fs, ino, &inode);
 	if (ret)
@@ -3678,12 +3680,12 @@ static int op_chmod(const char *path, mode_t mode, struct fuse_file_info *fi)
 static int op_chown(const char *path, uid_t owner, gid_t group,
 		    struct fuse_file_info *fi)
 {
+	struct ext2_inode_large inode;
 	struct fuse_context *ctxt = fuse_get_context();
 	struct fuse2fs *ff = fuse2fs_get();
 	ext2_filsys fs;
 	errcode_t err;
 	ext2_ino_t ino;
-	struct ext2_inode_large inode;
 	int ret = 0;
 
 	FUSE2FS_CHECK_CONTEXT(ff);

