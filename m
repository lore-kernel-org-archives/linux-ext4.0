From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: Don't use 'struct dentry' for internal lookups
Date: Sun, 21 Sep 2008 16:17:08 -0400
Message-ID: <20080921201708.GA29476@infradead.org>
References: <E1KhEil-0004s7-Ve@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	viro@zeniv.linux.org.uk
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYIUURK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Sep 2008 16:17:10 -0400
Content-Disposition: inline
In-Reply-To: <E1KhEil-0004s7-Ve@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 20, 2008 at 10:30:47PM -0400, Theodore Ts'o wrote:
> This is a port of a patch from Linus which fixes a 200+ byte stack
> usage problem in ext4_get_parent().
> 
> It's more efficient to pass down only the actual parts of the dentry
> that matter: the parent inode and the name, instead of allocating a
> struct dentry on the stack.

Al had a variant of this in the vfs queue for a while.

