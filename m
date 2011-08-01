From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/5] Break up "fall back to vmalloc() for large allocations"
Date: Mon,  1 Aug 2011 09:13:13 -0400
Message-ID: <1312204398-12460-1-git-send-email-tytso@mit.edu>
References: <A8CDAA23-61C6-4823-ADB1-7D36CBAFC025@whamcloud.com>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40451 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab1HANN0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 09:13:26 -0400
In-Reply-To: <A8CDAA23-61C6-4823-ADB1-7D36CBAFC025@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series breaks up Andreas and Yu Jian's patch "fall back to
vmalloc() for large allocations" into 5 patches, with the following
changes:

1) I created new helper functions, ext4_kvmalloc(), ext4_kzalloc, and
	ext4_kvfree() to simplify the code.

2) Fixed the patch so that online resize would work correctly if
	s_group_info and s_group_desc were allocated using vmalloc().
	(Yeah, there are other reasons why online resize won't work for
	such large allocations, but let's not add to the problems; also,
	there's always the possibility that kmalloc might fail for even
	for a small allocation.)

3) Fixed many more places in mballoc.c where ext4_msg() would be better
	than just printk().

I was waiting for Andreas and/or Yu Jian to resubmit, but since they
didn't, and I wanted these fixes, I decided to break up the patch
myself.

						- Ted

Theodore Ts'o (3):
  ext4: introduce ext4_kvmalloc(), ext4_kzalloc(), and ext4_kvfree()
  ext4: use ext4_kvzalloc()/ext4_kvmalloc() for s_group_desc and
    s_group_info
  ext4: use ext4_msg() instead of printk in mballoc

Yu Jian (2):
  ext4: use EXT4_BAD_INO for buddy cache to avoid colliding with valid
    inode #
  ext4: prevent memory leaks from ext4_mb_init_backend() on error path

 fs/ext4/ext4.h    |    3 ++
 fs/ext4/mballoc.c |  103 +++++++++++++++++++++++++++++------------------------
 fs/ext4/resize.c  |   13 ++++---
 fs/ext4/super.c   |   63 +++++++++++++++++++++-----------
 4 files changed, 107 insertions(+), 75 deletions(-)

-- 
1.7.4.1.22.gec8e1.dirty

