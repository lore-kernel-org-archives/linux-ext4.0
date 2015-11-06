From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [PATCH 0/9 v3] ext4: Punch hole and DAX fixes
Date: Fri, 6 Nov 2015 17:57:04 +0000
Message-ID: <80B02B5F638F054B8B1358323FECDE0A5EA64CCF@G1W3650.americas.hpqcorp.net>
References: <1446653920-23127-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>
To: Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:41676 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbKFR6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2015 12:58:08 -0500
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id E81062ADD
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2015 17:58:07 +0000 (UTC)
In-Reply-To: <1446653920-23127-1-git-send-email-jack@suse.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've written a test tool (included below) that exercises page faults on
hole-y portions of an mmapped file.  The file is created, sized using
various methods, mmapped, and then two threads race to write a marker to
different offsets within each mapped page.  Once the threads have
finished marking each page, the pages are checked for the presence of
the markers.

With vanilla 4.2 and 4.3 kernels, this test easily exposes corruption on
pmem-backed, DAX-mounted xfs and ext4 file systems.

With 4.3 and this ext4 patch set, the data corruption is still seen:

$ ./holetest -f /pmem1/brian/holetest 1000
holetest r207

INFO: zero-filled test...
INFO: sz = 3e800000, npages = 256000
INFO: vastart = 00007f2ad0bd0000
INFO: thread 0 is 7f2ad0bcf700
INFO: thread 1 is 7f2ad03ce700
INFO: 0 error(s) detected

INFO: posix_fallocate test...
INFO: sz = 3e800000, npages = 256000
INFO: vastart = 00007f2ad0bd0000
INFO: thread 0 is 7f2ad03ce700
INFO: thread 1 is 7f2ad0bcf700
INFO: 0 error(s) detected

INFO: fallocate test...
INFO: sz = 3e800000, npages = 256000
INFO: vastart = 00007f2ad0bd0000
INFO: thread 0 is 7f2ad0bcf700
INFO: thread 1 is 7f2ad03ce700
INFO: 0 error(s) detected

INFO: ftruncate test...
INFO: sz = 3e800000, npages = 256000
INFO: vastart = 00007f2ad0bd0000
INFO: thread 0 is 7f2ad03ce700
INFO: thread 1 is 7f2ad0bcf700
ERROR: thread 0, offset 01001c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 01801c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 02001c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 02807c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 0281dc00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 03001c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 03023c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 03801c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 03804c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 04001c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 04801c00, 00000000 != 7f2ad03ce700
ERROR: thread 0, offset 05001c00, 00000000 != 7f2ad03ce700
ERROR: thread 1, offset 0e001400, 00000000 != 7f2ad0bcf700
ERROR: thread 1, offset 16001400, 00000000 != 7f2ad0bcf700
ERROR: thread 1, offset 1b001400, 00000000 != 7f2ad0bcf700
ERROR: thread 1, offset 2a802400, 00000000 != 7f2ad0bcf700
ERROR: thread 1, offset 31005400, 00000000 != 7f2ad0bcf700
ERROR: thread 0, offset 3e6b3c00, 00000000 != 7f2ad03ce700
INFO: 18 error(s) detected
$


Thanks,
Brian



/*
 * holetest -- test simultaneous page faults on hole-backed pages
 * Copyright (C) 2015  Hewlett Packard Enterprise Development LP
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */


/*
 * holetest
 *
 * gcc -Wall -pthread -o holetest holetest.c
 *
 * This test tool exercises page faults on hole-y portions of an mmapped
 * file.  The file is created, sized using various methods, mmapped, and
 * then two threads race to write a marker to different offsets within
 * each mapped page.  Once the threads have finished marking each page,
 * the pages are checked for the presence of the markers.
 *
 * The file is sized four different ways: explicitly zero-filled by the
 * test, posix_fallocate(), fallocate(), and ftruncate().  The explicit
 * zero-fill does not really test simultaneous page faults on hole-backed
 * pages, but rather serves as control of sorts.
 *
 * Usage:
 *
 *   holetest [-f] FILENAME FILESIZEinMB
 *
 * Where:
 *
 *   FILENAME is the name of a non-existent test file to create
 *
 *   FILESIZEinMB is the desired size of the test file in MiB
 *
 * If the test is successful, FILENAME will be unlinked.  By default,
 * if the test detects an error in the page markers, then the test exits
 * immediately and FILENAME is left.  If -f is given, then the test
 * continues after a marker error and FILENAME is unlinked, but will
 * still exit with a non-0 status.
 */


/* for fallocate(2) */
#define _GNU_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <inttypes.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>


#ifndef HOLETEST_REVISION
#define HOLETEST_REVISION "0"
#endif


#define PGSZ   (4096)


