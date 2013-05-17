From: frankcmoeller@arcor.de
Subject: Ext4: Slow performance on first write after mount
Date: Fri, 17 May 2013 18:51:23 +0200 (CEST)
Message-ID: <1679869241.585607.1368809483337.JavaMail.ngmail@webmail12.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:52168 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575Ab3EQQvY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 May 2013 12:51:24 -0400
Received: from mail-in-12-z2.arcor-online.net (mail-in-12-z2.arcor-online.net [151.189.8.29])
	by mx.arcor.de (Postfix) with ESMTP id 5CF0CAA7AC
	for <linux-ext4@vger.kernel.org>; Fri, 17 May 2013 18:51:23 +0200 (CEST)
Received: from mail-in-15.arcor-online.net (mail-in-15.arcor-online.net [151.189.21.55])
	by mail-in-12-z2.arcor-online.net (Postfix) with ESMTP id 54D042E6056
	for <linux-ext4@vger.kernel.org>; Fri, 17 May 2013 18:51:23 +0200 (CEST)
Received: from webmail12.arcor-online.net (webmail12.arcor-online.net [151.189.8.64])
	by mail-in-15.arcor-online.net (Postfix) with ESMTP id 50BFC1AB52B
	for <linux-ext4@vger.kernel.org>; Fri, 17 May 2013 18:51:23 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

we're using ext4 on satellite boxes (e.g. XTrend et9200) with mounted harddisks. The receiver uses linux with kernel version 3.8.7. Some users (like me) have problems with the first recording right after boot. Most of them have big partitions(1-2TB) and high disk usage (over 50%). The application signals in this case a buffer overflow (the buffer is 4 MB big). We found out, that one of the first writes after boot or remount is very slow. I have debugged it. The testcase was a umount then mount and then a write of 64MB data to the disk:
The problem is the initialization of the buffer cache which takes very long(ext4_mb_init_group in ext4_mb_good_group procedure). In my case it loads around 1300 groups per second (with the patch which avoids loading full groups). My disk is at the beginning quite full, so it needs to read around 8200 groups to find a "good" one. This takes over 6 seconds. Here is the output:
May 10 02:06:15 et9x00 user.info kernel: EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator start                         time: 4284161251798
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before for group loop cr: 0
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 0  time: 4284161318465
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after allocate buffer_heads;         time: 4284161355983
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_read_block_bitmap_nowait  time: 4284161440835
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_wait_block_bitmap         time: 4284167134687
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after allocate buffer_heads;         time: 4284167180243
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_read_block_bitmap_nowait  time: 4284167198909
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_wait_block_bitmap         time: 4284167212835
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 1  time: 4284167260724
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 2  time: 4284167276576
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 3  time: 4284167291205
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 4  time: 4284167305798
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 5  time: 4284167320280
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 6  time: 4284167334835
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 7  time: 4284167349317
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8  time: 4284167363909
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 9  time: 4284167378391
May 10 02:06:31 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 10  time: 4284167392872
...
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8240  time: 4290297430389
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after allocate buffer_heads;         time: 4290297464612
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_read_block_bitmap_nowait  time: 4290297521464
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_wait_block_bitmap         time: 4290310304019
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after allocate buffer_heads;         time: 4290310346352
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_read_block_bitmap_nowait  time: 4290310363908
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_wait_block_bitmap         time: 4290310377834
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8241  time: 4290310425945
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8242  time: 4290310443241
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8243  time: 4290310458352
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8244  time: 4290310473204
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8245  time: 4290310488056
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8246  time: 4290310503167
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8247  time: 4290310517982
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8248  time: 4290310533093
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8249  time: 4290310547945
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8250  time: 4290310562797
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8251  time: 4290310577871
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8252  time: 4290310592945
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8253  time: 4290310608019
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8254  time: 4290310622871
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator before good group; group: 8255  time: 4290310637723
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after allocate buffer_heads;         time: 4290310668278
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_read_block_bitmap_nowait  time: 4290310739464
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_wait_block_bitmap         time: 4290310979093
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after allocate buffer_heads;         time: 4290311058093
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_read_block_bitmap_nowait  time: 4290311077538
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_init_cache after ext4_wait_block_bitmap         time: 4290311091167
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator after good group;  group: 8255  time: 4290311137649
May 10 02:06:37 et9x00 user.info kernel: EXT4-fs (sda1): ext4_mb_regular_allocator end                           time: 4290311168501

Don't be surprised I couldn't activate kernel tracing on the satellite box. Perhaps because of 2 closed source kernel modules which we need to use. I have added some ext4_msg statements in mballoc.c.

If I understood right, this can also happen hours after first write, because there might be some space at the beginning of the harddisk and if it is consumed the initialization of the buffer cache proceeds...
For debugging I tested with a 64MB write, which took more than 7 seconds (the subsequently writes were much faster):
root@et9x00:~# dd if=/dev/zero of=/hdd/test.6434 bs=64M count=1
1+0 records in
1+0 records out
67108864 bytes (64.0MB) copied, 7.379178 seconds, 8.7MB/s

The application writes 188KB blocks to disk. And there we also see after some quick writes several seconds taking writes after boot or mount.

So we have real time data (up to 2 MB per second per recording) which needs to be written within max 2 or 3 seconds (depending on the bitrate of the channel). We cannot have very big buffer in the application, because of limited resources, which we cannot change.

So my questions:
- What can we do to avoid this (at best with no reformating)?
- Why do you throw away buffer cache and don't store it on disk during umount? The initialization of the buffer cache is quite awful for application which need a specific write throughput.
- A workaround would be to read whole /proc/.../mb_groups file right after every mount. Correct?
- I can try to add a mount option to initialize the cache at mount time. Would you be interested in such a patch?
- I can see (see debug output) that the call of ext4_wait_block_bitmap in mballoc.c line 848 takes during buffer cache initialization the longest time (some 1/100 of a second). Can this be improved?

Regards,
Frank
