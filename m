From: Dave Johnson <dave-lkml-01@centerclick.org>
Subject: [ext3] kjournald writing after each read despite noatime,commit=nnn
Date: Wed, 31 Dec 2008 16:28:41 -0500
Message-ID: <18779.58377.160214.225792@wellington.i202.centerclick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lexington.centerclick.org ([66.114.92.10]:55476 "EHLO
	lexington.centerclick.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYLaVns (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Dec 2008 16:43:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Since upgrading from 2.6.23.1 to 2.6.27.8, I'm now seeing kjournald
perform a write 2 seconds after each read to an ext3 fs.

laptop mode is on and filesystem is mounted with noatime and a large
commit time (6 hours).

Did I miss something or is this expected?


Note, there is no other activity reported by block_dump at this time
from any other mounted filesystem.

Some examples:

Dec 31 15:43:14 gw kernel: w(26329): READ block 756266 on hda1 
Dec 31 15:43:16 gw kernel: kjournald(760): WRITE block 2152 on hda1 

Dec 31 15:45:05 gw kernel: top(26366): READ block 756008 on hda1 
Dec 31 15:45:05 gw kernel: top(26366): READ block 756016 on hda1 
Dec 31 15:45:05 gw kernel: top(26366): READ block 756026 on hda1 
Dec 31 15:45:05 gw kernel: top(26366): READ block 756098 on hda1 
Dec 31 15:45:07 gw kernel: kjournald(760): WRITE block 2154 on hda1 

Dec 31 15:48:43 gw kernel: cat(26430): READ block 502016 on hda1 
Dec 31 15:48:43 gw kernel: cat(26430): READ block 502024 on hda1 
Dec 31 15:48:43 gw kernel: cat(26430): READ block 502032 on hda1 
Dec 31 15:48:43 gw kernel: cat(26430): READ block 502040 on hda1 
Dec 31 15:48:43 gw kernel: cat(26430): READ block 502042 on hda1 
Dec 31 15:48:43 gw kernel: cat(26430): READ block 502050 on hda1 
Dec 31 15:48:43 gw kernel: cat(26430): READ block 502114 on hda1 
Dec 31 15:48:45 gw kernel: kjournald(760): WRITE block 2156 on hda1 

Dec 31 15:48:55 gw kernel: bash(26436): READ block 744586 on hda1 
Dec 31 15:48:55 gw kernel: bash(26436): READ block 744594 on hda1 
Dec 31 15:48:55 gw kernel: bash(26436): READ block 744602 on hda1 
Dec 31 15:48:55 gw kernel: bash(26436): READ block 744610 on hda1 
Dec 31 15:48:55 gw kernel: bash(26436): READ block 744612 on hda1 
Dec 31 15:48:55 gw kernel: reset(26436): READ block 744620 on hda1 
Dec 31 15:48:57 gw kernel: kjournald(760): WRITE block 2158 on hda1 

$ grep ext3 /proc/mounts 
/dev/root / ext3 rw,noatime,errors=remount-ro,commit=21600,data=ordered 0 0

$ for f in /proc/sys/vm/*; do printf "%-50s" $f; cat $f; done
/proc/sys/vm/block_dump                           1
/proc/sys/vm/dirty_background_ratio               10
/proc/sys/vm/dirty_expire_centisecs               2160000
/proc/sys/vm/dirty_ratio                          60
/proc/sys/vm/dirty_writeback_centisecs            2160000
/proc/sys/vm/drop_caches                          0
/proc/sys/vm/laptop_mode                          2
/proc/sys/vm/legacy_va_layout                     0
/proc/sys/vm/lowmem_reserve_ratio                 256   32
/proc/sys/vm/max_map_count                        65536
/proc/sys/vm/min_free_kbytes                      1440
/proc/sys/vm/nr_pdflush_threads                   2
/proc/sys/vm/oom_dump_tasks                       0
/proc/sys/vm/oom_kill_allocating_task             0
/proc/sys/vm/overcommit_memory                    0
/proc/sys/vm/overcommit_ratio                     50
/proc/sys/vm/page-cluster                         3
/proc/sys/vm/panic_on_oom                         0
/proc/sys/vm/percpu_pagelist_fraction             0
/proc/sys/vm/swappiness                           60
/proc/sys/vm/vdso_enabled                         2
/proc/sys/vm/vfs_cache_pressure                   100
$ 

-- 
Dave
