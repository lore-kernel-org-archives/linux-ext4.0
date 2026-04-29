Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901562FD1B3;
	Wed, 29 Apr 2026 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777474327; cv=none; b=HWlCu0CPvQsK2TWs8/cdwY9sNkR2trjjUTP43Hab52h9VD58xnXqS81Ux5gAtTk2xwcvn1hxUgulf2KpSwXlrcaMRc+FflWOGIe5R7XdERzfMHXg3gAL6LmDYnhY8ed8NncmdS6XFMNTcHh+SzBPA1roxjlb6wXZ1iP6KO8HW5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777474327; c=relaxed/simple;
	bh=1KARdzxxUJrI+FpDwGK2VOzeQ2Aa7m0wLpL5KCa75xo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QkQckknsSnCY5PUPNWcQYRbbLYD9ZgTUFaHLwuUzmZm2NfKq5c+KykKupVudPfuaV5/HzRCzoOEDrqqpd/U7rGeOLyKl4gKG2AhsRuBWvCG9bpwQFgPXZKEkRKgB27Z5dj7miom2MS0y4QSFLRproe+rmJKDzYFvLzi+WcwcNQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIuh+4oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIuh+4oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D65EC19425;
	Wed, 29 Apr 2026 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777474327;
	bh=1KARdzxxUJrI+FpDwGK2VOzeQ2Aa7m0wLpL5KCa75xo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nIuh+4ojYM3YuYl5TguGO+REt7UZcaqIR7PFAR/P8vQiavoIlsIJEUCjeCxr0BSBK
	 vv9lA/CGErxPMeLUxLRkdXy9YENH0GtjBAw5bycjnQNaJB0J8ukdO6YlqUjLRg92wi
	 guW4cZ9fK1kthJBnnZKxLYYC+bXZd5DSOEd/WVI3Cb9YncaCs1HXO3mRRjz37q98Zq
	 OLlzJHQA6nc+Jyn5bSEESlFSDfXDNoIL7vqPHlYH2Xt/axw9wHD5bdRmMTgx6IkPT4
	 EpuBLqMvl5hT3CJToms+WdSaA7w84ReAvuTHxIVZJoetvWK0frLPy7Q5iZQ0CBR2a7
	 4eKD/1kypQQ1g==
Date: Wed, 29 Apr 2026 07:52:06 -0700
Subject: [PATCH 3/5] libext2fs: allow unix_write_byte when the write would be
 aligned
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214291.4107228.16597858897977604442.stgit@frogsfrogsfrogs>
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

If someone calls write_byte on an IO channel with an alignment
requirement and the range to be written is aligned correctly, go ahead
and do the write.  This will be needed later when we try to speed up
superblock writes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/unix_io.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 35c42c35f735a3..ea8ee56b7d5163 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1599,7 +1599,9 @@ static errcode_t unix_write_byte(io_channel channel, unsigned long offset,
 #ifdef ALIGN_DEBUG
 		printf("unix_write_byte: O_DIRECT fallback\n");
 #endif
-		return EXT2_ET_UNIMPLEMENTED;
+		if (!IS_ALIGNED(data->offset + offset, channel->align) ||
+		    !IS_ALIGNED(data->offset + offset + size, channel->align))
+			return EXT2_ET_UNIMPLEMENTED;
 	}
 
 #ifndef NO_IO_CACHE

