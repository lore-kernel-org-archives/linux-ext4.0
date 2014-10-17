From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] New: drastic reduction of write performance after the
 termination of mysqld
Date: Fri, 17 Oct 2014 13:14:23 +0000
Message-ID: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55999 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbaJQNO3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Oct 2014 09:14:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E52E0201FA
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2014 13:14:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1D9C32020F
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2014 13:14:24 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=86471

            Bug ID: 86471
           Summary: drastic reduction of write performance after the
                    termination of mysqld
           Product: File System
           Version: 2.5
    Kernel Version: 3.14.21
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: m.koenigshaus@wut.de
        Regression: No

With our ARM Board we obtain a reduction of the write performance of about 15
MB/s to 0.4 MB/s, if we stop the mysqld. As hard drive we use a e.MMC - chip.

mount:

rootfs on / type rootfs (rw)
/dev/mmcblk0p6 on / type ext4 (rw,noatime,nodiratime,stripe=1024,data=ordered)
proc on /proc type proc (rw,relatime)
sys on /sys type sysfs (rw,relatime)
tmpfs on /mnt/tmpfs type tmpfs (rw,relatime,size=16384k)
tmpfs on /tmp type tmpfs (rw,relatime,size=16384k)
tmpfs on /var type tmpfs (rw,relatime,size=16384k)
tmpfs on /tmp type tmpfs (rw,relatime,size=16384k)
none on /dev type devtmpfs (rw,relatime,size=256232k,nr_inodes=64058,mode=755)
/dev/pts on /dev/pts type devpts (rw,relatime,mode=600)
none on /dev/shm type tmpfs (rw,relatime)
/dev/mmcblk0p7 on /data type ext4
(rw,noatime,nodiratime,stripe=1024,data=ordered)
none on /sys/kernel/debug type debugfs (rw,relatime)

uname -r: 3.14.21

Test Program: dd if=/dev/zero of=/data/trash bs=4k count=128, /data is a ext4 -
Partition

dmesg Output with echo 5 > mballoc_debug:

>> before mysqld shudown:

[   59.067463] (fs/ext4/mballoc.c, 2755): ext4_free_data_callback: gonna free
64 blocks in group 1 (0xdf1bd000):
[   59.067485] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[   59.068738] (fs/ext4/mballoc.c, 2803): ext4_free_data_callback: freed 64
blocks in 1 structures
[   59.068748] (fs/ext4/mballoc.c, 2755): ext4_free_data_callback: gonna free
32 blocks in group 1 (0xdf1bd028):
[   59.068758] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[   59.069999] (fs/ext4/mballoc.c, 2803): ext4_free_data_callback: freed 32
blocks in 1 structures
[   59.070008] (fs/ext4/mballoc.c, 2755): ext4_free_data_callback: gonna free
32 blocks in group 1 (0xdf1bd050):
[   59.070017] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[   59.071257] (fs/ext4/mballoc.c, 2803): ext4_free_data_callback: freed 32
blocks in 1 structures
[   66.117581] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 2208
[   66.120616] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 1499
[   66.120666] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[   66.124007] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
128 blocks @ 0, goal 32768, flags c20, 2^0, left: 0/0, right 0/0 to writable
[   66.124029] (fs/ext4/mballoc.c, 3166): ext4_mb_normalize_request: goal:
128(was 524288) blocks at 0
[   66.124042] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[   66.125507] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 1499
[   72.068755] (fs/ext4/mballoc.c, 2755): ext4_free_data_callback: gonna free
128 blocks in group 1 (0xdf1bd050):
[   72.068777] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[   72.070031] (fs/ext4/mballoc.c, 2803): ext4_free_data_callback: freed 128
blocks in 1 structures
[   79.662962] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 2208

>> after mysqld shutdown

