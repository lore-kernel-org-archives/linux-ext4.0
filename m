From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] ext3,4:fdatasync should skip metadata writeout
Date: Tue, 20 Nov 2007 16:20:56 +0900
Message-ID: <6.0.0.20.2.20071120142849.03f5f5e0@172.19.0.2>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
 <20071115185919.7df4cda9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Bryan Henderson <hbryan@us.ibm.com>,
	J=?ISO-2022-JP?B?GyRCi1MbKEI=?=n Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:37062 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbXKTHWY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2007 02:22:24 -0500
In-Reply-To: <20071115185919.7df4cda9.akpm@linux-foundation.org>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
 <20071115185919.7df4cda9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


At 11:59 07/11/16, Andrew Morton wrote:
 >
 >I suppose so.  Although one wonders what earthly point there is in syncing
 >a file's data if we haven't yet written out the metadata which is required
 >for locating that data.
 >
 >IOW, fdatasync() is only useful if the application knows that it is overwriting
 >already-instantiated blocks.
 >
 >In which case it might as well have used fsync().  For ext2-style filesystems,
 >anyway.
 >
 >hm.  It needs some thought.

I did a test to measure the file overwriting performance difference between
original fdatasync and one that skips journal flush.
The test program and obtained result is as follows:

Test program source code:

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>

#define BUFSIZE 8192
#define LOOP 1024*1024

main(void)
{
	int i;
	int fd;
	char buf[BUFSIZE];
	time_t t1,t2;

	memset(buf,0,BUFSIZE);

	fd = open("testfile", O_CREAT|O_RDWR);
	if (fd < 0)
		perror("cannot open file\n");

	for (i = 0; i < LOOP; i++)
		write(fd,buf,BUFSIZE);
	fsync(fd);

	lseek(fd, 0, SEEK_SET);
	time(&t1);
	for (i = 0; i < LOOP; i++) {
		write(fd,buf,BUFSIZE);
		fdatasync(fd);
	}
	time(&t2);

	printf("%d sec\n",t2-t1);
}

Result:

  2.6.24-rc3:

	264 sec

  2.6.23-rc3-fdatasync-skips-journal-flush-patched

	253 sec

Hardware environment:
  Dell Poweredge 850
  CPU Pentium D  3GHz
  memory 4GB
  HDD Maxtor 6L160M0


I got somewhat better result from the patched ext3 skipping journal flush.

Some DBMS such as PostgreSQL can use fdatasync. So I think skipping
journal flush on overwriting leads to performance improvement for
these application.

I am for the notion that skipping metadata writeout unconditionally is wrong,
and "important metadata" such as i_size, block-bitmap etc should be
synched even if fdatasync is issued , but unimportant meta such as
mtime and ctime update can be ignored when a file is overwritten.
