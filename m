From: Kristian Nielsen <knielsen@knielsen-hq.org>
Subject: [ext3/4] PROBLEM: fdatasync not syncing appended data (w/test program)
Date: Mon, 03 Sep 2012 10:45:15 +0200
Message-ID: <87k3wb8pgk.fsf@frigg.knielsen-hq.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=

It appears that ext3 and ext4 fdatasync() does not fully sync data to
disk. Specifically, when new data is written at the end (so that the file
length is increased), not all of the new data is synced by fdatasync().

It looks as if the problem is when the new data fits in the last allocated
page for the file - then ext3/4 flushes the new data page to disk, but _not_
the new metadata with the longer file size.

This seems in violation of how fdatasync() is supposed to perform, ie. from
the Linux man page:

  fdatasync() ... does not flush modified metadata unless that metadata is
  needed in order to allow a subsequent data retrieval to be correctly
  handled ...

  For example, changes to st_atime or st_mtime ... do not require flushing ...

  On the other hand, a change to the file size (st_size, as made by say
  ftruncate(2)), would require a metadata flush.

It also causes real problems - it was found because it causes silent data
corruption on ext3/ext4 of MySQL/MariaDB in case of a crash. XFS appears not
to be affected.

To reproduce, I run code like this (full test program attached) with disk
cache disabled, and pull the power plug:

  for (seq = 0; seq < COUNT; ++seq)
  {
    snprintf(buf, sizeof(buf), "%7d\n", seq);
    write(append_fd, buf, RECSIZE);
    fdatasync(append_fd);
    memcpy(buf2 + (seq * RECSIZE) % BLOCKSIZE, buf, RECSIZE);
    pwrite(inplace_fd, buf2, BLOCKSIZE, 0);
    fdatasync(inplace_fd);
  }

The append_fd is a new file that is appended to in each write; the inplace_fd
is a pre-allocated file that does not change size. After a crash the two files
should always be in sync (or append_fd can be one record ahead). But on ext3
and ext4, append_fd typically lacks several records. This does not happen on
XFS, or if fdatasync(append_fd) is replaced with fsync(append_fd).

I also tested this in kvm, and used strace on the host process to see exactly
which writes the guest does. Each fdatasync(append_fd) causes a flush to disk
of the data page of append_fd, but not of the inode (or journal) page. So even
if fdatasync() is by design not suitable for appending data to a file, there
still seems to be a bug, though then a performance rather than a correctness
bug: there is no reason to flush the new data block if the increased file
length is not flushed also.

I tested the following kernels, all show the problem:

  Linux vm-lucid-amd64 2.6.32-39-server #86-Ubuntu SMP Mon Feb 13 23:15:11 UTC 2012 x86_64 GNU/Linux
  Linux thor 2.6.32-42-generic #95-Ubuntu SMP Wed Jul 25 15:57:54 UTC 2012 i686 GNU/Linux
  Linux archie 3.6.0-rc2-DEB #175 SMP PREEMPT Fri Aug 17 05:00:46 IST 2012 x86_64 GNU/Linux

Googling turned up this patch, which may be relevant (but I am not
sufficiently familiar with the ext3/ext4 code to really know):

    http://osdir.com/ml/file-systems.ext4/2008-02/msg00128.html

To run the test program, just `gcc ext4bug-minimal.c && ./a.out`. After crash,
the last record in each file can be compared with eg.

    tail -1 append.log
    perl -lne '$x = $_ if $_ > $x; END {print $x}' inplace.log 

Please let me know if there is any additional information that I can supply to
help.

(BTW, the problem is fixed/worked-around in MariaDB by using fsync() instead
of fdatasync() when a file is extended.)

 - Kristian.


--=-=-=
Content-Type: text/x-csrc
Content-Disposition: inline; filename=ext4bug-minimal.c
Content-Description: Program to reproduce fdatasync bug in ext3/4

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define BLOCKSIZE 4096
#define RECSIZE 8
#define COUNT 1000000

static void
do_test(int append_fd, int inplace_fd, int use_fdatasync)
{
  char buf[RECSIZE+1];
  char buf2[BLOCKSIZE];
  int seq;
  int res;

  memset(buf2, 0, sizeof(buf2));
  for (seq = 0; seq < COUNT; ++seq)
  {
    printf("Adding log entry %d...\n", seq);
    snprintf(buf, sizeof(buf), "%7d\n", seq);

    res = write(append_fd, buf, RECSIZE);
    if (res != RECSIZE)
    {
      fprintf(stderr, "Unexpected return %d from write() (errno=%d: %s)\n",
              res, errno, strerror(errno));
      exit(1);
    }
    res = use_fdatasync ? fdatasync(append_fd) : fsync(append_fd);
    if (res)
    {
      fprintf(stderr, "Error in fdatasync() of append file (errno=%d: %s)\n",
              errno, strerror(errno));
      exit(1);
    }

    memcpy(buf2 + (seq * RECSIZE) % BLOCKSIZE, buf, RECSIZE);
    res = pwrite(inplace_fd, buf2, BLOCKSIZE, 0);
    if (res != BLOCKSIZE)
    {
      fprintf(stderr, "Unexpected return %d from pwrite() (errno=%d: %s)\n",
              res, errno, strerror(errno));
      exit(1);
    }
    res = fdatasync(inplace_fd);
    if (res)
    {
      fprintf(stderr, "Error in fdatasync() of inplace file (errno=%d: %s)\n",
              errno, strerror(errno));
      exit(1);
    }
  }
}

int
main(int argc, char *argv[])
{
  int append_fd, inplace_fd;
  int res;
  int use_fdatasync = 1;
  unsigned char buf[BLOCKSIZE];

  if (argc > 1 && !strcmp("--fsync", argv[1]))
    use_fdatasync = 0;

  append_fd = open("append.log", O_WRONLY|O_CREAT|O_TRUNC, 0666);
  if (append_fd < 0)
  {
    fprintf(stderr, "Failed to open append file: %d: %s\n",
            errno, strerror(errno));
    exit(1);
  }
  res = fsync(append_fd);
  if (res)
  {
    fprintf(stderr, "Failed initial fsync() of append file: %d: %s\n",
            errno, strerror(errno));
    exit(1);
  }
  inplace_fd = open("inplace.log", O_WRONLY|O_CREAT, 0666);
  if (inplace_fd < 0)
  {
    fprintf(stderr, "Failed to open inplace file: %d: %s\n",
            errno, strerror(errno));
    exit(1);
  }
  memset(buf, 0, BLOCKSIZE);
  res = write(inplace_fd, buf, BLOCKSIZE);
  if (res != BLOCKSIZE)
  {
    fprintf(stderr, "Failed to initialise inplace file, write() returns %d "
            "errno=%d: %s\n", res, errno, strerror(errno));
    exit(1);
  }
  res = fsync(inplace_fd);
  if (res)
  {
    fprintf(stderr, "Failed initial fsync() of inplace file: %d: %s\n",
            errno, strerror(errno));
    exit(1);
  }

  do_test(append_fd, inplace_fd, use_fdatasync);

  return 0;
}

--=-=-=--
