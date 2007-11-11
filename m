From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Handle rec_len correctly for 64KB blocksize
Date: Sat, 10 Nov 2007 19:37:03 -0500
Message-ID: <20071111003703.GA14815@thunk.org>
References: <20071106113142.GA23689@duck.suse.cz> <20071107160939.GF22214@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47005 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbXKKAly (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Nov 2007 19:41:54 -0500
Content-Disposition: inline
In-Reply-To: <20071107160939.GF22214@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 07, 2007 at 05:09:39PM +0100, Jan Kara wrote:

> Subject: Support for 64KB blocksize in ext2-4 directories.
> 
> When block size is 64KB, we have to take care that rec_len does not overflow.
> Kernel stores 0xffff in case 0x10000 should be stored - perform appropriate
> conversion when reading from / writing to disk.

NACK.  You can't do the conversion in the reader/writer routines
because the fundamentally rec_len is only a 16 bit field.  So when you
read a directory block where the rec_len field is encoded as 0xFFFF,
and you translate it to 0x10000, when you assign it to
dirent->rec_len, the 0x10000 gets chopped off and rec_len gets a value
of zero.  Did you test this patch before submitting it?

The only way to do this is to find all of the places that reference
rec_len, and do the check there.

						- Ted
