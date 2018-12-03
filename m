Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42920 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbeLCVAQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2018 16:00:16 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs v4 0/9] Support encoding awareness and casefold
References: <20181201003910.18982-1-krisman@collabora.com>
        <20181203051806.GA6639@thunk.org>
Date: Mon, 03 Dec 2018 16:00:12 -0500
In-Reply-To: <20181203051806.GA6639@thunk.org> (Theodore Y. Ts'o's message of
        "Mon, 3 Dec 2018 00:18:06 -0500")
Message-ID: <87ftvetjfn.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> Hi Gabriel,
>
> Thanks for all of your work on it so far.  There's still some work
> that we need to do, but I think this is good enough for merge what we
> have, so I've pulled this into the e2fsprogs master and next branches.
> There were a few commit description adjustments, and in one place I
> replaced a call to calloc() with a fixed-size buffer to just using a
> on-stack buffer.

Hi Ted,

Thank you for helping me get this done and for amending the remaining
edges.

> The main thing I noticed is that nothing is initializing fs->encoding.
> We need to do that in ext2fs_open() and ext2fs_initialize().  We also
> need to add some test cases --- if we did, we would have noticed the
> missing initialization of fs->encoding.

I didn't want to load the table in those functions because I didn't want
to fail there if the nls_table wasn't found.  If the user has some new
unsupported encoding, e2fsprogs could provide some functionality, even
if it can't deal with the file tree itself.  Failing during open seemed
too harsh.

Do you think the patch below is better?  It tries to load the table
early, but only aborts the execution for fsck.  I'm not sure it is a
valid interface.

> I do want to include of the script which generates utf8data.h in
> e2fsprogs sources; we'll need to it in sync with the kernel sources,
> and so long as it stays in sync, we can always double check that
> version of utf8data.h in e2fsprogs matches the version the one in the
> kernel.  But for reasons of GPL compliance, we should keep a copy of
> the script which creates the generated .h file.

I can send another patch for this right away.  Should we also include
the ucd files into e2fsprogs tree?

Thanks,

-- >8 --
Subject: [PATCH] ext2fs: Always attempt to load nls table when loading the
 filesystem

fs->encoding is exposed by the library, so we need to at least try to
load it when populating ext2_filsys.  Nevertheless, failing to do so
shouldn't be a fatal error, unless the user really needs that
information.  Thus, we ignore this failure during open/initialization
and let the user who needs it validate that field before trying to use
it.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 e2fsck/unix.c           | 12 ++++--------
 lib/ext2fs/initialize.c |  4 ++++
 lib/ext2fs/openfs.c     |  4 ++++
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 5b3552ece6b1..7c24f2e31e4f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -55,7 +55,6 @@ extern int optind;
 #include "problem.h"
 #include "jfs_user.h"
 #include "../version.h"
-#include <ext2fs/nls.h>
 
 /* Command line options */
 static int cflag;		/* check disk */
@@ -1785,13 +1784,10 @@ print_unsupp_features:
 		goto get_newer;
 	}
 
-	if (ext2fs_has_feature_fname_encoding(sb)) {
-		fs->encoding = nls_load_table(sb->s_encoding);
-		if (!fs->encoding) {
-			log_err(ctx, _("%s has unsupported encoding: %0x\n"),
-				ctx->filesystem_name, sb->s_encoding);
-			goto get_newer;
-		}
+	if (ext2fs_has_feature_fname_encoding(sb) && !fs->encoding) {
+		log_err(ctx, _("%s has unsupported encoding: %0x\n"),
+			ctx->filesystem_name, sb->s_encoding);
+		goto get_newer;
 	}
 
 	/*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 30b1ae033340..2d470a070bcc 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -27,6 +27,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "nls.h"
 
 #ifndef O_BINARY
 #define O_BINARY 0
@@ -190,6 +191,9 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	assign_field(s_encoding);
 	assign_field(s_encoding_flags);
 
+	if (ext2fs_has_feature_fname_encoding(param))
+		fs->encoding = nls_load_table(param->s_encoding);
+
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 85d73e2a429b..9ee6cd07f7f3 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -32,6 +32,7 @@
 
 #include "ext2fs.h"
 #include "e2image.h"
+#include "nls.h"
 
 blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
 				     dgrp_t i)
@@ -502,6 +503,9 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		ext2fs_set_feature_shared_blocks(fs->super);
 	}
 
+	if (ext2fs_has_feature_fname_encoding(fs->super))
+		fs->encoding = nls_load_table(fs->super->s_encoding);
+
 	fs->flags &= ~EXT2_FLAG_NOFREE_ON_ERROR;
 	*ret_fs = fs;
 
-- 
2.20.0.rc2
