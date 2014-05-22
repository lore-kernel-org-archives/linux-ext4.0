From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Wed, 21 May 2014 22:45:27 -0400
Message-ID: <20140522024527.GA22059@thunk.org>
References: <537C4A2F.8040402@cn.fujitsu.com>
 <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
 <20140521141203.GB1501@thunk.org>
 <20140521150619.GA5459@rei.suse.cz>
 <20140521185824.GB8868@thunk.org>
 <20140521212003.GA7493@rei.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Luk???? Czerner <lczerner@redhat.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: chrubis@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54642 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaEVCpi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 22:45:38 -0400
Content-Disposition: inline
In-Reply-To: <20140521212003.GA7493@rei.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2014 at 11:20:03PM +0200, chrubis@suse.cz wrote:
> 
> The test in question here (mmap_11-4) is a part of the Open Posix
> Testsuite that continues to live in LTP. The whole testsuite runs in
> about 30 minutes and covers most of the POSIX interfaces in ~1600
> testcases.

I'm pretty familiar with the PCTS (which is different from the Open
Posix Testsuite), epsecially as it relates to the tty/termios
interfaces.

At least with the PCTS, there are a large number of the tests which
are primarily issues which are implemented in the core VFS layer or in
the core TTY layer.  If you are a core tty implementor (as I was), the
PCTS was really useful for that.  If you are a serial device driver
implementor, however, not all of the tests were as useful.

I suspect the same would be true with file system related tests.
There will be those tests which are are really useful if you are doing
core VFS work, and then there are those tests which are useful if you
are working on a particular file system.  Separating out those tests
which are most useful for developers would probably be a good thing,
although obviously tere will always be a certain amount of overlap.

> I guess that we can filter filesystem related syscalls quite easily. The
> overlap would take more work though. In LTP we have mostly conformance
> testcases and some stress testcases. I'm not much familiar with xfstests
> and its coverage.

Xfstests has already taken some parts of LTP.  The xfstests sources
has a ltp directory with the following:

% ls ltp
total 376
40 aio-stress.c   8 doio.h	44 fsx.c	44 iogen.c    8 rwtest.sh*
84 doio.c	   68 fsstress.c   76 growfiles.c   4 Makefile

Furthermore, there are a number of xfstests which run programs like
fsstress and fsx using a variety of configuration options which have
historically been best at stress testing file systems. 

So it sounds like there's quite a lot of overlap, some of it caused by
xfstests grabbing bits and pieces of LTP, and part of it because
people have been adding both functional and stress tests to xfstests.

The question is what's the best way of dealing with the overlap.
Clearly xfstests has a lot more mindshare amonst file system
developers, and LTP does have that unfortunate reputation which it is
still trying to overcome.  :-/

Cheers,

						- Ted
