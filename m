From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v4 0/8] ext4: io type accouting
Date: Tue, 24 Jan 2012 00:50:20 +0800
Message-ID: <1327337428-8266-1-git-send-email-wenqing.lz@taobao.com>
Cc: Jens Axboe <axboe@kernel.dk>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48297 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2AWQqe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jan 2012 11:46:34 -0500
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Aditya Kali <adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is the fourth version of ext4 io type accouting. It can be used to
understand the detailed IO in ext4. It is closed by default when a device is
mounted. We can turn on/off it manually in sysfs. There has three files in
/sys/fs/ext4/${DEVICE}/. io_stats shows the result of accounting,
io_stats_enable can turn on/off accouting and io_stats_reset resets the
counters.  We can use 'echo 1 >/sys/fs/ext4/${DEVICE}/io_stats_enable' to turn
on accouting. Then we can read the result from io_stats file. It can displays
ten types, which are super block, group descritptor, inode bitmap, block bitmap,
inode table, extent block, indirect block, dir index and entry, xattr, and
regular data block. So we can precisely understand how many IOs are issued by
ext4. It can help us to improve the performance of applications and filesystems.
Meanwhile, we can type 'echo 1 > /sys/fs/ext4/${DEVICE}/io_stats_reset' to
reset counters.

Any comments or suggestions are appreciated. Thanks!

Changes since v3:
* Add io_stats_enable to turn on/off accouting. Now it is closed by
  default. If we need to use it, we can type the following command:
	$ echo 1 >/sys/fs/ext4/${DEVICE}/io_stats_enable
* Rebase to 3.3.

Changes since v2:
* Define wrapper function for io type accouting in ext4:
  submit_bh(), bh_submit_read(), sb_bread(), sb_breadahead() and ll_rw_blocK() 
  are replaced by these wrapper functions. In these wrapper functions, 
  percpu_couters are added to account the number of different IO requests which
  are issued to the disk.
* Add per-device counter: 
  The percpu_counter is moved into ext4_sb_info structure in order to supprt
  per-device accouting.
* Add io_stats_reset to reset counter:
  io_stats_reset file is created in /sys/fs/ext4/$DEVICE/. We can use 
  'echo 1 > /sys/fs/ext4/$DEVICE/io_stats_reset' command to reset counter.
* Add version information into io_stats:
  'Version' field is printed in io_stats in order to userspace tool can parse
  the format according to the current version.

Changes since v1:
* Totoally redisgn the implementation:
  A 'Issue' flag is added in buffer_head structure to let filesystem can check
  it and do related things.

Regards,
Zheng