[  135.204260] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 2208
[  135.207150] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 1499
[  135.207200] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[  135.208241] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
32 blocks @ 0, goal 32768, flags c20, 2^0, left: 0/0, right 0/0 to writable
[  135.208263] (fs/ext4/mballoc.c, 3166): ext4_mb_normalize_request: goal:
32(was 131072) blocks at 0
[  135.208276] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[  135.234404] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 32, goal 34496, flags c20, 2^0, left: 31/34495, right 32/0 to
writable
[  135.234431] (fs/ext4/mballoc.c, 3166): ext4_mb_normalize_request: goal:
32(was 135168) blocks at 32
[  135.234442] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[  135.234464] (fs/ext4/mballoc.c, 3606): ext4_mb_new_inode_pa: new inode pa
df25ecc0: 34496/32 for 32
[  135.234476] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34496/1
from inode pa df25ecc0
[  135.244879] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 33, goal 34497, flags c20, 2^0, left: 32/34496, right 33/0 to
writable
[  135.244901] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34497/1
from inode pa df25ecc0
[  135.254621] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 34, goal 34498, flags c20, 2^0, left: 33/34497, right 34/0 to
writable
[  135.254642] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34498/1
from inode pa df25ecc0
[  135.264638] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 35, goal 34499, flags c20, 2^0, left: 34/34498, right 35/0 to
writable
[  135.264659] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34499/1
from inode pa df25ecc0
[  135.274632] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 36, goal 34500, flags c20, 2^0, left: 35/34499, right 36/0 to
writable
[  135.274652] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34500/1
from inode pa df25ecc0
[  135.284633] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 37, goal 34501, flags c20, 2^0, left: 36/34500, right 37/0 to
writable
[  135.284653] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34501/1
from inode pa df25ecc0
[  135.294625] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 38, goal 34502, flags c20, 2^0, left: 37/34501, right 38/0 to
writable
[  135.294646] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34502/1
from inode pa df25ecc0
[  135.304634] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 39, goal 34503, flags c20, 2^0, left: 38/34502, right 39/0 to
writable
[  135.304654] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34503/1
from inode pa df25ecc0
[  135.314623] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 40, goal 34504, flags c20, 2^0, left: 39/34503, right 40/0 to
writable
[  135.314644] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34504/1
from inode pa df25ecc0
[  135.324677] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 41, goal 34505, flags c20, 2^0, left: 40/34504, right 41/0 to
writable
[  135.324698] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34505/1
from inode pa df25ecc0
[  135.334630] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 42, goal 34506, flags c20, 2^0, left: 41/34505, right 42/0 to
writable
[  135.334650] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34506/1
from inode pa df25ecc0
[  135.344620] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 43, goal 34507, flags c20, 2^0, left: 42/34506, right 43/0 to
writable
[  135.344641] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34507/1
from inode pa df25ecc0
[  135.354621] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 44, goal 34508, flags c20, 2^0, left: 43/34507, right 44/0 to
writable
[  135.354642] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34508/1
from inode pa df25ecc0
[  135.364653] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 45, goal 34509, flags c20, 2^0, left: 44/34508, right 45/0 to
writable
[  135.364673] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34509/1
from inode pa df25ecc0
[  135.374697] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 46, goal 34510, flags c20, 2^0, left: 45/34509, right 46/0 to
writable
[  135.374717] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34510/1
from inode pa df25ecc0
[  135.384654] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 47, goal 34511, flags c20, 2^0, left: 46/34510, right 47/0 to
writable
[  135.384674] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34511/1
from inode pa df25ecc0
[  135.394652] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 48, goal 34512, flags c20, 2^0, left: 47/34511, right 48/0 to
writable
[  135.394673] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34512/1
from inode pa df25ecc0
[  135.404653] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 49, goal 34513, flags c20, 2^0, left: 48/34512, right 49/0 to
writable
[  135.404674] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34513/1
from inode pa df25ecc0
[  135.414646] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 50, goal 34514, flags c20, 2^0, left: 49/34513, right 50/0 to
writable
[  135.414666] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34514/1
from inode pa df25ecc0
[  135.424645] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 51, goal 34515, flags c20, 2^0, left: 50/34514, right 51/0 to
writable
[  135.424665] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34515/1
from inode pa df25ecc0
[  135.434645] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 52, goal 34516, flags c20, 2^0, left: 51/34515, right 52/0 to
writable
[  135.434666] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34516/1
from inode pa df25ecc0
[  135.444653] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 53, goal 34517, flags c20, 2^0, left: 52/34516, right 53/0 to
writable
[  135.444674] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34517/1
from inode pa df25ecc0
[  135.454651] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 54, goal 34518, flags c20, 2^0, left: 53/34517, right 54/0 to
writable
[  135.454672] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34518/1
from inode pa df25ecc0
[  135.464652] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 55, goal 34519, flags c20, 2^0, left: 54/34518, right 55/0 to
writable
[  135.464672] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34519/1
from inode pa df25ecc0
[  135.474643] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 56, goal 34520, flags c20, 2^0, left: 55/34519, right 56/0 to
writable
[  135.474664] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34520/1
from inode pa df25ecc0
[  135.484637] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 57, goal 34521, flags c20, 2^0, left: 56/34520, right 57/0 to
writable
[  135.484658] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34521/1
from inode pa df25ecc0
[  135.494651] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 58, goal 34522, flags c20, 2^0, left: 57/34521, right 58/0 to
writable
[  135.494672] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34522/1
from inode pa df25ecc0
[  135.504639] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 59, goal 34523, flags c20, 2^0, left: 58/34522, right 59/0 to
writable
[  135.504659] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34523/1
from inode pa df25ecc0
[  135.514634] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 60, goal 34524, flags c20, 2^0, left: 59/34523, right 60/0 to
writable
[  135.514654] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34524/1
from inode pa df25ecc0
[  135.524640] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 61, goal 34525, flags c20, 2^0, left: 60/34524, right 61/0 to
writable
[  135.524661] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34525/1
from inode pa df25ecc0
[  135.534634] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 62, goal 34526, flags c20, 2^0, left: 61/34525, right 62/0 to
writable
[  135.534654] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34526/1
from inode pa df25ecc0
[  135.544643] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 63, goal 34527, flags c20, 2^0, left: 62/34526, right 63/0 to
writable
[  135.544663] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34527/1
from inode pa df25ecc0
[  135.554638] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 64, goal 34528, flags c20, 2^0, left: 63/34527, right 64/0 to
writable
[  135.554661] (fs/ext4/mballoc.c, 3166): ext4_mb_normalize_request: goal:
64(was 266240) blocks at 64
[  135.554672] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[  135.554689] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[  135.554706] (fs/ext4/mballoc.c, 3606): ext4_mb_new_inode_pa: new inode pa
df1843c0: 34112/64 for 64
[  135.554718] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34112/1
from inode pa df1843c0
[  135.565027] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 65, goal 34113, flags c20, 2^0, left: 64/34112, right 65/0 to
writable
[  135.565047] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34113/1
from inode pa df1843c0
[  135.574649] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 66, goal 34114, flags c20, 2^0, left: 65/34113, right 66/0 to
writable
[  135.574670] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34114/1
from inode pa df1843c0
[  135.584635] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 67, goal 34115, flags c20, 2^0, left: 66/34114, right 67/0 to
writable
[  135.584654] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34115/1
from inode pa df1843c0
[  135.594383] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 68, goal 34116, flags c20, 2^0, left: 67/34115, right 68/0 to
writable
[  135.594404] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34116/1
from inode pa df1843c0
[  135.604559] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 69, goal 34117, flags c20, 2^0, left: 68/34116, right 69/0 to
writable
[  135.604579] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34117/1
from inode pa df1843c0
[  135.614368] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 70, goal 34118, flags c20, 2^0, left: 69/34117, right 70/0 to
writable
[  135.614388] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34118/1
from inode pa df1843c0
[  135.624352] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 71, goal 34119, flags c20, 2^0, left: 70/34118, right 71/0 to
writable
[  135.624370] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34119/1
from inode pa df1843c0
[  135.634373] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 72, goal 34120, flags c20, 2^0, left: 71/34119, right 72/0 to
writable
[  135.634393] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34120/1
from inode pa df1843c0
[  135.644354] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 73, goal 34121, flags c20, 2^0, left: 72/34120, right 73/0 to
writable
[  135.644373] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34121/1
from inode pa df1843c0
[  135.654369] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 74, goal 34122, flags c20, 2^0, left: 73/34121, right 74/0 to
writable
[  135.654391] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34122/1
from inode pa df1843c0
[  135.664353] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 75, goal 34123, flags c20, 2^0, left: 74/34122, right 75/0 to
writable
[  135.664371] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34123/1
from inode pa df1843c0
[  135.674373] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 76, goal 34124, flags c20, 2^0, left: 75/34123, right 76/0 to
writable
[  135.674393] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34124/1
from inode pa df1843c0
[  135.684352] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 77, goal 34125, flags c20, 2^0, left: 76/34124, right 77/0 to
writable
[  135.684370] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34125/1
from inode pa df1843c0
[  135.694367] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 78, goal 34126, flags c20, 2^0, left: 77/34125, right 78/0 to
writable
[  135.694387] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34126/1
from inode pa df1843c0
[  135.704352] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 79, goal 34127, flags c20, 2^0, left: 78/34126, right 79/0 to
writable
[  135.704371] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34127/1
from inode pa df1843c0
[  135.714373] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 80, goal 34128, flags c20, 2^0, left: 79/34127, right 80/0 to
writable
[  135.714393] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34128/1
from inode pa df1843c0
[  135.724356] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 81, goal 34129, flags c20, 2^0, left: 80/34128, right 81/0 to
writable
[  135.724374] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34129/1
from inode pa df1843c0
[  135.734366] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 82, goal 34130, flags c20, 2^0, left: 81/34129, right 82/0 to
writable
[  135.734386] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34130/1
from inode pa df1843c0
[  135.744361] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 83, goal 34131, flags c20, 2^0, left: 82/34130, right 83/0 to
writable
[  135.744380] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34131/1
from inode pa df1843c0
[  135.754368] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 84, goal 34132, flags c20, 2^0, left: 83/34131, right 84/0 to
writable
[  135.754389] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34132/1
from inode pa df1843c0
[  135.764353] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 85, goal 34133, flags c20, 2^0, left: 84/34132, right 85/0 to
writable
[  135.764372] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34133/1
from inode pa df1843c0
[  135.774366] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 86, goal 34134, flags c20, 2^0, left: 85/34133, right 86/0 to
writable
[  135.774387] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34134/1
from inode pa df1843c0
[  135.784349] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 87, goal 34135, flags c20, 2^0, left: 86/34134, right 87/0 to
writable
[  135.784367] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34135/1
from inode pa df1843c0
[  135.794373] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 88, goal 34136, flags c20, 2^0, left: 87/34135, right 88/0 to
writable
[  135.794393] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34136/1
from inode pa df1843c0
[  135.804353] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 89, goal 34137, flags c20, 2^0, left: 88/34136, right 89/0 to
writable
[  135.804371] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34137/1
from inode pa df1843c0
[  135.814376] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 90, goal 34138, flags c20, 2^0, left: 89/34137, right 90/0 to
writable
[  135.814396] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34138/1
from inode pa df1843c0
[  135.824406] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 91, goal 34139, flags c20, 2^0, left: 90/34138, right 91/0 to
writable
[  135.824425] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34139/1
from inode pa df1843c0
[  135.834384] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 92, goal 34140, flags c20, 2^0, left: 91/34139, right 92/0 to
writable
[  135.834406] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34140/1
from inode pa df1843c0
[  135.844356] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 93, goal 34141, flags c20, 2^0, left: 92/34140, right 93/0 to
writable
[  135.844374] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34141/1
from inode pa df1843c0
[  135.854367] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 94, goal 34142, flags c20, 2^0, left: 93/34141, right 94/0 to
writable
[  135.854387] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34142/1
from inode pa df1843c0
[  135.864354] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 95, goal 34143, flags c20, 2^0, left: 94/34142, right 95/0 to
writable
[  135.864372] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34143/1
from inode pa df1843c0
[  135.874377] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 96, goal 34144, flags c20, 2^0, left: 95/34143, right 96/0 to
writable
[  135.874397] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34144/1
from inode pa df1843c0
[  135.884355] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 97, goal 34145, flags c20, 2^0, left: 96/34144, right 97/0 to
writable
[  135.884373] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34145/1
from inode pa df1843c0
[  135.894373] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 98, goal 34146, flags c20, 2^0, left: 97/34145, right 98/0 to
writable
[  135.894393] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34146/1
from inode pa df1843c0
[  135.904361] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 99, goal 34147, flags c20, 2^0, left: 98/34146, right 99/0 to
writable
[  135.904380] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34147/1
from inode pa df1843c0
[  135.914376] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 100, goal 34148, flags c20, 2^0, left: 99/34147, right 100/0 to
writable
[  135.914399] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34148/1
from inode pa df1843c0
[  135.924356] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 101, goal 34149, flags c20, 2^0, left: 100/34148, right 101/0 to
writable
[  135.924374] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34149/1
from inode pa df1843c0
[  135.934365] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 102, goal 34150, flags c20, 2^0, left: 101/34149, right 102/0 to
writable
[  135.934385] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34150/1
from inode pa df1843c0
[  135.944352] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 103, goal 34151, flags c20, 2^0, left: 102/34150, right 103/0 to
writable
[  135.944370] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34151/1
from inode pa df1843c0
[  135.954375] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 104, goal 34152, flags c20, 2^0, left: 103/34151, right 104/0 to
writable
[  135.954396] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34152/1
from inode pa df1843c0
[  135.964353] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 105, goal 34153, flags c20, 2^0, left: 104/34152, right 105/0 to
writable
[  135.964372] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34153/1
from inode pa df1843c0
[  135.974367] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 106, goal 34154, flags c20, 2^0, left: 105/34153, right 106/0 to
writable
[  135.974388] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34154/1
from inode pa df1843c0
[  135.984352] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 107, goal 34155, flags c20, 2^0, left: 106/34154, right 107/0 to
writable
[  135.984370] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34155/1
from inode pa df1843c0
[  135.994374] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 108, goal 34156, flags c20, 2^0, left: 107/34155, right 108/0 to
writable
[  135.994394] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34156/1
from inode pa df1843c0
[  136.004353] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 109, goal 34157, flags c20, 2^0, left: 108/34156, right 109/0 to
writable
[  136.004371] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34157/1
from inode pa df1843c0
[  136.014367] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 110, goal 34158, flags c20, 2^0, left: 109/34157, right 110/0 to
writable
[  136.014387] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34158/1
from inode pa df1843c0
[  136.024350] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 111, goal 34159, flags c20, 2^0, left: 110/34158, right 111/0 to
writable
[  136.024369] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34159/1
from inode pa df1843c0
[  136.034371] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 112, goal 34160, flags c20, 2^0, left: 111/34159, right 112/0 to
writable
[  136.034392] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34160/1
from inode pa df1843c0
[  136.044352] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 113, goal 34161, flags c20, 2^0, left: 112/34160, right 113/0 to
writable
[  136.044370] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34161/1
from inode pa df1843c0
[  136.054367] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 114, goal 34162, flags c20, 2^0, left: 113/34161, right 114/0 to
writable
[  136.054388] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34162/1
from inode pa df1843c0
[  136.064524] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 115, goal 34163, flags c20, 2^0, left: 114/34162, right 115/0 to
writable
[  136.064544] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34163/1
from inode pa df1843c0
[  136.074461] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 116, goal 34164, flags c20, 2^0, left: 115/34163, right 116/0 to
writable
[  136.074483] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34164/1
from inode pa df1843c0
[  136.094365] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 117, goal 34165, flags c20, 2^0, left: 116/34164, right 117/0 to
writable
[  136.094386] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34165/1
from inode pa df1843c0
[  136.104355] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 118, goal 34166, flags c20, 2^0, left: 117/34165, right 118/0 to
writable
[  136.104374] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34166/1
from inode pa df1843c0
[  136.114376] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 119, goal 34167, flags c20, 2^0, left: 118/34166, right 119/0 to
writable
[  136.114397] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34167/1
from inode pa df1843c0
[  136.124353] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 120, goal 34168, flags c20, 2^0, left: 119/34167, right 120/0 to
writable
[  136.124371] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34168/1
from inode pa df1843c0
[  136.134366] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 121, goal 34169, flags c20, 2^0, left: 120/34168, right 121/0 to
writable
[  136.134387] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34169/1
from inode pa df1843c0
[  136.144352] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 122, goal 34170, flags c20, 2^0, left: 121/34169, right 122/0 to
writable
[  136.144370] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34170/1
from inode pa df1843c0
[  136.154379] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 123, goal 34171, flags c20, 2^0, left: 122/34170, right 123/0 to
writable
[  136.154400] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34171/1
from inode pa df1843c0
[  136.164353] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 124, goal 34172, flags c20, 2^0, left: 123/34171, right 124/0 to
writable
[  136.164371] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34172/1
from inode pa df1843c0
[  136.174366] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 125, goal 34173, flags c20, 2^0, left: 124/34172, right 125/0 to
writable
[  136.174386] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34173/1
from inode pa df1843c0
[  136.184354] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 126, goal 34174, flags c20, 2^0, left: 125/34173, right 126/0 to
writable
[  136.184372] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34174/1
from inode pa df1843c0
[  136.194376] (fs/ext4/mballoc.c, 4174): ext4_mb_initialize_context: init ac:
1 blocks @ 127, goal 34175, flags c20, 2^0, left: 126/34174, right 127/0 to
writable
[  136.194396] (fs/ext4/mballoc.c, 3255): ext4_mb_use_inode_pa: use 34175/1
from inode pa df1843c0
[  136.204271] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 1499
[  141.067488] (fs/ext4/mballoc.c, 2755): ext4_free_data_callback: gonna free
128 blocks in group 1 (0xdf1bd050):
[  141.067508] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[  141.068763] (fs/ext4/mballoc.c, 2803): ext4_free_data_callback: freed 128
blocks in 1 structures
[  144.904259] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 2208
[  144.904466] (fs/ext4/mballoc.c, 3917): ext4_discard_preallocations: discard
preallocation for inode 1501
[  144.904502] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1
[  144.904545] (fs/ext4/mballoc.c, 1111): ext4_mb_load_buddy: load group 1

Regards, Markus

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
