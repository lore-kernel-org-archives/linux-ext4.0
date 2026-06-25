Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1741623ED60
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416191; cv=none; b=ZKIYSEwTBbBh0jXA6tnY1t5yiCZTcHNXyuo0pqKQZMiTAFkKobw+B5PCqEUrXXT87vUKFLBEDxKvdIpNWxtxhpJ2HzHQR2eTb2ElNk2kdWLJLtcbEknX1+a7kbaQhQ4QcRQyHmwY6mf4yikXJiJm+KU79ettltOfrYP8q7ioh/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416191; c=relaxed/simple;
	bh=tYjdQr2/vAzZdBYLwrROdv3cE7IwQkoXgESSj1yoLFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQHKvYUQDX1fv8rRhTgh6cmBOP0BqzygBnk6dsGrbz3MxRwr26kAaVT+gca+EEmdqrxX15JS2UETcHgWEZ2LXVYX0BXwFmV1EneFTv8+KaS4yI6s85wmAOKmQcMoSE8RYAHCjjmuFaQAjlA9lQK0pr7odoKsieXTTDWYx+mhZTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=US4RgifE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="US4RgifE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 914C31F000E9;
	Thu, 25 Jun 2026 19:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416189;
	bh=GfyB2arjNO3+aqpifGZZ2rnT17rZVR6BAIUgDn2yd68=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=US4RgifE4oQ4h17yjxxoj1QLBuhtC/Hdf7NarP3wPxHnxJqPmZWFlMGJjZ+tWnOJP
	 8BZ146yH7oOr+3yDIjSYurUKcFAr6xMth0LupVRXAoBm5n6weMCTYFkd1qgpd1h10B
	 NiKdB/HuRLnR+7wgSk5tT5AhH7cirX7U6axkt9kBqRNgn4m8e3AuDkB7hIdqd0IsB2
	 xTUwvjlvwXNqwj1Wd/EdU/Q4M2HXe+Fqss4+GixelXMOSjYPzCYBzKLQMroPgCNsdp
	 Xv5AjfSxNXbO7x2oARNM/R5WodZAmfFaE8HiQUF7vQLgOgkTLvlR8AeCGOp5aCD2G2
	 y9fG/fyjh4dGA==
Date: Thu, 25 Jun 2026 12:36:29 -0700
Subject: [PATCH 2/3] libext2fs: always fsync the device when closing the unix
 IO manager
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606617.1810243.15496338605560013765.stgit@frogsfrogsfrogs>
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

unix_close is the last chance that libext2fs has to report write
failures to users.  Although it's likely that ext2fs_close already
called ext2fs_flush and told the IO manager to flush, we could do one
more sync before we close the file descriptor.  Also don't override the
fsync's errno with the close's errno.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/unix_io.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index b6feebef93fa5b..15d6d55ff7fdd4 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -1213,10 +1213,16 @@ static errcode_t unix_close(io_channel channel)
 #ifndef NO_IO_CACHE
 	retval = flush_cached_blocks(channel, data, 0);
 #endif
+#ifdef HAVE_FSYNC
+	/* always fsync the device, even if flushing our own cache failed */
+	if (fsync(data->dev) != 0 && !retval)
+		retval = errno;
+#endif
 
 	unix_funlock(channel);
 
-	if (channel->manager != unixfd_io_manager && close(data->dev) < 0)
+	if (channel->manager != unixfd_io_manager && close(data->dev) < 0 &&
+	    !retval)
 		retval = errno;
 	free_cache(data);
 	free(data->cache);

