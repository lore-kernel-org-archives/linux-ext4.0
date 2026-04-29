Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6798A2727FD;
	Wed, 29 Apr 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474358; cv=none; b=C1g9q1alRmyh3mU2gXHGNxXlJslsUKj19s3Vz0mbLBHrAVT5cSIuU1IC+SMSsazUYsX5BW6jGU4M96SxC3WdksYDPTVPJ8DhbFQ2VytPHZPB0WY/iqRf0fYfoFmRVPayvY9Clw2wru0I3gKHqwHo8WLZ2Yyq3/osMwqj5c+ELdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474358; c=relaxed/simple;
	bh=d8YWgFo6RU7h+KnbJt1EGpteSqV25oyVcW8p2ugZDgo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C4XgNGLCUn/9vYJ4lZEjch6NkcmzirWTRZVly3fGml4+P0Yve+y8VuBXhJAJE4tUEsH8z8KiYRzeBSAkGejILTN4U5VyYqtqnKNLKk5U5mWaihfLOArwduHUE2cHOUqFc2WRjP/m+AI50lEjZrfQm4xbwbGiaBzFl7L6qglx/h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYREVN6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYREVN6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419EBC19425;
	Wed, 29 Apr 2026 14:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474358;
	bh=d8YWgFo6RU7h+KnbJt1EGpteSqV25oyVcW8p2ugZDgo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sYREVN6SyYuO7Lsqv3M0OlFkMXvPeXz2YP9bB3r7J0ltI+uBIPB2/ard6igC0/8VI
	 /zxC/9Tj+Y3WUGvHRpBiath9f1LdqdlySi6FQLpAtcxoi8TYJwmGoOY+sHbEIl8c00
	 4+eVLsnF9bchhRCmds1eQA1X0XPvUim1jcfoIaZL3kzNZbOe/RE2xHGKYk55gYikbL
	 qoS8WejX7KSGdoCtWQREORUbJ44ob9LrBoasZTsb15/kRBLTbUEqVEm6U966KbHwkR
	 STk2iL62d3hELIbYFPk/ibu6IbSR2oi3RX7/kABCcueUbZga0eAntgrEGdHf40D7VQ
	 QSVEIuhG/FvBg==
Date: Wed, 29 Apr 2026 07:52:37 -0700
Subject: [PATCH 5/5] libext2fs: allow callers to disallow I/O to file data
 blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214327.4107228.3239123429130995999.stgit@frogsfrogsfrogs>
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

Add a flag to ext2_file_t to disallow read and write I/O to file data
blocks.  This supports fuse2fs iomap support, which will keep all the
file data I/O inside the kerne.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/ext2fs.h |    3 +++
 lib/ext2fs/fileio.c |   12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 8fad4c4011dd5a..23b0695a32d150 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -178,6 +178,9 @@ typedef struct ext2_struct_dblist *ext2_dblist;
 #define EXT2_FILE_WRITE		0x0001
 #define EXT2_FILE_CREATE	0x0002
 
+/* no file I/O to disk blocks, only to inline data */
+#define EXT2_FILE_NOBLOCKIO	0x0004
+
 #define EXT2_FILE_MASK		0x00FF
 
 #define EXT2_FILE_BUF_DIRTY	0x4000
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 3a36e9e7fff43b..95ee45ec7371ae 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -314,6 +314,11 @@ errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
 	if (file->inode.i_flags & EXT4_INLINE_DATA_FL)
 		return ext2fs_file_read_inline_data(file, buf, wanted, got);
 
+	if (file->flags & EXT2_FILE_NOBLOCKIO) {
+		retval = EXT2_ET_OP_NOT_SUPPORTED;
+		goto fail;
+	}
+
 	while ((file->pos < EXT2_I_SIZE(&file->inode)) && (wanted > 0)) {
 		retval = sync_buffer_position(file);
 		if (retval)
@@ -441,6 +446,11 @@ errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
 		retval = 0;
 	}
 
+	if (file->flags & EXT2_FILE_NOBLOCKIO) {
+		retval = EXT2_ET_OP_NOT_SUPPORTED;
+		goto fail;
+	}
+
 	while (nbytes > 0) {
 		retval = sync_buffer_position(file);
 		if (retval)
@@ -609,7 +619,7 @@ static errcode_t ext2fs_file_zero_past_offset(ext2_file_t file,
 	int ret_flags;
 	errcode_t retval;
 
-	if (off == 0)
+	if (off == 0 || (file->flags & EXT2_FILE_NOBLOCKIO))
 		return 0;
 
 	retval = sync_buffer_position(file);

