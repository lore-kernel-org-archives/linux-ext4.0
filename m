From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: partial revert to fix double brelse WARNING()
Date: Sat, 7 Nov 2009 03:11:16 -0500
Message-ID: <20091107081116.GG26342@mit.edu>
References: <1257579823-31295-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40264 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZKGILM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Nov 2009 03:11:12 -0500
Content-Disposition: inline
In-Reply-To: <1257579823-31295-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 07, 2009 at 02:43:42AM -0500, Theodore Ts'o wrote:
> This is a partial revert of commit 6487a9d (only the changes made to
> fs/ext4/namei.c), since it is causing the following brelse() of an
> already free buffer when running fsstress on a file system with 1k
> blocksize:

This description isn't quite right.  I did get this error while
running fsstress on a file system with a 1k blocksize, but the real
problem was that I was using a device that wasn't big enough for
fsstress, and it was really an ENOSPC error while extending a
directory from 1 block.  Curt's patch didn't take into account that
the call to ext4_append() in make_indexed_dir() could also return
ENOSPC, that would cause a double brelse().

I suppose I could have fixed it up by adding an explicit check for
ENOSPC and not freeing the buffer head in that one return path, which
would have made for a smaller patch, but the resulting code would be
really horrible.  So I still think the best thing to do for now is to
partially revert commit 6487a9d now, and fix things up cleanly after
2.6.32 is released.

						- Ted
