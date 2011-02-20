From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Mon, 21 Feb 2011 00:15:14 +0100
Message-ID: <20110220231514.GC21917@bitwizard.nl>
References: <20110220090656.GA11402@bitwizard.nl> <20110220170931.GB3017@thunk.org> <20110220193406.GC3017@thunk.org> <20110220215531.GA21917@bitwizard.nl> <20110220222013.GA2849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:64747 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755279Ab1BTXPQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 18:15:16 -0500
Content-Disposition: inline
In-Reply-To: <20110220222013.GA2849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 20, 2011 at 05:20:13PM -0500, Ted Ts'o wrote:
> On Sun, Feb 20, 2011 at 10:55:31PM +0100, Rogier Wolff wrote:
> > I looked into this myself as well. Suspecting the locking calls I put
> > a "return 0" in the first line of the tdb locking function. This makes
> > all locking requests a noop. Doing it the proper way as you suggest
> > may be nicer, but this was a method that existed within my
> > abilities...
> 
> Well, my change also enables the TDB_NOSYNC flag, which eliminates the
> sync calls.  Based on your straces, I'm not convinced that will make a
> huge difference, but it might be worth a try.

In my straces it is not calling sync. So the performance hit
of the "sync calls" is unmeasurable.... 

> > > Could you let me know what this does to the performance of e2fsck
> > > with scratch files enabled?
> > 
> > I apparently have scratch files enabled, right?
> 
> Well, given that you are accessing the tdb files, I assume you have an
> e2fsck.conf file that has the "[scratch_files]" configuration section
> in it....

Yeah. Found that near the end of writing my message. I'm starting to
remember something about e2fsck crashing outright because of the
scratchfiles missing.... 

> > I just straced 
> > 
> > 1298236533.396622 _llseek(3, 522912374784, [], SEEK_SET) = 0 <0.000038>
> > 1298236540.311416 _llseek(3, 522912407552, [], SEEK_SET) = 0 <0.000035>
> > 1298236547.288401 _llseek(3, 522912440320, [], SEEK_SET) = 0 <0.000035>
> > 
> > and I see it seeking to somewhere in the 486Gb range. Does this mean
> > it has 6x more to go? 
> 
> Well, I assume at the moment you're still in pass 1.  After you finish
> the scan of the inode table, you'll need to scan directory blocks,
> which will also involve touching the tdb dirinfo file (but mostly not
> the icount file).  So it might be closer to two weeks, but yeah, we're
> talking about 1-2 weeks, not months or years.  :-)

Oh....  On the other hand, it seems it takes a sprint, reading more
like 10Mb per second at the beginning. And it seems to be slowing down
due to linearly searching a list or something like that. Thus when it
has progressed 2x further than where it is now it'll be 2x slower.

That might mean we need 2 weeks * 25.... :-(

> > To estimate the time-to-run, would it be safe to suspend the running
> > fsck, and start an fsck -n ? I've invested 10 CPU hours in this fsck
> > instance already, I would like it to finish eventually... 9 days seems
> > doable...
> 
> Yes, that should be safe.
> 
> > out-of-order example: 
> > 
> > 1298236950.540958 _llseek(3, 523986247680, [], SEEK_SET) = 0 <0.000035>
> > 1298236950.646999 _llseek(3, 523986280448, [], SEEK_SET) = 0 <0.000038>
> > 1298236952.813587 _llseek(3, 630728769536, [], SEEK_SET) = 0 <0.000036>
> > 1298236953.947109 _llseek(3, 523986313216, [], SEEK_SET) = 0 <0.000035>
> > 1298236953.948982 _llseek(3, 523986345984, [], SEEK_SET) = 0 <0.000015>
> > 
> > (I've deleted the number in the brackets, it's the same as the number
> > before.)
> 
> The out of order scan was probably reading an extent tree block.
> 
> > 
> > > Oh, and BTW, it would be useful if you tried configuring
> > > tests/test_config so that it sets E2FSCK_CONFIG with a test
> > > e2fsck.conf that enables the scratch files somewhere in tmp, and then
> > > run the regression test suite with these changes.
> > 
> > I'm not sure I understand correctly. Although undocumented you're
> > saying that e2fsck honors an environment variable E2FSCK_CONFIG, that
> > allows me to specify a different config file from /etc/e2fsck.conf.
> 
> Correct.
> 
> 
> > I've created a e2fsck.conf file in the tests directory and changed it
> > to: 
> > [options]
> >         buggy_init_scripts = 1
> > [scratch_files]
> >   directory=/tmp
> 
> Well, it won't use the e2fsck.conf file unless you also modify the
> test_config.in file, since it generates the test_config file, which
> explicitly sets E2FSCK_CONF to be /dev/null (this prevents a locally
> installed /etc/e2fsck.conf file from affecting the test results).

Ah! Back to the drawing board. :-) I'll redo the tests. 

