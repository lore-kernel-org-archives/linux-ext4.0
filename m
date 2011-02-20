From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Sun, 20 Feb 2011 22:55:31 +0100
Message-ID: <20110220215531.GA21917@bitwizard.nl>
References: <20110220090656.GA11402@bitwizard.nl> <20110220170931.GB3017@thunk.org> <20110220193406.GC3017@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:63382 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754363Ab1BTVzd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Feb 2011 16:55:33 -0500
Content-Disposition: inline
In-Reply-To: <20110220193406.GC3017@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted, 

Thanks for looking into this... 

On Sun, Feb 20, 2011 at 02:34:06PM -0500, Ted Ts'o wrote:
> On Sun, Feb 20, 2011 at 12:09:31PM -0500, Ted Ts'o wrote:
> > 
> > Ah, you're using tdb.  Tdb can be really slow.  It's been on my todo
> > list to replace tdb with something else, but I haven't gotten around
> > to it.
> 
> Hmm... after taking a quick look at the TDB sources, why don't you try
> this.  In lib/ext2fs/icount.c and e2fsck/dirinfo.c, try replacing the
> flag TDB_CLEAR_IF_FIRST with TDB_NOLOCK | TDB_NOSYNC.  i.e., try
> replacing:
> 
> 	icount->tdb = tdb_open(fn, 0, TDB_CLEAR_IF_FIRST,
> 			       O_RDWR | O_CREAT | O_TRUNC, 0600);
> 
> with:
> 
> 	icount->tdb = tdb_open(fn, 0, TDB_NOLOCK | TDB_NOSYNC,
> 			       O_RDWR | O_CREAT | O_TRUNC, 0600);

I looked into this myself as well. Suspecting the locking calls I put
a "return 0" in the first line of the tdb locking function. This makes
all locking requests a noop. Doing it the proper way as you suggest
may be nicer, but this was a method that existed within my
abilities...

Ayway, this removed all the fcntl calls to lock and unlock the
database.... It didn't solve the performance issue though.... 

Here is an strace... 

0.000379  .525531 munmap(0x8d03e000, 108937216) = 0
0.008008  .533540 ftruncate(5, 108941312) = 0
0.000207  .533748 pwrite64(5, "BBBBBBBBBB"..., 1024, 108937216) = 1024
0.000235  .533983 pwrite64(5, "BBBBBBBBBB"..., 1024, 108938240) = 1024
0.000108  .534092 pwrite64(5, "BBBBBBBBBB"..., 1024, 108939264) = 1024
0.000138  .534230 pwrite64(5, "BBBBBBBBBB"..., 1024, 108940288) = 1024
0.000106  .534336 mmap2(NULL, 108941312, PROT_READ|PROT_WRITE, MAP_SHARED, 5, 0) = 0x8d03d000
1.994850 2.529190 fstat64(6, {st_mode=S_IFREG|0600, st_size=92045312, ...}) = 0

The first column is the difference of the timestamp on THIS line
compared to the previous one. Consider that mostly CPUtime. 

The system calls all take between 17 and 127 microseconds. i.e.  fast.
The exception is the munmap call, which takes 7
milliseconds. Acceptable.

The performance killer is the almost two seconds of CPU time spent
before the fstat of the 5 or 6 file descriptors. 

It seems wasteful to mmap and munmap the whole 100M of those two
files all the time. 

The "BBBBB" strings in the pwrite calls are the padding. 0x42, get it?

I checked... The full 4x1024 bytes are just padding. Nothing else.


> Could you let me know what this does to the performance of e2fsck
> with scratch files enabled?

I apparently have scratch files enabled, right? I just typed

./configure ; ./make ; scp e2fsck/e2fsck othermachine:e2fsck.test 

so I didn't mess with the configuration. 


I just straced 

1298236533.396622 _llseek(3, 522912374784, [], SEEK_SET) = 0 <0.000038>
1298236540.311416 _llseek(3, 522912407552, [], SEEK_SET) = 0 <0.000035>
1298236547.288401 _llseek(3, 522912440320, [], SEEK_SET) = 0 <0.000035>

and I see it seeking to somewhere in the 486Gb range. Does this mean
it has 6x more to go? I don't really see the numbers increasing
significantly. Although out-of-order numbers appear in the llseek
outputs, the most common numbers are slowly increasing. 

I had first estimated thee ETA around the end of this century, but that
seems to be a bit overly pessimistic. I probably missed a factor of
1000 somewhere. I now get about 9 days. That means I'm likely to live
long enough to see the end of this..... :-)

Whenever the time to completion seems longer than optimizing it a bit
and then restarting, I'll restart. But in this case, if I keep
estimating the "normal fsck time" as 8 hours, and "a bit of coding" as
2 hours, I'm afraid It will never finish.

To estimate the time-to-run, would it be safe to suspend the running
fsck, and start an fsck -n ? I've invested 10 CPU hours in this fsck
instance already, I would like it to finish eventually... 9 days seems
doable...


out-of-order example: 

1298236950.540958 _llseek(3, 523986247680, [], SEEK_SET) = 0 <0.000035>
1298236950.646999 _llseek(3, 523986280448, [], SEEK_SET) = 0 <0.000038>
1298236952.813587 _llseek(3, 630728769536, [], SEEK_SET) = 0 <0.000036>
1298236953.947109 _llseek(3, 523986313216, [], SEEK_SET) = 0 <0.000035>
1298236953.948982 _llseek(3, 523986345984, [], SEEK_SET) = 0 <0.000015>

(I've deleted the number in the brackets, it's the same as the number
before.)


> Oh, and BTW, it would be useful if you tried configuring
> tests/test_config so that it sets E2FSCK_CONFIG with a test
> e2fsck.conf that enables the scratch files somewhere in tmp, and then
> run the regression test suite with these changes.

I'm not sure I understand correctly. Although undocumented you're
saying that e2fsck honors an environment variable E2FSCK_CONFIG, that
allows me to specify a different config file from /etc/e2fsck.conf.

I've created a e2fsck.conf file in the tests directory and changed it
to: 
[options]
        buggy_init_scripts = 1
[scratch_files]
  directory=/tmp

I've then pointed E2FSCK_CONFIG to this file (absolute pathname). I
then chickend out and edited my system /etc/e2fsck.conf to be the
same.

Next I typed "make" and got: 
102 tests succeeded     0 tests failed

> If they work, and it solves the performance problem, let me know and
> send me patches.  If we can figure out some way of improving the
> performance without needing to replace tdb, that would be great...

The system where the large filesystem is running already has an
e2fsck.conf that holds:

[scratch_files]
        directory = /var/cache/e2fsck

With "send me patches" you mean with the NOSYNC option enabled?


	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
