From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4]ext4: Fix wrong comparisons in
	mext_check_arguments()
Date: Wed, 16 Sep 2009 14:37:39 -0400
Message-ID: <20090916183739.GG15451@mit.edu>
References: <4A9DE3DE.2010509@rs.jp.nec.com> <20090906021032.GA3055@mit.edu> <4AB06FE4.2010405@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45021 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbZIPShh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Sep 2009 14:37:37 -0400
Content-Disposition: inline
In-Reply-To: <4AB06FE4.2010405@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 16, 2009 at 01:56:04PM +0900, Akira Fujita wrote:
> Hi Ted,
> 
> We found that "fix-wrong-comparisons-in-mext_check_arguments"
> in the ext4 patch queue does not fix the objective issue completely.
> (The last partial block is not checked in mext_check_arguments().)
> 
> Could you replace "fix-wrong-comparisons-in-mext_check_arguments"
> in the ext4 patch queue with this patch ?

Done, thanks.

					- Ted
