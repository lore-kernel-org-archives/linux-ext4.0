From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Wed, 21 May 2014 14:58:24 -0400
Message-ID: <20140521185824.GB8868@thunk.org>
References: <537C4A2F.8040402@cn.fujitsu.com>
 <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
 <20140521141203.GB1501@thunk.org>
 <20140521150619.GA5459@rei.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Luk???? Czerner <lczerner@redhat.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: chrubis@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53988 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbaEUS6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 14:58:39 -0400
Content-Disposition: inline
In-Reply-To: <20140521150619.GA5459@rei.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2014 at 05:06:19PM +0200, chrubis@suse.cz wrote:
> > It would be good to get this test case (thank you very much for
> > writing it!) imported into xfstests, since the lack of this test is
> > why we didn't notice the bug when we added the fs/ext4/page_io.c code
> > paths.
> 
> It has been in LTP for ages. Maybe it's a time developers should start
> to use LTP :) (We managed to fix most of the problems that are credible
> for the bad LTP reputation...)

There is a pretty large amount of overlap between LTP and xfstests,
and xfstests are what most of the file system developers are using,
and we have developed a lot of automated test automation which means
running xfstests is very easy and convenient.  For example:

	https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/README

The ability for me to build a kernel and then with a single command,
"kvm-xfstests smoke", do a quick verification in about 30 minutes, is
very convenient.

As I recall, ltp was integrated with autotest, and my experience with
autotest at multiple companies is if anything, worse than ltp's
reputation.  (I considered ltp to be mostly harmless, albeit not
particularly useful, whereas I considered autotest to be activetly
harmful to engineer productivity.)

Anyway, it's already the case that most of the useful file-system
specific bits of LTP has been cherry picked into xfstests, and I
suspect it will be a lot easier to get a few additional LTP test cases
added into xfstests, than it will be to convince a large number of
file system developers that they should (a) try to figure out how to
integrate LTP into their test harnesses, and (b) how to avoid
duplicating tests which xfstests are already running.

> This is exacly what we concluded when we were fixing the testacase (I
> talked about this I think with Jan Kara and Michal Hocko). And the
> result was to add the msync() to the testcase. We also agreed that
> fixing this for tmpfs is not worth the effort although when interpreting
> POSIX strictly it should work with shm memory as well.

Sure, although it's not clear what "written out" means in the context
of tmpfs.

					- Ted
