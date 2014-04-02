From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest generic/127 rcu_sched self-detected stall
Date: Wed, 2 Apr 2014 16:52:11 -0400
Message-ID: <20140402205211.GO6901@thunk.org>
References: <nsxzjk3omxh.fsf@closure.thunk.org>
 <20140402154909.GA2182@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49288 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024AbaDBUwW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 16:52:22 -0400
Content-Disposition: inline
In-Reply-To: <20140402154909.GA2182@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 02, 2014 at 11:49:10AM -0400, Eric Whitney wrote:
> Unrelated note - I'm seeing a failure in spot testing of the patch you
> picked up from me yesterday on yesterday's dev branch (commit 9f0e2722e9,
> ext4: remove unneeded test of ret variable) - shared/298 on bigalloc
> fails:
> 
>     --- tests/shared/298.out	2014-02-05 11:20:44.834219953 -0500
>     +++ /root/xfstests/results//shared/298.out.bad	2014-04-02 11:20:44.618348029 -0400
>     @@ -2,4 +2,4 @@
>      Generating garbage on loop...done.
>      Running fstrim...done.
>      Detecting interesting holes in image...done.
>     -Comparing holes to the reported space from FS...done.
>     +Comparing holes to the reported space from FS...Sectors 614368-614399 are not marked as free!
> 

OK, I've figured out what was going on.  A buggy version of the Zero
Range patch masked this problem.  If you go back to commit 92e3b40,
which is the last version of ext4 that has been merged into mainline,
shared/298 fails there as well.  The original version of the
zero_range patch masked this problem, but that was due to a bug in
that patch which recently got fixed up:

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 243a02e..464e95d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3644,13 +3644,13 @@ static int ext4_split_convert_extents(handle_t *handle,
 	ee_len = ext4_ext_get_actual_len(ex);
 
 	/* Convert to unwritten */
-	if (flags | EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
+	if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
 		split_flag |= EXT4_EXT_DATA_VALID1;
 	/* Convert to initialized */
-	} else if (flags | EXT4_GET_BLOCKS_CONVERT) {
+	} else if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		split_flag |= ee_block + ee_len <= eof_block ?
 			      EXT4_EXT_MAY_ZEROOUT : 0;
-		split_flag |= (EXT4_EXT_MARK_UNINIT2 & EXT4_EXT_DATA_VALID2);
+		split_flag |= (EXT4_EXT_MARK_UNINIT2 | EXT4_EXT_DATA_VALID2);
 	}
 	flags |= EXT4_GET_BLOCKS_PRE_IO;
 	return ext4_split_extent(handle, inode, path, map, split_flag, flags);

So it's a bug for bigalloc that we'll need to look at, but it's not a
regression in that if you try testing the what we had last pushed to
linus (ext4_for_linus_stable) or v3.14, shared/298 is failing with
bigalloc.  And once we fixed up the ZERO RANGE patch, it's still
failing.  :-/

						- Ted
