From: Theodore Tso <tytso@mit.edu>
Subject: Re: Using libext2fs in libe2p?
Date: Tue, 3 Feb 2009 16:06:10 -0500
Message-ID: <20090203210610.GT14762@mit.edu>
References: <20090203195645.GG20654@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Nick Dokos <nicholas.dokos@hp.com>
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39453 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZBCVGP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Feb 2009 16:06:15 -0500
Content-Disposition: inline
In-Reply-To: <20090203195645.GG20654@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 03, 2009 at 02:56:45PM -0500, Valerie Aurora Henson wrote:
> Nick Dokos noticed that libe2p now depends on libext2fs in the 64-bit
> tree, since we use ext2fs_blocks_count() and friends (see diff below).

Fixed already in my rebased version of your patches:  

    http://github.com/tytso/e2fsprogs-64bit/tree/master
    git://github.com/tytso/e2fsprogs-64bit.git

> Possible solutions:
> 
> Link libext2fs with libe2p
> Open code 64-bit block counts
> Require users of libe2p to link with libext2fs
> Move ext2fs_blocks_count() and friends into a header file and inline them

I chose door #2.  Actually, I created new static functions in
lib/e2p/ls.c, named e2p_*_blocks_count().  It's in the patch:
Add-e2p-64bit-blocks-support.

Note: my patchset (which is against e2fsprogs 1.41.4 at the moment)
still has regression test failures, and I have done *zero* testing on
64-bit filesystems.  Hopefully Val can help me with that; the updated,
rebase patchset is the first step towards getting these commits merged
into e2fsprogs mainline.

						- Ted
