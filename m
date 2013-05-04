From: Dave Chinner <david@fromorbit.com>
Subject: [3.9] Parallel unlinks serialise completely
Date: Sat, 4 May 2013 11:36:43 +1000
Message-ID: <20130504013643.GC19978@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37920 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138Ab3EDBgq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 May 2013 21:36:46 -0400
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>)
	id 1UYRP1-00071G-TZ
	for linux-ext4@vger.kernel.org; Sat, 04 May 2013 11:36:43 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

Just an FYI.  I was running a few fsmark workloads to compare
xfs/btrfs/ext4 performance (as i do every so often), and found that
ext4 is serialising unlinks on the orphan list mutex completely. The
script I've been running:

$ cat fsmark-50-test-ext4.sh 
#!/bin/bash

sudo umount /mnt/scratch > /dev/null 2>&1
sudo mkfs.ext4 /dev/vdc
sudo mount /dev/vdc /mnt/scratch
sudo chmod 777 /mnt/scratch
cd /home/dave/src/fs_mark-3.3/
time ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  63 \
        -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
        -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
        -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
        -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
        | tee >(stats --trim-outliers | tail -1 1>&2)
sync
sleep 30
sync

echo walking files
sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
time (
        for d in /mnt/scratch/[0-9]* ; do

                for i in $d/*; do
                        (
                                echo $i
                                find $i -ctime 1 > /dev/null
                        ) > /dev/null 2>&1
                done &
        done
        wait
)

echo removing files
for f in /mnt/scratch/* ; do time rm -rf $f &  done
wait
$

This is on a 100TB sparse VM image on a RAID0 of 4xSSDs, but that's
pretty much irrelevant to the problem being see. That is, I'm seeing
just a little over 1 CPU being expended during the unlink phase, and
only one of the 8 rm processes is running at a time.

`perf top -U -G` shows this as the leading 2 CPU consumers:

  11.99%  [kernel]  [k] __mutex_unlock_slowpat
   - __mutex_unlock_slowpat
      - 99.79% mutex_unloc
         + 51.06% ext4_orphan_add
         + 46.86% ext4_orphan_del
           1.04% do_unlinkat
              sys_unlinkat
              system_call_fastpath
              unlinkat
           0.95% vfs_unlink
              do_unlinkat
              sys_unlinkat
              system_call_fastpath
              unlinkat
-   7.14%  [kernel]  [k] __mutex_lock_slowpath
   - __mutex_lock_slowpath
      - 99.83% mutex_lock
         + 81.84% ext4_orphan_add
           11.21% ext4_orphan_del
              ext4_evict_inode
              evict
              iput
              do_unlinkat
              sys_unlinkat
              system_call_fastpath
              unlinkat
         + 3.47% vfs_unlink
         + 3.24% do_unlinkat

and the workload is running at roughly 40,000 context switches/s at
roughly 7000 iops.

Which looks rather like all unlinks are serialising the orphan list.

The overall results of the test are roughly:

	create		find		unlink
ext4    24m21s		8m17s		37m51s
xfs	 9m52s		6m53s		13m59s

The other notable thing about the unlink completion is this:

	first rm	last rm
ext4	30m26s		37m51s
xfs	13m52s		13m59s

There is significant unfairness in behaviour of the parallel
unlinks. The first 3 processes completed by 30m39s, but the last 5
processes all completed between 37m40s and 37m51s, 7 minutes later...

FWIW, there is also significant serialisation of the create
workload, but I didn't look at that at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
