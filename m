From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 0/8] Filesystem io types statistic
Date: Mon, 28 Nov 2011 20:13:12 +0800
Message-ID: <1322482392-5346-1-git-send-email-wenqing.lz@taobao.com>
Cc: axboe@kernel.dk, swhiteho@redhat.com, adityakali@google.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50792 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1K1MLK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 07:11:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Since the last discussion[1], here is a third version of filesystem io type
accouting. This version only is implemented in ext4 because I don't add any
generic mechanism in buffer layer. Now, in ext4, we can know the number of 
different IO requests that are issued to the disk from io_stats file.

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


Steven,

I don't add the flag into the buffer layer as you said before. I think that
it is too tricky if we just OR the __REQ_* flags together. I wish Jens can give
some suggestions.

Any comments or suggestions are welcome.

[1]. http://www.spinics.net/lists/linux-ext4/msg28817.html

Regards,
Zheng
