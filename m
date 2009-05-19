From: Jan Kara <jack@suse.cz>
Subject: Block estimates for delayed allocation in ext4 wrong?
Date: Tue, 19 May 2009 18:53:10 +0200
Message-ID: <20090519165310.GE28289@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZESQxK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2009 12:53:10 -0400
Received: from relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 4085374609
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 18:53:11 +0200 (CEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  I was looking into doing delayed allocation for ext3 in page_mkwrite()
and I've noticed that the way how ext4 estimates number of blocks it needs
to reserve during delayed allocation is probably wrong when inode uses
indirect blocks and not extents. The problem is with files with holes - for
example we write blocks 1024, 2048, 3072, 4096, we have to allocate
indirect block together with each data block we write. Therefore we need
at least 8 blocks reserved but ext4_indirect_calc_metadata_amount()
will reserve only 6 of them.
  We can only improve the estimate against the worst case (allocating all
indirect blocks) if we know some block before the one for which we estimate
needed amount is already allocated / has space reserved. But that's kind of
non-trivial to detect. Maybe what we could do is look into pagecache, find
the first page before the current one, check that it has mapped or delayed
buffer and subtract indirect blocks for buffers in this page from those we
need to reserve. But the locking is going to be nasty :( (we need page lock
to safely investigate buffers in that page).
  Maybe counting with the worst case is better after all. What do you think?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
