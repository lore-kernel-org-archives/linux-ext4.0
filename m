From: Jan Kara <jack@suse.cz>
Subject: Strange behavior of ext2fs_allocate_group_table()
Date: Thu, 30 Jul 2015 10:50:37 +0200
Message-ID: <20150730085037.GA21939@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbbG3Iuk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jul 2015 04:50:40 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

when doing refactoring of the resize code (so that we can easily handle
setting of 64-bit feature and increasing number of reserved inodes from
tune2fs) I've noticed that ext2fs_allocate_group_table() has somewhat
strange behavior. It updates allocation statistics only if FLEX_BG feature
is enabled. Actually the resize code doesn't get the allocation statistics
wrong only because it recomputes everything when resizing it done. Why is
that? It would seem more logical to update the statistics either always or
never...

Independently of when the allocation statistics get updated, it would seem
as a saner interface to mark allocated structures both in the provided
bitmap and in fs->block_map and define that the provided bitmap is simply a
bitmap of blocks that can be used for allocation. That would simplify the
resize code which is the only one providing a special bitmap...

Even better, we could teach ext2fs_get_free_blocks() to use
->get_alloc_block callback for allocating blocks if available. That way
resize could implement it's checking of reserved map when allocating new
blocks and we would not have to clutter ext2fs_allocate_group_table() with
the extra bitmap. Admittedly that would mean extending ->get_alloc_block
prototype to take range acceptable for allocation as well. But that's not
that hard to do. 

It may be that I'm missing something and there's a good reason why things
are the way they are. So would the above changes (or some of them) look
sane to you?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
