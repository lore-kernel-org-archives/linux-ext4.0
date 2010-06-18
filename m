From: Jens Axboe <jaxboe@fusionio.com>
Subject: fio test triggering bad data on ext4
Date: Fri, 18 Jun 2010 10:07:08 +0200
Message-ID: <4C1B292C.2080205@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55520 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab0FRIHU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jun 2010 04:07:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I was writing a small fio job file to do writes and read verifies on a
device. It forks 32 processes, each writing randomly to 4 files with a
block size between 4k and 16k. When it has written 1024 of those blocks,
it'll verify the oldest 512 of them. Each block is checksummed for every
512b. It uses libaio and O_DIRECT.

It works on ext2 and btrfs. I haven't run it to completion yet, but they
survive 15-20 minutes just fine. ext4 doesn't even go a full minutes
before this triggers:

Bad verify header 0 at 10137600
fio: pid=9943, err=84/file:io_u.c:1212, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character

writers: (groupid=0, jobs=32): err=84 (file:io_u.c:1212, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide character): pid=9943

which tells us that where we expected to find the correct verify magic
in the header, it was all zeroes. The job file used is below, and to
reproduce you want to use the latest fio (1.40) since some earlier
versions don't do verify_interval properly for non-pattern verifies. You
can get fio here:

http://brick.kernel.dk/snaps/fio-1.40.tar.gz

or from git at:

git://git.kernel.dk/fio.git

The kernel used is 2.6.35-rc3 and I ran this on a raid0 that had 8 SSD
drives.

--- snip job file ---

[global]
direct=1
group_reporting=1
exitall
runtime=4h
time_based=1

# writers, will repeatedly randomly write and verify data
[writers]
rw=randwrite
bsrange=4k-16k
ioengine=libaio
iodepth=4
directory=/data
verify=crc32c
verify_backlog=1024
verify_backlog_batch=512
verify_interval=512
size=512m
nrfiles=4
filesize=64m-256m
numjobs=32
create_serialize=0

--- snip job file ---

-- 
Jens Axboe

