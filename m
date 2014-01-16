From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Dumpe2fs output with primary and backup superblock are different?
Date: Thu, 16 Jan 2014 11:35:34 -0500
Message-ID: <20140116163534.GA32391@thunk.org>
References: <CAEUQcegq-ZmgJ2Cr+jqr=1HiOK+NqnvBoxH0JQ3fTYXOd+Z83g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49087 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaAPQfi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jan 2014 11:35:38 -0500
Content-Disposition: inline
In-Reply-To: <CAEUQcegq-ZmgJ2Cr+jqr=1HiOK+NqnvBoxH0JQ3fTYXOd+Z83g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 16, 2014 at 04:14:14PM +0530, Subranshu Patel wrote:
> I am using dumpe2fs command using primary superblock (default) and
> backup superblock. In both the cases the output is different.

Yes, this is expected.  It's too expensive to be constantly updating
all of the backup block group descriptors every time we allocate or
deallocate a block or inode.  What is important to be kept in the
backup block group descriptors is where to find the inode table and
allocation bitmaps.  E2fsck can reconstruct the information which is
not updated in the backup block group descriptors and backup
superblock, and that's what you are seeing which is different.

Regards,

					- Ted
