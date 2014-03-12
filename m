From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] create_inode: fix gcc -Wall complaints
Date: Wed, 12 Mar 2014 10:59:43 -0700
Message-ID: <20140312175943.GB9070@birch.djwong.org>
References: <1394595670-11193-1-git-send-email-tytso@mit.edu>
 <20140312034539.GC26898@thunk.org>
 <20140312034841.GC31864@birch.djwong.org>
 <20140312143215.GA15334@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	liezhi.yang@windriver.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51248 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCLR7u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2014 13:59:50 -0400
Content-Disposition: inline
In-Reply-To: <20140312143215.GA15334@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 10:32:15AM -0400, Theodore Ts'o wrote:
> On Tue, Mar 11, 2014 at 08:48:41PM -0700, Darrick J. Wong wrote:
> > 
> > I fixed that up in the cppcheck cleanups patch by moving those declarations to
> > ext2fs.h.  Maybe I should have shoved the patch closer to the head.
> 
> I was going to ask about cppcheck, since I'm not as familiar with it.
> We have multiple static code checkers that we are available to
> e2fsprogs developers:

I've been using cppcheck (http://cppcheck.sourceforge.net/) as a poor man's
Coverity to find resource leaks, since I don't have the ability to upload code
and run checks myself.  Later I would like to use cppcheck's custom rule
feature to catch incorrect use of library functions, e.g. modifying an extent
without calling ext2fs_extent_fix_parents(), or setting i_blocks directly.

Excerpting from https://packages.debian.org/sid/cppcheck, it can catch:

 * pointers to out-of-scope auto variables;
 * assignment of auto variables to an effective parameter of a function;
 * use of deprecated functions (mktemp, gets, scanf);
 * memory leaks in class or function variables;
 * C-style pointer cast in C++ code;
 * redundant if;
 * misuse of the strtol or sprintf functions;
 * unsigned division or division by zero;
 * unused functions and struct members;
 * passing parameters by value;
 * misuse of signed char variables;
 * unusual pointer arithmetic (such as "abc" + 'd');
 * dereferenced null pointers;
 * incomplete statements;

It also seems to catch fd leaks.

> sparse, via "make C=1"
> 
> gcc -Wall, via "make gcc-wall" and "make gcc-wall-new"
> 

I didn't even realize these existed.  I rather like the idea of a make target
that builds with as much static analysis as we can muster and spits out a
report.

> clang, via "CC=clang ./configure ; make"
> 
> converity, via Eric or Ted uploading to scan.coverity.com
> 
> ... and for dynamic testing, we also have:
> 
> valgrind, via "cd build/tests ; make test_script ; ./test_script --valgrind"
> 	  or "... ; ./test_scripte --valgrind-leakcheck"
> 
> At this point, the problem is not that we don't have enough testing
> tools --- but that we're not using them regularly.

Agreed.

> I'm not opposed to adding cppcheck, but I'm not familiar with it ---
> are there things that it catches that we might not catch via other
> means?
>
> The other thing is that if we can figure out ways to automate running
> some of these tests, and perhaps detecting when there are new warnings
> that have popped up, that would probably be really useful.
> 
> Also, if anyone feels moved to document ways that e2fsprogs developers
> can improve their code submissions, and go hunting for bugs if they so
> feel moved, that would probably be a great thing to add to the ext4
> wiki.

Yes.  I'll start writing a page.
https://ext4.wiki.kernel.org/index.php?title=Ext4_Contributing

--D
