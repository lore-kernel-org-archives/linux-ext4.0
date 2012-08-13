From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V5 00/23] ext4: Add inline data support.
Date: Mon, 13 Aug 2012 11:04:45 -0400
Message-ID: <20120813150445.GC13072@thunk.org>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44431 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab2HMPEr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 11:04:47 -0400
Content-Disposition: inline
In-Reply-To: <1341070917-4889-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I had an idea which I think would make inline directories more
efficient, although it wouldn't be a backwards compatible change with
the existing patch sets to date.

We don't actually need to store the entry for '.', since we know what
that should be, and we could just store the parent directory in a
4-byte entry.  By not storing the full directory entries for "." and
"..", we would save 20 bytes, which for a 256 byte inode where only
120 bytes or so are available for the inline directory, is pretty
significant.  (We can just synthesize them for the benefit of readdir
and lookup --- and I'm pretty sure the VFS is doing its own synthesis
for "." and possibly ".." already as far as lookup is concerned.)

What do you think?

					- Ted
