From: "Theodore Ts'o" <tytso@mit.edu>
Subject: proposed ext4 test matrix
Date: Mon, 16 May 2011 13:49:20 -0400
Message-ID: <E1QM1uy-00070D-KR@tytso-glaptop>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56671 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1EPRtX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 13:49:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Per the discusison on the ext4 concall, here's a proposed ext4 test
matrix.

						- Ted

P.S.  There was something else I said I would send out, but I didn't
write it down and I can't remember what it was.  Can someone remind me?
Thanks!!


4k blocksize, no journal, nodealloc, noextents (ext2)
1k blocksize, no journal, nodealloc, noextents (ext2)
4k blocksize, journal, nodealloc, noextents (ext3)
1k blocksize, journal, nodealloc, noextents (ext3)
4k blocksize, journal, delalloc, extents
1k blocksize, journal, delalloc, extents
4k blocksize, nojournal, delalloc, extents
4k blocksize, journal, 64bits(*), delalloc, extents
1k blocksize, journal, 64bits(*), delalloc, extents
4k blocksize, nojournal, 64bits(*), delalloc, extents
4k blocksize, journal, delalloc, extents, quota enabled
1k blocksize, journal, delalloc, extents, quota enabled

(*) requires master/next branch e2fsprogs; by this I mean creating a
file system with the 64-bit feature enabled, not necessarily creating
a 40TB file system!
