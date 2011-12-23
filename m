From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v5 00/15] ext4: add new online resize
Date: Fri, 23 Dec 2011 16:14:50 +0800
Message-ID: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47423 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1LWLw4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Dec 2011 06:52:56 -0500
Received: by iaeh11 with SMTP id h11so15005525iae.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Dec 2011 03:52:55 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the 5th version of patch series adding new online resize to ext4.

-- What's new resize implementation?
   It is a new online resize interface for ext4.  It can be used via
   ioctl with EXT4_IOC_RESIZE_FS and a 64 bit integer indicating size
   of the resized fs in block.

-- Difference between current resize and new resize.
   New resize lets kernel do all work, like allocating bitmaps and
   inode tables and can support flex_bg and BLOCK_UNINIT features.
   Besides these, new resize is much faster than current resize.

   Below are benchmarks I made on my personal computer, fses with
   flex_bg size = 16 were resized to 230GB evry time. The first
   row shows the size of a fs from which the fs was resized to 230GB.
   The datas were collected by 'time resize2fs'.

                      new resize
                20GB          50GB      100GB
      real    0m3.558s     0m2.891s    0m0.394s
      user    0m0.004s     0m0.000s    0m0.394s
      sys     0m0.048s     0m0.048s    0m0.028s

                      current resize
                20GB          50GB      100GB
      real    5m2.770s     4m43.757s  3m14.840s
      user    0m0.040s     0m0.032s   0m0.024s
      sys     0m0.464s     0m0.432s   0m0.324s

   According to data above, new resize is faster than current resize in both
   user and sys time.  New resize performs well in sys time, because it
   supports BLOCK_UNINIT and adds multi-groups each time.

-- About supporting new features.
   YES! New resize can support new feature like bigalloc and exclude bitmap
   easily.  Because it lets kernel do all work.

 V4->V5:
   release resizing lock in error case of IOC_RESIZEFS
   Thanks Djalal <tixxdz@opendz.org> for pointing it out and his patch for
   IOC_GROUP_EXTEND and IOC_GROUP_ADD.

 V3->V4:
   rename __ext4_group_extend to ext4_group_extend_no_check.

 V2->V3:
   initialize block bitmap of last group.
   remove code initalizing inode bitmap and inode tables.

Yongqiang.

