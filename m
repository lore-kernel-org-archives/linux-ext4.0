From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Sat, 26 Jul 2014 12:12:11 +0800
Message-ID: <53D32A9B.50903@fnarfbargle.com>
References: <53CBA75B.2030102@fnarfbargle.com> <53CC66DA.2080804@fnarfbargle.com> <20140725081312.GO6397@azat> <53D24307.6050903@fnarfbargle.com> <20140725140715.GR1865@thunk.org> <53D320F6.40809@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns3.fnarfbargle.com ([103.4.17.7]:47560 "EHLO
	ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaGZEiw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2014 00:38:52 -0400
In-Reply-To: <53D320F6.40809@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 26/07/14 11:31, Brad Campbell wrote:
> On 25/07/14 22:07, Theodore Ts'o wrote:
>> On Fri, Jul 25, 2014 at 07:44:07PM +0800, Brad Campbell wrote:
>>>
>>> Appreciate you taking a look at this and I see where you are going
>>> with it.
>>
>> This patch looks good to me.  If you could give it a try, I would
>> appreciate it.
>>
>> This looks like the same bug which was reported in Ubuntu:
>>
>> https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/1321958
>
>
> The patch would not apply automatically to 1.42.11 but was easy enough
> to apply by hand.
>
> root@srv:~/src/e2fsprogs/e2fsprogs-1.42.11/resize# ./resize2fs -d 255
> /dev/md0
> resize2fs 1.42.11 (09-Jul-2014)
> fs has 4007207 inodes, 1957 groups required.
> fs requires 4374122900 data blocks.
> With 1957 group(s), we have 63820826 blocks available.
> Added 131540 extra group(s), blks_needed 4374122900, data_blocks
> 4356990326, last_start 4356599580
> Added 523 extra group(s), blks_needed 4374122900, data_blocks
> 4374059350, last_start 4373440788
> Added 2 extra group(s), blks_needed 4374122900, data_blocks 4374124886,
> last_start 4373473426
> Last group's overhead is 1430
> Need 649474 data blocks in last group
> Final size of last group is 650904
> Estimated blocks needed: 4391437088
> Extents safety margin: 2826959
> Filesystem at /dev/md0 is mounted on /server; on-line resizing required
> old_desc_blocks = 2768, new_desc_blocks = 2795
> ./resize2fs: Invalid argument While checking for on-line resizing support
>
> [489412.650430] EXT4-fs (md0): resizing filesystem from 5804916736 to
> 5860149888 blocks
> [489412.700282] EXT4-fs warning (device md0): verify_reserved_gdb:713:
> reserved GDT 2769 missing grp 177147 (5804755665)
> [489412.739676] EXT4-fs (md0): resized filesystem to 5860149888
> [489413.215230] EXT4-fs warning (device md0): ext4_group_extend:1720:
> can't shrink FS - resize aborted

Rebooted, did an fsck -f (was clean) and ran it again without the fs 
mounted.

root@srv:~/src/e2fsprogs/e2fsprogs-1.42.11/resize# ./resize2fs -d 255 
/dev/md0
resize2fs 1.42.11 (09-Jul-2014)
fs has 4007359 inodes, 1957 groups required.
fs requires 4655464570 data blocks.
With 1957 group(s), we have 63820826 blocks available.
Added 140126 extra group(s), blks_needed 4655464570, data_blocks 
4637219414, last_start 4636829448
Added 557 extra group(s), blks_needed 4655464570, data_blocks 
4655398390, last_start 4654584520
Added 3 extra group(s), blks_needed 4655464570, data_blocks 4655496694, 
last_start 4654617158
Last group's overhead is 1820
Need 847412 data blocks in last group
Final size of last group is 849232
Estimated blocks needed: 4674027936
Extents safety margin: 2261777
Resizing the filesystem on /dev/md0 to 5860149888 (4k) blocks.
read_bitmaps: Memory used: 132k/763980k (49k/84k), time: 113.93/ 1.26/ 4.45
read_bitmaps: I/O read: 648MB, write: 0MB, rate: 5.69MB/s
fix_uninit_block_bitmaps 1: Memory used: 132k/763980k (49k/84k), time: 
7.61/ 7.91/ 0.00
adjust_superblock: Memory used: 132k/18014398507538268k (52k/81k), time: 
  0.49/ 0.57/ 0.00
fix_uninit_block_bitmaps 2: Memory used: 132k/18014398507538268k 
(52k/81k), time:  8.10/ 8.17/ 0.00
blocks_to_move: Memory used: 132k/18014398508253624k (52k/81k), time: 
0.74/ 0.50/ 0.05
Number of free blocks: 1126335202/7242495991050, Needed: 0
block_mover: Memory used: 132k/18014398508254140k (57k/76k), time: 
192.51/192.28/ 0.00
block_mover: I/O read: 1MB, write: 0MB, rate: 0.01MB/s
inode_scan_and_fix: Memory used: 132k/18014398508254140k (57k/76k), 
time:  0.00/ 0.00/ 0.00
inode_ref_fix: Memory used: 132k/18014398508254140k (57k/76k), time: 
0.00/ 0.00/ 0.00
move_itables: Memory used: 132k/18014398508254140k (57k/76k), time: 
0.01/ 0.00/ 0.00
calculate_summary_stats: Memory used: 132k/18014398508254140k (57k/76k), 
time: 168.74/168.43/ 0.01
fix_resize_inode: Memory used: 132k/18014398508254140k (61k/72k), time: 
  0.00/ 0.00/ 0.00
fix_resize_inode: I/O read: 0MB, write: 3MB, rate: 1843.88MB/s
fix_sb_journal_backup: Memory used: 132k/18014398508254140k (61k/72k), 
time:  0.00/ 0.00/ 0.00
overall resize2fs: Memory used: 132k/18014398508254140k (61k/72k), time: 
492.61/379.13/ 4.52
overall resize2fs: I/O read: 648MB, write: 13MB, rate: 1.34MB/s
The filesystem on /dev/md0 is now 5860149888 blocks long.

So it would appear to have succeeded when run offline.

