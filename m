From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: (unknown)
Date: Tue, 30 Aug 2011 16:10:10 +0800
Message-ID: <1314691825-12295-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51065 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1H3Ixl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 04:53:41 -0400
Received: by pzk37 with SMTP id 37so9952724pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 01:53:41 -0700 (PDT)
Subject: 
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

  v1->v2:
  Reimplement old resize on new common code.

  This patch series adds new resize implementation to ext4.

  -- What's new resize implementation?
     It is a new online resize interface for ext4.  It can be used via
     ioctl with EXT4_IOC_RESIZE_FS and a 64 bit integer indicating size
     of the resized fs in block.

  -- What's difference between current resize and new resize?
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

                        current resize
                  20GB          50GB      100GB
        real    5m2.770s     4m43.757s  3m14.840s
        user    0m0.040s     0m0.032s   0m0.024s
        sys     0m0.464s     0m0.432s   0m0.324s

     According to data above, new resize is faster than current resize in both
     user and sys time.  New resize performs well in sys time, because it
     supports BLOCK_UNINIT and adds multi-groups each time.

  -- Can new resize support new features like bigalloc and exclude bitmap easily?
     YES! New resize can support new feature like bigalloc and exclude bitmap
     easily.  Because it lets kernel do all work.

[PATCH v2 01/15] ext4: add a function which extends a group without
[PATCH v2 02/15] ext4: add a function which adds a new desc to a fs
[PATCH v2 03/15] ext4: add a function which sets up a new group desc
[PATCH v2 04/15] ext4: add a function which updates super block
[PATCH v2 05/15] ext4: add a structure which will be used by
[PATCH v2 06/15] ext4: add a function which sets up group blocks of
[PATCH v2 07/15] ext4: add a function which adds several group
[PATCH v2 08/15] ext4: add a function which sets up a flex groups
[PATCH v2 09/15] ext4: enable ext4_update_super() to handle a flex
[PATCH v2 10/15] ext4: pass verify_reserved_gdb() the number of
[PATCH v2 11/15] ext4: add a new function which allocates bitmaps
[PATCH v2 12/15] ext4: add a new function which adds a flex group to
[PATCH v2 13/15] ext4: add new online resize interface
[PATCH v2 14/15] ext4: let ext4_group_extend() use common code
[PATCH v2 15/15] ext4: let ext4_group_add() use common code
