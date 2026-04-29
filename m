Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E232727FD;
	Wed, 29 Apr 2026 14:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474311; cv=none; b=KuwH10LFMeu8HMnBe6Y/8MzJgiWbqfWOsgna1L8xJcfAhOxH6GDlvxrrYe5j2IJPGskA0iUEjcaI31TKfBQDnduSU20t+QdyiExMNRncfOx2z1K/PLp5m5HsGpJsj6gNbnHAEeNk6lWePP+lAIYGGm5j0BoBdzrvqg9uYB+hLhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474311; c=relaxed/simple;
	bh=225/Iat5rTiduRfqL5FozIIZ6Jf/RUepA27A7FwcgQ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hz5DeCc7ujINthrGjfh17ErrWcqHyprXRrujWqz+bbCwHEzF57KQI2uAr0/aJWGHrvttJxwMIfaEYJnyqYCbvi8UyUseKMPlVGrI4QXOGJbRIZIIXDexU/QYYUk6PNV93ahDXKiOx+q1rex2fZoTigNaqST4glnhe6owiZVuAjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKNf+hrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKNf+hrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8433EC19425;
	Wed, 29 Apr 2026 14:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474311;
	bh=225/Iat5rTiduRfqL5FozIIZ6Jf/RUepA27A7FwcgQ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eKNf+hrDsp0vYpVvyziEDvLKSnrt1ruUtiR72IgeRsUIRZYt8p/aTtSMKVSTs4yli
	 B1/R66ODQeO7RteUsLuqRBRJ+vWR32z6VGbJ1xdchvtGUGPrZP8ZU0K73dYBmbgp0r
	 ov2xX7EWnUcDFTgpnBLgNYYdyCTkmRkame7pFE6bSobOZM8wdChkeLC+OATx+xr5we
	 TMng0qB9tDZROehSmiLf7zgLBHCDtz21oqnbGRnqc4Fy7lxYEJoXHCu8R97yXMiX/Z
	 WAFE6XtvUdRfN0scA7rzp1YnE7Qn1KKH+0KvgUlWC90MfaTMlneALINB3Td2T/tKLW
	 wUfx4vkEg1BQg==
Date: Wed, 29 Apr 2026 07:51:51 -0700
Subject: [PATCH 2/5] libext2fs: only flush affected blocks in unix_write_byte
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214274.4107228.2148742246580255983.stgit@frogsfrogsfrogs>
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

There's no need to invalidate the entire cache when writing a range of
bytes to the device.  The only ones we need to invalidate are the ones
that we're writing separately.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/unix_io.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 54bd4b5597ea9e..35c42c35f735a3 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1588,6 +1588,7 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 {
 	struct unix_private_data *data;
 	errcode_t	retval = 0;
+	unsigned long long bno, nbno;
 	ssize_t		actual;
 
 	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
@@ -1603,10 +1604,17 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 
 #ifndef NO_IO_CACHE
 	/*
-	 * Flush out the cache completely
+	 * Flush all the dirty blocks, then invalidate the blocks we're about
+	 * to write.
 	 */
-	if ((retval = flush_cached_blocks(channel, data, FLUSH_INVALIDATE)))
+	retval = flush_cached_blocks(channel, data, 0);
+	if (retval)
 		return retval;
+
+	bno = offset / channel->block_size;
+	nbno = (offset + size + channel->block_size - 1) / channel->block_size;
+
+	invalidate_cached_blocks(channel, data, bno, nbno - bno);
 #endif
 
 	if (lseek(data->dev, offset + data->offset, SEEK_SET) < 0)

