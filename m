From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/3 v2] ext4: punching hole improvement
Date: Mon, 19 Nov 2012 20:55:15 +0800
Message-ID: <1353329718-2075-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48741 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2KSMms (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 07:42:48 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so3444029pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 04:42:47 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all, 

In this patch set, punching hole feature is improved.  The improvements are as
below.
 - add block-based file punching hole support
 - add tracepoint in punching hole

In patch 1, it introduces punching hole feature for block-based file.

In patch 2, we check FALLOC_FL_PUNCH_HOLE flag firstly in ext4_fallocate to
fully enable punching hole feature for extent-based file and block-based file.

In patch 3, a tracepoint is added in ext4_punch_hole.

Any comments or feedbacks are appreciated.  Thanks!

v2 <- v1:
 * Rework patch 1.  Now it looks very simple and straightforward.

BTW, after applying this patch set, xfstest #255 will not pass w/o extent
because block-based file doesn't support unwritten extents.

Regards,
						- Zheng
---
Zheng Liu(3)
      ext4: add indirect punching hole support
      ext4: let us fully support punching hole feature in fallocate
      ext4: add tracepoint for punching hole

 fs/ext4/ext4.h              |   1 +
 fs/ext4/extents.c           |  14 ++++-----
 fs/ext4/indirect.c          | 244 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c             |   8 ++---
 include/trace/events/ext4.h |  25 +++++++++++++++
 5 files changed, 281 insertions(+), 11 deletions(-)
