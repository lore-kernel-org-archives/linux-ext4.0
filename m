From: Jun He <jhe@cs.wisc.edu>
Subject: ext4 mballoc: unaligned requests could steal space preferred by
 dentries
Date: Wed, 8 Apr 2015 11:54:00 -0500
Message-ID: <20150408165400.GD5764@wifi-789.cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jhe@cs.wisc.edu
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This email is to document a block allocator problem. If someone sees a
weird behavior, this might help.

In ext4, the first block group in a flex bg is usually reserved for
directory data. Such a policy speeds up commands such as ls and find
because all the dentries of a flex bg are in one block group. The policy
is enforced by the following lines in mballoc.c.

static int ext4_mb_good_group(struct ext4_allocation_context *ac,
                ext4_group_t group, int cr)
{
...
     switch (cr) {                                                                      
     case 0:
         BUG_ON(ac->ac_2order == 0);
 
         /* Avoid using the first bg of a flexgroup for data files */                   
         if ((ac->ac_flags & EXT4_MB_HINT_DATA) &&                                      
             (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) &&                          
             ((group % flex_size) == 0))
             return 0;
...

But the policy can be violated when an allocation request size of a file
is not aligned to 2^n blocks. In other words, if the request size of a
file is not aligned to 2^n blocks, the request can use the first block
group of a flex bg and potentially fill up the block group. Then, new
dentries will have to mix with file data, which hurts performance of
operations such as ls and find.

The following program attacks the problem.

/***********************************************/
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    int fd;
    int hole, size, off;
    char buf[4096];
    char *bigbuf;

    hole = 64*1024;
    size = 4096;

    fd = open(argv[1], O_WRONLY|O_CREAT);
    if ( fd == -1 ) {
        perror("opening file");
        exit(1);
    }
    
    off = 0;
    pwrite(fd, buf, size, off);
    printf("wrote at %d, size %d bytes\n", off, size);
    fsync(fd);

    off = off + size + hole;
    pwrite(fd, buf, size, off);
    printf("wrote at %d, size %d bytes\n", off, size);
    fsync(fd);

    bigbuf = (char *) malloc(100*1024*1024);

    off = off + size + hole;
    size = 100*1024*1024;
    pwrite(fd, bigbuf, size, off);
    printf("wrote at %d, size %d bytes\n", off, size);

    close(fd);
    sync();

    free(bigbuf);
}
/***********************************************/

Mount an empty ext4 on /mnt/ext4onloop and run the program. Then use
filefrag to see the extents of /mnt/ext4onloop/testfile.

$ filefrag -sv /mnt/ext4onloop/testfile 
Filesystem type is: ef53
File size of /mnt/ext4onloop/testfile is 104996864 (25634 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    33280               1 
   1      17     8503    33281      1 
   2      34     8518     8504  22494 
   3   22528    34816    31012   3106 eof
/mnt/ext4onloop/testfile: 4 extents found

First write:
The block of the first write is allocated from locality group
preallocation at group 1. 

Second write:
When allocating the block of the second write (the file is now a big
file > 64KB), the request is normalized to 31 blocks (it was normalized
to 32 blocks at first. But since the first block of the file already
exists, the final size is 32-1=31 blocks). 31 is not aligned to 2^n,
which set initial cr=1 (ext4_mb_regular_allocator()), which effectively
avoids checking if we are in the first block group of the first flex bg
in ext4_mb_good_group(). At this time, sbi->s_mb_last_group=0, so we
start looking for good group from group 0. And we find that group 0 is
good and then used it. 

Third write:
The blocks of the third write are allocated close to the block of the
second write.

The program is to demonstrate that allocation requests that are not
aligned to 2^n could go to the block group preferred/reserved for
dentries. Unaligned request can happen when allocating file tail
(writing a new file without fsync will also make a tail request.) and
fragmented normalized request (like the second write in the program
above). Since we look for good group by a for loop (for (i = 0; i <
ngroups; group++, i++)) in which 'group' can be the first block group of
a flex bg, the unaligned requests could go to the group pointed by
'group'.
