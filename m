Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04552309F09
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416253; cv=none; b=b1UE3cQal8/2pG/gtqo6ZB/qK2jJ/ZpmFy1lTZL5Lq8Oyl6i+zi07IxSLEVt9LPtRncZUsvnDAOmkJayTF1jOTlq+irE0spPVFv6JWcy5ZhHwvw7R4KJQ0u+3xtIotBbtRDJ4E14EVpzsVd51Hd4jz4PyGWDswJ5ebWmGXa4Ujw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416253; c=relaxed/simple;
	bh=NkhOfkyKeLlFOmxSWSlGf6xb4M1S8YLYljkVdi3MaHo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SlxYI+Tbkkp9euykYd1GVEg6LKU3StPm3C9LoP56dsL/caMsPtkeN4cobuuMlg9mZsTFb1RPYW8k7R8eNU+oVTwFvavewMhEh35zO188x9eTg72d7Vu4VAm/2ovrHLgDcPyUxy8/u7f3tqby8ISoZWBkAZhWWDdtJhXm36didug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYzAgbHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYzAgbHZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 941E11F000E9;
	Thu, 25 Jun 2026 19:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416251;
	bh=mx3cTTISTwWgNMHQtRxeSeZbdmyLeMnmFveBnoSGg/k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HYzAgbHZK2/4cXhJL4oudGAknbiu1EcLnaU36Ee/EzmtXiZpVqUBlDI/jUYqYQat9
	 O6gcZzISZMtLJSUmy/9vKFpSWVi0whWT6lpSkvAqUZmCf7y8tyghzCOaGsYdzDIqmU
	 1edRPEssUMaq4KQgLpK5Dx8d7BMWeLH0hWW74sUhw9PYVWE5BXCA/DRXpzxwR1nh6E
	 TigpKtSj7y7tZmzGauQ1UZuqWPLPvjlQRfiY2IbT8v5Skwbh1LAcAz6OG2WE6cPbsk
	 FWrRuaORPDenW1GQX/3adhXCCtko/KfhqxiROF016MQma2Okb90ZXoBI5EcYLugX8L
	 C4Kg09jSXTLYA==
Date: Thu, 25 Jun 2026 12:37:31 -0700
Subject: [PATCH 03/10] unix_io: allow passing /dev/fd/XXX paths to the unixfd
 IO manager
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <178241606866.1810414.6638699048358949972.stgit@frogsfrogsfrogs>
In-Reply-To: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
References: <178241606773.1810414.1910863348345107939.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Commit 4ccf9e4fe165cf created a "unixfd" IO manager that allows someone
to choose the unixfd IO manager and then mount a filesystem from an
existing file descriptor by passing a string with the fd number as the
"device" name to ext2fs_open().

That was an unfortunate choice of naming, however, because that could
be mistaken for a relative path to a file whose name is an integer
number.  Let's improve this by allowing callers to pass /dev/fd/XX
as the filesystem device name.  The upcoming fuse4fs service patches
will employ this method to open a filesystem on a block device fd passed
into the secure container from a mount helper.

Cc: <linux-ext4@vger.kernel.org> # v1.43.2
Fixes: 4ccf9e4fe165cf ("libext2fs: add unixfd_io_manager")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 lib/ext2fs/unix_io.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 79bc9219f9515b..a9b1fac62a0250 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -67,6 +67,7 @@
 #ifdef HAVE_SYS_FILE_H
 #include <sys/file.h>
 #endif
+#include <limits.h>
 
 #if defined(__linux__) && defined(_IO) && !defined(BLKROGET)
 #define BLKROGET   _IO(0x12, 94) /* Get read-only status (0 = read_write).  */
@@ -1148,13 +1149,40 @@ static errcode_t unix_open_channel(const char *name, int fd,
 	return retval;
 }
 
+#define DEV_FD_PATH	"/dev/fd/"
+#define DEV_FD_PATHLEN	(sizeof(DEV_FD_PATH) - 1)
+
+static int possible_unixfd_pathname(const char *path)
+{
+	return strncmp(DEV_FD_PATH, path, DEV_FD_PATHLEN) == 0;
+}
+
 static errcode_t unixfd_open(const char *str_fd, int flags,
 			     io_channel *channel)
 {
 	int fd;
 	int fd_flags;
 
-	fd = atoi(str_fd);
+	/*
+	 * The caller should provide a path in the form "/dev/fd/XX",
+	 * but the shorthand form "XX" is allowed for legacy reasons.
+	 */
+	if (possible_unixfd_pathname(str_fd)) {
+		char *endptr;
+		long maybe_fd;
+
+		errno = 0;
+		maybe_fd = strtol(str_fd + DEV_FD_PATHLEN, &endptr, 10);
+		if (errno)
+			return errno;
+		if (*endptr != 0)
+			return EINVAL;
+		if (maybe_fd < 0 || maybe_fd > INT_MAX)
+			return EINVAL;
+		fd = maybe_fd;
+	} else {
+		fd = atoi(str_fd);
+	}
 #if defined(HAVE_FCNTL)
 	fd_flags = fcntl(fd, F_GETFL);
 	if (fd_flags == -1)

