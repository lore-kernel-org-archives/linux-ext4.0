Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B1C352FA5
	for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900180; cv=none; b=l5Hvw1mRr4RXPn24wSup7YX1sU9WeJsiQ0vWoFT4ah8mYMmizUOywLXmwh1r4vKUGudHy/2mLBy6WhQ+vX/H4xjAnYKekSrNrX86gZMbyd7gzskLOpi0FzJyYT8ksizUB1wsj/mCLZSqKwq2AoIXRdKXtmkAJI9HeqjhOjgf/z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900180; c=relaxed/simple;
	bh=CPVapfxOdzK79ldUNiY74kvv1H/1tR7u2G/bXa+WsOY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xi0DYq06z2m+S59EavmR9p2qQGIXmgXmejDjHGJnarTGOP+NVxR/mTB7+tS0IYrxOgPrqx8XNdZMVSXlLrjHRO9v7KtD5wQqitj6TDpiWNUsObWPdEZG5A6gT4p/Isd6c3hQpONdJZ+xy1uB15WNltjITQrWuuTC2VU6BrE4QwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMXiyJoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMXiyJoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B231BC19425;
	Wed, 22 Apr 2026 23:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900180;
	bh=CPVapfxOdzK79ldUNiY74kvv1H/1tR7u2G/bXa+WsOY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UMXiyJoYx7Wm4SnpdytNjjZ6YYcDzaN+BluosFU/HIFrQa6VCbHyC9czldV4De8UB
	 Zk6WEbVaaV35e/xz+AV+fV5Qx0sFdPxD2LWV1klCmc5hw0Mf+30eB7ofZaGypDP8um
	 xiF+NDVXBKH5YRtwKaIVnBRq6qoVzqm1Xbvs4FsLLd4mTtiBi87LjOXDikmCvrmPHw
	 8dgqqwfBZ77J5vymlHHVf3k96ZpqgFtvMewrXB4KTsPZUY/Xo4Mrndo2wwW/YlXwwS
	 +ZVedQ+7ak37pp0ZxRgA3gZKc8wQuEXssJjm1Ci90NX9BZ+FlDE4fb+ZEK1lOgglXd
	 Lbh2UT0S8Y47A==
Date: Wed, 22 Apr 2026 16:23:00 -0700
Subject: [PATCH 1/3] libext2fs: always fsync the device when flushing the
 cache
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <177689989330.3821152.4019461882726051373.stgit@frogsfrogsfrogs>
In-Reply-To: <177689989303.3821152.12873703999139555043.stgit@frogsfrogsfrogs>
References: <177689989303.3821152.12873703999139555043.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're flushing the unix IO manager's buffer cache, we should always
fsync the block device, because something could have written to the
block device -- either the buffer cache itself, or a direct write.
Regardless, the callers all want all dirtied regions to be persisted to
stable media.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/unix_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index abd33ba839f7e9..b6feebef93fa5b 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1531,7 +1531,8 @@ static errcode_t unix_flush(io_channel channel)
 	retval = flush_cached_blocks(channel, data, 0);
 #endif
 #ifdef HAVE_FSYNC
-	if (!retval && fsync(data->dev) != 0)
+	/* always fsync the device, even if flushing our own cache failed */
+	if (fsync(data->dev) != 0 && !retval)
 		return errno;
 #endif
 	return retval;

