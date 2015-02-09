From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v3] ext4: fix indirect punch hole corruption
Date: Mon, 9 Feb 2015 13:28:05 -0800
Message-ID: <20150209212805.GA10892@mew.cs.washington.edu>
References: <c1b3048d1afd6d30946bd036292ec3e94f7f8cea.1423345772.git.osandov@osandov.com>
 <2f10494037d06107efa0e545c814b5a8b4a3710c.1423397569.git.osandov@osandov.com>
 <54D8FA92.5030606@canonical.com>
 <54D920BC.2040402@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris J Arges <chris.j.arges@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54D920BC.2040402@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 09, 2015 at 03:03:56PM -0600, Chris J Arges wrote:
> On 02/09/2015 12:21 PM, Chris J Arges wrote:
> > On 02/08/2015 06:15 AM, Omar Sandoval wrote:
> >> Commit 4f579ae7de56 (ext4: fix punch hole on files with indirect
> >> mapping) rewrote FALLOC_FL_PUNCH_HOLE for ext4 files with indirect
> >> mapping. However, there are a bugs in a few cases.
> >>
> >> In the case where the punch happens within one level of indirection, we
> >> expect the start and end shared branches to converge on an indirect
> >> block. However, because the branches returned from ext4_find_shared do
> >> not necessarily start at the same level (e.g., the partial2 chain will
> >> be shallower if the last block occurs at the beginning of an indirect
> >> group), the walk of the two chains can end up "missing" each other and
> >> freeing a bunch of extra blocks in the process. This mismatch can be
> >> handled by first making sure that the chains are at the same level, then
> >> walking them together until they converge.
> >>
> >> In the case that a punch spans different levels of indirection, the
> >> original code skips freeing the intermediate indirect trees if the last
> >> block is the first triply-indirected block because it returns instead of
> >> jumping to do_indirects. Additionally, a non-zero nr2 does not mean that
> >> there's nothing else to free at the level of partial2: consider the case
> >> where the all_zeroes in ext4_find_shared backed up the shared branch.
> >>
> >> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > 
> > Omar,
> > With this patch I no longer seem to be getting the original corruption I
> > detected with my test case; however eventually I do get errors when
> > trying to delete qcow2 snapshots. After getting these errors if I run
> > 'qemu-img check <image>' I see the following errors:
> > 
> > ERROR OFLAG_COPIED data cluster: l2_entry=800000018f7f0000 refcount=0
> > ERROR OFLAG_COPIED data cluster: l2_entry=800000018f800000 refcount=0
> > ERROR OFLAG_COPIED data cluster: l2_entry=800000018f810000 refcount=0
> > 
> > 16941 errors were found on the image.
> > Data may be corrupted, or further writes to the image may corrupt it.
> > 
> > 60459 leaked clusters were found on the image.
> > This means waste of disk space, but no harm to data.
> > 88629/262144 = 33.81% allocated, 9.57% fragmented, 0.00% compressed clusters
> > Image end offset: 10438180864
> > 
> > So this patch seems to have moved the problem. I can collect additional
> > logs if necessary.
> > 
> > Thanks,
> > --chris j arges
> > 
> 
> After ignoring snapshot deletion errors, I've hit the original
> corruption problem with your patch still. I'll continue debugging this.
> --chris j arges
> 
Chris,

Thanks for testing, and sorry about this game of whack-a-mole. Looks
like there's at least one more bug in the n == n2 case (if nr != 0, we
sometimes, but not always, need to free the subtree referred to by it.)
I'll send you another patch as soon as I have the proper fix.

P.S. The fpunch xfstests don't cover these bugs. I'm attaching the
slightly convoluted script I've been using for testing. It's a Python
script that generates a shell script which I then run on the test
machine. The interesting stuff is in known_bugs(), the first three of
which are fixed by the last patch I sent out.

-- 
Omar

--wRRV7LY7NUeQGEoC
Content-Type: text/x-python; charset=us-ascii
Content-Disposition: attachment; filename="punchtests.py"

#!/usr/bin/env python3

import hashlib

