From: Theodore Tso <tytso@mit.edu>
Subject: Re: ask for help; hash-directory machanism of ext3 cannot work well
Date: Fri, 22 Jun 2007 02:20:00 -0400
Message-ID: <20070622062000.GA17097@thunk.org>
References: <20070621165749.GA5664@thunk.org> <467b2b7b.0f98600a.1bbc.ffff9c53@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: LIOU Payphone <lioupayphone@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38126 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXFVGUQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 02:20:16 -0400
Content-Disposition: inline
In-Reply-To: <467b2b7b.0f98600a.1bbc.ffff9c53@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 22, 2007 at 09:52:55AM +0800, LIOU Payphone wrote:
> 
> What makes me puzzled is there are two entries both  named  "3220" with ino
> "3350" were shown under "/mnt" when I "ls  -li  /mnt".

Hmm.  I still can't verify this.

Can you replicate the result?  If so, can you send me the output of
dumpe2fs?

> The version of kernel is 2.6.17-1.2142; and e2fsprogs-1.28. 

That looks like a vendor version of the kernel; what distribution are
you using?

E2fsprogs 1.28 is a frighteningly old version of e2fsprogs.  Did you
really mean 1.28?  Or 1.38?

> You know that we can set "s_def_hash_version" to be "DX_HASH_LEAGCY" in
> function  "main{}" of mke2fs.c 

Oh, so you were modifying your sources to set this variable?

> But I don't know why the latest version e2fsprogs-1.39 takes "DX_HASH_TEA"
> for default. Why "DX_HASH_LEAGCY" cannot be taken for default? Could you
> tell me the reason for it? Thanks.  :-)

Because DX_HASH_TEA is a better hash, and because it is keyed off of a
per-filesystem secret hash value stored in the superblock.

						- Ted
