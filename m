From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Sun, 4 Nov 2007 23:32:22 -0500
Message-ID: <20071105043222.GA30552@thunk.org>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071105021533.GA3055@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58804 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXKEEdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Nov 2007 23:33:06 -0500
Content-Disposition: inline
In-Reply-To: <20071105021533.GA3055@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 05, 2007 at 10:15:33AM +0800, Andreas Dilger wrote:
> On Nov 04, 2007  17:42 -0500, Theodore Ts'o wrote:
> > * js/uninit (Sun Oct 21 21:04:24 2007 -0500) 14 commits
> >  - Add m_uninit test case.
> >  - Add new mm_lazy test case.
> >  - Fix test cases.
> 
> Do you have all of the f_uninit test cases we made?
> 
> f_uninit_bad_free_inodes
> f_uninit_blk_used_not_set
> f_uninit_checksum_bad
> f_uninit_disable
> f_uninit_enable
> f_uninit_inode_past_unused
> f_uninit_last_uninit
> f_uninit_set_inode_not_set

Nope, it wasn't in the patches that Jose sent out.  I assume they're
in the CFS e2fsprogs?

> > 	This still doesn't pass "make check" in lib/ext2fs, but I'll
> > 	take a closer look at this in the near future.
> 
> That's a bit of a surprise, since the e2fsprogs-uninit patches in
> our own CVS repo pass "make check".

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

I'm pretty sure it's just a Makefile.in screwup; I just haven't had
time to seriously look at the uninit patch series yet.

          		       	      - Ted
