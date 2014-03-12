From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] create_inode: fix gcc -Wall complaints
Date: Wed, 12 Mar 2014 13:02:19 -0700
Message-ID: <20140312200219.GC9070@birch.djwong.org>
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
Received: from userp1040.oracle.com ([156.151.31.81]:51399 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaCLUCY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2014 16:02:24 -0400
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
> 
> sparse, via "make C=1"
> 
> gcc -Wall, via "make gcc-wall" and "make gcc-wall-new"

Annoyingly, I ran make gcc-wall on Ubuntu 12.04 (gcc 4.6, glibc 2.15) and got
this splat:

/usr/include/x86_64-linux-gnu/sys/stat.h:456: multiple definition of `stat'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:456: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:463: multiple definition of `lstat'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:463: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:470: multiple definition of `fstat'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:470: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:478: multiple definition of `fstatat'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:478: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:486: multiple definition of `mknod'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:486: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:495: multiple definition of `mknodat'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:495: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:505: multiple definition of `stat64'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:505: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:512: multiple definition of `lstat64'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:512: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:519: multiple definition of `fstat64'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:519: first defined here
/usr/include/x86_64-linux-gnu/sys/stat.h:527: multiple definition of `fstatat64'
../lib/libquota.a(quotaio_v2.o):/usr/include/x86_64-linux-gnu/sys/stat.h:527: first defined here

Not sure how to fix this, other than changing WFLAGS to start with -std=gnu99.
gcc 4.8/glibc 2.19 on Ubuntu 14 are no better.

--D
> 
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
> 
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
> 
> Thanks!
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
