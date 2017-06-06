From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [xfstests PATCH v3 1/5] generic: add a writeback error handling
 test
Date: Tue, 06 Jun 2017 06:15:57 -0400
Message-ID: <1496744157.27183.1.camel@redhat.com>
References: <20170531130820.17634-1-jlayton@redhat.com>
         <20170531130820.17634-2-jlayton@redhat.com>
         <20170606085855.GN19952@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net, dhowells@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606085855.GN19952@eguan.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-06-06 at 16:58 +0800, Eryu Guan wrote:
> On Wed, May 31, 2017 at 09:08:16AM -0400, Jeff Layton wrote:
> > I'm working on a set of kernel patches to change how writeback errors
> > are handled and reported in the kernel. Instead of reporting a
> > writeback error to only the first fsync caller on the file, I aim
> > to make the kernel report them once on every file description.
> > 
> > This patch adds a test for the new behavior. Basically, open many fds
> > to the same file, turn on dm_error, write to each of the fds, and then
> > fsync them all to ensure that they all get an error back.
> > 
> > To do that, I'm adding a new tools/dmerror script that the C program
> > can use to load the error table. For now, that's all it can do, but
> > we can fill it out with other commands as necessary.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> Thanks for the new tests! And sorry for the late review..
> 
> It's testing a new behavior on error reporting on writeback, I'm not
> sure if we can call it a new feature or it fixed a bug? But it's more
> like a behavior change, I'm not sure how to categorize it.
> 
> Because if it's testing a new feature, we usually let test do proper
> detection of current test environment (based on actual behavior not
> kernel version) and _notrun on filesystems that don't have this feature
> yet, instead of failing the test; if it's testing a bug fix, we could
> leave the test fail on unfixed filesystems, this also serves as a
> reminder that there's bug to fix.
> 

Thanks for the review! I'm not sure how to categorize this either. Since
the plan is to convert all the filesystems piecemeal, maybe we should
just consider it a new feature.

> I pulled your test kernel tree, and test passed on EXT4 but failed on
> other local filesystems (XFS, btrfs). I assume that's expected.
> 
> Besides this kinda high-level question, some minor comments inline.
> 

Yes, ext4 should pass on my latest kernel tree, but everything else
should fail. 

> > ---
> >  common/dmerror             |  13 ++--
> >  doc/auxiliary-programs.txt |   8 +++
> >  src/Makefile               |   2 +-
> >  src/fsync-err.c            | 161 +++++++++++++++++++++++++++++++++++++++++++++
> 
> New binary needs an entry in .gitignore file.
> 

OK, thanks. Will fix.

> >  tests/generic/999          |  76 +++++++++++++++++++++
> >  tests/generic/999.out      |   3 +
> >  tests/generic/group        |   1 +
> >  tools/dmerror              |  44 +++++++++++++
> 
> This file is used by the test, then it should be in src/ directory and
> be installed along with other executable files on "make install".
> Because files under tools/ are not installed. Most people will run tests
> in the root dir of xfstests and this is not a problem, but there're
> still cases people do "make && make install" and run fstests from
> /var/lib/xfstests (default installation target).
> 

Ok, no problem. I'll move it. I wasn't sure here since dmerror is a
shell script, and most of the stuff in src/ is stuff that needs to be
built.
 
