From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/9 v6] ext4: extent status tree (step2)
Date: Mon, 18 Feb 2013 00:27:45 +0800
Message-ID: <1361118474-18310-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Jan kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51218 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3BQQNY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 11:13:24 -0500
Received: by mail-pb0-f45.google.com with SMTP id ro8so1276862pbb.18
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2013 08:13:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here is the sixth version of extent status tree (step2).  In this
version a regression is fixed when bigalloc and delalloc are enabled,
which is triggered by xfstests #13.  The root cause is that when an
extent is delayed allocated and later is allocated by fallocate it
should be as a delayed extent until this extent is written out because
we need to use it to update reserved space.  That means that in extent
status tree an extent could be with unwritten and delayed status
simultaneously.

As Jan's suggestions, ext4_es_find_delayed_extent is refined.  Now it
has a input parameter 'lblk' and a output parameter 'es'.  Meanwhile
this function never return the first block of the next delayed extent
after 'es'.  In the mean time, in ext4_es_lookup_extent its parameter
also is splitted like above.

In fifth version, I try to convert unwritten extents from extent status
tree in end_io callback function and remove a bogus wait in direct io
codepath.  But there is a bug.  So in this version these patches are
dropped.  I will give it a try after this patch series is applied.

Further, after applied commit (ext4: grab page before starting
transaction handle in write_begin()), it seems that we could try to call
end_page_writeback() after unwritten io has done using extent status
tree.  Previously, I have tried to clear page's writeback flag after
unwritten extent is converted using extent status tree, but there is a
deadlock because in ext4 we always start a transaction handle before
grabbing a page.

This patch set can be applied against 3.8-rc7 and 'dev' branch of ext4
directly.

changelog:
v6 <- v5:
 - fix a regression that is reported by xfstests #13 with bigalloc
 - improve ext4_es_find_delayed_extent according to Jan's suggestions
 - improve ext4_es_lookup_extent according to Jan's suggestions
 - drop patches that convert unwritten extents in status tree and
   remove a bogus wait in ext4_ind_direct_IO()
 - add a comment to describe why es_lblk can be changed directly in
   __es_insert_extent()

v5: http://lwn.net/Articles/537371/
v4: http://lwn.net/Articles/536037/
v3: http://lwn.net/Articles/533730/
v2: http://lwn.net/Articles/532446/
v1: http://lwn.net/Articles/531065/

Any feedbacks are always welcome.

Thanks,
						- Zheng

Zheng Liu (9):
  ext4: refine extent status tree
  ext4: add physical block and status member into extent status tree
  ext4: ext4_es_find_extent improvement
  ext4: let ext4_ext_map_blocks return EXT4_MAP_UNWRITTEN flag
  ext4: track all extent status in extent status tree
  ext4: lookup block mapping in extent status tree
  ext4: remove single extent cache
  ext4: adjust some functions for reclaiming extents from extent status
    tree
  ext4: reclaim extents from extent status tree

 fs/ext4/ext4.h              |  24 +-
 fs/ext4/ext4_extents.h      |   6 -
 fs/ext4/extents.c           | 234 ++++++-----------
 fs/ext4/extents_status.c    | 625 ++++++++++++++++++++++++++++++++------------
 fs/ext4/extents_status.h    |  83 +++++-
 fs/ext4/file.c              |  14 +-
 fs/ext4/inode.c             | 153 ++++++++---
 fs/ext4/move_extent.c       |   3 -
 fs/ext4/super.c             |   8 +-
 include/trace/events/ext4.h | 189 +++++++++++---
 10 files changed, 914 insertions(+), 425 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

