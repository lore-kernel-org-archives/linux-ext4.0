From: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] ext4: fix ext4_get_group_number() at cluster boundaries
Date: Thu, 11 Jul 2013 12:28:48 +0100
Message-ID: <1373542128-15662-1-git-send-email-apw@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:45340 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3GKL2x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jul 2013 07:28:53 -0400
Received: by mail-ea0-f171.google.com with SMTP id m14so5593512eaj.2
        for <linux-ext4@vger.kernel.org>; Thu, 11 Jul 2013 04:28:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit bd86298e60b8 introduced a new optimisation for callers who needed
only the ext4 group number and not the block offset within.  It hand
calculates the group number from the block in the common case, falling
back to the original group offset implementation otherwise.

Clearly the group number returned by this speed optimised block to group
mapping in ext4_get_group_number() must return the same group that
ext4_get_group_no_and_offset() otherwise we get group missmatches when
compared with callers needing the offset.  Currently where the first
block is non-zero we will return differing blocks near cluster boundaries.

This missmatch was uncovered by a multi-lvm test case which builds
systems with a large number of separate filesystems.  It was reliably
triggering the BUG below in ext4_mb_release_group_pa() when trying to
clean up preallocations:

    static noinline_for_stack int ext4_mb_release_group_pa(
	    struct ext4_buddy *e4b, struct ext4_prealloc_space *pa)
    {
	[...]
	    BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
	[...]
    }

This was occuring because the caller uses ext4_get_group_number() to obtain
the buddy information and when that was compared against the group number
locally calculated via ext4_get_group_no_and_offset() from the same block
number it was inconsistant tripping the above BUG.

I pulled these two routines out and fed them the filesystem parameters
for the filesystem triggering the OOPS and a range of block numbers.
Comparing the results I found the following inconsistancies at cluster
boundaries:

    1 != 0 at 8191
    1 != 0 at 8192
    2 != 1 at 16383
    2 != 1 at 16384
    3 != 2 at 24575
    3 != 2 at 24576

We are calculating incorrect block numbers within s_first_data_block blocks
of the boundary (1 block in my failing example).  Fix up the calculations
to match.

BugLink: http://bugs.launchpad.net/bugs/1195710
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/ext4/balloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

	While it seems clear this must be correct I would like some
	confirmation on my thinking.  I have done some touch testing
	and it seems to fix the OOPS in my test setup, but I am somewhat
	unsure why this does not commonly get triggered in all testing
	but only in the specific testing scenario.  Perhaps it is only
	trivially triggered with very small filesystems or similar.

	-apw

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index d0f13ea..e496f03 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -38,8 +38,8 @@ ext4_group_t ext4_get_group_number(struct super_block *sb,
 	ext4_group_t group;
 
 	if (test_opt2(sb, STD_GROUP_SIZE))
-		group = (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
-			 block) >>
+		group = (block - 
+			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) >>
 			(EXT4_BLOCK_SIZE_BITS(sb) + EXT4_CLUSTER_BITS(sb) + 3);
 	else
 		ext4_get_group_no_and_offset(sb, block, &group, NULL);
-- 
1.8.1.2

