Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238C314D15
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416284; cv=none; b=mVqf4HG7VZ+lfLKUrciAyLujLxiTzBPNH+yVDPHcZ6W1zj4Lv6BV8kBYEw+IIO+ZfDjBQ3dQGq0zx5CZ1CwR6thpbelEj6/TMaPn3lWuV5GWNmxz8Ifyq/p6/+eXODsUJBBhBmtXYmht5NtOAS7eiaMj4a/e75zYfSErM8Aik3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416284; c=relaxed/simple;
	bh=DQSsxBVls/QO9vKZcYa9zkt81Mc6oE0adIbB3p1F3/A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C9gec06WyEmMyPziYTzWLa+St6dUmcVKtRvvF3+t30Zxu3/hUkpdm84CRPLxmchGPCSaoBFzYmhIIqr6XCPCltGcs2foiANWUDnMaWb6V38D4wimHZ/6LqqJ3Jwh/6YTslnWlaNW3QzJn2del9pN6lEu44fBlH5MRbMWIh2MDDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7+cyHAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7+cyHAF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A4C6F1F000E9;
	Thu, 25 Jun 2026 19:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782416282;
	bh=cjqUowfiB7EGt+/f2xoGW7JfTFejnRX7nbF9HH5LnTg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=F7+cyHAFNKBlM/5Duin42XsCdichR8kTEtPsmBBCqNsxhFodmp2oZPinsX+WqP+36
	 +nPXM9jsIw5uF+cdwx3AUrSqs2QPbdc0uHJF6TLPIgMak2EKNt1/aCKH5Ay1FbXKCd
	 AzHv2DBzr/Wxh/xUx+WIV8r04/rvN8VTeuaZB5Cre0xC3LYladomKCyZH1nsnqJ1Ut
	 gIDPJSeO5RA/iw2UhcIJQ9lrWQ/x0pjweXsMrVIkdMRU/OvnEpEuCDeaOiPW95+MlG
	 wh1VZXjfA7BHfdMySzuGAE+ZOxDVKT2F0WhGplrO2kqRv6t82n4YCBEiaE+kCAgrfs
	 +/1t9uHf6CU1w==
Date: Thu, 25 Jun 2026 12:38:02 -0700
Subject: [PATCH 05/10] libext2fs: bump libfuse API version to 3.19
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org
Message-ID: <178241606901.1810414.6684725423139009352.stgit@frogsfrogsfrogs>
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

The fuse service container API is only available in 3.19, so we need to
bump FUSE_USE_VERSION up from 3.14 to 3.19.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 configure    |    8 ++++----
 configure.ac |   10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/configure b/configure
index d941ff1f1ad900..f24897fcdd4949 100755
--- a/configure
+++ b/configure
@@ -14604,14 +14604,14 @@ fi
 
 if test -n "$FUSE_LIB"
 then
-	FUSE_USE_VERSION=314
+	FUSE_USE_VERSION=319
 	CFLAGS="$fuse3_CFLAGS $CFLAGS"
 	FUSE_LIB="$fuse3_LIBS"
 	       for ac_header in pthread.h fuse.h
 do :
   as_ac_Header=`printf "%s\n" "ac_cv_header_$ac_header" | sed "$as_sed_sh"`
 ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#define _FILE_OFFSET_BITS	64
-#define FUSE_USE_VERSION	314
+#define FUSE_USE_VERSION	319
 "
 if eval test \"x\$"$as_ac_Header"\" = x"yes"
 then :
@@ -14646,7 +14646,7 @@ printf %s "checking for lowlevel interface in libfuse... " >&6; }
 
 	#define _GNU_SOURCE
 	#define _FILE_OFFSET_BITS	64
-	#define FUSE_USE_VERSION	314
+	#define FUSE_USE_VERSION	319
 	#include <fuse_lowlevel.h>
 
 int
@@ -14826,7 +14826,7 @@ printf %s "checking for cache_readdir support in libfuse... " >&6; }
 
 	#define _GNU_SOURCE
 	#define _FILE_OFFSET_BITS	64
-	#define FUSE_USE_VERSION	314
+	#define FUSE_USE_VERSION	319
 	#include <fuse.h>
 
 int
diff --git a/configure.ac b/configure.ac
index d8f40f5df0946b..38a18de0b67283 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1384,17 +1384,17 @@ AC_SUBST(FUSE_LIB)
 
 dnl
 dnl Set FUSE_USE_VERSION, which is how fuse servers build against a particular
-dnl libfuse ABI.  Currently we link against the libfuse 3.14 ABI (hence 314)
+dnl libfuse ABI.  Currently we link against the libfuse 3.19 ABI (hence 319)
 dnl
 if test -n "$FUSE_LIB"
 then
-	FUSE_USE_VERSION=314
+	FUSE_USE_VERSION=319
 	CFLAGS="$fuse3_CFLAGS $CFLAGS"
 	FUSE_LIB="$fuse3_LIBS"
 	AC_CHECK_HEADERS([pthread.h fuse.h], [],
 		[AC_MSG_FAILURE([Cannot build against fuse3 headers])],
 [#define _FILE_OFFSET_BITS	64
-#define FUSE_USE_VERSION	314])
+#define FUSE_USE_VERSION	319])
 fi
 if test -n "$FUSE_USE_VERSION"
 then
@@ -1413,7 +1413,7 @@ then
 	[	AC_LANG_PROGRAM([[
 	#define _GNU_SOURCE
 	#define _FILE_OFFSET_BITS	64
-	#define FUSE_USE_VERSION	314
+	#define FUSE_USE_VERSION	319
 	#include <fuse_lowlevel.h>
 		]], [[
 	struct fuse_lowlevel_ops fs_ops = { };
@@ -1515,7 +1515,7 @@ then
 	[	AC_LANG_PROGRAM([[
 	#define _GNU_SOURCE
 	#define _FILE_OFFSET_BITS	64
-	#define FUSE_USE_VERSION	314
+	#define FUSE_USE_VERSION	319
 	#include <fuse.h>
 		]], [[
 	struct fuse_file_info fs_ops = {

