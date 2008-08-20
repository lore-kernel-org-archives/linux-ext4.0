From: Sami Liedes <sliedes@cc.hut.fi>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Wed, 20 Aug 2008 16:29:59 +0300
Message-ID: <20080820132959.GM8997@lh.kyla.fi>
References: <bug-11266-10286@http.bugzilla.kernel.org/> <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi> <20080807202840.GC26307@lh.kyla.fi> <20080818145841.GC10621@atrey.karlin.mff.cuni.cz> <20080818165131.GC6491@skywalker> <20080819032410.GE3392@webber.adilger.int> <20080819091339.GE14799@duck.suse.cz> <20080819105111.GK8997@lh.kyla.fi> <20080820102533.GA5979@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:36446 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYHTNn2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 09:43:28 -0400
Content-Disposition: inline
In-Reply-To: <20080820102533.GA5979@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 12:25:33PM +0200, Jan Kara wrote:
>   OK, thanks. Then we must somehow corrupt group descriptor block during
> the operation. Because I'm pretty sure it *is* corrupted - the oops
> is: unable to handle kernel paging request at c7e95ffc. If we look into
> registers, we see ECX has c7e96000 (which is probably bh->b_data). In
> the second oops it's exactly the same - ECX has c11e4000, the oops is at
> address c11e3ffc. So in both cases it is ECX-4. So somehow we managed to
> pass negative offset into ext2_test_bit(). But as Andreas pointed out,
> when we load descriptors into memory, we check that both bitmaps and
> inode table is in ext2_check_descriptors()... The other possibility
> would be that we managed to corrupts s_first_data_block in the
> superblock. Anyway, both possibilities don't look very likely. I'll try
> to reproduce the problem and maybe get more insight... How large is your
> filesystem BTW?

My FS is 10 MiB and tries to be diverse in its contents. It has a copy
of my /dev and a small partial copy of /usr/share/doc.

I put the pristine (non-corrupted) filesystem at

   http://www.hut.fi/~sliedes/fsdebug-hdc-ext2.bz2

(520k compressed).

I've been thinking I should write a script to prepare the root
filesystem for the tests, but haven't got that far yet. Basically
(unless I forget some step) I use debootstrap to bootstrap a minimal
Debian system, create some needed devices in it (hd[abc], ttyS0 at
least), set the hostname to fstest, configure getty to listen to
ttyS0, copy the script to /root/runtest (the script's first parameter
is the seed) and install some Debian packages (zzuf and timeout at
least).

Then I make four copies of the images and run four qemus in parallel
since I have four cpus, modifying the first parameter (initial seed)
of the runtest script, e.g. 0, 10M, 20M, 30M.

I guess the approach might be useful for those who write the code too
(or people closer to them than me), since I've already found a fair
number of bugs with it in a fairly short period of time (#10871,
#10882, #10976, #11250, #11253, #11266 for ext[23] bugs, also one ext4
bug I hit when an ext3 fs was detected as ext4; search bugzilla for my
email to see the rest of the bugs).

The current root filesystem is 144M compressed (yeah, there's a lot of
stuff irrelevant to the tests there), I could upload it somewhere if
that helps. After that running the tests is a matter of running
something like

   qemu -kernel bzImage -append 'root=/dev/hda console=ttyS0,115200n8' \
       -hda hda -hdb hdb -hdc hdc -nographic -serial pty

, attaching a screen session to the allocated pty, logging in as root
and running ./runtest $seed.

Also the tests are not as comprehensive as I'd like. As an example,
some years ago I stress tested reiser4 (it was already "ready") with
pretty mundane operations (without corrupting the fs) and it worked,
but I've got it to break badly at three separate times in separate
ways just by normally using Debian's aptitude - the breakage was in
flock(), and the current tests don't test flock()). Other things to
test would be at least hard links and fifos...

The level of automation isn't quite what I'd like either, optimally
there would just be a single script that takes the kernel image,
filesystem type and number of parallel instances as arguments and runs
the tests.

	Sami
