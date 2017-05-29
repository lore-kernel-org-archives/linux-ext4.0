From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] generic: Add regression test for tail page zeroing
Date: Mon, 29 May 2017 13:30:59 +0200
Message-ID: <20170529113059.GF3608@quack2.suse.cz>
References: <20170525134947.15130-1-jack@suse.cz>
 <20170526122527.GN23805@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, fstests@vger.kernel.org,
        Michael Zimmer <michael@swarm64.com>,
        linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170526122527.GN23805@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 26-05-17 20:25:27, Eryu Guan wrote:
> On Thu, May 25, 2017 at 03:49:47PM +0200, Jan Kara wrote:
> > Add test checking for a race in ext4 writeback that could result in
> > zeroing too much from the tail page during writeback.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  src/Makefile           |  2 +-
> >  src/t_mmap_fallocate.c | 61 ++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/438      | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/438.out  |  2 ++
> >  tests/generic/group    |  1 +
> >  5 files changed, 140 insertions(+), 1 deletion(-)
> >  create mode 100644 src/t_mmap_fallocate.c
> >  create mode 100755 tests/generic/438
> >  create mode 100644 tests/generic/438.out
> > 
> > diff --git a/src/Makefile b/src/Makefile
> > index 47246622ce7f..adbfd286fe89 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -13,7 +13,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
> >  	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
> >  	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
> >  	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
> > -	t_mmap_cow_race
> > +	t_mmap_cow_race t_mmap_fallocate
> 
> A new test program needs an entry in .gitignore file :)

Thanks. Fixed.

> > +	if (argc != 3) {
> > +		fputs("Usage: mmap_fallocate <file> <size-in-MB>\n", stderr);
>                               ^^^^^^^^^^^^^^ t_mmap_fallocate or argv[0] ?

Yeah, used basename(argv[0]).

> > +	buf = mmap(NULL, fsize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> > +	if (buf == MAP_FAILED) {
> > +		perror("Cannot memory map");
> > +		exit(1);
> > +	}
> > +
> > +	for (i = 0; i < fsize; i++) {
> > +		if (posix_fallocate(fd, i, 1) != 0) {
> > +			perror("Cannot fallocate");
> > +			exit(1);
> > +		}
> > +		buf[i] = 0x78;
> 
> It seems hard to understand the purpose of this part without looking at
> the referenced kernel patch. I think it's good to have some comments in
> this c program to explain the test steps.

OK, will add.

> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test
> > +_require_test_program "t_mmap_fallocate"
> > +
> > +# real QA test starts here
> > +FILE=$TEST_DIR/testfile_fallocate
> > +# Make sure file exists
> > +echo >$FILE
> > +# Force frequent writeback of the file
> > +while true; do fsync $FILE; done &
> 
> Meant '$XFS_IO_PROG -c fsync $FILE' ? There's no 'fsync' command
> avalable on my host.

Ah, OK.

> > +SYNCPID=$!
> > +
> > +# Run the test
> > +src/t_mmap_fallocate $FILE 10 && echo "Silence is golden"
> 
> Hmm, iterating over a 10MB file takes xfs 203s to finish on my test vm,
> and takes btrfs 8178s to finish.. That's too long time for a test in
> auto group.
> 
> I found that if I change t_mmap_fallocate to accept file size in KB
> instead MB, and specify file size as 16 in the test, the ext4 bug can
> still be reproduced pretty quickly, and xfs and btrfs also finish the
> test quickly (1s for xfs, 11s for btrfs on my host).

OK, I'll change it. I was originally sizing the test with just background
writeback (without the fsync running in a loop) and that required much
larger sizes. With fsync the problem reproduces more easily and so reducing
the file size is fine. However 16 seems too low for me to reproduce. I need
at least 256 KB for the problem to reproduce reasonably reliably - I've
changed the file size to that.

> Another problem I hit was that at times something was pinning the
> filesystem in use after test, and test harness failed to umount TEST_DIR
> then reported test failure, because the device was busy. I'm not sure
> the exact reason for now, but removing $FILE in _cleanup does resolve
> the problem for me.

I've hit that once but then the problem disappeared so I thought I've fixed
it by some twiddling. I've added rm $FILE to _cleanup since it makes sense
however I suppose the culprit of the problem is that kill and wait just
work with the shell that gets executed in the background. However xfs_io
(or fsync) command it spawns still can be executing and they can pin the
mountpoint. Actually I was able to hit the problem when trying hard enough
even with 'rm'. I've fixed the problem by trapping the signal in the
subshell and making sure xfs_io is finished when the shell exits...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
