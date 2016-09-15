From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fscrypto: improved validation when loading inode encryption
 metadata
Date: Thu, 15 Sep 2016 16:16:56 -0400
Message-ID: <20160915201656.grnmcq7f7blljx47@thunk.org>
References: <1473708240-39880-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473708240-39880-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 12, 2016 at 12:24:00PM -0700, Eric Biggers wrote:
> - Validate fscrypt_context.format and fscrypt_context.flags.  If
>   unrecognized values are set, then the kernel may not know how to
>   interpret the encrypted file, so it should fail the operation.
> 
> - Validate that AES_256_XTS is used for contents and that AES_256_CTS is
>   used for filenames.  It was previously possible for the kernel to
>   accept these reversed, though it would have taken manual editing of
>   the block device.  This was not intended.
> 
> - Fail cleanly rather than BUG()-ing if a file has an unexpected type.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.  (I plan to carry Eric's fscrypto changes ext4 git
tree; Jaeguk, I assume you have no objections?)

		   	       	       	   	- Ted
