From: Curt Wohlgemuth <curtw@google.com>
Subject: Ext4 without a journal: some benchmark results
Date: Wed, 7 Jan 2009 11:29:11 -0800
Message-ID: <6601abe90901071129v3de159d4jcf3b250aac40d0eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:55214 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759580AbZAGT3Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 14:29:16 -0500
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id n07JTFrK026860
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 11:29:16 -0800
Received: from fxm10 (fxm10.prod.google.com [10.184.13.10])
	by zps35.corp.google.com with ESMTP id n07JTBtO010971
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 11:29:12 -0800
Received: by fxm10 with SMTP id 10so1416580fxm.12
        for <linux-ext4@vger.kernel.org>; Wed, 07 Jan 2009 11:29:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi:

I promised back in mid-December to send out some benchmark numbers I'm
seeing with Frank Mayhar's work to allow ext4 to run without a journal.  My
apologies for the delay...

I ran both iozone and compilebench on the following filesystems, using a
2.6.26-based kernel, with most ext4 patches applied.  This is on a x86 based
4-core system, with a separate disk for these runs.

   ext2, default create/mount options
   ext3, default create/mount options
   ext4, default create/mount options
   ext4, created with "-O ^has_journal"

For each filesystem, I ran each benchmark twice, doing a mke2fs before each
run.  The same disk was used for each run; all benchmarks ran in the mount
directory of the newly mkfs'ed disk.  I averaged the values for the two runs
for each FS/thread number.

