From: James Dingwall <james.dingwall@zynstra.com>
Subject: ext[234] data corruption (Linux 3.8, 3.9 / Xen)
Date: Thu, 26 Sep 2013 08:22:40 +0100
Message-ID: <5243E0C0.2090304@zynstra.com>
References: <524314B3.3090000@zynstra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-am1lp0011.outbound.protection.outlook.com ([213.199.154.11]:31472
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755851Ab3IZHWu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Sep 2013 03:22:50 -0400
In-Reply-To: <524314B3.3090000@zynstra.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hi,
>
> We have observed a data corruption bug in a database created by the 
> postmap command (BDB file) under the following conditions:
>
> Xen domU guest kernel 3.8, 3.9 (3.5, 3.10, 3.11 don't show the 
> behaviour 3.6 and 3.7 are unknown)
> dom0 Xen 4.2.1 / kernel 3.8 or Xen 4.3.0 / kernel 3.11
> The guest has a passed through block device (phy:/ or file:/)
> The filesytem on the passed through device is ext2/3/4 with a 1k block 
> size
>
> By examining a strace of the postmap command we produced a short piece 
> of code (at the bottom) which demonstrates the problem.  If this is 
> executed in a loop such as:
>
> #!/bin/bash
> for i in $(seq 1 5) ; do
>         mount /dev/xvde1 /mnt
>         pushd /mnt> /dev/null
>         echo "checksums after mount"
>         md5sum testcase.bin
>         [ "${i}" = "1" ] && ./a.out
>         echo "checksums before umount"
>         md5sum testcase.bin
>         popd> /dev/null
>         umount /mnt
> done
>
>
> The output is
>
> checksums after mount
> md5sum: testcase.bin: No such file or directory
> checksums before umount
> 719f20c98b69457ce0247d6bf4474cf9  testcase.bin# the correct checksum 
> for the file
> checksums after mount
> a90804e64bcc1c0c98dd2cb23d0e4c10  testcase.bin
> checksums before umount
> a90804e64bcc1c0c98dd2cb23d0e4c10  testcase.bin
> checksums after mount
> 14bb035eca1ec516ce3865700536fc0c  testcase.bin
> checksums before umount
> 14bb035eca1ec516ce3865700536fc0c  testcase.bin
> checksums after mount
> 124d3d3ea8e421925825ff94a815630b  testcase.bin
> checksums before umount
> 124d3d3ea8e421925825ff94a815630b  testcase.bin
> checksums after mount
> 7c05f36ffdd6b8217a27c0bd4d9cb531  testcase.bin
> checksums before umount
> 7c05f36ffdd6b8217a27c0bd4d9cb531  testcase.bin
>
> If we dd out the block device and then loop mount the resulting file 
> we do not see this problem suggesting that communication between xen 
> block back/front is ok and that it is only when the mount takes place 
> that there is a problem.  The default libdb behaviour seems to be to 
> create a database with a block size matching that of the filesystem, 
> if we override this and set it at 4k we do not see this issue.  This 
> is also observed by changing the bs value in our test program.  Once 
> bs is > 3072 we no longer observe the problem.  Also we can avoid the 
> issue in our test program by filling in hole while __testcase.bin is 
> being generated.  A similar test on xfs with a 1k block size did not 
> demonstrate this problem.  If make a cp of the file before the umount 
> then the copied version is and remains correct.
>
> Our searching does not seem to have revealed any similar reports or an 
> explicitly identified fix that was introduced for 3.10.  Our concern 
> therefore is that this is an unrecognised failure that has been 
> inadvertently fixed and could equally inadvertently be reintroduced by 
> some other change.  If this problem sounds familiar or there are 
> suggestions on how to narrow this down further we would greatly 
> appreciate the advice.
>
> Thanks,
> James
>
>
>
> #include <string.h>
> #include <stdio.h>
> #include <fcntl.h>
> #include <stdlib.h>
> #include <sys/stat.h>
>
> extern
> int main(int argc, char *argv[])
> {
>         struct stat *sbuf;
>         char *buf, *zero, *null;
>         int fd5, fd6, fd7;
>         int i;
>         int bs = 1024;  /* lte 3072 = corruption */
>
>
>         buf = malloc(3*bs);
>         zero = malloc(3*bs);
>         null = malloc(bs);
>         memset(zero, 0, 3*bs);
>         sbuf = malloc(sizeof(struct stat));
>         memset(sbuf, 0, sizeof(struct stat));
>
>         for(i = 0; i < 3*bs; i++) {
>                 buf[i] = i & 0x000f;
>         }
>
>         fd5 = open("__testcase.bin", O_RDWR|O_CREAT|O_EXCL, 0644);
>         //fcntl(fd5, F_GETFD);
>         //fcntl(fd5, F_SETFD, FD_CLOEXEC);
>         //stat("__testcase.bin", sbuf);
>         fstat(fd5, sbuf);
>         /* this only writes the first and last blocks */
>         lseek(fd5, 0*bs, SEEK_SET);
>         write(fd5, zero, bs);
>         //lseek(fd5, 1*bs, SEEK_SET); /* filling in this hole is a fix! */
>         //write(fd5, zero, bs);
>         lseek(fd5, 2*bs, SEEK_SET);
>         write(fd5, zero, bs);
>         fdatasync(fd5);
>         rename("__testcase.bin", "testcase.bin");
>
>         //stat("testcase.bin", sbuf);
>         fd6 = open("testcase.bin", O_RDWR|O_CREAT, 0);
>         //fcntl(fd6, F_GETFD);
>         //fcntl(fd6, F_SETFD, FD_CLOEXEC);
>         //fstat(fd6, sbuf);
>         pread(fd6, null, bs, 0);
>         //fstat(fd6, sbuf);
>         //fcntl(fd6, F_GETFD);
>         //fcntl(fd6, F_SETFD, FD_CLOEXEC);
>         //fcntl(fd6, F_GETFD);
>         //fcntl(fd6, F_SETFD, FD_CLOEXEC);
>         fd7 = open("testcase.bin", O_RDWR);
>         flock(fd7, LOCK_EX);
>         umask(022);
>         pread(fd6, null, bs, 1*bs);
>         pread(fd6, null, bs, 2*bs);
>         pwrite(fd6, buf, bs, 0*bs);
>         pwrite(fd6, buf, bs, 1*bs);
>         pwrite(fd6, buf, bs, 2*bs);
>         fdatasync(fd6);
>         fdatasync(fd6);
>         close(fd5);
>         close(fd6);
>
>         fd5 = open("testcase.bin", O_RDWR, 0);
>         //fcntl(fd5, F_GETFD);
>         //fcntl(fd5, F_SETFD, FD_CLOEXEC);
>         fdatasync(fd5);
>         close(fd5);
>
>         close(fd7);
>
>         free(buf);
>         free(sbuf);
>         free(zero);
>         free(null);
> }
