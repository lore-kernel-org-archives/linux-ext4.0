From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: fix eofblock flag handling
Date: Tue, 25 May 2010 00:17:37 -0400
Message-ID: <20100525041737.GB5556@thunk.org>
References: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
 <1271687537-15655-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49547 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab0EYERl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 00:17:41 -0400
Content-Disposition: inline
In-Reply-To: <1271687537-15655-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 19, 2010 at 06:32:17PM +0400, Dmitry Monakhov wrote:
> - Fix NULL pointer deference on error path
> - Extent header we found may be not latest node of the inode. In order to
>   find latest extent we have to traverse a path from very beginning.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=15792
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

I split this patch into two patches, since they are addressing two
very distinct and different bugs.  As it turns out I chose a
completely different way of tackling the second issue, which has the
advantage being much simpler, and not requiring a second call to
ext4_ext_find_extent(), which can end up requiring extra disk reads.

Also note that I supplied a test case to demonstrate the problem.
This was helpful in assuring that the problem was fixed, and also in
proving that there really *was* a problem; as it turns out triggering
it is quite difficult and I would be very surprised if it has really
happenned in real life.

To construct the test case I first of all used a 1k block file system,
and then generated an extremely fragmented free space:

mkdir a; cd a
seq -f %05.0f 1 65536 | xargs touch
seq -f %05.0f 1 65536 | xargs -L 1 fallocate -l 1k
seq -f %05.0f 1 2 65536 | xargs rm
cd ..

I then created the fragmented file with the EOFBLOCKS set:

fallocate -n -l 32m foo

This should generate a file with a two-deep extent tree.  (It is
otherwise *very* hard to create a deep extent tree.)  I then found the
last block in an leaf block in the middle of the tree, and deleted the
last extent in that leaf block, using the tst_extents program found in
lib/ext2fs in the e2fsprogs sources (it is built using "make check").
In the case described in the commit, this happened to be for the
logical block 17925.

Could such a file be generated in real life?  Yes, but you'd have to
be quite unlucky, as it would require extending a sparse, fragmented
file using an i_size-preserving fallocate call, where there was a hole
at precisely the right (wrong) place in the extent tree.

			      	      	 - Ted
