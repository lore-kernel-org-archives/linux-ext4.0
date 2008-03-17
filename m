From: Theodore Ts'o <tytso@mit.edu>
Subject: Respin of the uninit_group patches
Date: Mon, 17 Mar 2008 09:28:36 -0400
Message-ID: <1205760527-14858-1-git-send-email-tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60373 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752451AbYCQN2v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 09:28:51 -0400
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1JbFPy-0004V5-Eg
	for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2008 09:30:22 -0400
Received: from tytso by closure.thunk.org with local (Exim 4.67)
	(envelope-from <tytso@mit.edu>)
	id 1JbFOR-0003sq-65
	for linux-ext4@vger.kernel.org; Mon, 17 Mar 2008 09:28:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've reworked this patch series to clean them up a bit.  In
particular, an unused ext2fs_scan_inode flag (EXT2_SF_DO_CSUM) was
removed, and I made ext2fs_group_desc_csum() static, and added
ext2fs_group_desc_csum_set().  In addition, ext2fs_group_desc_set()
and ext2fs_group_desc_verify() take an ext2_filsys argument instead of
a superblock and a pointer to a group descriptor, in order to simplify
the calling code.

If this looks good, this should be the next set of patches to move
into the 'next' branch.

							- Ted


