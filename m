From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: ext4: prevent parallel resizers and fix some error handling in resize
Date: Tue, 19 Jul 2011 12:02:06 +0800
Message-ID: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, amir73il@gmail.com, tm@tao.ma
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49578 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1GSEGX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 00:06:23 -0400
Received: by iwn6 with SMTP id 6so3703318iwn.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 21:06:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch series prevents parallel resizers and fixes some error handling in
resize code.  Besides these, some code is simplified so that the code could be
used easily in new resize implementation.

In the new resize implementation, all work, like allocating group tables, are
done by kernel side, so it can support flex_bg feature and BLOCK_UNINIT, and
adds multi groups (a flex groups) each time, it thus is very fast.

Once the patch series are merged, the new resize implementation will be post
quickly.

I split the patches into 2 series to let the patches be reviewed easily.

v1->v2:
   -- add commit logs for the 8th and the 10th patches.
   -- fix error handling in the 4th patch.
   -- remove the patch which prevents a fs without journal fromn being resized.

The patch for no-journal mode is removed so that this patches can be merged quickly,
we can handle no-journal mode after new resize is merged.

[PATCH v2 01/11] ext4: prevent parallel resizers by atomic bit ops
[PATCH v2 02/11] ext4: prevent a fs with errors from being resized
[PATCH v2 03/11] ext4: rename ext4_add_groupblocks() to
[PATCH v2 04/11] ext4: let ext4_group_add_blocks() return an error
[PATCH v2 05/11] ext4: let ext4_group_add_blocks() handle 0 blocks
[PATCH v2 06/11] ext4: fix a typo in ext4_group_extend()
[PATCH v2 07/11] ext4: let setup_new_group_blocks() set multi-bits
[PATCH v2 08/11] ext4: simplify journal handling in
[PATCH v2 09/11] ext4: remove lock_buffer in bclean() and
[PATCH v2 10/11] ext4: simplify parameters of add_new_gdb()
[PATCH v2 11/11] ext4: simplify parameters of reserve_backup_gdb()
