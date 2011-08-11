From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: New resize interface implementation
Date: Thu, 11 Aug 2011 11:28:15 +0800
Message-ID: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48649 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1HKDf0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 23:35:26 -0400
Received: by pzk37 with SMTP id 37so2947235pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Aug 2011 20:35:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This patch series adds new resize implementation to ext4.

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

[PATCH 01/13] ext4: add a function which extends a group without
[PATCH 02/13] ext4: add a function which adds a new desc to a fs
[PATCH 03/13] ext4: add a function which sets up a new group desc
[PATCH 04/13] ext4: add a function which updates super block
[PATCH 05/13] ext4: add a structure which will be used by
[PATCH 06/13] ext4: add a function which sets up group blocks of a
[PATCH 07/13] ext4: add a function which adds several group
[PATCH 08/13] ext4: add a function which sets up a flex groups each
[PATCH 09/13] ext4: enable ext4_update_super() to handle a flex
[PATCH 10/13] ext4: pass verify_reserved_gdb() the number of group
[PATCH 11/13] ext4: add a new function which allocates bitmaps and
[PATCH 12/13] ext4: add a new function which adds a flex group to a
[PATCH 13/13] ext4: add new online resize interface

