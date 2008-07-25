From: Jan Blunck <jblunck@suse.de>
Subject: kernel build time
Date: Fri, 25 Jul 2008 18:23:14 +0200
Message-ID: <20080725162314.GC4944@T61.linuxsymposium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:42626 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136AbYGYQXT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2008 12:23:19 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After Andreas talk yesterday I did some tests on my T61. This is not really a
perfect benchmark setup but Andreas said I should send the data anyway.

make clean (ext3)
real    0m3.073s
user    0m1.324s
sys     0m1.444s

make -j 4 (ext3)
real    6m37.377s
user    10m58.081s
sys     1m38.890s

make clean (ext4)
real    0m6.443s
user    0m1.712s
sys     0m1.824s

make -j 4 (ext4)
real    6m42.694s
user    10m59.593s
sys     1m36.994s

Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash test_filesystem 

That is with the patch queue from
http://www.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-ext4-1
on top of 2.6.26. Both ext3 and ext4dev are running on logical volumes (no
barrier support). I used the latest e2fsprogs available.

HTH,
Jan
