From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: filefrag: improvements to filefrag FIEMAP handling
Date: Sat, 29 Dec 2012 22:56:18 -0500
Message-ID: <20121230035618.GA1238@thunk.org>
References: <1353632772-18664-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40922 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab2L3D4U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 22:56:20 -0500
Content-Disposition: inline
In-Reply-To: <1353632772-18664-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 22, 2012 at 03:06:12PM -0000, Andreas Dilger wrote:
> Update the filefrag program to allow displaying the extents in
> some different formats.  Try and stay within 80 columns.
> * add -k option to print extents in kB-sized units (like df -k)
> * add -b {blocksize} to print extents in blocksize units
> * add -e option to print extent format, even when FIBMAP is used
> * add -X option to print extents in hexadecimal format
> 
> Internally, the FIBMAP handling code has been moved into its own
> function like FIEMAP, so that the code is more modular.  Extent
> offsets are now handled in bytes instead of in blocks, to allow
> printing extents with arbitrary block sizes.  The extent header
> printing also moved into its own function so that it can be shared
> between the FIEMAP and FIBMAP handling routines, since it got more
> complex with the different output options.
> 
> Only print error about FIBMAP being root-only a single time.
> Print the filesystem type if it changes between specified files.
> Add fsync() for FIBMAP if "-s" is given.
> 
> Add support for filesystems that have multiple backing devices
> so that extents stored on different devices can be disinguished
> from each other.  This is enabled by default for Lustre, but
> can be selected for other filesystems if desired/supported with
> the "-l" option.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

In the future, it's really a lot easier to review these sorts of
patches if you break up the patch.  Note how I sent my resize2fs
flex_bg patches as an example.  Reviewing a huge megapatch is much
more difficult, and it makes patch conflicts more common and more
difficult to resolve.

I removed the DEVICE_ORDER support since I'm not entirely sure how
much we want support these Lustre-specific extensions, especially
since they require out-of-tree ABI extensions.  The bit fields in
question haven't been reserved in the kernel, and I've been having
trouble finding the formal definition of these ABI extensions.

In any case, it looks like Lustre's e2fsprogs patches have hugely
modified filefrag, and so by accepting the bulk of this patch, it
should make things easier for you to maintain the Lustre-speciific
patches until we can figure out how we want ot deal with this bit of
your changes.

						- Ted
