From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: open bugs found by fuzzing
Date: Thu, 14 Jul 2016 23:10:18 +0200
Message-ID: <5787FFBA.70406@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbcGNVKZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jul 2016 17:10:25 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u6ELAOLu003462
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2016 21:10:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u6ELAOAC006369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2016 21:10:24 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u6ELAKWK019627
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jul 2016 21:10:24 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've been doing some ext4 fuzzing with AFL lately and run into a number
of crashes/warnings. Below is a list of these present in a 100% vanilla
mainline kernel. I will keep debugging and submitting patches until the
list is empty. In the meantime, the list is a useful way to keep track
of each bug and gauge the overall progress.

If anybody thinks they know what causes a particular bug, I'm happy to
test patches or provide more info. The only thing I can't do is to post
full-blown disk images or reproducers. Also note that several of these
may actually be the same underlying bug.

1. kasan: GPF could be caused by NULL-ptr deref or user memory 
accessgeneral protection fault: 0000 [#1] KASAN
http://139.162.151.198/f/ext4/57be666646a37e9821d52bc64846a3b3b785ee7a

2. kernel BUG at fs/buffer.c:2994!
http://139.162.151.198/f/ext4/7df880da89c82579c15ca8bc786a3467ca9c47f7

3. kernel BUG at fs/ext4/inode.c:3709!
http://139.162.151.198/f/ext4/5bdefda69f39b2f2c56d9b67d5b7d9e2cc8dfd5f

4. kernel BUG at fs/ext4/mballoc.c:3188!
http://139.162.151.198/f/ext4/34284738d67f0405325b2c43211c56020b9d0211

5. kernel BUG at fs/ext4/mballoc.c:3518!
http://139.162.151.198/f/ext4/0f702e84173b87861c4ce226cc2e82f600ad9d0c

6. kernel BUG at fs/jbd2/commit.c:825!
http://139.162.151.198/f/ext4/3143febf7925bd1ea398bd1a775551133bd69ffd

7. WARNING: CPU: 0 PID: 58 at fs/ext4/ext4.h:2807 
ext4_block_bitmap_csum_set+0x358/0x600
http://139.162.151.198/f/ext4/9628c19aff0bbaaae4149a03486305c7f6cd7523

8. WARNING: CPU: 0 PID: 58 at fs/ext4/mballoc.c:3987 
ext4_discard_preallocations+0x6cb/0x8b0
http://139.162.151.198/f/ext4/0181e37a689dfcb8565695d93172e790a34a3d14

9. WARNING: CPU: 0 PID: 58 at fs/jbd2/transaction.c:293 
start_this_handle+0xab6/0xcf0
http://139.162.151.198/f/ext4/55c691ba260963ffe20b365298e1f79f3b81968a

10. WARNING: CPU: 0 PID: 58 at kernel/locking/mutex-debug.c:78 
debug_mutex_unlock+0x214/0x520
http://139.162.151.198/f/ext4/000ac1bce9ae7640565328ddcceb31a675e3052a

11. WARNING: CPU: 0 PID: 58 at lib/idr.c:401 idr_preload+0xec/0x110
http://139.162.151.198/f/ext4/7eace56beb912159fba1776ede9c2566f35f95ca

12. WARNING: CPU: 0 PID: 58 at lib/list_debug.c:36 __list_add+0x169/0x1c0
http://139.162.151.198/f/ext4/488a8e50b5137e01d1dd54e30e0e2fe34d8f0b27

13. WARNING: CPU: 0 PID: 58 at lib/list_debug.c:56 
__list_del_entry+0x135/0x1d0
http://139.162.151.198/f/ext4/2e2c6122422aa6007cec500846fe8f891e954fee

14. WARNING: CPU: 0 PID: 58 at lib/list_debug.c:59 
__list_del_entry+0x14f/0x1d0
http://139.162.151.198/f/ext4/1ac079bb08a23c32500cf5d4c29a29ca615f9295

15. WARNING: CPU: 0 PID: 58 at mm/slab_common.c:861 kmalloc_slab+0x8a/0x90
http://139.162.151.198/f/ext4/53b3aab7ddab0fb156047ea5cf72c359511f2726


Vegard
