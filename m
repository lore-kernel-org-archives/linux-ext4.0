From: Ted Ts'o <tytso@mit.edu>
Subject: Re: smatch stuff: -next: null dereference in ext4_readdir()
Date: Sun, 2 Jan 2011 18:11:22 -0500
Message-ID: <20110102231122.GA11955@thunk.org>
References: <20110101134013.GI1886@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32937 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1ACCtx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Jan 2011 21:49:53 -0500
Content-Disposition: inline
In-Reply-To: <20110101134013.GI1886@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 01, 2011 at 04:40:13PM +0300, Dan Carpenter wrote:
> Hi Ted,
> 
> There is a NULL dereference introduced in linux-next "ext4: Use
> ext4_error_file() to print the pathname to the corrupted inode"

Thanks for catching this!  I'll fix up the bad patch in the ext4 patch
tree and regen the tree.

					- Ted
