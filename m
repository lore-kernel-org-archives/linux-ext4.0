Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F7F388389
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775229568; cv=none; b=aOput3NAKikzX2dQWLwq95rd+TkQW4caZYywlkvUlrhTiT0XK4zGpmz09aNr5QyH9l6we/6Ev6DnmqdxRIjtwamq4rabKpkqIAuM51jQsQfd7VkjTizNsQkyOhTNwCVZSLa0Vd/PZVVzUvIspiPrm4gm0AgaabrwRi1ae55WKM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775229568; c=relaxed/simple;
	bh=x19Hg2oMkg18EV87SUoCYRAxXJKwiYTObp/+2Nzq8cs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Y30HV/rEQdmb1xiFPB10FGesJGvxzER/nXwn0HqCVImeEFiPT2WQ5fqbssCijGaFisaPODeow43c4IescasxEAMSZHLYo0WY4qFqc9EgcnU/c5iavMLKj8gctbif/EOzigd8qqsw08txxNXgd1xAeUX3tRPxDb5dXtJpvpBiw5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVR5vw8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVR5vw8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B75C4CEF7;
	Fri,  3 Apr 2026 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775229567;
	bh=x19Hg2oMkg18EV87SUoCYRAxXJKwiYTObp/+2Nzq8cs=;
	h=Date:From:To:Cc:Subject:From;
	b=NVR5vw8gRPG2Mk+PYkRW+BMdn0TxRs3gZmXk72RWWox5oACXV6zdxVsOo86vKwtvm
	 QDGn70AeBy8Am8E0c9waohEmIlrK/Bhe5EOLfD3/iCIqnvba3C0FGrS1S7QQlw1m/V
	 3mLwIj9w20KF1ksWK94yE7tginliXHzKJhLf8z6pp6pPeUyRV1VKBpYStGhaA3M72v
	 b9AajRB7ydqY0EqyJA8HGIqqRh4Gmvsn42YoEa4tfSYFeZ45MIxrjmav9f3ZephudZ
	 ULcTzBPaME1OJSi2ZM/Lk+K70FMpS9P0DtBEsbuhx0C1F16yQi6IdHC+dRqd+9RhCn
	 qO8tCAP6qfWhA==
Date: Fri, 3 Apr 2026 08:19:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: [PATCH] libsupport: change get_thread_id return type to unsigned
 long long
Message-ID: <20260403151927.GB6192@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

With -Wformat enabled, the e2fsprogs build spews out a lot of warnings
for fuse2fs:

 ../../misc/fuse2fs.c: In function ‘__fuse2fs_finish’:
 ../../misc/fuse2fs.c:152:24: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘uint64_t’ {aka ‘long unsigned int’} [-Wformat=]
   152 |                 printf("FUSE2FS (%s): tid=%llu " format, (fuse2fs)->shortdev, get_thread_id(), ##__VA_ARGS__); \
       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~                              ~~~~~~~~~~~~~~~
       |                                                                               |
       |                                                                               uint64_t {aka long unsigned int}
 ../../misc/fuse2fs.c:556:17: note: in expansion of macro ‘dbg_printf’
   556 |                 dbg_printf(ff, "%s: libfuse ret=%d\n", func, ret);
       |                 ^~~~~~~~~~

Because the linter doesn't like mixing %llu with a uint64_t type.
On some platforms, uint64_t is merely "unsigned long" and whiiiiine.

Since this is a new wrapper function, let's change the return type.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/support/thread.h |    2 +-
 lib/support/thread.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/support/thread.h b/lib/support/thread.h
index 9a7f5c9db1b7a2..efba1c3b1eec0b 100644
--- a/lib/support/thread.h
+++ b/lib/support/thread.h
@@ -2,4 +2,4 @@
  * thread.h -- header file for thread utilities
  */
 
-uint64_t get_thread_id(void);
+unsigned long long get_thread_id(void);
diff --git a/lib/support/thread.c b/lib/support/thread.c
index a9a10940c0fd3e..651be1cf833860 100644
--- a/lib/support/thread.c
+++ b/lib/support/thread.c
@@ -12,7 +12,7 @@
 
 #include "support/thread.h"
 
-uint64_t get_thread_id(void)
+unsigned long long get_thread_id(void)
 {
 #if defined(HAVE_GETTID)
 	return gettid();
@@ -22,7 +22,7 @@ uint64_t get_thread_id(void)
 	if (pthread_threadid_np(NULL, &tid))
 		return tid;
 #elif defined(HAVE_PTHREAD)
-	return (__u64)(uintptr_t) pthread_self();
+	return (unsigned long long)(uintptr_t) pthread_self();
 #endif
 	return getpid();
 }
