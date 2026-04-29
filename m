Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C812C237C;
	Wed, 29 Apr 2026 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474436; cv=none; b=Sn+P2C7712AXsEX2TEEmtUuC2ERHgB0djoxbojfFpRMVPqtYdlf3pD5oLHJjbLBTeQ0hl2feL/X1bp3L9w5R4hTIG5DC5AdUBNg+pNYOxMMaF7qifHLOjbeyhomVnTFLJqWHi7UWaLkOZqX07wQ7VPpkCTed3/aPgZ7Xxmpsjd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474436; c=relaxed/simple;
	bh=YP76nYhAtFv7urlVu7ot7GfWQzJEqUUzn7i0FChmjas=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/Dxv7lOPzVIZdSbhmskPfuOVyVRbK9uNtS31bwQ+8HqXd6D7tUcmzUQSQvJ9ZXB1J55++OngIUSeT4G2VGcp2pvICJmAGY3DAHM2GQT0YMKEwemvoaTln7g2od0qOSr52xsYA1NgJxbzMNPzVcZ0Pm5nNDK3HoiDw3HYQ8KHMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=svFnqYk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="svFnqYk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEB1C2BCB8;
	Wed, 29 Apr 2026 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474436;
	bh=YP76nYhAtFv7urlVu7ot7GfWQzJEqUUzn7i0FChmjas=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=svFnqYk/Ytah1uXoOByst9mELLZ9FAPlvcw/6x44Dkb6EYcGwZK26ATzlBZwuxDft
	 YNceHaf2DUIo2XtkddvfdbVJmTyjcEgEijFG9gqLtyzFCbvZo4zDDOeuRZWT1Oyz2Y
	 NwPH3lkVmH5/d3uFp6wVoyY2B4LPxTxWU6i4VSbybjQOE+fygyy21CPOpKm/0YL5fI
	 l44IOxESYSo7YsATM9hrQgNS69Yb/QgMKQp2h/cooy5nOZ/JMvPhsQ3fYEgtisG0jO
	 /sDbfWhDoUTKYGhp0lB5WD2HlvS1Fr9YRH+XjF+wX4zyS0QZzAUILo9cd5sd1d5GFm
	 /0w/c5xyeMwQA==
Date: Wed, 29 Apr 2026 07:53:55 -0700
Subject: [PATCH 05/19] fuse2fs: implement directio file reads
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214626.4107473.1244274603478834116.stgit@frogsfrogsfrogs>
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

Implement file reads via iomap.  Currently only directio is supported.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fuse4fs/fuse4fs.c |   14 +++++++++++++-
 misc/fuse2fs.c    |   14 +++++++++++++-
 2 files changed, 26 insertions(+), 2 deletions(-)


diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
index 3e9852f585302d..a1d931aed8f393 100644
--- a/fuse4fs/fuse4fs.c
+++ b/fuse4fs/fuse4fs.c
@@ -6370,7 +6370,19 @@ static int fuse4fs_iomap_begin_read(struct fuse4fs *ff, ext2_ino_t ino,
 				    uint64_t count, uint32_t opflags,
 				    struct fuse_file_iomap *read)
 {
-	return -ENOSYS;
+	if (!(opflags & FUSE_IOMAP_OP_DIRECT))
+		return -ENOSYS;
+
+	/* fall back to slow path for inline data reads */
+	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+		return -ENOSYS;
+
+	if (inode->i_flags & EXT4_EXTENTS_FL)
+		return fuse4fs_iomap_begin_extent(ff, ino, inode, pos, count,
+						  opflags, read);
+
+	return fuse4fs_iomap_begin_indirect(ff, ino, inode, pos, count,
+					    opflags, read);
 }
 
 static int fuse4fs_iomap_begin_write(struct fuse4fs *ff, ext2_ino_t ino,
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index c24ae461dad2ad..739867fa41dd91 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -5605,7 +5605,19 @@ static int fuse2fs_iomap_begin_read(struct fuse2fs *ff, ext2_ino_t ino,
 				    uint64_t count, uint32_t opflags,
 				    struct fuse_file_iomap *read)
 {
-	return -ENOSYS;
+	if (!(opflags & FUSE_IOMAP_OP_DIRECT))
+		return -ENOSYS;
+
+	/* fall back to slow path for inline data reads */
+	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+		return -ENOSYS;
+
+	if (inode->i_flags & EXT4_EXTENTS_FL)
+		return fuse2fs_iomap_begin_extent(ff, ino, inode, pos, count,
+						  opflags, read);
+
+	return fuse2fs_iomap_begin_indirect(ff, ino, inode, pos, count,
+					    opflags, read);
 }
 
 static int fuse2fs_iomap_begin_write(struct fuse2fs *ff, ext2_ino_t ino,

