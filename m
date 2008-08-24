From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 bug fixes
Date: Sat, 23 Aug 2008 21:05:54 -0400
Message-ID: <20080824010554.GE18169@mit.edu>
References: <E1KWXf5-0004gv-P7@closure.thunk.org> <20080823234439.GA24760@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38115 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751941AbYHXBGG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 21:06:06 -0400
Content-Disposition: inline
In-Reply-To: <20080823234439.GA24760@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 23, 2008 at 07:44:39PM -0400, Christoph Hellwig wrote:
> >       ext4: Initialize writeback_index to 0 when allocating a new inode
> 
> Since commit 7d455e0030eeab820773e7786605be4d9e56a04b this is already
> done in common code, so this changeset doesn't have any effect.
> 

Hmm, I thought Andrew said he this was better to do in each filesystem
rather than in the common code, so I thought he was NACK'ing that
patch.  Still, I see his sign-off, so I guess I must have misread the
thread.....

						- Ted

