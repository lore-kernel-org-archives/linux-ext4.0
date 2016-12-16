From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] fscrypt: Factor out bio specific functions
Date: Fri, 16 Dec 2016 14:14:28 -0800
Message-ID: <20161216221428.GC14264@gmail.com>
References: <20161216105006.10207-1-richard@nod.at>
 <72D4D0FB-F56D-4457-9660-4CFF7B4CFB6E@sigma-star.at>
 <48d4de8e-6e57-cbad-7556-03aa788c815a@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Gstir <david@sigma-star.at>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, jaegeuk@kernel.org, tytso@mit.edu,
        hch@infradead.org, arnd@arndb.de, dedekind1@gmail.com,
        linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-ext4@vger.kernel.org, ebiggers@google.com,
        rdunlap@infradead.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33178 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758564AbcLPWOj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Dec 2016 17:14:39 -0500
Content-Disposition: inline
In-Reply-To: <48d4de8e-6e57-cbad-7556-03aa788c815a@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 16, 2016 at 09:48:19PM +0100, Richard Weinberger wrote:
> On 16.12.2016 16:37, David Gstir wrote:
> >> @@ -349,33 +347,10 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
> >> 		err = do_page_crypto(inode, FS_ENCRYPT, lblk,
> >> 					ZERO_PAGE(0), ciphertext_page,
> >> 					PAGE_SIZE, 0, GFP_NOFS);
> >> +		err = fscrypt_bio_submit_page(inode, pblk, ciphertext_page);
> > 
> > Any specific reason why you didn't just move the whole fscrypt_zeroout_range() to bio.c?
> 
> The function depends other internal functions of crypto.c which I didn't want to
> export.
> At the end of the day it's a matter of taste. I found it less ugly to keep
> fscrypt_zeroout_range() in crypto.c than exposing internal stuff.
> 

Hmm, it still seems weird to define fscrypt_zeroout_range() when it can't
actually be used.  It looks like the problem is specifically the use of
alloc_bounce_page() and do_page_crypto().  Would it be that bad to make those
available in fscrypt_internal.h (not exported to filesystems)?

Also, it seems the actual problem is that fscrypt_zeroout_range() tries to be
clever and reuse one bounce page over and over.  But this seems very inefficient
because it has to wait for each block to be synchronously written out before
moving on to the next.  I'm thinking it really should be updated to work more
like the normal write path, and then it could use fscrypt_encrypt_page()...

Eric