NDIR = 12
BLOCK_SIZE = 1024
ADDRS = (BLOCK_SIZE // 4)

ALLOCED_BLOCK = b'\xcd' * BLOCK_SIZE
HOLE_BLOCK = b'\x00' * BLOCK_SIZE

TEST_CASE = 0

def test_case(file_blocks, *args):
    global TEST_CASE
    test_file = '/mnt/test/test.%d' % TEST_CASE
    TEST_CASE += 1

    print('rm -f %s' % test_file)
    print("xfs_io -f -c 'pwrite 0 %d' %s > /dev/null" % (file_blocks * BLOCK_SIZE, test_file))

    blocks = [True] * file_blocks
    for arg in args:
        punch_start, punch_end = arg
        offset = punch_start * BLOCK_SIZE
        length = punch_end * BLOCK_SIZE - offset
        print("xfs_io -c 'fpunch %d %d' %s" % (offset, length, test_file))
        for i in range(punch_start, punch_end):
            blocks[i] = False

    print('umount /mnt/test')
    print('mount /mnt/test')

    print('diff - <(_fiemap %s) << "EOF"' % test_file)

    m = hashlib.md5()
    num = 0
    extent_start = None
    extent_type = None
    for i, alloced in enumerate(blocks):
        m.update(ALLOCED_BLOCK if alloced else HOLE_BLOCK)
        if alloced != extent_type:
            if extent_type is not None:
                start = extent_start * (BLOCK_SIZE // 512)
                end = i * (BLOCK_SIZE // 512) - 1
                print('%d: [%d..%d]: %s' % (num, start, end, 'extent' if extent_type else 'hole'))
                num += 1
            extent_start = i
            extent_type = alloced
    if extent_type is not None:
        if extent_start > 0 or extent_type:
            start = extent_start * (BLOCK_SIZE // 512)
            end = len(blocks) * (BLOCK_SIZE // 512) - 1
            print('%d: [%d..%d]: %s' % (num, start, end, 'extent' if extent_type else 'hole'))
    print('EOF')

    print('diff - <(md5sum %s) << "EOF"' % test_file)
    print('%s  %s' % (m.hexdigest(), test_file))
    print('EOF')
    print()

def simple_tests():
    # Punch within direct level.
    print("echo 'n = 1, n2 = 1'")
    test_case(NDIR, (2, NDIR - 2))
    test_case(NDIR, (0, NDIR // 2))

    # Punch from direct level to starts of indirect levels.
    print("echo 'n2 > n'")
    print("echo '  n = 1'")
    test_case(NDIR + 1, (0, NDIR)) # Start of direct.
    test_case(NDIR + ADDRS + 1, (0, NDIR + ADDRS))
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 1, (0, NDIR + ADDRS + ADDRS * ADDRS))
    test_case(NDIR + 1, (2, NDIR)) # Middle of direct.
    test_case(NDIR + ADDRS + 1, (2, NDIR + ADDRS))
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 1, (2, NDIR + ADDRS + ADDRS * ADDRS))

    # Punch from direct level into indirect levels.
    test_case(NDIR + 2, (0, NDIR + 1)) # Start of direct.
    test_case(NDIR + ADDRS + 2, (0, NDIR + ADDRS + 1))
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 2, (0, NDIR + ADDRS + ADDRS * ADDRS + 1))
    test_case(NDIR + 2, (2, NDIR + 1)) # Middle of direct
    test_case(NDIR + ADDRS + 2, (2, NDIR + ADDRS + 1))
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 2, (2, NDIR + ADDRS + ADDRS * ADDRS + 1))

    # Punch from indirect level into another indirect level.
    print("echo '  n = 2'")
    # IND -> DIND, IND -> TIND, start of end.
    test_case(NDIR + ADDRS + 1, (NDIR, NDIR + ADDRS)) # Start of indirect.
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 1, (NDIR, NDIR + ADDRS + ADDRS * ADDRS))
    test_case(NDIR + ADDRS + 1, (NDIR + 2, NDIR + ADDRS)) # Middle of indirect.
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 1, (NDIR + 2, NDIR + ADDRS + ADDRS * ADDRS))

    # Middle of end.
    test_case(NDIR + ADDRS + 2, (NDIR, NDIR + ADDRS + 1)) # Start of indirect.
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 2, (NDIR, NDIR + ADDRS + ADDRS * ADDRS + 1))
    test_case(NDIR + ADDRS + 2, (NDIR + 2, NDIR + ADDRS + 1)) # Middle of indirect.
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 2, (NDIR + 2, NDIR + ADDRS + ADDRS * ADDRS + 1))


    # DIND -> TIND
    print("echo '  n = 3'")
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 1, (NDIR + ADDRS, NDIR + ADDRS + ADDRS * ADDRS)) # Start of indirect.
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 1, (NDIR + ADDRS + 2, NDIR + ADDRS + ADDRS * ADDRS))
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 2, (NDIR + ADDRS, NDIR + ADDRS + ADDRS * ADDRS + 1)) # Middle of indirect.
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 2, (NDIR + ADDRS + 2, NDIR + ADDRS + ADDRS * ADDRS + 1))

    # Punch within the same indirect level.
    print("echo 'n = 2, n2 = 2'")
    # IND
    test_case(NDIR + ADDRS, (NDIR, NDIR + ADDRS - 1))
    test_case(NDIR + ADDRS, (NDIR + 4, NDIR + ADDRS - 1))

    # DIND
    print("echo 'n = 3, n2 = 3'")
    test_case(NDIR + ADDRS + ADDRS * ADDRS, (NDIR + ADDRS, NDIR + ADDRS + ADDRS * ADDRS - 1))
    test_case(NDIR + ADDRS + ADDRS * ADDRS, (NDIR + ADDRS + 4, NDIR + ADDRS + ADDRS * ADDRS - 1))

    # TIND
    print("echo 'n = 4, n2 = 4'")
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 20, (NDIR + ADDRS + ADDRS * ADDRS, NDIR + ADDRS + ADDRS * ADDRS + 20))
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 20, (NDIR + ADDRS + ADDRS * ADDRS + 4, NDIR + ADDRS + ADDRS * ADDRS + 20))
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 20, (NDIR + ADDRS + ADDRS * ADDRS, NDIR + ADDRS + ADDRS * ADDRS + 19))
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 20, (NDIR + ADDRS + ADDRS * ADDRS + 4, NDIR + ADDRS + ADDRS * ADDRS + 19))

