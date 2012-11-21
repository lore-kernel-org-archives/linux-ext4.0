From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/2 v5] ext4: Fix some fiemap problems
Date: Wed, 21 Nov 2012 23:03:39 +0100
Message-ID: <1353535421-25631-1-git-send-email-lczerner@redhat.com>
Cc: gnehzuil.liu@gmail.com, tytso@mit.edu, dmonakhov@openvz.org,
	bergwolf@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab2KVSjT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Nov 2012 13:39:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patchset fixes mainly two problems in fiemap in ext4. First of all we
could hit BUG_ON() if the extent tree is changed while we are traversing it.
This particular problem has been revealed by xfstest 225 on s390x
architecture.

The other problem is that we potentially might miss some delayed extents
with fiemap if they are written after we've searched the extent tree and
before we're going to search for delayed extent in extent status tree.

Both problems are fixed by the first patch of the patch set. The second
contains just some cleanups.

This has been based on top of the ext4 git tree containing extent status
tree. It has been tested with xfstests on s390x.

Please review carefully since fiemap bugs might cause problems with cp
possibly corrupting user data.

Thanks!
-Lukas

--- 
[PATCH 1/2 v5] ext4: Prevent race while walking extent tree
[PATCH 2/2 v5] ext4: simple cleanup in fiemap codepath

fs/ext4/ext4_extents.h |   14 ----
fs/ext4/extents.c      |  156 ++++++++++++++++++++++++++---------------------
2 files changed, 86 insertions(+), 84 deletions(-)

