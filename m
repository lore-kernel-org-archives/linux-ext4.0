From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: ext4 kernel patches against linux-2.6.18-rc7-mm1
Date: Wed, 20 Sep 2006 10:56:39 -0500
Message-ID: <1158767799.9276.23.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40610 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751633AbWITP4q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Sep 2006 11:56:46 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8KFujQR025059
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 11:56:45 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8KFuhPk256202
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 11:56:45 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8KFugkV024369
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 11:56:42 -0400
Received: from [9.53.41.158] ([9.53.41.158])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k8KFugPR024256
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 11:56:42 -0400
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have ported the ext4 kernel patches to linux-2.6.18-rc7-mm1.  They
have been compile-tested, but I haven't done any run-time testing yet.

I expect that the rc7-mm1 ext3 that these patches are based off will be
close to 2.6.19-rc1, which is the target for merging ext4 into the
mainline tree.

The patches can be found here:
ftp://kernel.org/pub/linux/kernel/people/shaggy/ext4

Here's the series file:

# These patches were build against linux-2.6.18-rc7-mm1
#
# These first 3 patches create a clone of ext3 into ext4
ext4-copy.patch
ext4-rename.patch
ext4-enable.patch
#
# These next 4 copy clone jdb2 from jbd and modify ext4 to use it
jbd2-copy.patch
jbd2-rename.patch
jbd2-enable.patch
# ext4_jbd.h is no longer used
jbd2-cleanup.patch
#
# Shaggy made some minor changes to fix whitespace, sparse errors, etc.
# in many of the following patches
#
# From Alex Tomas
ext4-extents.patch
#
# From Mingming Cao
ext4_fsblk_sector_t.patch
#
# From Alex Tomas
ext4-extents-48bit.patch
#
# From Suparna Bhattacharya
ext4-unitialized-extent-handling.patch
#
# From Randy Dunlap
extents_comment_fix.patch
#
# From Zach Brown and Badari Pulavarty
64bit_jbd2_core.patch
#
# From Mingming Cao
sector_t-jbd2.patch
#
# From Badari Pulavarty
ext4_48bit_i_file_acl.patch
#
# From Laurent Vivier
64bit-metadata.patch
#
# From Avantika Mathur
64bitmetadata_inline_funcs_fix.patch
#
# From Mingming Cao
ext4_blk_type_from_sector_t_to_ulonglong.patch
ext4_remove_sector_t_bits_check.patch
jbd2_blks_type_from_sector_t_to_ull.patch
#
# From Alexandre Ratchov
ext4_remove_relative_block_numbers.patch
ext4_allow_larger_descriptor_size.patch
ext4_move_block_number_hi_bits.patch
-- 
David Kleikamp
IBM Linux Technology Center

