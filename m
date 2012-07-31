From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Serious bug?
Date: Tue, 31 Jul 2012 18:34:02 -0400
Message-ID: <20120731223402.GA3989@thunk.org>
References: <0408C81F72528E40A0D3235A1F67FFC804A61E@SN2PRD0202MB144.namprd02.prod.outlook.com>
 <20120731024236.GB5027@thunk.org>
 <0408C81F72528E40A0D3235A1F67FFC804A643@SN2PRD0202MB144.namprd02.prod.outlook.com>
 <20120731032536.GE5027@thunk.org>
 <0408C81F72528E40A0D3235A1F67FFC804A65F@SN2PRD0202MB144.namprd02.prod.outlook.com>
 <20120731213845.GA3945@thunk.org>
 <501850D4.8060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Nelson, John R" <John_Nelson@student.uml.edu>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42391 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab2GaWeJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 18:34:09 -0400
Content-Disposition: inline
In-Reply-To: <501850D4.8060101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 04:40:36PM -0500, Eric Sandeen wrote:
> > The problem is that fallocate allocated a large number of blocks, which
> > mke2fs then immediately discarded as its first order of business.
> 
> Hm, then why didn't mkfs.ext4 -K solve the problem....

I wasn't able to replicate it with mkfs.ext4 -K on a 3.2 kernel.

However, with a 3.2 kernel, if you have a pre-existing file1 created
via the fallocate, mke2fs, umount, e2fsck series of commands, the
fallocate command will BUG.  More interestingly, if you have an extent
tree created using a 3.2 kernel, and then mount it on using a 3.5+ext4
patches for 3.6 kernel, it still BUG's.

It dies on line 837 of extent.c:

	len = EXT_LAST_INDEX(curp->p_hdr) - ix + 1;   
	BUG_ON(len < 0);

Obviously, it shouldn't do that, and that is a bug which is upstream
in the latest 3.6-rc0 kernel.  But it only happens on a file system
that had tripped over the 3.2 kernel bug first.  At the very least,
the BUG_ON should be an ext4_error() --- but given that this is a file
system that was given clean bill of health by e2fsck, we should handle
it in a more graceful way.

Of course, it might be a good idea if e2fsck was taught how to clean
up non-standard extent trees that have empty extent tree leaf nodes,
but nevertheless, the kernel *should* be able to handle
non-standard/non-optimal extent tree blocks in a sane fashion.

						- Ted
