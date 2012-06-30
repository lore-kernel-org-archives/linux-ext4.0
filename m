From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 00/23] ext4: Add inline data support.
Date: Sat, 30 Jun 2012 23:41:57 +0800
Message-ID: <1341070917-4889-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60640 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751400Ab2F3PoF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:44:05 -0400
Received: from [221.217.40.18] (port=40031 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1Skzq6-0004gW-QH
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:44:03 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

this is another try for the inline data support for ext4.
I have runned all the xfstests cases and fixes the bugs it found.
Hope it is stable now for the inclusion.

So in genernal, I have runned several test cases and try to prove
that it works.

A fsstats shows the directory information for my home.
(The test tools can be found here. http://www.pdsi-scidac.org/fsstats/.
Thanks goes to Andreas Dilger).

directory size (entries): Range of entries, count of directories in range, number of dirs in range as a % of total num of dirs, number of dirs in this range or smaller as a % total number of dirs, total entries in range, number of entries in range as a % of total number of entries, number of entries in this range or smaller as a % of total number of entries.
  count=13671 avg=11.58 ents
  min=0.00 ents max=4562.00 ents
  [   0-   1 ents]:  5198 (38.02%) ( 38.02% cumulative)   3322.00 ents ( 2.10%) (  2.10% cumulative) 
  [   2-   3 ents]:  2246 (16.43%) ( 54.45% cumulative)   5477.00 ents ( 3.46%) (  5.56% cumulative) 
  [   4-   7 ents]:  2266 (16.58%) ( 71.03% cumulative)  12037.00 ents ( 7.60%) ( 13.16% cumulative) 
  [   8-  15 ents]:  1877 (13.73%) ( 84.76% cumulative)  20269.00 ents (12.80%) ( 25.96% cumulative) 
  [  16-  31 ents]:  1126 ( 8.24%) ( 92.99% cumulative)  24196.00 ents (15.28%) ( 41.24% cumulative) 
  [  32-  63 ents]:   554 ( 4.05%) ( 97.04% cumulative)  23772.00 ents (15.01%) ( 56.26% cumulative) 
  [  64- 127 ents]:   234 ( 1.71%) ( 98.76% cumulative)  20919.00 ents (13.21%) ( 69.47% cumulative) 
  [ 128- 255 ents]:   119 ( 0.87%) ( 99.63% cumulative)  20654.00 ents (13.05%) ( 82.52% cumulative) 
  [ 256- 511 ents]:    40 ( 0.29%) ( 99.92% cumulative)  12941.00 ents ( 8.17%) ( 90.69% cumulative) 
  [ 512-1023 ents]:     6 ( 0.04%) ( 99.96% cumulative)   4147.00 ents ( 2.62%) ( 93.31% cumulative) 
  [1024-2047 ents]:     3 ( 0.02%) ( 99.99% cumulative)   3487.00 ents ( 2.20%) ( 95.51% cumulative) 
  [2048-4095 ents]:     1 ( 0.01%) ( 99.99% cumulative)   2544.00 ents ( 1.61%) ( 97.12% cumulative) 
  [4096-8191 ents]:     1 ( 0.01%) (100.00% cumulative)   4562.00 ents ( 2.88%) (100.00% cumulative) 

So with inode size equals 256, more than 50% directory can be inlined.

I have also runned several other test cases to prove the peroformance gain,
And I'd like to describe the result here. For more test details, please see below.

For a dir iteration test, if most of the dirs are inlined, we can see a 10 fold
speed up(240ms vs. 2250ms) in dir iteration(try to find a not-exist file). Yes,
that is expected. ;)

With a normal kernel tar and directory iteration test, we can find a 1.5% space
saving(with cluster size=4096, I would imagine a better result with bigalloc enabled).
As for the directory iteration, we can see a 22.4% speedup.

I ran postmark for 2 senarios, one with file size between 11 and 500 which is good
for inline data test, and another with file size between 100 and 50000. We can see
a 32.8%(49s vs. 73s) improvement for the first one, and 3.6%(805s vs. 835s) for the
latter.

The final test case is the fs_mark. I ran the different sync modes, and we can see
more than 100% increase if we does the sync and this is really a huge win.

