From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4 patch queue updated(2.6.23-rc5)
Date: Wed, 12 Sep 2007 17:30:39 -0700
Message-ID: <1189643439.4935.30.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39040 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbXIMAak (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2007 20:30:40 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8D0W6gY002194
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:32:06 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8D0Ue6n508256
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:30:40 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8D0UdKh026730
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 20:30:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Rebased the patches to 2.6.23-rc5,  I reordered the series file to move
cleanups/fixes to the beginning of the series file. Added a patch to
cleanup slab useage in jbd/jbd2, and fixed some checkpatch.pl warnings.
Added large block patch and Jose's FLEX_BG patch.

Changes since 2.6.23-rc4

# cleanups:
+jbd_slab_cleanup.patch: removing slab from jbd/jbd2
+sparse-fix.patch: fixing sparse warning

ext4_uninit_blockgroup.patch: updated

# Added Large blocksize(up to 64k) support

+ext234_enlarge_blocksize.patch
+ext2_rec_len_overflow_with_64kblk_fix.patch
+ext3_rec_len_overflow_with_64kblk_fix.patch
+ext4_rec_len_overflow_with_64kblk_fix.patch
+JBD-blocks-reservation-fix-for-large-blk.patch

# generic-find-next-le-bit support for mballoc on big endian arch
#updated mballoc patch
+generic-find-next-le-bit
mballoc-core.patch

# Added FLEX_BG kernel patch
+flex_bg_kernel.patch


Mingming
