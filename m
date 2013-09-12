From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Please help: Is ext4 counting trims as writes, or is something
 killing my SSD?
Date: Thu, 12 Sep 2013 11:28:45 -0400
Message-ID: <20130912152845.GG12918@thunk.org>
References: <20130912141856.GA17640@jak-x230>
 <1378997643.28638.53.camel@hp-a6734f>
 <20130912151955.GA19285@jak-x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Julian Andres Klode <jak@jak-linux.org>,
	Calvin Walton <calvin.walton@kepstin.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59030 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3ILP2t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 11:28:49 -0400
Content-Disposition: inline
In-Reply-To: <20130912151955.GA19285@jak-x230>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 is getting this information from the block layer.  Specifically,
it's calling

	part_stat_read(bd_part, sectors[WRITE])

to get the statistics information it uses to caluclate how many kb
have been written.

I'm not a block layer expert, but it may very well be the case that
TRIMS are being counted as requests.  Requests are categorized as
either READS or WRITES, and I don't see any special casing for non r/w
requests in block/blk-core.c.

Regards,

						- Ted
