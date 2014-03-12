From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] create_inode: fix gcc -Wall complaints
Date: Wed, 12 Mar 2014 10:32:15 -0400
Message-ID: <20140312143215.GA15334@thunk.org>
References: <1394595670-11193-1-git-send-email-tytso@mit.edu>
 <20140312034539.GC26898@thunk.org>
 <20140312034841.GC31864@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	liezhi.yang@windriver.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40467 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbaCLOcV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 10:32:21 -0400
Content-Disposition: inline
In-Reply-To: <20140312034841.GC31864@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2014 at 08:48:41PM -0700, Darrick J. Wong wrote:
> 
> I fixed that up in the cppcheck cleanups patch by moving those declarations to
> ext2fs.h.  Maybe I should have shoved the patch closer to the head.

I was going to ask about cppcheck, since I'm not as familiar with it.
We have multiple static code checkers that we are available to
e2fsprogs developers:

sparse, via "make C=1"

gcc -Wall, via "make gcc-wall" and "make gcc-wall-new"

clang, via "CC=clang ./configure ; make"

converity, via Eric or Ted uploading to scan.coverity.com

... and for dynamic testing, we also have:

valgrind, via "cd build/tests ; make test_script ; ./test_script --valgrind"
	  or "... ; ./test_scripte --valgrind-leakcheck"

At this point, the problem is not that we don't have enough testing
tools --- but that we're not using them regularly.

I'm not opposed to adding cppcheck, but I'm not familiar with it ---
are there things that it catches that we might not catch via other
means?

The other thing is that if we can figure out ways to automate running
some of these tests, and perhaps detecting when there are new warnings
that have popped up, that would probably be really useful.

Also, if anyone feels moved to document ways that e2fsprogs developers
can improve their code submissions, and go hunting for bugs if they so
feel moved, that would probably be a great thing to add to the ext4
wiki.

Thanks!

						- Ted
