From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4]ext4: Fix wrong comparisons in
	mext_check_arguments()
Date: Sat, 5 Sep 2009 22:10:32 -0400
Message-ID: <20090906021032.GA3055@mit.edu>
References: <4A9DE3DE.2010509@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51611 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbZIFCKd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 22:10:33 -0400
Content-Disposition: inline
In-Reply-To: <4A9DE3DE.2010509@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 12:17:50PM +0900, Akira Fujita wrote:
> ext4: Fix wrong comparisons in mext_check_arguments()
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> mext_check_arguments() in move_extents.c has wrong comparisons.
> orig_start which is passed from user-space is block unit,
> but i_size of inode is byte unit, therefore the checks do not work fine.
> This mis-check leads to the overflow of 'len' and then hits BUG_ON()
> in ext4_move_extens().   The patch fixes this issue.

Thanks, I've added this to the ext4 patch queue to be pushed when the
2.6.32 merge window opens.

						- Ted