102 tests succeeded     0 tests failed


> > With "send me patches" you mean with the NOSYNC option enabled?
> 
> Well, with the TDB_NOSYNC and TDB_NOLOCK flags set.  Although it looks
> like it might not be sufficient.

No. I would like to find out where it's spending its CPU time. When
the kernel suspends a process, it has to store the current userspace
program counter somewhere.

[....] It's called 
   kstkeip
in /proc/<pid>/stat  . It is the 30th field . 

Now figure out a way to reverse this to what function it's in.
Hmm. My eip is:  3076930326 which is hex 0xB7663B16. 
According to /proc/<pid>/maps this is: 

b75ee000-b75ef000 rw-p 00000000 00:00 0 
b75ef000-b772f000 r-xp 00000000 09:02 103630     /lib/i686/cmov/libc-2.11.2.so
b772f000-b7731000 r--p 0013f000 09:02 103630     /lib/i686/cmov/libc-2.11.2.so
b7731000-b7732000 rw-p 00141000 09:02 103630     /lib/i686/cmov/libc-2.11.2.so

in the executable part of libc ???

Every once in a while... it ends up somewhere else... Ah. Succes!

08077340 t tdb_rec_read
08077349
08077356
080773d2
080773f2
080773fa

08077c50 t tdb_oob
08077c51
08077c6a
08077cbd
08077cc3

080787a0 t tdb_read
080787a1
080787a1
080787a9
080787a9
080787be
080787e1
080787e9
080787f3
080787f8
080787f8
080787fb
08078809
0807880f

08078bb0 t tdb_find
08078bfa
08078c11
08078c11
08078c1c

I've managed to catch it outside of "libc" some 30 times the last 5
minutes. I'll leave it running the next few hours, to make a bit
better profile.

Now we have a couple of functions where fsck spends its time outside
of libc, and one of them is the likely candidate for calling a
time-consuming libc function.

> BTW, my backup plan was to replace tdb with something else.  One of
> the candidates I was looking at was sqlite, but rumors of its speed
> deficiencies are making me worry that it won't be a good fit.  I don't
> want to use berk_db because it has a habit of changing API's
> regularly, and you can never be sure which version of berk_db
> different distributions might be using.  One package which I thought
> held promise was Koyoto Cabinet, but unfortunately, it's released
> under GPLv3, which makes it incompatible with the license used by
> e2fsprogs (which has to be GPLv2, since there are a few files which
> are shared with the Linux kernel).

Hmm. I'll take a look. 

> Here's another possibility if you are willing to replace the kernel
> --- can you upgrade to a 64-bit kernel, even if you are mostly using
> 32-bit binaries, and then use a statically linked 64-bit e2fsck?  Then
> all you need to do is configure a nice big swap space, and then
> disable the scratch_files section in e2fsck.conf....

Ohhhhh shit. long time ago that I've done that.... I have a page on my
internal wiki on how to do this..... Problem is....

driepoot:/home/wolff# grep lm /proc/cpuinfo 
driepoot:/home/wolff# 

.... it doesn't have a 64-bit CPU.... :-(

I thought when I bought those that buying AMD chips would give me
64-bit because AMD had brought that feature down to the lower-end
chips (at least much lower-end than Intel), but apparenly not to 
the desktop CPUs that I was buying at the time. I didn't want to
run 64-bit OSes on those machines until years later... 

	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
