From: Jan Kara <jack@suse.cz>
Subject: Re: ext2 issues with xfstests 113
Date: Mon, 31 May 2010 19:57:47 +0200
Message-ID: <20100531175747.GD5334@quack.suse.cz>
References: <20100531094625.GA10283@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab0EaR57 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 13:57:59 -0400
Content-Disposition: inline
In-Reply-To: <20100531094625.GA10283@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 31-05-10 11:46:25, Christoph Hellwig wrote:
> fsck from util-linux-ng 2.17
> e2fsck 1.41.11 (14-Mar-2010)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 22, i_blocks is 20512, should be 16512.  Fix? no
> 
> Inode 31, i_blocks is 20512, should be 16512.  Fix? no
> 
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -(8090--8191) -(43829--44328) -(51784--52181)
> Fix? no
  Are you able to reproduce this? Because for me ext2 runs went just
fine...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
