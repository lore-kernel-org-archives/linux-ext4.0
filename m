From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: prevent parallel resizers and fix some error handling in resize
Date: Mon, 18 Jul 2011 10:52:23 +0800
Message-ID: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45447 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1GRC4n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 22:56:43 -0400
Received: by iwn6 with SMTP id 6so2719031iwn.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 19:56:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

  This patch series prevents parallel resizer and fixes some error handling in
resize code.  Besides these, some code is simplified so that the code can be
used easily in new resize implementation.

  The patches are tested by resize2fs and e2fsck -fn.

[PATCH 01/12] ext4: prevent parallel resizers by atomic bit ops
[PATCH 02/12] ext4: prevent a fs with errors from being resized
[PATCH 03/12] ext4: prevent a fs without journal from being resized
[PATCH 04/12] ext4: rename ext4_add_groupblocks() to
[PATCH 05/12] ext4: let ext4_group_add_blocks return an error code
[PATCH 06/12] ext4: let ext4_group_add_blocks() handle 0 blocks
[PATCH 07/12] ext4: fix a typo in ext4_group_extend()
[PATCH 08/12] ext4: let setup_new_group_blocks set multi-bits each
[PATCH 09/12] ext4: simplify journal handling in
[PATCH 10/12] ext4: remove lock_buffer in bclean() and
[PATCH 11/12] ext4: simplify parameters of add_new_gdb()
[PATCH 12/12] ext4: simplify parameters of reserve_backup_gdb()

