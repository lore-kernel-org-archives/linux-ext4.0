Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33066 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbeJCVmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 17:42:53 -0400
Date: Wed, 3 Oct 2018 10:54:06 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: fix EXT4_IOC_SWAP_BOOT
Message-ID: <20181003145406.GA2835@thunk.org>
References: <20181002233808.16118-1-tytso@mit.edu>
 <20181003125520.GA19655@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003125520.GA19655@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 03, 2018 at 05:55:20AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 02, 2018 at 07:38:08PM -0400, Theodore Ts'o wrote:
> > The code EXT4_IOC_SWAP_BOOT ioctl hasn't been updated in a while, and
> > it's a bit broken with respect to more modern ext4 kernels, especially
> > metadata checksums.
> 
> Do you have any reports of anyone but sysbot actually using it?
> Maybe it is a better idea to drop it unless it also gets coverage
> in xfstests?

Adding xfstests coverage is on my todo list.  I need to clean up an
ext4-ioc.c test program so it can be added to xfstests/src, but yes, I
noticed that the lack of test coverage is what led to the code
bitrot.

There was recent discussion that perhaps Grub should use this instead
of chasing file system format changes (which was the original
intention of this patch) so I had been examining the code path looking
for potential problems anyway.  So I'd rather not drop it for now.

This will allow us to future-proof ext4 in case we ever grow support
for reflink (which I understand from Darrick has been an issue for
XFS :-).

						- Ted
