From: tytso@mit.edu
Subject: Re: [PATCH] resize2fs: fix uninit group test accessing invalid
 memory
Date: Fri, 5 Feb 2010 22:35:39 -0500
Message-ID: <20100206033539.GA321@thunk.org>
References: <4B5E0966.3040704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38716 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab0BFDfp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2010 22:35:45 -0500
Content-Disposition: inline
In-Reply-To: <4B5E0966.3040704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 25, 2010 at 03:13:10PM -0600, Eric Sandeen wrote:
> Commit 74128f8d7e93fe633aa87951319a4afd252a4494 added tests
> for uninit groups, but did it after the group counter
> increment in 2 loops, so we were testing past the end
> of the ->group_desc[] array:

This patch is not correct; the test for uninit and the calculation for
old_desc_blk needs to be for the next group, not the previous block.
I believe this patch is the correct one instead.

						- Ted

commit 40b09fbe01fac8722b699b29f796e18550d68c84
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Feb 5 22:25:03 2010 -0500

    resize2fs: Fix fix uninit group test accessing invalid memory
    
    Commit 74128f8 added tests for uninit groups, but it could access past
    the end of the group_desc[] array after processing the last group:
    
    ==19668== Invalid read of size 2
    ==19668==    at 0x40518C: resize_fs (resize2fs.c:1824)
    ==19668==    by 0x405A46: main (main.c:451)
    ==19668==  Address 0x5a0d002 is not stack'd, malloc'd or (recently) free'd
    ==19668==
    ==19668== Invalid read of size 2
    ==19668==    at 0x405391: resize_fs (resize2fs.c:1864)
    ==19668==    by 0x405A46: main (main.c:451)
    ==19668==  Address 0x5a0d002 is not stack'd, malloc'd or (recently) free'd
    ==19668==
    
    It was found by Eric Sandeen running the regression suite through
    valgrind.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 75c4721..346fd53 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1819,6 +1819,8 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 				group_free;
 			ext2fs_group_desc_csum_set(fs, group);
 			group++;
+			if (group >= fs->group_desc_count)
+				break;
 			count = 0;
 			group_free = 0;
 			uninit = (fs->group_desc[group].bg_flags &
@@ -1859,6 +1861,8 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 				group_free;
 			ext2fs_group_desc_csum_set(fs, group);
 			group++;
+			if (group >= fs->group_desc_count)
+				break;
 			count = 0;
 			group_free = 0;
 			uninit = (fs->group_desc[group].bg_flags &
