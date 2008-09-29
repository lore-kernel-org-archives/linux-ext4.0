From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [e2fsprogs] Failing extents tests
Date: Mon, 29 Sep 2008 19:17:35 +0530
Message-ID: <1222696055.3971.42.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:42417 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYI2Nrk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2008 09:47:40 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m8TDlYDZ002901
	for <linux-ext4@vger.kernel.org>; Mon, 29 Sep 2008 13:47:36 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K7Y00J01M3ZZA00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 29 Sep 2008 21:47:34 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

The extents support in e2fsprogs-1.41.1 doesn't pass a few of the
regression tests that we had created. 4 tests out of 20 are failing, I
have included some details about the failures.

e2fsprogs-tests-f_extents_ee_len.patch: Corrupt ee_len is not detected. 
e2fsprogs-tests-f_extents_ei_block.patch: Corrupt ei_block is not
detected. In the Sun extents code, we passed the previous extent to
ext2fs_extent_verify(), so additional sanity checks could be performed.
Here is a snippet of that:

/* Verify that a single extent @ex is valid.  If @ex_prev is passed in,
 * then this was the previous logical extent in this block and we can
 * do additional sanity checking (though in case of error we don't know
 * which of the two extents is bad).  Similarly, if @ix is passed in
 * we can check that this extent is logically part of the index that
 * refers to it (though again we can't know which of the two is bad). */
errcode_t ext2fs_extent_verify(ext2_filsys fs, struct ext3_extent *ex,
                               struct ext3_extent *ex_prev,
                               struct ext3_extent_idx *ix, int ix_len)


Similarly we also passed previous ext3_extent_idx to
ext2fs_extent_index_verify().

Maybe we can do something similar by adding ex_prev and ix_prev to
ext2_extent_handle_t?

e2fsprogs-tests-f_extents_imbalanced_tree.patch,
e2fsprogs-tests-f_extents_eh_depth.patch: In both these cases, e2fsck
aborts with a "Corrupt extent header on inode %i" error. Instead of
aborting we can clear the extent header and set i_blocks to 0?

I have uploaded these tests at
http://downloads.lustre.org/public/tools/e2fsprogs/extent_tests/

One problem with these tests is that, the high 16 bits of extent/index
block are set, so these tests cannot be used as-is, but the image should
be helpful to check if the problem is solved or not.

Thanks,
Kalpak

