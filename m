From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Of block allocation algorithms, fsck times, and file fragmentation
Date: Wed, 06 May 2009 07:28:40 -0400
Message-ID: <E1M1fIm-0001Hw-0f@closure.thunk.org>
Cc: Curt Wohlgemuth <curtw@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36396 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbZEFL2z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 07:28:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With the flexgroups Orlov allocator and with the don't-avoid-
BLOCK_UNINIT-block-groups patch I decided it was time to do a quick
check on fsck times.   Using a root filesystem freshly copied to a
laptop hardrive, I got the following results:
       
                    Ext3                          Ext4
             Time (seconds) Data Read       Time (seconds) Data Read
         Real  User   Sys   MB    Mb/s   Real  User Sys   MB   Mb/s
Pass 1  192.30 20.65 12.45  1324  6.89    9.87 5.32 0.91  203  20.56
Pass 2   11.81  2.31  1.70   260 22.02    6.34 1.98 1.49  261  41.19
Pass 3    0.01  0.01  0.00     1 74.38    0.01 0.01 0.00    1  75.06
Pass 4    0.13  0.13  0.00     0  0.00    0.18 0.18 0.00    0   0.00
Pass 5    6.56  0.75  0.21     3  0.46    2.24 1.66 0.05    2   0.89
------
Total   211.10 23.90 14.38  1588  7.52   18.75 9.19 2.46 466  24.85

The ext4 fsck time is a little over 11 times better than ext3 time.
This isn't entirely a fair comparison with the 6.7 times improvement
discussed at

     http://thunk.org/tytso/blog/2008/08/08/fast-ext4-fsck-times/

... since that filesystem had 67% of its blocks used and 9.3% of its
inode used, where as this filesystem has 41% of its block used and 18%
of its inodes used.  However, the improvement in e2fsck pass2 is quite
satisfactorily dramatic.

So that's the good news.  However, the block allocation shows that we
are doing something... strange.  Running an e2fsck -E fragcheck report,
the large files seem to be written out in 8 megabyte chunks:

  1313(f): expecting  51200 actual extent phys  53248 log 2048 len 2048
  1313(f): expecting  55296 actual extent phys  59392 log 4096 len 2048
  1313(f): expecting  61440 actual extent phys  63488 log 6144 len 9
  1351(f): expecting  53248 actual extent phys  57344 log 2048 len 2048
  1351(f): expecting  59392 actual extent phys  67584 log 4096 len 4096
  1351(f): expecting  71680 actual extent phys  73728 log 8192 len 2048
  1351(f): expecting  75776 actual extent phys  77824 log 10240 len 2048
  1351(f): expecting  79872 actual extent phys  83968 log 12288 len 642
  1572(f): expecting  63488 actual extent phys  64512 log 1024 len 99
  1573(f): expecting  49152 actual extent phys  64000 log 512 len 412
  1574(f): expecting  67584 actual extent phys  71680 log 2048 len 2048
  1574(f): expecting  73728 actual extent phys  75776 log 4096 len 2048
  1574(f): expecting  77824 actual extent phys  81920 log 6144 len 2048
  1574(f): expecting  83968 actual extent phys  86016 log 8192 len 12288
  1574(f): expecting  98304 actual extent phys 100352 log 20480 len 32768
  1574(f): expecting 149504 actual extent phys 151552 log 69632 len 2048
  1574(f): expecting 153600 actual extent phys 155648 log 71680 len 2048
  1574(f): expecting 157696 actual extent phys 159744 log 73728 len 2048
  1574(f): expecting 161792 actual extent phys 165888 log 75776 len 2048
  1574(f): expecting 167936 actual extent phys 169984 log 77824 len 2048
  1574(f): expecting 172032 actual extent phys 174080 log 79872 len 1959

The ext3 and ext4 filesystems were copied using rsync, which copies
files on a file-by-file basis; that is, one file should have been
written, followed by another file.   Yet there seems to be some kind of
interleaving effect going on.  

  1351(f): expecting  71680 actual extent phys  73728 log 8192 len 2048
  1574(f): expecting  67584 actual extent phys  71680 log 2048 len 2048

