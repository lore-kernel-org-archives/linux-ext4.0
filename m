From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 2/2] ext4 crypto: add ioctls to allow backup of
 encryption metadata
Date: Wed, 9 Dec 2015 08:38:34 -0500
Message-ID: <20151209133834.GA8898@thunk.org>
References: <1449607865-21913-1-git-send-email-tytso@mit.edu>
 <1449607865-21913-2-git-send-email-tytso@mit.edu>
 <20151208213215.GA5469@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47833 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630AbbLINig (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2015 08:38:36 -0500
Content-Disposition: inline
In-Reply-To: <20151208213215.GA5469@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 08, 2015 at 01:32:15PM -0800, Michael Halcrow wrote:
> 
> Looks like something went wonky here.

Oops, fixed.

> > +/**
> > + * Structure used for communicating encrypted metadata with userspace
> > + */
> > +struct ext4_encrypted_metadata {
> > +	u32 len;
> > +	char metadata[288];
> 
> Did you choose 288 because of the max encrypted file name length?
> 
> While struct ext4_encryption_context is currently 28 bytes, it could
> conceivably get much larger with more advanced key management
> features.  E.g., supporting multiple users' keys per file.
> 
> Do you think it's worth anticipating this with a version number?  Or
> plan on something like adding another IOCTL if we end up needing more
> space?

For the ioctl's that do a GET, the caller is required to initialize
mdata.len to the size of the metadata array, and then the kernel
returns the actual size in mdata.len.  (I suppose that means I should
have used _IORW for the ioctl encoding for
EXT4_IOC_GET_ENCRYPTION_METADATA and EXT4_IOC_SET_ENCRYPTION_METADATA.
I'll fix that in the next spin of the patches.)

At the moment we just blindly copy the entire ext4_encrypted_metadata
structure in and out of userspace, mainly because it's much easier,
and because today there is no way for the ioctl's to return more than
256 bytes (I added 32 bytes worth of padding just in case some day we
want to support a crypto system that requires an explicit IV for
filename encryption, although at the moment we don't have a way to
encode this in the on-disk directory entry.)

But the way I constructed the interface, it *is* possible to support
larger metadata sizes for things like public keys, etc., should we
ever decide to go down that path.

Cheers,

						- Ted
