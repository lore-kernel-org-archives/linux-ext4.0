Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA84333445;
	Wed, 29 Apr 2026 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474420; cv=none; b=rjoIADsAbYDgwJS8HE4gYlGZvOz2+0RuuXEjH/SaSAU0CJvsharDl1P4H4nLdNka0toz81ZKN8ypXhA2TYoAUz4zDn4DRo04stlOjUx7rpDv38j2mwAUPMIFAxn6LoLUPc/1EQs1Byo/J3A7w3m93bIg+ejvRn5vZqDz3pfnS0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474420; c=relaxed/simple;
	bh=LaJ9Lq0EP/219RjzO8l2eoiRThp67IrIO2x77PHw9ZU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iuFfZXLcjSZEy1PrsyLOiohxi+QlURIkpPraRqKEB/eLgkim3yQ3emA6kmRy87Z4OtNMTkJt1nGqok9v0oJw9+DWCyOvdMPe0Ai7FahLLk0hijIKJLGeskvZYXZYlkOjvleGC/nDN9qvpRBR6yeKRmidPPUnw3/ZsXW5QLjR4fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7MAdUTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7MAdUTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BE0C19425;
	Wed, 29 Apr 2026 14:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474420;
	bh=LaJ9Lq0EP/219RjzO8l2eoiRThp67IrIO2x77PHw9ZU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m7MAdUTZ7SUoBVslnN7I7LmaLWWYt3HZtQWdlywDAmwW2+v2SDPuPkBWpl39Wp4uQ
	 wVif97tTfjJocphR+Uf6vaLu9uTIdrXussmugeCCuiMdnsGkSJiQUW2S+NufbjYvJk
	 o7hJqyUncXINT93WQOAsZa6DsxLtE4E5wmSGmz9+E72nhlfJ9O23qr2DVpIxjtm/kl
	 Z2Fnd1W7cl4maGRvYxBc9jduu3xy7RVEoo7QHvo9R2P/+iYiPsM7NvFdPicAw/XuCj
	 UnbgmfAVag73gfHQKYUew0Vl26JGuKkuKwrKsDKCad7TCxi5zIuZnmIMgitoL3RFa2
	 ddmVoA5BrWoYw==
Date: Wed, 29 Apr 2026 07:53:40 -0700
Subject: [PATCH 04/19] fuse2fs: register block devices for use with iomap
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214608.4107473.9714580127528968368.stgit@frogsfrogsfrogs>
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

