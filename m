From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] ext4 bugfixes
Date: Tue, 15 Jul 2008 00:37:18 -0400
Message-ID: <20080715043718.GA30017@infradead.org>
References: <E1KIbeO-0001yQ-N4@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYGOEhW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 00:37:22 -0400
Content-Disposition: inline
In-Reply-To: <E1KIbeO-0001yQ-N4@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 11:56:28PM -0400, Theodore Ts'o wrote:
> Alex Tomas (2):
>       vfs: add hooks for ext4's delayed allocation support

This is still missing kerneldoc comments for the newly exported
functions.

>       ext4: Add delayed allocation support in data=writeback mode

And for this one I haven't even heard back on my review comments.  None
of them is a merge blocker so it's not critical, but I find it quite odd
that the pull request is coming before even replying to the review
comments.