Logical block 8192 of inode 1371 *should* have been written at physical
block 71680 in order to keep 1371 contiguous on disk.  Yet logical block
2048 of inode 1574 was written there instead.  Why?

This also happened here:

  1351(f): expecting  75776 actual extent phys  77824 log 10240 len 2048
  1574(f): expecting  73728 actual extent phys  75776 log 4096 len 2048

and here:

  1572(f): expecting  63488 actual extent phys  64512 log 1024 len 99
  1313(f): expecting  61440 actual extent phys  63488 log 6144 len 9

The bottom line is this was a freshly mke2fs'ed filesystem, and the
files were getting copied one at a time using rsync, so in theory all of
the files should be written contiguously on the disk.  However, this was
not true:

     535 non-contiguous files (0.1%)

None of the fragmented files were disastrously fragmented; the files
seem to be written in extents that are sized in multiples of 2048
blocks, or 8 megabytes, interleaved with files that were written before
and after a particular file in question.  The question is why is this
happening at all, and can we do better?

This effect looks like the one which Curt Wohlgemuth had noticed and
reported last week.

-----------------

On a lark, I tried copying the filesystem with nodelalloc, and the
results were *really* bad:

   33780 non-contiguous files (4.2%)

Worse yet, the fragments were happening at boundaries of 60k, after 15
blocks:

   288(f): expecting  34777 actual extent phys  37155 log 15 len 1
   288(f): expecting  37156 actual extent phys  37728 log 16 len 3
   338(f): expecting  37912 actual extent phys  36340 log 15 len 1
   338(f): expecting  36341 actual extent phys  37744 log 16 len 5
   400(f): expecting  41714 actual extent phys  37116 log 15 len 1
   400(f): expecting  37117 actual extent phys  40224 log 16 len 3
   430(f): expecting  41741 actual extent phys  37117 log 15 len 1
   438(f): expecting  42063 actual extent phys  37118 log 15 len 1
   438(f): expecting  37119 actual extent phys  40240 log 16 len 112
   438(f): expecting  40352 actual extent phys  42496 log 128 len 723
   440(f): expecting  41770 actual extent phys  37119 log 15 len 1
   440(f): expecting  37120 actual extent phys  40352 log 16 len 5
   441(f): expecting  41785 actual extent phys  37523 log 15 len 1
   441(f): expecting  37524 actual extent phys  40368 log 16 len 7
   443(f): expecting  41808 actual extent phys  37156 log 15 len 1
   443(f): expecting  37157 actual extent phys  43232 log 16 len 468
   446(f): expecting  41825 actual extent phys  37157 log 15 len 1
   446(f): expecting  37158 actual extent phys  40384 log 16 len 7
   447(f): expecting  41840 actual extent phys  37158 log 15 len 1
   447(f): expecting  37159 actual extent phys  40400 log 16 len 48
   447(f): expecting  40448 actual extent phys  43712 log 64 len 55

A quick look with debugfs shows the obvious block interleaving:

debugfs:  stat <400>
	  ...
BLOCKS:
(0-14):41699-41713, (15):37116, (16-18):40224-40226

debugfs:  stat <401>
	  ...
BLOCKS:
(0):41714

debugfs:  stat <403>
	  ...
(0-4):41715-41719

debugfs:  stat <404>
	  ...
(0-4):41720-41724

debugfs:  stat <405>
	  ..
(0):41725

debugfs:  stat <406>
	  ..
(0-2):42008-42010

debugfs:  stat <407>
	  ...
(0):42011

debugfs:  stat <408>
	  ...
(0):42012

Thinking this was perhaps rsync's fault, I tried the experiment where I
copied the files using tar:

       tar -cf - -C /mnt2 . | tar -xpf - -C /mnt .

However, the same pattern was visible.  Tar definitely copies files
using one at a time, so this must be an artifact of the page writeback
algorithms.

						- Ted



