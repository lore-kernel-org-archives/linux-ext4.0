Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EBA27EFE9;
	Wed, 29 Apr 2026 14:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474593; cv=none; b=hbpT7Jt73e0DLj7Ej5j/sedwQ1neLG5QAlvGDwmd7nl3F5/QtAK6lrl+Jq3/azsrIVXIPBxFpzHyW/gHxzOTX3cL3D2ZjXBvM6GoWYgCJsfHx9x2v73p1ySZ4eOF/18SpreN5rhJZG/qU6c7+8q3qtal8UPVoRG0F0a7LH0whNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474593; c=relaxed/simple;
	bh=GnRiRuVR7Zp8LfRFffmx59sd85sWQ5DzJxEwg3FAetE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jG+TWRlZw7OEqMhqXG0VJt90qHvmKVSzACaaM7WmOX/gaxIr7FxJ95zHSAhYQzJD75r16si2T7oC4yuzauQn94r3db5x7Zg7aoWeufNHZhlvfc3pJR8Aa7tSUjvqTbb00s6GUJjjzLAZ3/3ZXz+RHEZ5IpOgrnbAr4HLqdLgYHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WshfxKNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WshfxKNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2DFC19425;
	Wed, 29 Apr 2026 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474592;
	bh=GnRiRuVR7Zp8LfRFffmx59sd85sWQ5DzJxEwg3FAetE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WshfxKNkWu9Tey+8prwOyC35QnKYya7oAHn6ZWw+CW7Lz74Zz7kWAlBsls2skJFJj
	 4msStcUm/7Ig+Yk5u0VY3A1/DhgOGL7oNRhL22mXIM8UG+0vvLuw5n6ycJx/vw/vJU
	 GSiOnWDVBrRqK+EIxWhBqJdsSlCaX1EwCPwXJOawV6VMNFPsQAI4U2dlxoej2HOP7p
	 9CHjQZpaHDF0AZoKSgJ7NaqNxJ0SKr65kZjGyV/PNJSoNR3qE+vMDB108PqHsDVNjD
	 SD+zjWehc373+CYkLgTyHLs9YPo0vf+dVFrIERGoLNIWoP5C/DsZO6p7vZ1yOQl4Ln
	 F4zDibtF6SLig==
Date: Wed, 29 Apr 2026 07:56:32 -0700
Subject: [PATCH 15/19] fuse4fs: separate invalidation
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214804.4107473.6585738532314990412.stgit@frogsfrogsfrogs>
In-Reply-To: <177747214459.4107473.9520724883867588970.stgit@frogsfrogsfrogs>
References: <177747214459.4107473.9520724883867588970.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the new stuff

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/fuse2fs.c    |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index e92a85da0115ca..6016e23c511ac1 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -293,6 +293,9 @@ struct fuse4fs {
 	enum fuse4fs_iomap_state iomap_state;
 	uint32_t iomap_dev;
 	uint64_t iomap_cap;
+	void (*old_alloc_stats)(ext2_filsys fs, blk64_t blk, int inuse);
+	void (*old_alloc_stats_range)(ext2_filsys fs, blk64_t blk, blk_t num,
+				      int inuse);
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -6958,6 +6961,51 @@ static int fuse4fs_iomap_config_devices(struct fuse4fs *ff)
 	return 0;
 }
 
+static void fuse4fs_invalidate_bdev(struct fuse4fs *ff, blk64_t blk, blk_t num)
+{
+	off_t offset = FUSE4FS_FSB_TO_B(ff, blk);
+	off_t length = FUSE4FS_FSB_TO_B(ff, num);
+	int ret;
+
+	ret = fuse_lowlevel_iomap_device_invalidate(ff->fuse, ff->iomap_dev,
+						    offset, length);
+	if (!ret)
+		return;
+
+	if (num == 1)
+		err_printf(ff, "%s %llu: %s\n",
+			   _("error invalidating block"),
+			   (unsigned long long)blk,
+			   strerror(ret));
+	else
+		err_printf(ff, "%s %llu-%llu: %s\n",
+			   _("error invalidating blocks"),
+			   (unsigned long long)blk,
+			   (unsigned long long)blk + num - 1,
+			   strerror(ret));
+}
+
+static void fuse4fs_alloc_stats(ext2_filsys fs, blk64_t blk, int inuse)
+{
+	struct fuse4fs *ff = fs->priv_data;
+
+	if (inuse < 0)
+		fuse4fs_invalidate_bdev(ff, blk, 1);
+	if (ff->old_alloc_stats)
+		ff->old_alloc_stats(fs, blk, inuse);
+}
+
+static void fuse4fs_alloc_stats_range(ext2_filsys fs, blk64_t blk, blk_t num,
+				      int inuse)
+{
+	struct fuse4fs *ff = fs->priv_data;
+
+	if (inuse < 0)
+		fuse4fs_invalidate_bdev(ff, blk, num);
+	if (ff->old_alloc_stats_range)
+		ff->old_alloc_stats_range(fs, blk, num, inuse);
+}
+
 static void op_iomap_config(fuse_req_t req,
 			    const struct fuse_iomap_config_params *p,
 			    size_t psize)