def known_bugs():
    print("echo 'n == n2, uneven partials'")
    test_case(NDIR + ADDRS + 2 * ADDRS, (NDIR + ADDRS + ADDRS // 2, NDIR + ADDRS + ADDRS))

    print("echo 'n <= 2, n2 == 4, end is first triply-indirect block'")
    test_case(NDIR + ADDRS + ADDRS * ADDRS + 4, (0, NDIR + ADDRS + ADDRS * ADDRS))

    print("echo 'n < n2, nr2 != 0 because all_zeroes'")
    test_case(NDIR + ADDRS + 2 * ADDRS + 5, (NDIR + ADDRS + 2 * ADDRS, NDIR + ADDRS + 2 * ADDRS + 4),
                                            (0, NDIR + ADDRS + 2 * ADDRS + 4))

    print("echo 'n == n2, nr != 0 because all_zeroes'")
    test_case(NDIR + ADDRS + 4 * ADDRS, (NDIR + ADDRS + ADDRS, NDIR + ADDRS + ADDRS + 1),
                                        (NDIR + ADDRS + ADDRS + 1, NDIR + ADDRS + 3 * ADDRS))

if __name__ == '__main__':
    print('#!/bin/bash')

    print(r"""
_coalesce_extents () {
	awk -F: '
	{
		range = $2;
		type = $3;

		split(range, bounds, "[\\[ \\.\\]]");
		low = bounds[3];
		high = bounds[5];

		if (type != prev_type) {
			if (prev_type != "")
				printf("%u]:%s\n", low - 1, prev_type);
			printf("%u: [%u..", out_count++, low);
			prev_type = type;
		}
	}
	END {
		if (prev_type != "")
			printf("%u]:%s\n", high, prev_type);
	}'
}

_filter_hole_fiemap () {
	awk --posix '
		$3 ~ /hole/ {
			print $1, $2, $3; 
			next;
		}   
		$5 ~ /0x[[:xdigit:]]+/ {
			print $1, $2, "extent";
		}' |
	_coalesce_extents
}

_fiemap () {
    xfs_io -c 'fiemap -v' "$1" | _filter_hole_fiemap
}
""")

    # simple_tests()
    known_bugs()

--wRRV7LY7NUeQGEoC--
