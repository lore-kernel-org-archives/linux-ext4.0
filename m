From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] ext4 bug fixes
Date: Sat, 23 Aug 2008 19:44:39 -0400
Message-ID: <20080823234439.GA24760@infradead.org>
References: <E1KWXf5-0004gv-P7@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbYHWXpB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 19:45:01 -0400
Content-Disposition: inline
In-Reply-To: <E1KWXf5-0004gv-P7@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>       ext4: Initialize writeback_index to 0 when allocating a new inode

Since commit 7d455e0030eeab820773e7786605be4d9e56a04b this is already
done in common code, so this changeset doesn't have any effect.

