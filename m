From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/6] ext4: try to fix up es regressions
Date: Fri,  1 Mar 2013 02:26:38 +0800
Message-ID: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44529 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3B1SLq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 13:11:46 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so1227782pbc.0
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 10:11:46 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Sorry for the late.  This patch series tries to fix up some regressions
after we try to use extent status tree as a cache, and give it some
improvements.

The first commit tries to fix a e4defrag regression which is reported by
Dmitry.  As Dmitry reported after applied this patch there still has a
failure in Dmitry's xfstests #300.

The second commit improves ext4_es_can_be_merged function to avoid a
potential overflow.

The third commit adds a self-testing infrastructure for extent status
tree to do a sanity check.  After as a extent cache we need to make sure
that extent status tree caches right things.  After applied this patch,
we will get a lot of messages when we run xfstests, e.g. #83, #91, ...
Please define ES_AGGRESSIVE_TEST to enable it.

The fourth commit lets ext4_ext_handle_uninitialized_extents return right
length of converted extent.  After applied this patch, some messages
that reports the return value is not equal to map->m_len disappears.

The fifth commit fixes a bug that will causes an initialized extent is
marked as uninitialized when we try to split an extent.  This patch is
very important for the later one because we will not eliminate all
error messages if this patch is missing.

The last commit updates extent status tree after we zeroout an extent.
Meanwhile we will not update it in ext4_map_blocks.  Otherwise we will
track an written extent as unwritten.  It might cause a potential bug.
After applied this patch, we will never get any messages from self-
testing infrastructure except that xfstest #223 when dioread_nolock
enables.  We don't need to worry about it because when we lookup a
block mapping from status tree i_data_sem hasn't been taken.  So there
is a race window that an unwritten extent is converted by end_io when
we compare the result between extent tree and status tree.  I have tried
to take i_data_sem locking and run #223 again, and the message doesn't
be printed.

After applied the patch series, I run xfstests with the following
configurations because it is easy to trigger a unwritten->written
conversion.

  * EXT4 4k Block
  * EXT4 4k Block with dioread_nolock
  * EXT4 4k Block with bigalloc

And I don't get any message from self-testing infrastructure except #223
as said before.  I will go on testing other configurations.  Hope I don't
screw up something.

The patch series also needs to do more tests, though.  I decide to send it
out now to let others review because we still have a pending regression.
I want to know whether this patch series can it or not.

Dmitry, I still couldn't reproduce the failure of #300 in my desktop.
I change another machine with a HDD to try to reproduce it, but I failed.
Could you please test this patch series to confirm this regression can
be fixed or not.  I really appreicate for your help.  If you have any
update please let me know.

This patch series is against the latest dev branch of ext4.  As always,
any feedback is appreicated.

Thanks!!!
						- Zheng

Dmitry Monakhov (3):
  ext4: invalidate exntent-status-tree during extent_migration
  ext4: add self-testing infrastructure to do a sanity check
  ext4: ext4_split_extent shoult take care about extent zeroout v3

Zheng Liu (3):
  ext4: improve ext4_es_can_be_merged() to avoid a potential overflow
  ext4: fix wrong m_len value after unwritten extent conversion
  ext4: update extent status tree after an extent is zeroed out

 fs/ext4/extents.c        |  53 ++++++++++++++++++++----
 fs/ext4/extents_status.c | 104 +++++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/extents_status.h |   9 ++++
 fs/ext4/inode.c          | 105 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/move_extent.c    |   8 ++++
 5 files changed, 266 insertions(+), 13 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

