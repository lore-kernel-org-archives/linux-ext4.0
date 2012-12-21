From: Jan Kara <jack@suse.cz>
Subject: Uninitialized extent races
Date: Fri, 21 Dec 2012 02:25:26 +0100
Message-ID: <20121221012526.GD13474@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab2LUBZ3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 20:25:29 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  I was looking into handling of unwritten extents and I've noticed two
things:
1) Commit 60d4616f added ext4_flush_unwritten_io() call into
   ext4_fallocate() with a comment that it should avoid a race between
   AIO DIO and fallocate. But that really doesn't completely fix the issue
   because writeback can create unwritten extents as well and that is not
   synchronized with i_mutex unlike AIO DIO.

2) Commit dee1f973 actually changed ext4_convert_unwritten_extents_endio()
   to be able to deal with the situation when extent we want to convert
   isn't exactly the one in the extent tree (i.e., it was merged with
   another extent in the mean time). That was the situation 1) tried to
   prevent so it seems to make ext4_flush_unwritten_io() call from 1)
   unnecessary?

Am I missing something Dmitry? Also I was wondering about one thing: Does
anybody see a problem with disabling merging of uninitialized extents
completely? It would simplify the code (end_io conversion doesn't need to
potentially split extents) and the case when we really want to merge
extents - i.e., when someone calls fallocate() on small chunks - doesn't
seem like the case we need to optimize for? Also it would bound the amount of
transaction credits we need for conversion to 1 block which would make it
easier for me to change ext4 to clear PageWriteback only after extent
conversion is done (again code simplification, more uniform handling of
page writeback).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
