From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] e2fsprogs: Handle rec_len correctly for 64KB blocksize
Date: Mon, 12 Nov 2007 10:52:45 +0100
Message-ID: <20071112095245.GA1465@duck.suse.cz>
References: <20071106113142.GA23689@duck.suse.cz> <20071107160939.GF22214@duck.suse.cz> <20071111003703.GA14815@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52166 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756285AbXKLJwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Nov 2007 04:52:47 -0500
Content-Disposition: inline
In-Reply-To: <20071111003703.GA14815@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 10-11-07 19:37:03, Theodore Tso wrote:
> On Wed, Nov 07, 2007 at 05:09:39PM +0100, Jan Kara wrote:
> 
> > Subject: Support for 64KB blocksize in ext2-4 directories.
> > 
> > When block size is 64KB, we have to take care that rec_len does not overflow.
> > Kernel stores 0xffff in case 0x10000 should be stored - perform appropriate
> > conversion when reading from / writing to disk.
> 
> NACK.  You can't do the conversion in the reader/writer routines
> because the fundamentally rec_len is only a 16 bit field.  So when you
> read a directory block where the rec_len field is encoded as 0xFFFF,
> and you translate it to 0x10000, when you assign it to
> dirent->rec_len, the 0x10000 gets chopped off and rec_len gets a value
> of zero.  Did you test this patch before submitting it?
  Argh, stupid me. I've just tested that I didn't break anything for normal
block size and thought that I cannot make mistake in such a simple thing
;).

> The only way to do this is to find all of the places that reference
> rec_len, and do the check there.
  Yes.. Thanks for having look.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
