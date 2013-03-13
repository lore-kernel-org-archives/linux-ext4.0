From: Jan Kara <jack@suse.cz>
Subject: Unwritten extent zeroing beyond i_size
Date: Wed, 13 Mar 2013 10:56:40 +0100
Message-ID: <20130313095640.GC29730@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab3CMJ4o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 05:56:44 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Dmitry,

  I'm tracking down failure in xfstests test 274 (fallocate + ENOSPC
testing). The problem I found (and that's really unrelated to the question
I want to ask) is that if write beyond i_size fails, we truncate the file
to i_size to remove any blocks that may have been allocated under the page
by the write before it failed (think of blocksize < pagesize config).

Now in this test the write fails because it needs to split unwritten extent
and there's no space for that and zeroing out is impossible because we are
beyond i_size. And here comes my question: You disallowed zeroing of
extents beyond i_size because fsck complains about those. Won't it be
better to just add inode flag saying "this inode has blocks preallocated
beyond i_size" and make fsck not complain about such blocks? IMHO that
would catch 99% of corruptions as well and would let us solve the problem
with ENOSPC on writes to preallocated space (plus it would simplify the
kernel code).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
