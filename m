From: tytso@mit.edu
Subject: Re: [PATCH V2] mke2fs: account for physical as well as logical
 sector size
Date: Tue, 9 Feb 2010 17:21:55 -0500
Message-ID: <20100209222155.GB739@thunk.org>
References: <4B7090B7.4060708@redhat.com>
 <4B70914B.3000102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab0BIWWH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Feb 2010 17:22:07 -0500
Content-Disposition: inline
In-Reply-To: <4B70914B.3000102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 08, 2010 at 04:33:47PM -0600, Eric Sandeen wrote:
> Some devices, notably 4k sector drives, may have a 512 logical
> sector size, mapped onto a 4k physical sector size.
> 
> When mke2fs is ratcheting down the blocksize for small filesystems,
> or when a blocksize is specified on the commandline, we should not
> willingly go below the physical sector size of the device.
> 
> When a blocksize is specified, we -must- not go below
> the logical sector size of the device.
> 
> Add a new library function, ext2fs_get_device_phys_sectsize()
> to get the physical sector size if possible, and adjust the
> logic in mke2fs to enforce the above rules.

Was this something you think is worth trying to slip into 1.41.10?

Just checking... my default is to defer this unless you think its
especially important.

						- Ted
