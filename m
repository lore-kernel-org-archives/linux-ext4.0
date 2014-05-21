From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Wed, 21 May 2014 10:12:03 -0400
Message-ID: <20140521141203.GB1501@thunk.org>
References: <537C4A2F.8040402@cn.fujitsu.com>
 <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Transfer-Encoding: 8bit
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org, chrubis@suse.cz
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53464 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaEUOMQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 10:12:16 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, May 21, 2014 at 02:55:12PM +0200, Lukáš Czerner wrote:
> > 
> > Recently I met the mmap_11-4 fails when running LTP in RHEL7.0RC. Attached is a
> > test program to reproduce this problem, which is written by Cyril.  Uncommenting the
> > msync() makes the test succeed in old linux distribution, such as RHEL6.5GA, but
> > fails in RHEL7.0RC.
> 
> please contact you Red Hat support to triage the issue within Red
> Hat.

This is a valid bug report which applies to upstream ext4.  It also
applies to tmpfs, by the way.

It would be good to get this test case (thank you very much for
writing it!) imported into xfstests, since the lack of this test is
why we didn't notice the bug when we added the fs/ext4/page_io.c code
paths.

BTW, there is one interesting thing about that changed when we moved
to page based I/O (years and years ago).  The requirement in mmap is
as Xiaoguang stated:

       A file is mapped in multiples of the page size.  For a file
       that is not a multi‐ ple of the page size, the remaining memory
       is zeroed when mapped, and writes to that region are not
       written out to the file.  The effect of changing the size of
       the underlying file of a mapping on the pages that correspond
       to added or removed regions of the file is unspecified.

Previously in Linux 2.2 (or was it 2.0; my memory is a bit fuzzy about
when we unified the buffer and page caches), when we copied the data
from the page cache to the buffer cache, we stopped at EOF.  This
implies that if the program modified the portion of the page mapped
beyond EOF, it would remain modified until the page was released and
the page was dropped from the page cache.

Now, when we call writepage() --- assuming the file system wasn't
buggy --- the bytes after EOF will get cleared.  If the user doesn't
call msync(), when this happens is unpredictable to the userspace
program, since it happens when writeback daemons decide to write back
the data.

See my modified test program to demonstrate this issue.  For ext3 and
xfs, you will see message:

nb: byte modified beyond EOF cleared after mysync

I think this is valid, or at least, not prohibited by the mmap()
interface specification, but it's not explicitly documented, and it
might be a little surprising.  Given that ext3 users have been seeing
this behavior for years and years, it's probably fine, so I'm
proposing that we change this; but we might want to make a note of it
in the man page.

Regards,

						- Ted

--Q68bSM7Ycu6FN28Q
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="mmap-test.c"

#define _XOPEN_SOURCE 600

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>

int main(void)
{
	char tmpfname[256];
	long page_size;

	void *pa;
	size_t len;
	int fd;

	pid_t child;
	char *ch;
	int exit_val;

	page_size = sysconf(_SC_PAGE_SIZE);

	len = page_size / 2;

	snprintf(tmpfname, sizeof(tmpfname), "testfile");
	child = fork();
	switch (child) {
	case 0:
		/* Create shared object */
		unlink(tmpfname);
		fd = open(tmpfname, O_CREAT | O_RDWR | O_EXCL,
			  S_IRUSR | S_IWUSR);
		if (fd == -1) {
			printf("Error at open(): %s\n", strerror(errno));
			return 1;
		}
		if (ftruncate(fd, len) == -1) {
			printf("Error at ftruncate(): %s\n", strerror(errno));
			return 1;
		}

		pa = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
		if (pa == MAP_FAILED) {
			printf("Error at mmap(): %s\n", strerror(errno));
			return 1;
		}
		
		/* Check the patial page is ZERO filled */
		ch = pa + len + 1;
		if (*ch != 0) {
			printf("Test FAILED: "
			       "The partial page at the end of an object "
			       "is not zero-filled\n");
			return 1;
		}

		/* Write the partial page */
		*ch = 'b';
		msync(pa, len, MS_SYNC);
		if (*ch != 'b')
			printf("nb: byte modified beyond EOF cleared after mysync\n");
		munmap(pa, len);
		close(fd);
		return 0;
	case -1:
		printf("Error at fork(): %s\n", strerror(errno));
		return 1;
	default:
	break;
	}

	wait(&exit_val);
	if (!(WIFEXITED(exit_val) && (WEXITSTATUS(exit_val) == 0))) {
		unlink(tmpfname);
		printf("Child exited abnormally\n");
		return 1;
	}

	fd = open(tmpfname, O_RDWR, 0);
//	unlink(tmpfname);

	pa = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (pa == MAP_FAILED) {
		printf("Error at 2nd mmap(): %s\n", strerror(errno));
		return 1;
	}

	ch = pa + len + 1;
	if (*ch == 'b') {
		printf("Test FAILED: Modification of the partial page "
		       "at the end of an object is written out\n");
		return 1;
	}
	close(fd);
	munmap(pa, len);

	printf("Test PASSED\n");
	return 0;
}

--Q68bSM7Ycu6FN28Q--
