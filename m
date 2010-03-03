From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 0/3] ext4: Bug fixes and cleanup for EXT4_IOC_MOVE_EXT ioctl
Date: Wed, 03 Mar 2010 15:49:21 +0900
Message-ID: <4B8E0671.4070601@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57050 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0CCGuK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Mar 2010 01:50:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

These patches are related to EXT4_IOC_MOVE_EXT ioctl.
Two of the beginning are bug fix, and the other is cleanup.

These are applied to 2.6.33-rc8 with the latest ext4 patch queue
(ee8a22d58776b8752a33973c9fe73e3b77cb0ee5).

Akira Fujita (3):
   ext4: Fix insertion point of extent in mext_insert_across_blocks()
   ext4: Fix the NULL reference in double_down_write_data_sem()
   ext4: Code cleanup for EXT4_IOC_MOVE_EXT ioctl

  fs/ext4/ioctl.c       |    3 ++-
  fs/ext4/move_extent.c |   24 +++++++++++++-----------
  2 files changed, 15 insertions(+), 12 deletions(-)

Regards,
Akira Fujita

