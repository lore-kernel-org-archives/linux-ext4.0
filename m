From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Commit 94968e74 breaks f_lotsbad
Date: Sun, 19 Jun 2011 21:58:01 -0400
Message-ID: <20110620015801.GB32133@thunk.org>
References: <418F4E42-50E6-4CAA-B6F5-CA59B17E84C0@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58739 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1FTB6C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jun 2011 21:58:02 -0400
Content-Disposition: inline
In-Reply-To: <418F4E42-50E6-4CAA-B6F5-CA59B17E84C0@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 17, 2011 at 12:28:01AM -0600, Andreas Dilger wrote:
> Ted,
> I was going to send some more fixes, but it looks like your commit
> 94968e74 "libext2fs: teach bitmap functions about bigalloc/cluster"
> breaks the "f_lotsbad" test, which I found via git bisect and verified
> is the offending commit:

The problem was a bug in lib/ext2fs/Makefile.in; the $(SRCS) macro
included "$(srcdir)/blkmap64_ba.o" (note ".o" instead of ".o"; Oops.)

As a result we didn't have a dependency for blkmap64_ba.c in the
Makefile, and so blkmap64_ba.o wasn't getting regenerated when
bmap64.h changed.  You can fix it by rm'ing blkmap64_ba.o and then
rebuilding.  I'll fixed the Makefile.in, rerun "make depend", and then
check in a fix.

Regards,

						- Ted