@@ -7004,6 +7052,19 @@ static void op_iomap_config(fuse_req_t req,
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * If we let iomap do all file block IO, then we need to watch for
+	 * freed blocks so that we can invalidate any page cache that might
+	 * get written to the block deivce.
+	 */
+	if (fuse4fs_iomap_enabled(ff)) {
+		ext2fs_set_block_alloc_stats_callback(ff->fs,
+				fuse4fs_alloc_stats, &ff->old_alloc_stats);
+		ext2fs_set_block_alloc_stats_range_callback(ff->fs,
+				fuse4fs_alloc_stats_range,
+				&ff->old_alloc_stats_range);
+	}
+
 out_unlock:
 	fuse4fs_finish(ff, ret);
 	if (ret)
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index c922c7fb45d311..138346fcc4517f 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -276,6 +276,9 @@ struct fuse2fs {
 	enum fuse2fs_iomap_state iomap_state;
 	uint32_t iomap_dev;
 	uint64_t iomap_cap;
+	void (*old_alloc_stats)(ext2_filsys fs, blk64_t blk, int inuse);
+	void (*old_alloc_stats_range)(ext2_filsys fs, blk64_t blk, blk_t num,
+				      int inuse);
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -6278,6 +6281,50 @@ static int fuse2fs_iomap_config_devices(struct fuse2fs *ff)
 	return 0;
 }
 
+static void fuse2fs_invalidate_bdev(struct fuse2fs *ff, blk64_t blk, blk_t num)
+{
+	off_t offset = FUSE2FS_FSB_TO_B(ff, blk);
+	off_t length = FUSE2FS_FSB_TO_B(ff, num);
+	int ret;
+
+	ret = fuse_fs_iomap_device_invalidate(ff->iomap_dev, offset, length);
+	if (!ret)
+		return;
+
+	if (num == 1)
+		err_printf(ff, "%s %llu: %s\n",
+			   _("error invalidating block"),
+			   (unsigned long long)blk,
+			   strerror(ret));
+	else
+		err_printf(ff, "%s %llu-%llu: %s\n",
+			   _("error invalidating blocks"),
+			   (unsigned long long)blk,
+			   (unsigned long long)blk + num - 1,
+			   strerror(ret));
+}
+
+static void fuse2fs_alloc_stats(ext2_filsys fs, blk64_t blk, int inuse)
+{
+	struct fuse2fs *ff = fs->priv_data;
+
+	if (inuse < 0)
+		fuse2fs_invalidate_bdev(ff, blk, 1);
+	if (ff->old_alloc_stats)
+		ff->old_alloc_stats(fs, blk, inuse);
+}
+
+static void fuse2fs_alloc_stats_range(ext2_filsys fs, blk64_t blk, blk_t num,
+				      int inuse)
+{
+	struct fuse2fs *ff = fs->priv_data;
+
+	if (inuse < 0)
+		fuse2fs_invalidate_bdev(ff, blk, num);
+	if (ff->old_alloc_stats_range)
+		ff->old_alloc_stats_range(fs, blk, num, inuse);
+}
+
 static int op_iomap_config(const struct fuse_iomap_config_params *p,
 			   size_t psize, struct fuse_iomap_config *cfg)
 {
@@ -6322,6 +6369,19 @@ static int op_iomap_config(const struct fuse_iomap_config_params *p,
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * If we let iomap do all file block IO, then we need to watch for
+	 * freed blocks so that we can invalidate any page cache that might
+	 * get written to the block deivce.
+	 */
+	if (fuse2fs_iomap_enabled(ff)) {
+		ext2fs_set_block_alloc_stats_callback(ff->fs,
+				fuse2fs_alloc_stats, &ff->old_alloc_stats);
+		ext2fs_set_block_alloc_stats_range_callback(ff->fs,
+				fuse2fs_alloc_stats_range,
+				&ff->old_alloc_stats_range);
+	}
+
 out_unlock:
 	fuse2fs_finish(ff, ret);
 	return ret;