Iozone was run with the following command line:

      iozone -t (# threads) -s 2g -r 256k -I -T -i0 -i1 -i2

I.e., throughput mode; 2GiB file; 256KiB buffer; O_DIRECT.  Tests were
limited to

        write/rewrite
        read/re-read
        random-read/write

I ran iozone twice for each FS: with a single thread (-t 1) and with 8
threads (-t 8).

Compilebench was run with the following command line:

   compilebench -D (mount dir) -i 10 -r 30

I.e., 10 kernel trees, 30 "random operation" runs.

Results follow.

Thanks,
Curt


Iozone
======
   ext2 : 1 thread
   ---------------
         Average throughput:
                     Type          Mean      Stddev
           initial_writers:    56.6 MB/s  ( 0.2)
                 rewriters:    58.4 MB/s  ( 0.2)
                   readers:    66.3 MB/s  ( 0.2)
                re-readers:    66.5 MB/s  ( 0.0)
            random_readers:    22.4 MB/s  ( 0.1)
            random_writers:    18.8 MB/s  ( 0.0)

   ext2 : 8 threads
   ----------------
         Average throughput:
                     Type          Mean      Stddev
           initial_writers:    28.5 MB/s  ( 0.0)
                 rewriters:    43.5 MB/s  ( 0.1)
                   readers:    51.5 MB/s  ( 0.1)
                re-readers:    51.8 MB/s  ( 0.2)
            random_readers:    20.3 MB/s  ( 0.0)
            random_writers:    17.3 MB/s  ( 0.0)

   ext3 : 1 thread
   ----------------
         Average throughput:
                     Type          Mean      Stddev
           initial_writers:    56.3 MB/s  ( 0.2)
                 rewriters:    58.2 MB/s  ( 0.1)
                   readers:    66.4 MB/s  ( 0.1)
                re-readers:    66.1 MB/s  ( 0.2)
            random_readers:    22.1 MB/s  ( 0.1)
            random_writers:    18.6 MB/s  ( 0.1)

   ext3 : 8 threads
   ----------------
         Average throughput:
                     Type          Mean      Stddev
           initial_writers:    28.7 MB/s  ( 0.1)
                 rewriters:    43.2 MB/s  ( 0.2)
                   readers:    51.5 MB/s  ( 0.0)
                re-readers:    51.5 MB/s  ( 0.0)
            random_readers:    20.2 MB/s  ( 0.0)
            random_writers:    17.3 MB/s  ( 0.0)

   ext4-nojournal : 1 thread
   -------------------------
         Average throughput:
                     Type          Mean      Stddev
           initial_writers:    66.3 MB/s  ( 0.2)
                 rewriters:    66.6 MB/s  ( 0.1)
                   readers:    66.4 MB/s  ( 0.0)
                re-readers:    66.4 MB/s  ( 0.0)
            random_readers:    22.4 MB/s  ( 0.1)
            random_writers:    19.4 MB/s  ( 0.2)

   ext4-nojournal : 8 threads
   --------------------------
         Average throughput:
                     Type          Mean      Stddev
           initial_writers:    56.1 MB/s  ( 0.1)
                 rewriters:    60.3 MB/s  ( 0.2)
                   readers:    61.0 MB/s  ( 0.0)
                re-readers:    61.0 MB/s  ( 0.0)
            random_readers:    20.4 MB/s  ( 0.1)
            random_writers:    18.3 MB/s  ( 0.1)

   ext4-stock : 1 thread
   ----------------------
         Average throughput:
                     Type          Mean      Stddev
           initial_writers:    65.5 MB/s  ( 0.1)
                 rewriters:    65.7 MB/s  ( 0.2)
                   readers:    65.8 MB/s  ( 0.2)
                re-readers:    65.6 MB/s  ( 0.3)
            random_readers:    21.9 MB/s  ( 0.0)
            random_writers:    19.1 MB/s  ( 0.1)

   ext4-stock : 8 threads
   ----------------------
         Average throughput:
                     Type          Mean      Stddev
           initial_writers:    53.7 MB/s  ( 0.2)
                 rewriters:    58.3 MB/s  ( 0.1)
                   readers:    58.8 MB/s  ( 0.1)
                re-readers:    59.0 MB/s  ( 0.1)
            random_readers:    20.2 MB/s  ( 0.0)
            random_writers:    18.1 MB/s  ( 0.0)


Compilebench
============

   ext2
   ----
         Average values:
                     Type          Mean      Stddev
               initial_create:    57.9 MB_s  ( 1.9)
                   new_create:    13.0 MB_s  ( 0.2)
                        patch:     7.3 MB_s  ( 0.1)
                      compile:    25.6 MB_s  ( 0.6)
                        clean:    70.4 MB_s  ( 1.3)
                    read_tree:    22.1 MB_s  ( 0.0)
           read_compiled_tree:    33.3 MB_s  ( 0.2)
                  delete_tree:     6.5 secs  ( 0.2)
                    stat_tree:     5.2 secs  ( 0.0)
           stat_compiled_tree:     5.7 secs  ( 0.1)

   ext3
   ----
         Average values:
                     Type          Mean      Stddev
               initial_create:    30.6 MB_s  ( 2.2)
                   new_create:    13.5 MB_s  ( 0.2)
                        patch:    10.6 MB_s  ( 0.1)
                      compile:    18.0 MB_s  ( 0.3)
                        clean:    41.7 MB_s  ( 1.8)
                    read_tree:    21.5 MB_s  ( 0.2)
           read_compiled_tree:    20.4 MB_s  ( 1.1)
                  delete_tree:    13.5 secs  ( 0.3)
                    stat_tree:     6.7 secs  ( 0.4)
           stat_compiled_tree:     9.6 secs  ( 2.9)

   ext4-nojournal
   --------------
         Average values:
                     Type          Mean      Stddev
               initial_create:    77.1 MB_s  ( 0.2)
                   new_create:    22.0 MB_s  ( 0.1)
                        patch:    13.1 MB_s  ( 0.0)
                      compile:    36.0 MB_s  ( 0.1)
                        clean:   592.4 MB_s  (39.4)
                    read_tree:    17.8 MB_s  ( 0.2)
           read_compiled_tree:    22.1 MB_s  ( 0.1)
                  delete_tree:     2.5 secs  ( 0.0)
                    stat_tree:     2.2 secs  ( 0.0)
           stat_compiled_tree:     2.5 secs  ( 0.0)

   ext4-stock
   ----------
         Average values:
                     Type          Mean      Stddev
               initial_create:    59.7 MB_s  ( 0.4)
                   new_create:    20.5 MB_s  ( 0.0)
                        patch:    12.5 MB_s  ( 0.0)
                      compile:    33.9 MB_s  ( 0.2)
                        clean:   539.5 MB_s  ( 3.6)
                    read_tree:    17.1 MB_s  ( 0.1)
           read_compiled_tree:    21.8 MB_s  ( 0.1)
                  delete_tree:     2.7 secs  ( 0.1)
                    stat_tree:     2.4 secs  ( 0.0)
           stat_compiled_tree:     2.5 secs  ( 0.2)
