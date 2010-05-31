From: Christoph Hellwig <hch@lst.de>
Subject: ext2 issues with xfstests 113
Date: Mon, 31 May 2010 11:46:25 +0200
Message-ID: <20100531094625.GA10283@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:60419 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab0EaJq0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 05:46:26 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fsck from util-linux-ng 2.17
e2fsck 1.41.11 (14-Mar-2010)
Pass 1: Checking inodes, blocks, and sizes
Inode 22, i_blocks is 20512, should be 16512.  Fix? no

Inode 31, i_blocks is 20512, should be 16512.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(8090--8191) -(43829--44328) -(51784--52181)
Fix? no

