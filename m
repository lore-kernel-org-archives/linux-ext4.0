From: Theodore Tso <tytso@mit.edu>
Subject: Re: i_size error with the latest patchqueue
Date: Thu, 31 Jul 2008 14:47:43 -0400
Message-ID: <20080731184743.GA20819@mit.edu>
References: <20080731161058.GA20838@skywalker> <20080731164728.GF11632@mit.edu> <20080731170856.GD20838@skywalker> <20080731182552.GJ11632@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59712 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201AbYGaSrp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 14:47:45 -0400
Content-Disposition: inline
In-Reply-To: <20080731182552.GJ11632@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I think what I need to do is to have scan_extent_node update two
variables; pb->last_block, and pb->last_block_used, where
pb->last_block_used doesn't get updated if the extent is not
initialized.

However, what we'll have to do is that if the two are different,
i_size must be at least pb->last_block_used*blocksize, but less than or
equal to pb->last_block*blocksize + (blocksize-1).

						- Ted
