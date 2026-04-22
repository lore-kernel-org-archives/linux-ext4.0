Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8275F1D6DA9;
	Wed, 22 Apr 2026 23:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776900294; cv=none; b=svSqlg8pKWBmsFOz8uk3FaQw4fSJpiN0dyTAuH3TnyGjD2w7d0ILVj5gneHyzuSnJdyn4dlkI+j9E5oLqLfddYYkXWXbcpf6ohTdW+4sOGiUN5HKlQbm+yqBOY5FPP6+iEDvJ63aIYMokD0MVrfFwFYYcNeX/Pb0OXh6IfDUBRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776900294; c=relaxed/simple;
	bh=VtUQH8nvmynk1XgxJ8+P6/2HFLN98EEObt1Hjk3YXPM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVW3mKcW+v6JUXJelHGWC4JUCGordww3OiXphkCMmZT6GOaaWBJHwlO2M4ZQuVMTBjAxYloryrSuJ+aC7pQPkxIfqAi1+j0Dfj+06pKlDj7sLl29qFs5DzHcgDLd+jZ1FOo7N1UTfwkgr77POuZwbf1pYXuThcikqUGJsNtaYoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFCy8B10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFCy8B10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150EEC2BCAF;
	Wed, 22 Apr 2026 23:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776900294;
	bh=VtUQH8nvmynk1XgxJ8+P6/2HFLN98EEObt1Hjk3YXPM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bFCy8B10QnzDX8ByhAvBHob24ADqmfRUlpTH2KKpTMUM+Ms6YOz8l9679b+bo2W/o
	 acWakXCX8j2+QK6docQvxg/5hN7bspv4uL43fj4h2qaCznVYryf2muMcOn/MNJLg6Z
	 qQG4K1LYnmZHUG6cUnYgV1QOLaJUQyQ3daCp0yxwP97QrTG7gxd9hrWpPlPKdPwWiK
	 am7e3r6SI+yIlu1808IK1qkuzkMPUSFDqz3UD1I4QP0vSePvubpiIF4sH6c6PP19ek
	 I3uGZIB5/hyeq2zHxMiVcOiY4qE2wHyYOGLOT2TWaVpd4rDoTlM/sp/jwdXqcC2RRR
	 VFqDbcMTvaMwA==
Date: Wed, 22 Apr 2026 16:24:53 -0700
Subject: [PATCH 05/10] libext2fs: bump libfuse API version to 3.19
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, neal@gompa.dev, joannelkoong@gmail.com,
 miklos@szeredi.hu, bernd@bsbernd.com
Message-ID: <177689989629.3821326.18114142368432938186.stgit@frogsfrogsfrogs>
In-Reply-To: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
References: <177689989498.3821326.15497525132012299039.stgit@frogsfrogsfrogs>
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
index a9779412174b34..59413d5fc32e83 100755
--- a/configure
+++ b/configure
@@ -14598,14 +14598,14 @@ fi
 
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
@@ -14640,7 +14640,7 @@ printf %s "checking for lowlevel interface in libfuse... " >&6; }
 
 	#define _GNU_SOURCE
 	#define _FILE_OFFSET_BITS	64
-	#define FUSE_USE_VERSION	314
+	#define FUSE_USE_VERSION	319
 	#include <fuse_lowlevel.h>
 
 int
@@ -14818,7 +14818,7 @@ printf %s "checking for cache_readdir support in libfuse... " >&6; }
 
 	#define _GNU_SOURCE
 	#define _FILE_OFFSET_BITS	64
-	#define FUSE_USE_VERSION	314
+	#define FUSE_USE_VERSION	319
 	#include <fuse.h>
 
 int
diff --git a/configure.ac b/configure.ac
index b62553e3d6b946..c7d18dd9988db4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1383,17 +1383,17 @@ AC_SUBST(FUSE_LIB)
 
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
@@ -1412,7 +1412,7 @@ then
 	[	AC_LANG_PROGRAM([[
 	#define _GNU_SOURCE
 	#define _FILE_OFFSET_BITS	64
-	#define FUSE_USE_VERSION	314
+	#define FUSE_USE_VERSION	319
 	#include <fuse_lowlevel.h>
 		]], [[
 	struct fuse_lowlevel_ops fs_ops = { };
@@ -1512,7 +1512,7 @@ then
 	[	AC_LANG_PROGRAM([[
 	#define _GNU_SOURCE
 	#define _FILE_OFFSET_BITS	64
-	#define FUSE_USE_VERSION	314
+	#define FUSE_USE_VERSION	319
 	#include <fuse.h>
 		]], [[
 	struct fuse_file_info fs_ops = {

