Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E3E315793
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416175; cv=none; b=hdBJO+EFJHH8f/lKEY5fZn3RQwJf3OIOmVeA+mjppsH3oGNQpuAF5gkg5mRy82ADwY5Ce6SGlTRFofRxB1EbctjLlUNCVo0z9+bMwy3h9wEx5oklrlziFKzCKE6h2vb+VJx8A1VM7hkIOpggAdnKdZMjHw/SVYqNr8d8BO1+jkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416175; c=relaxed/simple;
	bh=CPVapfxOdzK79ldUNiY74kvv1H/1tR7u2G/bXa+WsOY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XlxqxfA1VdkW4V91W2C+VKAl8RXLNHCFoE1I5AkwOZEyVPkhaIT9tylMEhiRcTjhF7VbN+Igb0CgK7BYQzwj93QqSP8C+7RGoeEWbZT/BmIZuYy+h/4hVdlx7ybsyNp1Htx6ryLP3RCJHE776GMU/unhZPsnpW6LMcGORQL8jkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yw/7wr/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yw/7wr/K"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 138111F000E9;
	Thu, 25 Jun 2026 19:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416174;
	bh=eNF+9g03n9g4shmUdt4YwknMuc5b1mSLrquhXby7I+s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Yw/7wr/Kg/zJBamv1BRap1id0hgRV/+t5dqZ+EsevWODhZ0RkpPXl+qMLAbNpbnf7
	 LYj6u+jsMKIuWAoqPDCON6ahA45THcZIqB73bjVtBdKSV/zQ0AekYhNLQOHEwk2ZT4
	 MFmq2EVQc8WuT2dmjHt1muGGnR6P3TmhjNQTkzah1tZpxUNJdvHsmfx9MRtYuYi+kc
	 oM2RO/00i2X0hLP18r6rzOtf2c2+W13GmRxvnupJs/lUxHhlbGzKjzuviXKt+/OaQI
	 VMZD7/eDK5cfv6a+DGXU1UbdMdhu7xwzL8M0anCbd5FApBQMxAlgpUQ4zi6CAwQ8qR
	 +IHgaTV0Ks6uQ==
Date: Thu, 25 Jun 2026 12:36:13 -0700
Subject: [PATCH 1/3] libext2fs: always fsync the device when flushing the
 cache
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606599.1810243.4814097157374595875.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606573.1810243.8333361812351601871.stgit@frogsfrogsfrogs>
References: <178241606573.1810243.8333361812351601871.stgit@frogsfrogsfrogs>
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

