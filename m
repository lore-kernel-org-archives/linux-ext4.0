From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: block allocator issue with ext4+DAX
Date: Wed, 30 Mar 2016 16:01:29 -0600
Message-ID: <20160330220129.GA9101@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've hit an issue in my testing which I believe to be related to the ext4
block allocator when using the DAX mount option.  I originally found this
issue with the generic/102 xfstest, but have reduced it to the minimal
reproducer at the bottom of this email.  I've been able to reproduce this with
both BRD and with PMEM as the underlying block device.

For this test we're running in a very small filesystem, only 512 MiB.  We
fallocate() 400 MiB of that space, unlink the file, then try and rewrite that
400 MiB file one chunk at a time.

What actually happens is that during the rewrite we run out of memory and the
DAX call to get_block() in dax_io() fails with -ENOSPC.

Here are the steps to reproduce this issue:

  # fdisk -l /dev/ram0
  Disk /dev/ram0: 1 GiB, 1073741824 bytes, 2097152 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
  
  # mkfs.ext4 /dev/ram0 512M
  
  # mount /dev/ram0 /mnt
  
  # gcc -o test test.c
  
  # ./test	# success!
  
  # umount /mnt
  
  # mount -o dax /dev/ram0 /mnt	# requires CONFIG_BLK_DEV_RAM_DAX
  
  # ./test	# failure
  Partial write - only 577536 written

This test succeeds with xfs, ext2, and with ext4 without the DAX mount option.
I've also tried it with O_DIRECT, and that has the same behavior - we succeed
without DAX and fail with DAX.

Another clue is that a sync() call in the middle of the test between the
unlink and the following writes clears up the issue.

Something that might be related is the output in
/proc/fs/ext4/ram0/mb_groups.  Here is that output when we're in a good
state, and the writes will succeed:

#group: free  frags first [ 2^0   2^1   2^2   2^3   2^4   2^5   2^6   2^7 2^8   2^9   2^10  2^11  2^12  2^13  ]
#0    : 30673 1     2095  [ 1     0     0     0     1     0     1     1     1 1     1     0     1     3     ]
#1    : 32735 1     33    [ 1     1     1     1     1     0     1     1     1 1     1     1     1     3     ]
#2    : 28672 1     4096  [ 0     0     0     0     0     0     0     0     0 0     0     0     1     3     ]
#3    : 32735 1     33    [ 1     1     1     1     1     0     1     1     1 1     1     1     1     3     ]

Here is the output in that file when we're in a bad state, and our writes are
about to fail:

#group: free  frags first [ 2^0   2^1   2^2   2^3   2^4   2^5   2^6   2^7   2^8   2^9   2^10  2^11  2^12  2^13  ]
#0    : 18385 1     14383 [ 1     0     0     0     1     0     1     1     1     1     1     0     0     2     ]
#1    : 2015  1     33    [ 1     1     1     1     1     0     1     1     1     1     1     0     0     0     ]
#2    : 0     0     32768 [ 0     0     0     0     0     0     0     0     0     0     0     0     0     0     ]
#3    : 2015  1     33    [ 1     1     1     1     1     0     1     1     1     1     1     0     0     0     ]

It appears as though we've exhausted group #2.  Interestingly, if I run sync()
at this point it takes us from the bad output to the good, which leads me to
believe the newly unlinked blocks in group #2 are finally being freed back
into that group for reallocation or something. (I've clearly reached the
limits of my ext4-fu. :)  )

I'm happy to help test proposed fixes.

Thanks,
- Ross

---
#define _GNU_SOURCE
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define MB(a) ((a)*1024ULL*1024)

int main(int argc, char *argv[])
{
	int i, fd, ret;
	void *buffer; 

	buffer = malloc(MB(1));

	fd = open("/mnt/file", O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
	if (fd < 0) {
		perror("fd");
		return 1;
	}

	ret = fallocate(fd, 0, 0, MB(400));
	if (ret) {
		perror("fallocate");
		return 1;
	}
	close(fd);

	unlink("/mnt/file");

	/* a sync() call here makes the DAX case of this test pass */
//	sync();

	fd = open("/mnt/file", O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
	if (fd < 0) {
		perror("fd");
		return 1;
	}

	for (i = 0; i < 400; i++) {
		ret = write(fd, buffer, MB(1));

		if (ret < 0) {
			perror("write");
			return 1;
		} else if (ret != MB(1)) {
			fprintf(stderr, "Partial write - only %lu written\n",
					ret);
			return 1;
		}
	}

	close(fd);
	free(buffer);
	return 0;
}
