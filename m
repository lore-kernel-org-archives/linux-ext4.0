From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: fix ENOSPC corruption case
Date: Mon, 18 May 2009 16:30:29 -0500
Message-ID: <4A11D375.30709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34027 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbZERVa3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 17:30:29 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4ILUVKF029220
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 17:30:31 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4ILUUe2032357
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 17:30:30 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4ILUT5F023250
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 17:30:30 -0400
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/ext2fs/extent.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/extent.c
+++ e2fsprogs/lib/ext2fs/extent.c
@@ -1068,16 +1068,17 @@ errcode_t ext2fs_extent_insert(ext2_exte
 
 	retval = ext2fs_extent_replace(handle, 0, extent);
 	if (retval)
-		goto errout;
+		goto errout_delete;
 
 	retval = update_path(handle);
 	if (retval)
-		goto errout;
+		goto errout_delete;
 
 	return 0;
 
-errout:
+errout_delete:
 	ext2fs_extent_delete(handle, 0);
+errout:
 	return retval;
 }
 
@@ -1239,16 +1240,17 @@ again:
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

