From: Theodore Tso <tytso@mit.edu>
Subject: Re: Porting Zfs features to ext2/3
Date: Sun, 27 Jul 2008 19:38:55 -0400
Message-ID: <20080727233855.GB9378@mit.edu>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: postrishi <postrishi@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56012 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751032AbYG0Xi4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 19:38:56 -0400
Content-Disposition: inline
In-Reply-To: <1217199281.6992.0.camel@telesto>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 27, 2008 at 04:54:41PM -0600, Eric Anopolsky wrote:
> On Sun, 2008-07-27 at 01:49 -0700, postrishi wrote:
> > Hello
> > 
> > I want to know that has any work been done to port the Zfs features to
> > ext2/3
> 
> Did you know that ZFS is available for Linux?

ZFS is available in a FUSE filesystem.  As a userspace filesystem, it
means a huge number of context switches to get data between the disk,
to the kernel, to the FUSE userspace, back to the kernel, and to the
process trying to access the ZFS file.  That's not going to be high
performance.  For someone who wants to migrate from Solaris to Linux,
it might be useful, but I'm not sure you would really want to use a
ZFS/FUSE implementation in production.

							- Ted
