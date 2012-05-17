From: Jan Kara <jack@suse.cz>
Subject: Lost fix for overflow in alloc_flex_gd()
Date: Thu, 17 May 2012 23:18:59 +0200
Message-ID: <20120517211859.GC23231@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, haogangchen@gmail.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab2EQVTW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 May 2012 17:19:22 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  I've noticed that fix https://lkml.org/lkml/2012/2/20/422 got lost in the
process. There were some concerns that the resize code might be too
optimistic in assuming it can allocate so much memory but anyway the patch
at least fixes the obvious problem until some gets to closer inspection of
the resize code...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
