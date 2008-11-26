From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Large EAs
Date: Tue, 25 Nov 2008 23:41:38 -0500
Message-ID: <20081126044138.GD1410@mit.edu>
References: <1226954173.3972.70.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, Andreas Dilger <adilger@Sun.COM>
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50426 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255AbYKZEll (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 23:41:41 -0500
Content-Disposition: inline
In-Reply-To: <1226954173.3972.70.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for not reviewing this patch earlier, but looking at the disk
format, I wonder if it's really necessary to allocate an inode for
each EA.  Given that we have a fixed inode table, if the user creates
a large number of 2k EA's (on a 4k filesystem) or 512 byte EA's (on a
1k) filesystem, this could easily burn a huge number of inodes,
causing users to run out.

We don't actually *need* to use an inode; what if we make use
e_value_block and e_hash to be a 64-bit block number, and use
e_value_offs (if 0) to indicate whether the 64-bit block number
contains data, or (if 1) contains the root of an extent tree.  This
adds a bit of complexity to the hash calculation if we want to support
sharing the EA block that contains pointers to Large EA's, but from
what I can tell the proposed patch doesn't support this anyway (and it
seems highly unlikely that multiple files with large EA's could be
able to be shared anyway).

The upsides of this patch (not needing to use inodes) seems to be
worth the downsides (slightly more complexity, and not being able to
share EA blocks).

What do folks think?

						- Ted
