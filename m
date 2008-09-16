From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Mon, 15 Sep 2008 23:49:43 -0700
Message-ID: <20080916064514.GH3241@webber.adilger.int>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org>
 <1221331767-16870-1-git-send-email-tytso@mit.edu>
 <20080914134711.GA21746@infradead.org> <20080914180132.GC13074@mit.edu>
 <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu>
 <20080915144754.GA16491@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, akpm@linuxfoundation.org,
	Mark Fasheh <mfasheh@suse.com>, mtk.manpages@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46458 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbYIPGtz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Sep 2008 02:49:55 -0400
In-reply-to: <20080915144754.GA16491@infradead.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 15, 2008  10:47 -0400, Christoph Hellwig wrote:
> Again, I'd love it when people would read my mails :(  Can we please
> first agree on what the flag is actually supposed to mean?  I made one
> guess in this mail, but I'm not sure if that's even what Andreas
> intended.  And of course the description for it is even more important
> than the name.

The intent of this flag was a "catch-all" to indicate it isn't safe
to try and read this block from disk, either because it is encrypted,
compressed, on a remote system (HSM or over a network), or maybe not
even written to disk yet (delalloc).

In some cases (e.g. dump on a snapshot, or boot with LILO) it IS ok to
read directly from a block device underneath the filesystem, but that
would completely fail for the above cases.

Note that the NO_BYPASS (formerly NO_DIRECT) flag is meant to be used
in conjunction with other flags that specify more clearly the reason
that this block is not directly accessible.  Having a "generic" flag
cover these different flag allows simple applications to know whether
the block is readable or not, without having to understand each flag
itself, and allows the flags to be expanded in the future (e.g. HSM or
whatever that doesn't get included right away).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

