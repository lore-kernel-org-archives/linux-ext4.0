From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fsck performance.
Date: Sun, 20 Feb 2011 17:20:13 -0500
Message-ID: <20110220222013.GA2849@thunk.org>
References: <20110220090656.GA11402@bitwizard.nl>
 <20110220170931.GB3017@thunk.org>
 <20110220193406.GC3017@thunk.org>
 <20110220215531.GA21917@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59145 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab1BTWUQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 17:20:16 -0500
Content-Disposition: inline
In-Reply-To: <20110220215531.GA21917@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 20, 2011 at 10:55:31PM +0100, Rogier Wolff wrote:
> I looked into this myself as well. Suspecting the locking calls I put
> a "return 0" in the first line of the tdb locking function. This makes
> all locking requests a noop. Doing it the proper way as you suggest
> may be nicer, but this was a method that existed within my
> abilities...

Well, my change also enables the TDB_NOSYNC flag, which eliminates the
sync calls.  Based on your straces, I'm not convinced that will make a
huge difference, but it might be worth a try.

> > Could you let me know what this does to the performance of e2fsck
> > with scratch files enabled?
> 
> I apparently have scratch files enabled, right?

Well, given that you are accessing the tdb files, I assume you have an
e2fsck.conf file that has the "[scratch_files]" configuration section
in it....

> I just straced 
> 
> 1298236533.396622 _llseek(3, 522912374784, [], SEEK_SET) = 0 <0.000038>
> 1298236540.311416 _llseek(3, 522912407552, [], SEEK_SET) = 0 <0.000035>
> 1298236547.288401 _llseek(3, 522912440320, [], SEEK_SET) = 0 <0.000035>
> 
> and I see it seeking to somewhere in the 486Gb range. Does this mean
> it has 6x more to go? 

Well, I assume at the moment you're still in pass 1.  After you finish
the scan of the inode table, you'll need to scan directory blocks,
which will also involve touching the tdb dirinfo file (but mostly not
the icount file).  So it might be closer to two weeks, but yeah, we're
talking about 1-2 weeks, not months or years.  :-)

> To estimate the time-to-run, would it be safe to suspend the running
> fsck, and start an fsck -n ? I've invested 10 CPU hours in this fsck
> instance already, I would like it to finish eventually... 9 days seems
> doable...

Yes, that should be safe.

> out-of-order example: 
> 
> 1298236950.540958 _llseek(3, 523986247680, [], SEEK_SET) = 0 <0.000035>
> 1298236950.646999 _llseek(3, 523986280448, [], SEEK_SET) = 0 <0.000038>
> 1298236952.813587 _llseek(3, 630728769536, [], SEEK_SET) = 0 <0.000036>
> 1298236953.947109 _llseek(3, 523986313216, [], SEEK_SET) = 0 <0.000035>
> 1298236953.948982 _llseek(3, 523986345984, [], SEEK_SET) = 0 <0.000015>
> 
> (I've deleted the number in the brackets, it's the same as the number
> before.)

The out of order scan was probably reading an extent tree block.

> 
> > Oh, and BTW, it would be useful if you tried configuring
> > tests/test_config so that it sets E2FSCK_CONFIG with a test
> > e2fsck.conf that enables the scratch files somewhere in tmp, and then
> > run the regression test suite with these changes.
> 
> I'm not sure I understand correctly. Although undocumented you're
> saying that e2fsck honors an environment variable E2FSCK_CONFIG, that
> allows me to specify a different config file from /etc/e2fsck.conf.

Correct.


> I've created a e2fsck.conf file in the tests directory and changed it
> to: 
> [options]
>         buggy_init_scripts = 1
> [scratch_files]
>   directory=/tmp

Well, it won't use the e2fsck.conf file unless you also modify the
test_config.in file, since it generates the test_config file, which
explicitly sets E2FSCK_CONF to be /dev/null (this prevents a locally
installed /etc/e2fsck.conf file from affecting the test results).

> With "send me patches" you mean with the NOSYNC option enabled?

Well, with the TDB_NOSYNC and TDB_NOLOCK flags set.  Although it looks
like it might not be sufficient.

BTW, my backup plan was to replace tdb with something else.  One of
the candidates I was looking at was sqlite, but rumors of its speed
deficiencies are making me worry that it won't be a good fit.  I don't
want to use berk_db because it has a habit of changing API's
regularly, and you can never be sure which version of berk_db
different distributions might be using.  One package which I thought
held promise was Koyoto Cabinet, but unfortunately, it's released
under GPLv3, which makes it incompatible with the license used by
e2fsprogs (which has to be GPLv2, since there are a few files which
are shared with the Linux kernel).

Here's another possibility if you are willing to replace the kernel
--- can you upgrade to a 64-bit kernel, even if you are mostly using
32-bit binaries, and then use a statically linked 64-bit e2fsck?  Then
all you need to do is configure a nice big swap space, and then
disable the scratch_files section in e2fsck.conf....

					- Ted