> >  8 files changed, 302 insertions(+), 6 deletions(-)
> >  create mode 100644 src/fsync-err.c
> >  create mode 100755 tests/generic/999
> >  create mode 100644 tests/generic/999.out
> >  create mode 100755 tools/dmerror
> > 
> > diff --git a/common/dmerror b/common/dmerror
> > index d46c5d0b7266..238baa213b1f 100644
> > --- a/common/dmerror
> > +++ b/common/dmerror
> > @@ -23,22 +23,25 @@ if [ $? -eq 0 ]; then
> >  	_notrun "Cannot run tests with DAX on dmerror devices"
> >  fi
> >  
> > -_dmerror_init()
> > +_dmerror_setup()
> >  {
> >  	local dm_backing_dev=$SCRATCH_DEV
> >  
> > -	$DMSETUP_PROG remove error-test > /dev/null 2>&1
> > -
> >  	local blk_dev_size=`blockdev --getsz $dm_backing_dev`
> >  
> >  	DMERROR_DEV='/dev/mapper/error-test'
> >  
> >  	DMLINEAR_TABLE="0 $blk_dev_size linear $dm_backing_dev 0"
> >  
> > +	DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
> > +}
> > +
> > +_dmerror_init()
> > +{
> > +	_dmerror_setup
> > +	$DMSETUP_PROG remove error-test > /dev/null 2>&1
> >  	$DMSETUP_PROG create error-test --table "$DMLINEAR_TABLE" || \
> >  		_fatal "failed to create dm linear device"
> > -
> > -	DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
> >  }
> >  
> >  _dmerror_mount()
> > diff --git a/doc/auxiliary-programs.txt b/doc/auxiliary-programs.txt
> > index 21ef118596b6..191ac0596511 100644
> > --- a/doc/auxiliary-programs.txt
> > +++ b/doc/auxiliary-programs.txt
> > @@ -16,6 +16,7 @@ note the dependency with:
> >  Contents:
> >  
> >   - af_unix		-- Create an AF_UNIX socket
> > + - fsync-err		-- tests fsync error reporting after failed writeback
> >   - open_by_handle	-- open_by_handle_at syscall exercise
> >   - stat_test		-- statx syscall exercise
> >   - t_dir_type		-- print directory entries and their file type
> > @@ -30,6 +31,13 @@ af_unix
> >  
> >  	The af_unix program creates an AF_UNIX socket at the given location.
> >  
> > +fsync-err
> > +	Specialized program for testing how the kernel reports errors that
> > +	occur during writeback. Works in conjunction with the dmerror script
> > +	in tools/ to write data to a device, and then force it to fail
> > +	writeback and test that errors are reported during fsync and cleared
> > +	afterward.
> > +
> >  open_by_handle
> >  
> >  	The open_by_handle program exercises the open_by_handle_at() system
> > diff --git a/src/Makefile b/src/Makefile
> > index 4ec01975f8f7..b79c4d84d31b 100644
> > --- a/src/Makefile
> > +++ b/src/Makefile
> > @@ -13,7 +13,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
> >  	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
> >  	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
> >  	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
> > -	t_mmap_cow_race
> > +	t_mmap_cow_race fsync-err
> >  
> >  LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
> >  	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
> > diff --git a/src/fsync-err.c b/src/fsync-err.c
> > new file mode 100644
> > index 000000000000..cbeb37fb1790
> > --- /dev/null
> > +++ b/src/fsync-err.c
> > @@ -0,0 +1,161 @@
> > +/*
> > + * fsync-err.c: test whether writeback errors are reported to all open fds
> > + * 		and properly cleared as expected after being seen once on each
> > + *
> > + * Copyright (c) 2017: Jeff Layton <jlayton@redhat.com>
> > + */
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <stdlib.h>
> > +#include <stdio.h>
> > +#include <string.h>
> > +#include <unistd.h>
> > +
> > +/*
> > + * btrfs has a fixed stripewidth of 64k, so we need to write enough data to
> > + * ensure that we hit both stripes.
> > + *
> > + * FIXME: have the test script pass in the length?
> > + */
> > +#define BUFSIZE (65 * 1024)
> > +
> > +/* FIXME: should this be tunable */
> > +#define NUM_FDS	10
> 
> Passed through command line parameter, and default value is 10 if not
> specified?
> 

Sure. Perhaps we should do the same with BUFSIZE? Particularly if we
need to vary it between fs'.

