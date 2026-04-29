Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F24336882;
	Wed, 29 Apr 2026 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474343; cv=none; b=OUIrPl/PoMdUHKo1dNCLeH6Bs1IdQWMKCDmmAU4thevb/Hdj/+u7tkF/btqddEheCsJ1utdd18nDOqgYuJQN/4SVjrpNvOJ0luBK/hy7FMxw6QbxyrZjaoOyjoAM8Mg0HSno2K/h0Af7hOEZmPfMYRECnadoi7lLq8cq10+F4Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474343; c=relaxed/simple;
	bh=Wd58/HTDfiC2J68MaW3ctW3aBj8z9vdubkYZGtDC1WI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gP1SFoF49oV4cOCTbiZKA2lQsO3jfTJjeJTOxGB2jY59DokYWU21cW0JRQqljJ0V4QGl3yw+k19FDHpuUMPhQI5HYwmHM+3wVskEysw8E9cNKgG12R+d0cOi26e1L12rQei6o95G30gIxg9iiSdvn0WPH14+Tr/CGmuQ/r811ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=auxbytEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="auxbytEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E2AC19425;
	Wed, 29 Apr 2026 14:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474342;
	bh=Wd58/HTDfiC2J68MaW3ctW3aBj8z9vdubkYZGtDC1WI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=auxbytEGp3aPhQ/b4diJ8i49oYRznFmb3R44OJvY3qTIdDOq0pN3zW10Qctg/9owu
	 qvKnEBurGnW0CZtzhg+FZ3IKAZhEQsQMXMEgao/O1SXwi57ZZH1MvblQ04yGHwVq87
	 qfqWCOBijr7dxuAZtwNaKwSPaofN99JOq2YwkB+8ZWB8OO8jvwh13N04M3QBLs0uTc
	 UCDz3YRkCorD0EocdkCGzn0gXePEbt4xJvdg4SCKxudF6ISVE5JiKMueDy2AIEYe7k
	 HzWpRLKF+/Bc9bXHGeCis0f11iBtTV5BZQWQrwRa53zq+S+BpfNAzA7S04nlWWVhks
	 NF630I2REGSyA==
Date: Wed, 29 Apr 2026 07:52:22 -0700
Subject: [PATCH 4/5] libext2fs: allow clients to ask to write full superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214309.4107228.9356150208209169953.stgit@frogsfrogsfrogs>
In-Reply-To: <177747214224.4107228.16300103064218258692.stgit@frogsfrogsfrogs>
References: <177747214224.4107228.16300103064218258692.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

write_primary_superblock currently does this weird dance where it will
try to write only the dirty bytes of the primary superblock to disk.  In
theory, this is done so that tune2fs can incrementally update superblock
bytes when the filesystem is mounted; ext2 was famous for allowing using
this dance to set new fs parameters and have them take effect in real
time.

The ability to do this safely was obliterated back in 2001 when ext3 was
introduced with journalling, because tune2fs has no way to know if the
journal has already logged an updated primary superblock but not yet
written it to disk, which means that they can race to write, and changes
can be lost.

This (non-)safety was further obliterated back in 2012 when I added
checksums to all the metadata blocks in ext4 because anyone else with
the block device open can see the primary superblock in an intermediate
state where the checksum does not match the superblock contents.

At this point in 2025 it's kind of stupid for fuse2fs to be doing this
because you can't have the kernel and fuse2fs mount the same filesystem
at the same time.  It also makes fuse2fs op_fsync slow because libext2fs
performs a bunch of small writes and introduce extra fsyncs.

So, add a new flag to ask for full superblock writes, which fuse2fs will
use later.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/ext2fs.h  |    1 +
 lib/ext2fs/closefs.c |    7 +++++++
 2 files changed, 8 insertions(+)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 02c3cbcea92482..8fad4c4011dd5a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -220,6 +220,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_IBITMAP_TAIL_PROBLEM	0x2000000
 #define EXT2_FLAG_THREADS		0x4000000
 #define EXT2_FLAG_IGNORE_SWAP_DIRENT	0x8000000
+#define EXT2_FLAG_WRITE_FULL_SUPER	0x10000000
 
 /*
  * Internal flags for use by the ext2fs library only
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 8e5bec03a050de..9a67db76e7b326 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -196,6 +196,13 @@ static errcode_t write_primary_superblock(ext2_filsys fs,
 	int		check_idx, write_idx, size;
 	errcode_t	retval;
 
+	if (fs->flags & EXT2_FLAG_WRITE_FULL_SUPER) {
+		retval = io_channel_write_byte(fs->io, SUPERBLOCK_OFFSET,
+					       SUPERBLOCK_SIZE, super);
+		if (!retval)
+			return 0;
+	}
+
 	if (!fs->io->manager->write_byte || !fs->orig_super) {
 	fallback:
 		io_channel_set_blksize(fs->io, SUPERBLOCK_OFFSET);

