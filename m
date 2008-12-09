From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Getting direct support for fallocate(2) into glibc
Date: Tue, 09 Dec 2008 10:58:19 -0600
Message-ID: <493EA3AB.2080308@redhat.com>
References: <E1L9wQt-0003dz-DE@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51395 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbYLIQ6n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Dec 2008 11:58:43 -0500
In-Reply-To: <E1L9wQt-0003dz-DE@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Hey Eric,
> 
> Can you or Ric put in a good word with Ulrich (through appropriate Red
> Hat channels, if that would be helpful) for this glibc enhancement request:
> 
> 	http://sources.redhat.com/bugzilla/show_bug.cgi?id=7083
> 
> Given that glibc 2.9 was just released, presumably this won't show up
> until glibc 2.10, and it'll probably be a *long* time before it this
> will show up in real distributions, but it would be good to get this
> into functionality into glibc ASAP.

Hm... I thought it was already there.  posix_fallocate() is indeed
calling sys_fallocate; doing a very simple test:

        fd = open("testfile", O_RDWR|O_CREAT);
        error = posix_fallocate(fd, 0, 16384);

and then asking xfs about the allocation (sorry for the xfs, but
xfs_bmap is still so handy for this...):

# xfs_bmap -vv testfile
testfile:
 EXT: FILE-OFFSET   BLOCK-RANGE        AG AG-OFFSET          TOTAL FLAGS
   0: [0..31]:      34984576..34984607  2 (1256112..1256143)    32 10000
 FLAG Values:
    010000 Unwritten preallocated extent

it looks like it's doing the Right Thing.  This is on:

# rpm -q glibc
glibc-2.9-2.x86_64

... oh, ok, but plain old fallocate() isn't yet hooked up, odd.

# gcc -o test-fallocate test-fallocate.c
/tmp/ccQTk6an.o: In function `main':
test-fallocate.c:(.text+0x3e): undefined reference to `fallocate'

Especially odd because we have a man page shipping, but no actual
implemented interface  :)  OK, I'll go bug people.

-Eric
