From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/3 ver. 7] Ext3/Ext4 Batched discard support
Date: Tue, 10 Aug 2010 16:19:34 +0200
Message-ID: <1281449977-8533-1-git-send-email-lczerner@redhat.com>
Cc: dmonakhov@openvz.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab0HJOUS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Aug 2010 10:20:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

this is "hopefully" the final version of the patch set, since it looks like
everyone agree with this. Since the last version some simple fixes was done.

- As Jan noticed it should subtract the s_first_data_block before modulo when
computing the group starting block.
- As Dimitry proposed cond_reshed() is really useless in the ext4_trim_extent
and rescheduling should be done in the ext4_trim_all_free.

Also from previous version it supports "partial" fs discard see [PATCH 1/3].

The patch set consist of these three patches. Second and third patch are
independent on each other and dependent on the first patch.

[PATCH 1/3] Add ioctl FITRIM.
[PATCH 2/3] Add batched discard support for ext3
[PATCH 3/3] Add batched discard support for ext4

Regards
-Lukas

---
 fs/ext3/balloc.c        |  250 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext3/super.c         |    1 +
 fs/ext4/ext4.h          |    2 +
 fs/ext4/mballoc.c       |  200 +++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c         |    1 +
 fs/ioctl.c              |   34 +++++++
 include/linux/ext3_fs.h |    1 +
 include/linux/fs.h      |    2 +
 8 files changed, 491 insertions(+), 0 deletions(-)
