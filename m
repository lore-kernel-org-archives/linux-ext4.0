From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr
 block csum.
Date: Fri, 29 Jun 2012 14:13:50 -0400
Message-ID: <20120629181349.GA16668@thunk.org>
References: <1340547236-2838-1-git-send-email-tm@tao.ma>
 <20120626022300.GB14329@thunk.org>
 <20120628162726.GA2342@tux1.beaverton.ibm.com>
 <EFD4E943-92D1-4F51-8659-0340B11D3674@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53532 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2F2SN5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jun 2012 14:13:57 -0400
Content-Disposition: inline
In-Reply-To: <EFD4E943-92D1-4F51-8659-0340B11D3674@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 28, 2012 at 08:27:06PM -0600, Andreas Dilger wrote:
> That was my fault.  I was trying to avoid the case when some node gets
> wrong xattr block, and there is no way to detect this.  Going from a
> single owner (using ino as seed) to multiple owners (using block as seed)
> is easy.  It's just the case of going from multiple owners to a single
> one that is tricky.
> 
> We could take the easy way out, and fall back to the block-seed checksum
> if the inode seed checksum fails.  In the most common cases (no shared
> block checksum, or many inodes sharing a checksum) this works fine, and
> in the uncommon case (formerly shared block only used by one inode) it
> would need to compute the checksum twice.  This means there are only a
> small number of xattr blocks for which two checksums work, instead of
> all xattr blocks which can be incorrectly referenced by any inode since
> if the inode is pointing at that block it will also compute the right
> checksum using the block seed.
> 
> Note that I'm not dead set on this, but wanted to explain the reasoning
> about how this decision got made.

I thought about proposing adding a flag to the xattr header to
indicate whether the superblock seed or the per-inode seed should be
used; I ultimately decided it wasn't worth the complexity that it
would add, so I didn't bring it up.

It seems to me that in the vast majority of the cases, the xattr will
fit in the inode, especially in the SElinux and ACL case.  So the
question is how often will we have really large xattrs.  It *should*
be rare, since if it is happening all the time for ACL's and SElinux
cases, performance will be disastrous.  If we do have lots of xattr
blocks, it would make sense to be worried about per-inode seeds, but
is it worth the extra complexity?

Eh.....  In the end it's kind of on the line as I see it.  I don't
feel strongly enough to engineer it myself, but if someone were to
send me the patch, I'd probably accept it.

Regards,

						- Ted