void*
pt_page_marker(
        void* args
)
{
        intptr_t*   a      = args;
        char*       va     = (char*)(a[0]);
        int         npages = (int)(a[1]);
        int         pgoff  = (int)(a[2]);
        uint64_t    tid    = (uint64_t)(pthread_self());

        va += pgoff;

        /* mark pages */
        for (; npages > 0; va += PGSZ, npages--) {
                *(uint64_t*)(va) = tid;
        }

        return NULL;

}  /* pt_page_marker() */


int
test_this(
        int fd,
        int sz
)
{
        int         npages;
        char*       vastart;
        char*       va;
        intptr_t    targs[6];
        pthread_t   t[2];
        uint64_t    tid[2];
        int         errcnt;

        npages = sz / PGSZ;
        printf("INFO: sz = %08x, npages = %d\n", sz, npages);

        /* mmap it */
        vastart = mmap(NULL, sz, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
        if (MAP_FAILED == vastart) {
                perror("mmap()");
                exit(20);
        }
        printf("INFO: vastart = %016lx\n", (uintptr_t)vastart);

        /* prepare the thread args
         *
         * thread 1:
         */
        targs[0] = (intptr_t)vastart;
        targs[1] = (intptr_t)npages;
        targs[2] = (intptr_t)(3072);
        /* thread 2: */
        targs[3] = (intptr_t)vastart;
        targs[4] = (intptr_t)npages;
        targs[5] = (intptr_t)(1024);

        /* start two threads */
        if (0 != pthread_create(&(t[0]), NULL, pt_page_marker, &(targs[0]))) {
                perror("pthread_create(1)");
                exit(21);
        }
        if (0 != pthread_create(&(t[1]), NULL, pt_page_marker, &(targs[3]))) {
                perror("pthread_create(2)");
                exit(22);
        }
        tid[0] = (uint64_t)t[0];
        tid[1] = (uint64_t)t[1];
        printf("INFO: thread 0 is %08lx\n", t[0]);
        printf("INFO: thread 1 is %08lx\n", t[1]);

        /* wait for them to finish */
        (void)pthread_join(t[0], NULL);
        (void)pthread_join(t[1], NULL);

        /* check markers on each page */
        errcnt = 0;
        for (va = vastart; npages > 0; va += PGSZ, npages--) {
                if (*(uint64_t*)(va + 3072) != tid[0]) {
                        printf("ERROR: thread 0, "
                               "offset %08lx, %08lx != %08lx\n",
                               (va + 3072 - vastart),
                               *(uint64_t*)(va + 3072), tid[0]);
                        errcnt += 1;
                }
                if (*(uint64_t*)(va + 1024) != tid[1]) {
                        printf("ERROR: thread 1, "
                               "offset %08lx, %08lx != %08lx\n",
                               (va + 1024 - vastart),
                               *(uint64_t*)(va + 1024), tid[1]);
                        errcnt += 1;
                }
        }

        printf("INFO: %d error(s) detected\n", errcnt);

        (void)munmap(vastart, sz);

        return errcnt;

}  /* test_this() */


int
main(
        int   argc,
        char* argv[]
)
{
        int     stoponerror = 1;
        char*   path;
        int     sz;
        int     fd;
        int     errcnt;
        int     toterr      = 0;

        printf("holetest r%s\n", HOLETEST_REVISION);

        /* process command line */
        argc--; argv++;
        /* ignore errors? */
        if ((3 == argc) && (0 == strcmp(argv[0], "-f"))) {
                stoponerror = 0;
                argc--;
                argv++;
        }
        /* file name and size */
        if ((2 != argc) || (argv[0][0] == '-')) {
                fprintf(stderr, "ERROR: usage: holetest [-f] "
                        "FILENAME FILESIZEinMB\n");
                exit(1);
        }
        path = argv[0];
        sz   = atoi(argv[1]) << 20;
        if (1 > sz) {
                fprintf(stderr, "ERROR: bad FILESIZEinMB\n");
                exit(1);
        }


        /*
         * we're going to run our test in several different ways:
         *
         * 1. explictly zero-filled
         * 2. posix_fallocated
         * 3. fallocated
         * 4. ftruncated
         */


        /*
         * explicitly zero-filled
         */
        printf("\nINFO: zero-filled test...\n");
        /* create the file */
        fd = open(path, O_RDWR | O_EXCL | O_CREAT, 0644);
        if (0 > fd) {
                perror(path);
                exit(2);
        }
        /* truncate it to size */
        if (0 != ftruncate(fd, sz)) {
                perror("ftruncate()");
                exit(3);
        }
        /* explicitly zero-fill */
        {
                char*   va = mmap(NULL, sz, PROT_READ | PROT_WRITE,
                                  MAP_SHARED, fd, 0);
                if (MAP_FAILED == va) {
                        perror("mmap()");
                        exit(4);
                }
                memset(va, 0, sz);
                munmap(va, sz);
        }
        /* test it */
        errcnt = test_this(fd, sz);
        toterr += errcnt;
        close(fd);
        if (stoponerror && (0 < errcnt))
                exit(5);
        /* cleanup */
        if (0 != unlink(path)) {
                perror("unlink()");
                exit(6);
        }


        /*
         * posix_fallocated
         */
        printf("\nINFO: posix_fallocate test...\n");
        /* create the file */
        fd = open(path, O_RDWR | O_EXCL | O_CREAT, 0644);
        if (0 > fd) {
                perror(path);
                exit(7);
        }
        /* fill it to size */
        if (0 != posix_fallocate(fd, 0, sz)) {
                perror("posix_fallocate()");
                exit(8);
        }
        /* test it */
        errcnt = test_this(fd, sz);
        toterr += errcnt;
        close(fd);
        if (stoponerror && (0 < errcnt))
                exit(9);
        /* cleanup */
        if (0 != unlink(path)) {
                perror("unlink()");
                exit(10);
        }


        /*
         * fallocated
         */
        printf("\nINFO: fallocate test...\n");
        /* create the file */
        fd = open(path, O_RDWR | O_EXCL | O_CREAT, 0644);
        if (0 > fd) {
                perror(path);
                exit(11);
        }
        /* fill it to size */
        if (0 != fallocate(fd, 0, 0, sz)) {
                perror("fallocate()");
                exit(12);
        }
        /* test it */
        errcnt = test_this(fd, sz);
        toterr += errcnt;
        close(fd);
        if (stoponerror && (0 < errcnt))
                exit(13);
        /* cleanup */
        if (0 != unlink(path)) {
                perror("unlink()");
                exit(14);
        }


        /*
         * ftruncated
         */
        printf("\nINFO: ftruncate test...\n");
        /* create the file */
        fd = open(path, O_RDWR | O_EXCL | O_CREAT, 0644);
        if (0 > fd) {
                perror(path);
                exit(15);
        }
        /* truncate it to size */
        if (0 != ftruncate(fd, sz)) {
                perror("ftruncate()");
                exit(16);
        }
        /* test it */
        errcnt = test_this(fd, sz);
        toterr += errcnt;
        close(fd);
        if (stoponerror && (0 < errcnt))
                exit(17);
        /* cleanup */
        if (0 != unlink(path)) {
                perror("unlink()");
                exit(18);
        }


        /* done */
        if (0 < toterr)
                exit(19);
        else
                return 0;

}  /* main() */



-----Original Message-----
From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-owner@vger.kernel.org] On Behalf Of Jan Kara
Sent: Wednesday, November 04, 2015 11:19 AM
Subject: [PATCH 0/9 v3] ext4: Punch hole and DAX fixes

