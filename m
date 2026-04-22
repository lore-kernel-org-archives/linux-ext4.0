Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806FE1D6DA9
	for <linux-ext4@vger.kernel.org>; Wed, 22 Apr 2026 23:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900196; cv=none; b=uT/Gw1Wo66mu4+//yWVS24IkJOzumlCMRD9iLgPWWmp6PsgMHWHfOVkJV8JmKgX4j0BrtDdObJHGSMMbFdsWGf6VD++JHgdpfgqJX8usO2UnxyKZayaiq18wYlsBYgcO95F3pdl+6q97exebuUGLzxF93jl3p8D8HrTBcykCyUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900196; c=relaxed/simple;
	bh=tYjdQr2/vAzZdBYLwrROdv3cE7IwQkoXgESSj1yoLFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g2Sv6vAwQLVWFqjAwiArzNybUK6fzUkzAlIhLqLIbxopALK33Dk8mFZgjwpNKGYMVSYgwsM7ndn5rIRr3Foq9ufoPYP0xs/uj/zhmJxX3IAkAFxS8Yg4Vdech5OA4VkkyHHIDsG6UlTJ7te86s5j8d9hAW5uaDXY5nLTmQEqQPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lW6hwf22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lW6hwf22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF79C19425;
	Wed, 22 Apr 2026 23:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900196;
	bh=tYjdQr2/vAzZdBYLwrROdv3cE7IwQkoXgESSj1yoLFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lW6hwf22p8ueTXnaJc9iwpH9GVaXCBSRpIu7LN7Wg5SR9XcqK26/rKL/Jijt+sncO
	 OmLKoS82LzvpBYqbIdlUjJfK/XOtR+psWPH9KneW7KpEQU0u80CqKPwYY4J3nF2hQG
	 NaWEQzTPSgSpVgcBiJdO57S84vZVQMQjaNxHaO/qLuiVYECLQVas7JRcCFzcc9P1+o
	 m5T9MiV2brx3QsID9kHBol39vOVmtyNajOVk9TtEUXeK3TC/K507WIIVCj2RLv5sD2
	 GrXFg4xPqtGNZ+7JRkvikRBfGDzIevbfFyH//u8yir3bAiSbUN1Zs7LmzhbhJ/xWq3
	 fWwtUR/jGiXRQ==
Date: Wed, 22 Apr 2026 16:23:15 -0700
Subject: [PATCH 2/3] libext2fs: always fsync the device when closing the unix
 IO manager
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <177689989348.3821152.13922579915019711363.stgit@frogsfrogsfrogs>
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