> > +
> > +static void usage() {
> > +	fprintf(stderr, "Usage: fsync-err <filename>\n");
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	int fd[NUM_FDS], ret, i;
> > +	char *fname, *buf;
> > +
> > +	if (argc < 1) {
> > +		usage();
> > +		return 1;
> > +	}
> > +
> > +	/* First argument is filename */
> > +	fname = argv[1];
> > +
> > +	for (i = 0; i < NUM_FDS; ++i) {
> > +		fd[i] = open(fname, O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > +		if (fd[i] < 0) {
> > +			printf("open of fd[%d] failed: %m\n", i);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	buf = malloc(BUFSIZE);
> > +	if (!buf) {
> > +		printf("malloc failed: %m\n");
> > +		return 1;
> > +	}
> > +
> > +	memset(buf, 0x7c, BUFSIZE);
> > +
> > +	for (i = 0; i < NUM_FDS; ++i) {
> > +		ret = write(fd[i], buf, BUFSIZE);
> > +		if (ret < 0) {
> > +			printf("First write on fd[%d] failed: %m\n", i);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < NUM_FDS; ++i) {
> > +		ret = fsync(fd[i]);
> > +		if (ret < 0) {
> > +			printf("First fsync on fd[%d] failed: %m\n", i);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	/* flip the device to non-working mode */
> > +	ret = system("./tools/dmerror load_error_table");
> 
> Hmm, how about passing these "load error table" and "load working table"
> commands through command line parameters too?
> 
> > +	if (ret) {
> > +		if (WIFEXITED(ret))
> > +			printf("system: program exited: %d\n",
> > +					WEXITSTATUS(ret));
> > +		else
> > +			printf("system: 0x%x\n", (int)ret);
> > +
> > +		return 1;
> > +	}
> > +
> > +	for (i = 0; i < NUM_FDS; ++i) {
> > +		ret = write(fd[i], buf, strlen(buf) + 1);
> > +		if (ret < 0) {
> > +			printf("Second write on fd[%d] failed: %m\n", i);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < NUM_FDS; ++i) {
> > +		ret = fsync(fd[i]);
> > +		/* Now, we EXPECT the error! */
> > +		if (ret >= 0) {
> > +			printf("Success on second fsync on fd[%d]!\n", i);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < NUM_FDS; ++i) {
> > +		ret = fsync(fd[i]);
> > +		if (ret < 0) {
> > +			/* Now the error should be clear */
> 
> It's not obvious to me why error should be clear at this stage, adding
> some comments would be good.
> 

Ok. FWIW:

We did some writes to a failing device and called fsync and got an error
back. Since no more data was written since then, we don't expect to see
an error at this point since it should have been "cleared".

> > +			printf("Third fsync on fd[%d] failed: %m\n", i);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	/* flip the device to working mode */
> > +	ret = system("./tools/dmerror load_working_table");
> > +	if (ret) {
> > +		if (WIFEXITED(ret))
> > +			printf("system: program exited: %d\n",
> > +					WEXITSTATUS(ret));
> > +		else
> > +			printf("system: 0x%x\n", (int)ret);
> > +
> > +		return 1;
> > +	}
> > +
> > +	for (i = 0; i < NUM_FDS; ++i) {
> > +		ret = fsync(fd[i]);
> > +		if (ret < 0) {
> > +			/* The error should still be clear */
> > +			printf("fsync after healing device on fd[%d] failed: %m\n", i);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * reopen each file one at a time to ensure the same inode stays
> > +	 * in core. fsync each one to make sure we see no errors on a fresh
> > +	 * open of the inode.
> > +	 */
> > +	for (i = 0; i < NUM_FDS; ++i) {
> > +		ret = close(fd[i]);
> > +		if (ret < 0) {
> > +			printf("Close of fd[%d] returned unexpected error: %m\n", i);
> > +			return 1;
> > +		}
> > +		fd[i] = open(fname, O_WRONLY | O_CREAT | O_TRUNC, 0644);
> > +		if (fd[i] < 0) {
> > +			printf("Second open of fd[%d] failed: %m\n", i);
> > +			return 1;
> > +		}
> > +		ret = fsync(fd[i]);
> > +		if (ret < 0) {
> > +			/* New opens should not return an error */
> > +			printf("First fsync after reopen of fd[%d] failed: %m\n", i);
> > +			return 1;
> > +		}
> > +	}
> > +
> > +	printf("Test passed!\n");
> > +	return 0;
> > +}
> > diff --git a/tests/generic/999 b/tests/generic/999
> > new file mode 100755
> > index 000000000000..6de143d1149e
> > --- /dev/null
> > +++ b/tests/generic/999
> > @@ -0,0 +1,76 @@
> > +#! /bin/bash
> > +# FS QA Test No. 999
> > +#
> > +# Open a file several times, write to it, fsync on all fds and make sure that
> > +# they all return 0. Change the device to start throwing errors. Write again
> > +# on all fds and fsync on all fds. Ensure that we get errors on all of them.
> > +# Then fsync on all one last time and verify that all return 0.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017, Jeff Layton <jlayton@redhat.com>
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf $tmp.* $testdir
> > +    _dmerror_cleanup
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/dmerror
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_require_scratch
> > +_require_logdev
> > +_require_dm_target error
> > +_require_test_program fsync-err
> 
> Test also uses tools/dmerror (or src/dmerror), also should make sure
> that file is there.
> 
> # Assuming src/dmerror
> _require_test_program "dmerror"
> 
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Format and mount"
> > +$XFS_IO_PROG -d -c "pwrite -S 0x7c -b 1048576 0 $((64 * 1048576))" $SCRATCH_DEV >> $seqres.full
> 
> This is not needed.
> 
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_dmerror_init
> > +_dmerror_mount >> $seqres.full 2>&1
> > +_dmerror_unmount
> 
> This extra _dmerror_mount/unmount cycle doesn't seem necessary to me
> either.
> 

ACK -- will fix all of the above.

> > +_dmerror_mount
> > +
> > +_require_fs_space $SCRATCH_MNT 8192
> > +
> > +testfile=$SCRATCH_MNT/fsync-err-test
> > +
> > +$here/src/fsync-err $testfile
> > +
> > +# success, all done
> > +_dmerror_load_working_table
> > +_dmerror_unmount
> > +_dmerror_cleanup
> > +_repair_scratch_fs >> $seqres.full
> 
> _require_scratch_fs will return 0 if it found corruption but repaired it
> successfully, then we'll miss a fs curruption failure.
> 
> Test harness will do fsck after each test by default, we can exit
> directly.
> 

I'm not really interested in testing whether the fs is corrupt after
this. It may very well be completely hosed afterward. The only thing we
want to test here is the behavior while the errors actually occur.


> Thanks,
> Eryu
> 
> > +status=0
> > +exit
> > diff --git a/tests/generic/999.out b/tests/generic/999.out
> > new file mode 100644
> > index 000000000000..2e48492ff6d1
> > --- /dev/null
> > +++ b/tests/generic/999.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 999
> > +Format and mount
> > +Test passed!
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 438c299030f2..39f7b14657f1 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -440,3 +440,4 @@
> >  435 auto encrypt
> >  436 auto quick rw
> >  437 auto quick
> > +999 auto quick
> > diff --git a/tools/dmerror b/tools/dmerror
> > new file mode 100755
> > index 000000000000..4aaf682ee5f9
> > --- /dev/null
> > +++ b/tools/dmerror
> > @@ -0,0 +1,44 @@
> > +#!/bin/bash
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017, Jeff Layton <jlayton@redhat.com>
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +. ./common/config
> > +. ./common/dmerror
> > +
> > +_dmerror_setup
> > +
> > +case $1 in
> > +cleanup)
> > +	_dmerror_cleanup
> > +	;;
> > +init)
> > +	_dmerror_init
> > +	;;
> > +load_error_table)
> > +	_dmerror_load_error_table
> > +	;;
> > +load_working_table)
> > +	_dmerror_load_working_table
> > +	;;
> > +*)
> > +	echo "Usage: $0 {init|cleanup|load_error_table|load_working_table}"
> > +	exit 1
> > +	;;
> > +esac
> > +
> > +status=0
> > +exit
> > -- 
> > 2.9.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jeff Layton <jlayton@redhat.com>
