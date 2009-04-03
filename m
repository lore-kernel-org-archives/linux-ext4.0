From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Fri, 3 Apr 2009 12:02:54 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757479AbZDCTFv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Apr 2009 15:05:51 -0400
In-Reply-To: <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 3 Apr 2009, Linus Torvalds wrote:

> 
> 
> On Fri, 3 Apr 2009, Theodore Ts'o wrote:
> > 
> > Please pull from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext3-latency-fixes
> 
> Thanks, pulled. I'll be interested to see how it feels. Will report back 
> after I've rebuild and gone through a few more emails.

Hmm.

The "overwrite" behavior may well be better, but it was smooth enough 
beforehand too (never having more than ~8MB dirty). The "create big file 
and sync" workload causes huge fsync pauses, though. IOW, try with

	while :
	do
		time sh -c "dd if=/dev/zero of=bigfile bs=8M count=256 ; sync"
	done

and even really small fsync's end up being at the end of all that 
unrelated activity, and you see things like

    fsync(7)                                = 0 <32.756308>

(that was my "switch email folders with update" test case, the full trace 
for that file descriptor is

    open("/home/torvalds/mail/git-list", O_RDWR) = 7 <0.000010>
    fstatfs(7, {f_type="EXT2_SUPER_MAGIC", f_bsize=4096, f_blocks=19230104, f_bfree=13853292, f_bavail=12876440, f_files=4890624
    flock(7, LOCK_EX)                       = 0 <0.000009>
    fstat(7, {st_mode=S_IFREG|0600, st_size=54231534, ...}) = 0 <0.000005>
    lseek(7, 0, SEEK_SET)                   = 0 <0.000006>
    write(7, "From MAILER-DAEMON Fri Apr  3 11:"..., 554) = 554 <0.000012>
    lseek(7, 54202529, SEEK_SET)            = 54202529 <0.000007>
    read(7, "From torvalds@linux-foundation.or"..., 66) = 66 <0.000008>
    lseek(7, 54202595, SEEK_SET)            = 54202595 <0.000006>
    read(7, "Return-Path: <git-owner@vger.kern"..., 2915) = 2915 <0.000007>
    lseek(7, 54202529, SEEK_SET)            = 54202529 <0.000005>
    write(7, "From torvalds@linux-foundation.or"..., 2981) = 2981 <0.000009>
    ftruncate(7, 54231534)                  = 0 <0.000008>
    fsync(7)                                = 0 <32.756308>
    close(7)                                = 0 <0.000006>

so it had done just a few kB of writes, but because it ended up behind
the humongous backlog of 'bigfile' it didn't much help.

Also, it's maybe worth noting that you don't actually need a 2GB file to 
trigger this behavior. Change that "count=256" into a "count=16", and you 
now have a simulation of just writing 128MB at a time, with a "sync" in 
between to make sure it hits the disk.  It makes the pauses smaller, but 
they are still several seconds.

(That, btw, is probably more the kind of thing I see when doign a "yum 
update". I assume a package manager would do exactly that kind of "unpack 
files and sync" in a loop).

Btw, I assume this same thing holds true for ext4 too? Because it shows 
how two different "sync" operations interact, and one kills the 
performance of the other one. So as long as there is a _single_ fsync() 
user, you're fine. It's when you get more than one...

Again, I have that Intel SSD that should do pretty reliably 40+MB/s even 
with really nasty write patterns, so I do need several hundred megs to 
really see painful pauses. On a slower disk you'd need much less).

			Linus
