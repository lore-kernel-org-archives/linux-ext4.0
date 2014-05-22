From: chrubis@suse.cz
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Thu, 22 May 2014 12:45:05 +0200
Message-ID: <20140522104505.GA10150@rei.suse.cz>
References: <537C4A2F.8040402@cn.fujitsu.com>
 <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
 <20140521141203.GB1501@thunk.org>
 <20140521150619.GA5459@rei.suse.cz>
 <20140521185824.GB8868@thunk.org>
 <20140521212003.GA7493@rei.suse.cz>
 <20140522024527.GA22059@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Luk???? Czerner <lczerner@redhat.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaEVKpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2014 06:45:12 -0400
Content-Disposition: inline
In-Reply-To: <20140522024527.GA22059@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!
> > The test in question here (mmap_11-4) is a part of the Open Posix
> > Testsuite that continues to live in LTP. The whole testsuite runs in
> > about 30 minutes and covers most of the POSIX interfaces in ~1600
> > testcases.
> 
> I'm pretty familiar with the PCTS (which is different from the Open
> Posix Testsuite), epsecially as it relates to the tty/termios
> interfaces.
> 
> At least with the PCTS, there are a large number of the tests which
> are primarily issues which are implemented in the core VFS layer or in
> the core TTY layer.  If you are a core tty implementor (as I was), the
> PCTS was really useful for that.  If you are a serial device driver
> implementor, however, not all of the tests were as useful.

The Open Posix Testsuite is written to the POSIX standard, it tries to
test each assertion written in POSIX so the coverage is very broad. I
guess that you are right that not much of the tests are relevant for
filesystem developers and that would similarily be true for the syscalls
tests, however the bug that started this thread proves that there are
some.

And by the way trying to test each POSIX assertion is sometimes wery
dumb thing to do and we did remove quite a lot of testcases that were
useless or even wrong but that is completly different story...

> I suspect the same would be true with file system related tests.
> There will be those tests which are are really useful if you are doing
> core VFS work, and then there are those tests which are useful if you
> are working on a particular file system.  Separating out those tests
> which are most useful for developers would probably be a good thing,
> although obviously tere will always be a certain amount of overlap.

Right, sorting out right testcases is not easy task. But given that the
runtime is not that long we can do rough selection and end up with
something that runs in about 10 or 20 minutes and covers all possibly
relevant testcases. We may end up selecting tests that are not relevant
to the job, but that shouldn't be problem unless these tests start to
misbehave and produce false positives. And even if misbehaved test is
found, which shouldn't common case, it's my job to help with getting it
right.

I've looked quickly at the syscalls testcases and I think that there are
conformance testcases that may be interesting to filesystem developers,
namely: ftruncate, fallocate, io_* syscalls tests, fdatasync, setxattr,
then there are separate testcases for capabilities (although I would
have to review these before use). And then there are a lot of testcases
for syscalls that interacts with the underlying filesystem i.e.
reading/writing/mmaping files, checking that file permissons are set
correctly etc.

> > I guess that we can filter filesystem related syscalls quite easily. The
> > overlap would take more work though. In LTP we have mostly conformance
> > testcases and some stress testcases. I'm not much familiar with xfstests
> > and its coverage.
> 
> Xfstests has already taken some parts of LTP.  The xfstests sources
> has a ltp directory with the following:
> 
> % ls ltp
> total 376
> 40 aio-stress.c   8 doio.h	44 fsx.c	44 iogen.c    8 rwtest.sh*
> 84 doio.c	   68 fsstress.c   76 growfiles.c   4 Makefile

I've looked at these tests in LTP and xfstests. The code in both
projects has drifted apart a bit and there are different fixes in both
projects which is not healty.

The best I can do as LTP maintainer is to help to unify the code so that
both LTP and xfstests uses latest code with all the fixes. Which would
be harder than just applying patches because there were some larger code
cleanups in both projects, it should be doable though.

> Furthermore, there are a number of xfstests which run programs like
> fsstress and fsx using a variety of configuration options which have
> historically been best at stress testing file systems. 

I'm not trying to argue with that. And I'm not trying to convince
anybody that LTP is the only right tool for kernel testing.

All I'm trying to say is that LTP is worth running. :)
(And maybe that LTP is a good home if you have just a test or two that
doesn't seem to fit to any specific testsuite and you don't want to
start you own test project.)

> So it sounds like there's quite a lot of overlap, some of it caused by
> xfstests grabbing bits and pieces of LTP, and part of it because
> people have been adding both functional and stress tests to xfstests.

There is overlap even inside of the LTP as well (for example between
Open Posix Testsuite and syscall tests), but I don't think that is
necessarily wrong. Each of these tests has a slightly different purpose
and different implementation and together it covers more cases.

> The question is what's the best way of dealing with the overlap.

I guess making sure that both LTP and xfstests share latest source code
with all the fixes would be a good start.

> Clearly xfstests has a lot more mindshare amonst file system
> developers, and LTP does have that unfortunate reputation which it is
> still trying to overcome.  :-/

To be frank the reputation is one thing I would really like to fix.
Nothing is more frustrating than spending years fixing code and still
being ignored because of the past you haven't been even involved in.

Unfortunately this seems to be one of the most challenging tasks in LTP
maintainership.

-- 
Cyril Hrubis
chrubis@suse.cz