Register the ext4 block device with the kernel for use with iomap.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 misc/fuse2fs.c    |   42 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 78 insertions(+), 8 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index feb46bdfbac39b..3e9852f585302d 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -284,6 +284,7 @@ struct fuse4fs {
 #ifdef HAVE_FUSE_IOMAP
 	enum fuse4fs_feature_toggle iomap_want;
 	enum fuse4fs_iomap_state iomap_state;
+	uint32_t iomap_dev;
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -6247,7 +6248,7 @@ static errcode_t fuse4fs_iomap_begin_extent(struct fuse4fs *ff, uint64_t ino,
 	}
 
 	/* Mapping overlaps startoff, report this. */
-	iomap->dev = FUSE_IOMAP_DEV_NULL;
+	iomap->dev = ff->iomap_dev;
 	iomap->addr = FUSE4FS_FSB_TO_B(ff, extent.e_pblk) + ff->offset;
 	iomap->offset = FUSE4FS_FSB_TO_B(ff, extent.e_lblk);
 	iomap->length = FUSE4FS_FSB_TO_B(ff, extent.e_len);
@@ -6280,13 +6281,14 @@ static int fuse4fs_iomap_begin_indirect(struct fuse4fs *ff, uint64_t ino,
 	if (err)
 		return translate_error(fs, ino, err);
 
-	iomap->dev = FUSE_IOMAP_DEV_NULL;
 	iomap->offset = FUSE4FS_FSB_TO_B(ff, startoff);
 	iomap->flags |= FUSE_IOMAP_F_MERGED;
 	if (startblock) {
+		iomap->dev = ff->iomap_dev;
 		iomap->addr = FUSE4FS_FSB_TO_B(ff, startblock) + ff->offset;
 		iomap->type = FUSE_IOMAP_TYPE_MAPPED;
 	} else {
+		iomap->dev = FUSE_IOMAP_DEV_NULL;
 		iomap->addr = FUSE_IOMAP_NULL_ADDR;
 		iomap->type = FUSE_IOMAP_TYPE_HOLE;
 	}
@@ -6506,6 +6508,30 @@ static off_t fuse4fs_max_size(struct fuse4fs *ff, off_t upper_limit)
 	return res;
 }
 
+static int fuse4fs_iomap_config_devices(struct fuse4fs *ff)
+{
+	errcode_t err;
+	int fd;
+	int ret;
+
+	err = io_channel_get_fd(ff->fs->io, &fd);
+	if (err)
+		return translate_error(ff->fs, 0, err);
+
+	ret = fuse_lowlevel_iomap_device_add(ff->fuse, fd, 0);
+	if (ret < 0) {
+		dbg_printf(ff, "%s: cannot register iomap dev fd=%d, err=%d\n",
+			   __func__, fd, -ret);
+		return translate_error(ff->fs, 0, -ret);
+	}
+
+	dbg_printf(ff, "%s: registered iomap dev fd=%d iomap_dev=%u\n",
+		   __func__, fd, ff->iomap_dev);
+
+	ff->iomap_dev = ret;
+	return 0;
+}
+
 static void op_iomap_config(fuse_req_t req,
 			    const struct fuse_iomap_config_params *p,
 			    size_t psize)
@@ -6513,6 +6539,7 @@ static void op_iomap_config(fuse_req_t req,
 	struct fuse_iomap_config cfg = { };
 	struct fuse4fs *ff = fuse4fs_get(req);
 	ext2_filsys fs;
+	int ret = 0;
 
 	FUSE4FS_CHECK_CONTEXT(req);
 
@@ -6547,8 +6574,16 @@ static void op_iomap_config(fuse_req_t req,
 	cfg.flags |= FUSE_IOMAP_CONFIG_MAXBYTES;
 	cfg.s_maxbytes = fuse4fs_max_size(ff, p->maxbytes);
 
-	fuse4fs_finish(ff, 0);
-	fuse_reply_iomap_config(req, &cfg);
+	ret = fuse4fs_iomap_config_devices(ff);
+	if (ret)
+		goto out_unlock;
+
+out_unlock:
+	fuse4fs_finish(ff, ret);
+	if (ret)
+		fuse_reply_err(req, -ret);
+	else
+		fuse_reply_iomap_config(req, &cfg);
 }
 #endif /* HAVE_FUSE_IOMAP */
 
@@ -7084,6 +7119,7 @@ int main(int argc, char *argv[])
 #ifdef HAVE_FUSE_IOMAP
 		.iomap_want = FT_DEFAULT,
 		.iomap_state = IOMAP_UNKNOWN,
+		.iomap_dev = FUSE_IOMAP_DEV_NULL,
 #endif
 	};
 	errcode_t err;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 7df4e127e5981a..c24ae461dad2ad 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -40,6 +40,7 @@
 # define _FILE_OFFSET_BITS 64
 #endif /* _FILE_OFFSET_BITS */
 #include <fuse.h>
+#include <fuse_lowlevel.h>
 #ifdef __SET_FOB_FOR_FUSE
 # undef _FILE_OFFSET_BITS
 #endif /* __SET_FOB_FOR_FUSE */
@@ -266,6 +267,7 @@ struct fuse2fs {
 #ifdef HAVE_FUSE_IOMAP
 	enum fuse2fs_feature_toggle iomap_want;
 	enum fuse2fs_iomap_state iomap_state;
+	uint32_t iomap_dev;
 #endif
 	unsigned int blockmask;
 	unsigned long offset;
@@ -5481,7 +5483,7 @@ static errcode_t fuse2fs_iomap_begin_extent(struct fuse2fs *ff, uint64_t ino,
 	}
 
 	/* Mapping overlaps startoff, report this. */
-	iomap->dev = FUSE_IOMAP_DEV_NULL;
+	iomap->dev = ff->iomap_dev;
 	iomap->addr = FUSE2FS_FSB_TO_B(ff, extent.e_pblk) + ff->offset;
 	iomap->offset = FUSE2FS_FSB_TO_B(ff, extent.e_lblk);
 	iomap->length = FUSE2FS_FSB_TO_B(ff, extent.e_len);
@@ -5514,13 +5516,14 @@ static int fuse2fs_iomap_begin_indirect(struct fuse2fs *ff, uint64_t ino,
 	if (err)
 		return translate_error(fs, ino, err);
 
-	iomap->dev = FUSE_IOMAP_DEV_NULL;
 	iomap->offset = FUSE2FS_FSB_TO_B(ff, startoff);
 	iomap->flags |= FUSE_IOMAP_F_MERGED;
 	if (startblock) {
+		iomap->dev = ff->iomap_dev;
 		iomap->addr = FUSE2FS_FSB_TO_B(ff, startblock) + ff->offset;
 		iomap->type = FUSE_IOMAP_TYPE_MAPPED;
 	} else {
+		iomap->dev = FUSE_IOMAP_DEV_NULL;
 		iomap->addr = FUSE_IOMAP_NULL_ADDR;
 		iomap->type = FUSE_IOMAP_TYPE_HOLE;
 	}
@@ -5739,11 +5742,36 @@ static off_t fuse2fs_max_size(struct fuse2fs *ff, off_t upper_limit)
 	return res;
 }
 
+static int fuse2fs_iomap_config_devices(struct fuse2fs *ff)
+{
+	errcode_t err;
+	int fd;
+	int ret;
+
+	err = io_channel_get_fd(ff->fs->io, &fd);
+	if (err)
+		return translate_error(ff->fs, 0, err);
+
+	ret = fuse_fs_iomap_device_add(fd, 0);
+	if (ret < 0) {
+		dbg_printf(ff, "%s: cannot register iomap dev fd=%d, err=%d\n",
+			   __func__, fd, -ret);
+		return translate_error(ff->fs, 0, -ret);
+	}
+
+	dbg_printf(ff, "%s: registered iomap dev fd=%d iomap_dev=%u\n",
+		   __func__, fd, ff->iomap_dev);
+
+	ff->iomap_dev = ret;
+	return 0;
+}
+
 static int op_iomap_config(const struct fuse_iomap_config_params *p,
 			   size_t psize, struct fuse_iomap_config *cfg)
 {
 	struct fuse2fs *ff = fuse2fs_get();
 	ext2_filsys fs;
+	int ret = 0;
 
 	FUSE2FS_CHECK_CONTEXT(ff);
 
@@ -5778,8 +5806,13 @@ static int op_iomap_config(const struct fuse_iomap_config_params *p,
 	cfg->flags |= FUSE_IOMAP_CONFIG_MAXBYTES;
 	cfg->s_maxbytes = fuse2fs_max_size(ff, p->maxbytes);
 
-	fuse2fs_finish(ff, 0);
-	return 0;
+	ret = fuse2fs_iomap_config_devices(ff);
+	if (ret)
+		goto out_unlock;
+
+out_unlock:
+	fuse2fs_finish(ff, ret);
+	return ret;
 }
 #endif /* HAVE_FUSE_IOMAP */
 
@@ -6145,6 +6178,7 @@ int main(int argc, char *argv[])
 #ifdef HAVE_FUSE_IOMAP
 		.iomap_want = FT_DEFAULT,
 		.iomap_state = IOMAP_UNKNOWN,
+		.iomap_dev = FUSE_IOMAP_DEV_NULL,
 #endif
 	};
 	errcode_t err;

