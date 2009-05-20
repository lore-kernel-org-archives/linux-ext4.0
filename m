From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] resize2fs: fix ENOSPC corruption case
Date: Wed, 20 May 2009 16:36:26 -0500
Message-ID: <4A1477DA.1070106@redhat.com>
References: <4A11D375.30709@redhat.com> <20090520113748.GC24836@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56358 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZETVg2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 17:36:28 -0400
In-Reply-To: <20090520113748.GC24836@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://people.redhat.com/esandeen/livecd-creator-imagefile.bz2
contains an image (for now) which, when resized to 578639, corrupts
the filesystem.

This is a bit crazy, I guess, because the fs currently has only
1 free block, but still, we should be graceful about the failure.
Perhaps it would make sense to check the requested valuea against
the minimum value resize2fs would compute for "-P" and fail (at
least without a force).

But in any case, this exposed 2 bugs when moving that one block
required an extent split, which is what hit the ENOSPC.

For starters, ext2fs_extent_set_bmap() in the "(re/un)mapping last 
block in extent" case was replacing the old extent before the
new one was created; when the new extent creation failed, it
left us in an inconsistent state.  Simply changing the order of
the two should fix this problem.

Next, ext2fs_extent_insert was calling ext2fs_extent_delete()
on *any* error, including one caused by failure to allocate a new
block to split the node to hold that extent ... the handle was left
unchanged, and we deleted the -original- extent.

As a quick fix for this, just don't do the delete if we fail the split,
though this may need to be smarter.  I don't think we have terribly
consistent behavior about where a handle is left on various errors.

v2: lose the goto change complexity

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 143929e..ddb2d2a 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1040,7 +1040,7 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 #endif
 			retval = extent_node_split(handle);
 			if (retval)
-				goto errout;
+				return retval;
 			path = handle->path + handle->level;
 		}
 	}
@@ -1239,16 +1239,17 @@ again:
 #ifdef DEBUG
 		printf("(re/un)mapping last block in extent\n");
 #endif
-		extent.e_len--;
-		retval = ext2fs_extent_replace(handle, 0, &extent);
-		if (retval)
-			goto done;
+		/* Make sure insert works before replacing old extent */
 		if (physical) {
 			retval = ext2fs_extent_insert(handle,
 					EXT2_EXTENT_INSERT_AFTER, &newextent);
 			if (retval)
 				goto done;
 		}
+		extent.e_len--;
+		retval = ext2fs_extent_replace(handle, 0, &extent);
+		if (retval)
+			goto done;
 	} else if (logical == extent.e_lblk) {
 #ifdef DEBUG
 		printf("(re/un)mapping first block in extent\n");

