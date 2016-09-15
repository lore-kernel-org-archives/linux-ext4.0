From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: fscrypto: improved validation when loading inode encryption
 metadata
Date: Thu, 15 Sep 2016 13:26:03 -0700
Message-ID: <20160915202603.GC52239@jaegeuk>
References: <1473708240-39880-1-git-send-email-ebiggers@google.com>
 <20160915201656.grnmcq7f7blljx47@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754029AbcIOU0G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Sep 2016 16:26:06 -0400
Content-Disposition: inline
In-Reply-To: <20160915201656.grnmcq7f7blljx47@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2016 at 04:16:56PM -0400, Theodore Ts'o wrote:
> On Mon, Sep 12, 2016 at 12:24:00PM -0700, Eric Biggers wrote:
> > - Validate fscrypt_context.format and fscrypt_context.flags.  If
> >   unrecognized values are set, then the kernel may not know how to
> >   interpret the encrypted file, so it should fail the operation.
> > 
> > - Validate that AES_256_XTS is used for contents and that AES_256_CTS is
> >   used for filenames.  It was previously possible for the kernel to
> >   accept these reversed, though it would have taken manual editing of
> >   the block device.  This was not intended.
> > 
> > - Fail cleanly rather than BUG()-ing if a file has an unexpected type.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>

> Thanks, applied.  (I plan to carry Eric's fscrypto changes ext4 git
> tree; Jaeguk, I assume you have no objections?)

No objection.

Thanks,

> 
> 		   	       	       	   	- Ted
