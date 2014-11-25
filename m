From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v4] ext4: Extent status tree shrinker improvements
Date: Tue, 25 Nov 2014 15:55:29 +0100
Message-ID: <1416927336-9328-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbaKYOzr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 09:55:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  this is the next revision of Zheng's patches for improving latency of ext4
extent status tree shrinker. Since previous version I have added a fix to a
bug in ext4_da_map_blocks() which was made more visible by this series and
also swapped patches 3 & 4 to fix double lock issue that happened when only
first three patches were applied.

Here are the measurements of the extent status tree shrinker (done in my
test VM with 6 CPUs and 2GB of RAM) [they are from the previous version but
nothing changed for the shrinker in this revision].

For my synthetic test maintaing lots of fragmented files the results were
like:
Baseline:
stats:
  2194 objects
  1206 reclaimable objects
  299726/14244181 cache hits/misses
  7796 ms last sorted interval
  2002 inodes on lru list
average:
  858 us scan time
  116 shrunk objects
maximum:
  601 inode (10 objects, 10 reclaimable)
  332987 us max scan time

Patched:
stats:
  4351 objects
  2176 reclaimable objects
  21183492/2809261 cache hits/misses
  220 inodes on list
max nr_to_scan: 128 max inodes walked: 15
average:
  148 us scan time
  125 shrunk objects
maximum:
  1494 inode (20 objects, 10 reclaimable)
  4173 us max scan time

Also for Zheng's write fio workload we get noticeable improvements:
Baseline:
stats:
  261094 objects
  261094 reclaimable objects
  4030024/1063081 cache hits/misses
  366508 ms last sorted interval
  15001 inodes on lru list
average:
  330 us scan time
  125 shrunk objects
maximum:
  9217 inode (46 objects, 46 reclaimable)
  19525 us max scan time

Patched:
stats:
  496796 objects
  466436 reclaimable objects
  1322023/119385 cache hits/misses
  14825 inodes on list
max nr_to_scan: 128 max inodes walked: 3
average:
  112 us scan time
  125 shrunk objects
maximum:
  2 inode (87 objects, 87 reclaimable)
  7158 us max scan time

OTOH I can see a regression in max latency for the randwrite workload:
Baseline:
stats:
  35953 objects
  33264 reclaimable objects
  110208/1794665 cache hits/misses
  56396 ms last sorted interval
  251 inodes on lru list
average:
  286 us scan time
  125 shrunk objects
maximum:
  225 inode (849 objects, 838 reclaimable)
  4220 us max scan time

Patched
stats:
  118256 objects
stats:
  193489 objects
  193489 reclaimable objects
  1133707/65535 cache hits/misses
  251 inodes on list
max nr_to_scan: 128 max inodes walked: 6
average:
  180 us scan time
  125 shrunk objects
maximum:
  15123 inode (1931 objects, 1931 reclaimable)
  6458 us max scan time

  In general you can see there are much more objects cached in the patched
kernel. This is because of the first patch - we now have all the holes in the
files cached as well. This is also the reason for the much higher cache hit
ratio. I'm still somewhat unsatisfied with the worst case latency of the
shrinker which is in order of miliseconds for all the workloads. I did some
more instrumentation of the code and the reason for this s_es_lock. Under
heavy load the wait time for this lock is on average ~100 us (3300 us max).
I have some ideas how to improve on this but I didn't want to delay posting
of the series even more...

								Honza
