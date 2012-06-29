From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Use s_csum_seed instead of i_csum_seed for xattr block csum.
Date: Thu, 28 Jun 2012 20:27:06 -0600
Message-ID: <EFD4E943-92D1-4F51-8659-0340B11D3674@dilger.ca>
References: <1340547236-2838-1-git-send-email-tm@tao.ma> <20120626022300.GB14329@thunk.org> <20120628162726.GA2342@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:4034 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2F2C1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jun 2012 22:27:07 -0400
In-Reply-To: <20120628162726.GA2342@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-28, at 2:15 PM, Darrick J. Wong wrote:
> On Mon, Jun 25, 2012 at 10:23:00PM -0400, Theodore Ts'o wrote:
>> On Sun, Jun 24, 2012 at 10:13:56PM +0800, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>> 
>>> In xattr block operation, we use h_refcount to indicate whether the
>>> xattr block is shared among many inodes. And xattr block csum uses
>>> s_csum_seed if it is shared and i_csum_seed if it belongs to
>>> one inode. But this has a problem. So consider the block is shared
>>> first bewteen inode A and B, and B has some xattr update and CoW
>>> the xattr block. When it updates the *old* xattr block(because
>>> of the h_refcount change) and calls ext4_xattr_release_block, we
>>> has no idea that inode A is the real owner of the *old* xattr
>>> block and we can't use the i_csum_seed of inode A either in xattr
>>> block csum calculation. And I don't think we have an easy way to
>>> find inode A.
>>> 
>>> So this patch just removes the tricky i_csum_seed and we now uses
>>> s_csum_seed every time for the xattr block csum. The corresponding
>>> patch for the e2fsprogs will be sent in another patch.
>> 
>> This makes sense to me; it's an on-disk format change, but we haven't
>> released the e2fsprogs patches in anything other than the proposed
>> updates branch of the e2fsprogs repo, so it seems reasonable to make
>> this change as there's really no other way to fix this.
>> 
>> Darrick, any objections to this change?
> 
> Nope. iirc the only reason we had that weird code to start with was that
> someone suggested that we use the inode checksum in the "xattr block only has
> one owner" case, though I seem to have FUBAR'd it anyway.

That was my fault.  I was trying to avoid the case when some node gets
wrong xattr block, and there is no way to detect this.  Going from a
single owner (using ino as seed) to multiple owners (using block as seed)
is easy.  It's just the case of going from multiple owners to a single
one that is tricky.

We could take the easy way out, and fall back to the block-seed checksum
if the inode seed checksum fails.  In the most common cases (no shared
block checksum, or many inodes sharing a checksum) this works fine, and
in the uncommon case (formerly shared block only used by one inode) it
would need to compute the checksum twice.  This means there are only a
small number of xattr blocks for which two checksums work, instead of
all xattr blocks which can be incorrectly referenced by any inode since
if the inode is pointing at that block it will also compute the right
checksum using the block seed.

Note that I'm not dead set on this, but wanted to explain the reasoning
about how this decision got made.

Cheers, Andreas





