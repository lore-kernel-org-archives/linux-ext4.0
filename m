From: Jun He <jhe@cs.wisc.edu>
Subject: Tail effect of ext4 block allocation
Date: Mon, 18 Nov 2013 00:04:14 -0600
Message-ID: <CABW1wHSA_9T472WOpfyWmPR9-J7HCDLKiNrx=kOP3-+BO3CvsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41680 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3KRGEy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Nov 2013 01:04:54 -0500
Received: by mail-ob0-f182.google.com with SMTP id wo20so1799710obc.41
        for <linux-ext4@vger.kernel.org>; Sun, 17 Nov 2013 22:04:54 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ext4 mailing list,
I found some "tail effect" of block allocation. The reason of doing
that is not obvious to me. So I am writing this.

The effect is that, if I write three (or any number larger than 2)
chunks of data with holes (>1 block) in between, the last chunk will
be allocated differently. Let me call the chunks Chunk0, Chunk1, and
Chunk2.

If the file's logical size is less than 64KB (assume
s_mb_stream_request is 64KB), Chunk 0 and Chunk1's physical blocks
will be allocated from group preallocation. There is no physical hole
between them. But Chunk3's physical block will be allocated from
outside of the group preallocation. So chunk3(the last chunk) is far
away from the rest of the chunks of the file. This hurts small file's
locality. Is there any good reason to have such a policy to treat
"tail" differently?

To reproduce:
(Tried on 3.2.17 and 3.12.0. showing 3.2.17 output here.)
Doing this on an 4GB empty file system.
////////////////////////////////////////
////////////////////////////////////////
jhe@h0:~/Home2/ubuntu-precise/test3writes$ cat write3.c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>


int main(int argc, char **argv)
{
    int fd = open(argv[1], O_CREAT|O_WRONLY, 0644);
    if ( fd == -1 ) {
        perror("opening file :(");
        exit(1);
    }

    char *buf = malloc(4096);
    if ( buf == NULL ) {
        perror("bad malloc()");
        exit(1);
    }

    off_t off;

    off = 0;
    pwrite(fd, buf, 4096, off);

    off += 4096 + 4096;
    pwrite(fd, buf, 4096, off);

    off += 4096 + 4096;
    pwrite(fd, buf, 4096, off);

    free(buf);
    close(fd);
    return 0;
}

jhe@h0:~/Home2/ubuntu-precise/test3writes$ ./write3 /mnt/scratch/smallfile
jhe@h0:~/Home2/ubuntu-precise/test3writes$ filefrag -sv /mnt/scratch/smallfile
Filesystem type is: ef53
File size of /mnt/scratch/smallfile is 20480 (5 blocks, blocksize 4096)
ext logical physical expected length flags
   0       0    33280               1
   1       2    33281               1 // no hole between Chunk0 and Chunk1
   2       4    33025    33282      1 eof // Big hole between Chunk1 and Chunk2
/mnt/scratch/smallfile: 2 extents found
////////////////////////////////////////
////////////////////////////////////////


If the file's logical size is bigger than 64KB and the logical holes
are 200MB (yes, this is not common.), the logical hole between Chunk0
and Chunk1 is not preserved physically (or partially preserved thanks
to the request normalization), but the logical hole between Chunk1 and
Chunk2 is preserved physically (which means the physical distance
between Chunk3 and others is close to 200MB). Why having different
policy for the tail?

To reproduce
////////////////////////////////////////
////////////////////////////////////////
jhe@h0:~/Home2/ubuntu-precise/test3writes$ cat write3big.c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>


int main(int argc, char **argv)
{
    int fd = open(argv[1], O_CREAT|O_WRONLY, 0644);
    if ( fd == -1 ) {
        perror("opening file :(");
        exit(1);
    }

    char *buf = malloc(4096);
    if ( buf == NULL ) {
        perror("bad malloc()");
        exit(1);
    }

    off_t off;

    off = 0;
    pwrite(fd, buf, 4096, off);

    off += 4096 + 200*1024*1024;
    pwrite(fd, buf, 4096, off);

    off += 4096 + 200*1024*1024;
    pwrite(fd, buf, 4096, off);

    free(buf);
    close(fd);
    return 0;
}
jhe@h0:~/Home2/ubuntu-precise/test3writes$ ./write3big /mnt/scratch/bigfile
jhe@h0:~/Home2/ubuntu-precise/test3writes$ sync
jhe@h0:~/Home2/ubuntu-precise/test3writes$ filefrag -sv /mnt/scratch/bigfile
Filesystem type is: ef53
File size of /mnt/scratch/bigfile is 419442688 (102403 blocks, blocksize 4096)
ext logical physical expected length flags
   0       0    34816               1
   1   51201    36865    34817      1
   2  102402    65536    36866      1 eof // Last chunk is far away
from the others.
/mnt/scratch/bigfile: 3 extents found
////////////////////////////////////////
////////////////////////////////////////


I have read the code and I understand how the code does so. But I
don't understand the policies behind the code.

Can anybody explain?


/********************** another (related) topic start
*************************/

BTW, another related topic: having a hard threshold
(s_mb_stream_request) for small/big files and judging file size by its
current logical end have some side effects. If I do:
///////////////
while ( filesize < 70KB) {
    write(1KB);
    fsync();
}
///////////////
The last 6KB (in inode preallocation) will be placed far away from the
rest of the 64KB (in group preallocation). In an empty 4GB file
system, the distance is about 2GB.


If we do:
///////////////
write(1KB)
fsync()

write(70KB)
fsync() // if no fsync() here, the tail effect happens.
///////////////
70KB data will be place far away from the first 1KB.

fsync() is quite common in production. Has anyone seen any problems
that might be caused by this?


Thanks,
Jun
