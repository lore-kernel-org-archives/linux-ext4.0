From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 10/14] Make e2fsck uninit block group aware.
Date: Mon, 22 Oct 2007 14:21:09 -0400
Message-ID: <20071022182108.GB6619@thunk.org>
References: <20071022020308.23849.98773.stgit@toolssf2> <20071022020403.23849.79537.stgit@toolssf2> <20071022110202.57dc2984@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52590 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbXJVSVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 14:21:21 -0400
Content-Disposition: inline
In-Reply-To: <20071022110202.57dc2984@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 22, 2007 at 11:02:02AM -0500, Jose R. Santos wrote:
> Hi Ted,
> 
> Aneesh was nice enough to explain how to checkout the next branch.
> This is the only patch that broke so I'm attaching one that applies
> cleanly

Thanks, I was able to clean that up fairly easily myself.  I noticed
though that after applying the patch series, "make check" blew up:

making check in lib/ext2fs
make[1]: Entering directory `/usr/projects/e2fsprogs/e2fsprogs/build/lib/ext2fs'
        CC ../../../lib/ext2fs/tst_bitops.c
        LD tst_bitops
        CC ../../../lib/ext2fs/tst_badblocks.c
        LD tst_badblocks
rw_bitmaps.o: In function `read_bitmaps':
/usr/projects/e2fsprogs/e2fsprogs/build/lib/ext2fs/../../../lib/ext2fs/rw_bitmaps.c:237: undefined reference to `ext2fs_group_desc_csum_verify'
/usr/projects/e2fsprogs/e2fsprogs/build/lib/ext2fs/../../../lib/ext2fs/rw_bitmaps.c:260: undefined reference to `ext2fs_group_desc_csum_verify'
collect2: ld returned 1 exit status
make[1]: *** [tst_badblocks] Error 1
make[1]: Leaving directory `/usr/projects/e2fsprogs/e2fsprogs/build/lib/ext2fs'
make: *** [check-recursive] Error 1

That's a relatively straightforward adjustment to lib/ext2fs/Makefile.in; 
but please do make sure you run "make check" at the end of each patch series.

In fact, something I will normally try to do is make sure that "make
check" runs cleanly after every single patch in a patch series.  That
makes it a lot easier to do git bisect runs.

Thanks,

					- Ted