1. normal test case of taring a kernel source and find a file:
time tar zxvf linux-3.4.tar.gz -C $MNT_DIR
df -hm|grep $MNT_DIR
umount $MNT_DIR
mount -t ext4 $DEVICE $MNT_DIR
time find $MNT_DIR -name a

inline_data result
in find real 1350ms
in find sys 230ms
in find user 90ms

normal result
in find real 1840ms
in find sys 340ms
in find user 110ms

inline_data + journal result
in find real 1590ms
in find sys 230ms
in find user 80ms

normal journal result
in find real 1900ms
in find sys 360ms
in find user 100ms

2. postmark test case 1:
set location $MNT_DIR
set subdirectories 2570
set size 11 500
set transactions 51110
set number 977770

with inline data result:
Time:
	49 seconds total
	2 seconds of transactions (25555 per second)

Files:
	1003234 created (20474 per second)
		Creation alone: 977770 files (29629 per second)
		Mixed with transactions: 25464 files (12732 per second)
	25561 read (12780 per second)
	25548 appended (12774 per second)
	1003234 deleted (20474 per second)
		Deletion alone: 977588 files (69827 per second)
		Mixed with transactions: 25646 files (12823 per second)

Data:
	6.25 megabytes read (130.59 kilobytes per second)
	247.18 megabytes written (5.04 megabytes per second)

Without inline data:
Time:
	73 seconds total
	25 seconds of transactions (2044 per second)

Files:
	1003234 created (13742 per second)
		Creation alone: 977770 files (31540 per second)
		Mixed with transactions: 25464 files (1018 per second)
	25561 read (1022 per second)
	25548 appended (1021 per second)
	1003234 deleted (13742 per second)
		Deletion alone: 977588 files (57505 per second)
		Mixed with transactions: 25646 files (1025 per second)

Data:
	6.25 megabytes read (87.66 kilobytes per second)
	247.18 megabytes written (3.39 megabytes per second)

postmark test 2:
set location $MNT_DIR
set subdirectories 2570
set size 100 50000
set transactions 51110
set number 977770

with inline data:
Time:
	805 seconds total
	263 seconds of transactions (194 per second)

Files:
	1003213 created (1246 per second)
		Creation alone: 977770 files (1975 per second)
		Mixed with transactions: 25443 files (96 per second)
	25597 read (97 per second)
	25513 appended (97 per second)
	1003213 deleted (1246 per second)
		Deletion alone: 977546 files (20798 per second)
		Mixed with transactions: 25667 files (97 per second)

without inline data:
Time:
	835 seconds total
	289 seconds of transactions (176 per second)

Files:
	1003213 created (1201 per second)
		Creation alone: 977770 files (2011 per second)
		Mixed with transactions: 25443 files (88 per second)
	25597 read (88 per second)
	25513 appended (88 per second)
	1003213 deleted (1201 per second)
		Deletion alone: 977546 files (16292 per second)
		Mixed with transactions: 25667 files (88 per second)

3. fs_mark test:
fs_mark -d $MNT_DIR -D 256 -s 256 -n 10000 -t 256 -S [0|1|2]

                         inline+nojournal noinline+nojournal
Files/sec for sync 0     63757.4          63086.4
Files/sec for sync 1     38976.7          16983.5
Files/sec for sync 2     35796.7          14682.6

                         inline+journal   noinline+journal
Files/sec for sync 0     63523.4          61092.1
Files/sec for sync 1     34441.4          15061.8
Files/sec for sync 2     40745.3          14083.4

git diff --stat
 fs/ext4/Makefile  |    2 +-
 fs/ext4/dir.c     |   39 +-
 fs/ext4/ext4.h    |   88 +++-
 fs/ext4/extents.c |   22 +-
 fs/ext4/ialloc.c  |    4 +
 fs/ext4/inline.c  | 1827 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c   |  237 ++++++--
 fs/ext4/namei.c   |  462 +++++++++-----
 fs/ext4/xattr.c   |   87 ++-
 fs/ext4/xattr.h   |  277 ++++++++
 10 files changed, 2781 insertions(+), 264 deletions(-)

any comments are welcomed.

Thanks
Tao
