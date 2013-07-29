From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Mon, 29 Jul 2013 12:38:38 -0400
Message-ID: <20130729163838.GI11816@thunk.org>
References: <20130729083941.GG28871@pcnci.linuxbox.cz>
 <51F694B6.90901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37053 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619Ab3G2Qiq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 12:38:46 -0400
Content-Disposition: inline
In-Reply-To: <51F694B6.90901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 11:13:42AM -0500, Eric Sandeen wrote:
> 
> Ted, these are the same ones I saw, plus one I think (working on getting
> all the info).
> 
> I don't think it's a regression, because:
> 
> commit e79a9395b382e831c125d000d2bf16ba4b6253d4
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Mar 31 20:34:24 2013 -0400
> 
>     tests: add more tests for off-line resizing
> 
> and:
> 
> $ git describe --contains e79a9395b382e831c125d000d2bf16ba4b6253d4
> v1.42.8~31
> 
> the tests were only added in the last release.  Running the same tests
> on older releases most likely breaks as well.

Well, they would almost certainly break on older releases because of
bugs due to bugs that were fixed in 1.42.8.  :-)

Let me be more precise; these tests aren't failing for me when I run
build and run "make check" on pristine 1.42.8 version of e2fsprogs on
Debian Stable.  So it's likely that the test is doing something that
is specific to Red Hat systems.  It may stil be turning up a bug that
for some reason we're not seeing on Debian systems.  

We are using the e2fsck binary built in the tree as the source of test
bits for the resize test.  I'm guessing that it is substantially
smaller or bigger when built on Red Hat systems?!?

Could you modify tests/script/resize to capture a copy of the
constructed file system before we start running resize2fs on it so I
can try reproducing it on my end?

					- Ted

P.S.  Hmm, for some reason the size of the e2fsck binary must be
*substantially* smaller on Red Hat systems.  What configure options
are you using?

Looking at my log, it shrinks the file system to:

r_1024_small_bg.log:The filesystem on /tmp/e2fsprogs-tmp.RE74xl is now 1341 blocks long.

and then

r_1024_small_bg.log:The filesystem on /tmp/e2fsprogs-tmp.RE74xl is now 1215 blocks long.

On your log, it shrinks the filesystem to 1191 blocks and then 1111 blocks.

On my system with default configure options, the size of the e2fsck
binary is 1124k.  It sounds like the size of your compiled e2fsck
binary is approximately 100k smaller?

