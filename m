From: "Theodore Ts'o" <tytso@mit.edu>
Subject: How were some of the lustre e2fsprogs test cases generated?
Date: Mon, 18 Feb 2008 19:06:58 -0500
Message-ID: <E1JRG0g-0001lz-Ur@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46112 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbYBSAHB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 19:07:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've started testing my in-development extents against the test cases
found in clusterfs's e2fsprogs patches, and I noticed that with
f_extents (the first one I tried), some of the inodes had non-zero
ee_start_hi fields.  (That is to say, they had block numbers in the
extents fields that were much larger than 1 << 32.)   

The clusterfs e2fsprogs code doesn't notice this, because it apparently
ignores ee_start_hi field entirely.  But when I try running it with my
version that has (incomplete) 64-bit support, I get the following.

e2fsck 1.40.6 (09-Feb-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 12 is in extent format, but superblock is missing EXTENTS feature
Fix? yes

Inode 12 has an invalid extent
	(logical block 0, invalid physical block 21994527527949, len 17)
Clear? yes
...

In contrast, e2fsprogs-interim and the clusterfs patches interpret the
physical block as 5131, because they don't pretend to have any 48-bit
block number support at all.  This means the results of the test run are
quite different.  From the clusterfs f_extents/expect.1 file:

Pass 1B: Rescanning for multiply-claimed blocks
Multiply-claimed block(s) in inode 12: 5133 5124 5125 5129 5132 5133 5142 5143 5
144 5145

Anyway, no big deal, I'll just regenerate test cases as necessary, or
just use them as they with different expect logs.  But this just brings
up one question --- are we 100% sure that for all deployed versions of
the clusterfs extents code, that the kernel-side implementation was
always careful to clear the ee_start_hi and ee_leaf_hi fields?

						- Ted