Hello,

Another version of my ext4 fixes. I've fixed up all the failures Ted reported
except for ext4/001 failures which are false positive (will send fixes for that
test shortly) and generic/269 in nodelalloc mode which I just wasn't able to
reproduce.

Note that testing with 1 KB blocksize on ramdisk is broken since brd has
buggy discard implementation. It took me quite some time to figure this out.
Fix is submitted but bear this in mind just in case.

Changes since v2:
* Fixed collaps range to truncate pagecache properly with blocksize < pagesize
* Fixed assertion in ext4_get_blocks_overwrite

Patch set description

This series fixes a long standing problem of racing punch hole and page fault
resulting in possible filesystem corruption or stale data exposure. We fix the
problem by using a new inode-private rw_semaphore i_mmap_sem to synchronize
page faults with truncate and punch hole operations.

When having this exclusion, the only remaining problem with DAX implementation
are races between two page faults zeroing out same block concurrently (where
the data written after the first fault finishes are possibly overwritten by
the second fault still doing zeroing).

Patch 1 introduces i_mmap_sem lock in ext4 inode and uses it to properly
serialize extent manipulation operations and page faults.

Patch 2 is mostly a preparatory cleanup patch which also avoids double lock /
unlock in unlocked DIO protections (currently harmless but nasty surprise).

Patches 3-4 fix further races of extent manipulation functions (such as zero
range, collapse range, insert range) with buffered IO, page writeback

Patch 5 documents locking order of ext4 filesystem locks.

Patch 6 removes locking abuse of i_data_sem from the get_blocks() path when
dioread_nolock is enabled since it is not needed anymore.

Patches 7-9 implement allocation of pre-zeroed blocks in ext4_map_blocks()
callback and use such blocks for allocations from DAX page faults.

The patches survived xfstests run both in dax and non-dax mode.

								Honza
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



