From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: make fname_encrypt() actually return length of
 ciphertext
Date: Wed, 14 Sep 2016 14:57:04 -0700
Message-ID: <20160914215704.GA32159@google.com>
References: <1473886634-24627-1-git-send-email-ebiggers@google.com>
 <1473886634-24627-2-git-send-email-ebiggers@google.com>
 <F8E95FD1-D51F-44B5-95C1-253FE9156816@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu,
        jaegeuk@kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F8E95FD1-D51F-44B5-95C1-253FE9156816@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 14, 2016 at 03:37:01PM -0600, Andreas Dilger wrote:
> On Sep 14, 2016, at 2:57 PM, Eric Biggers <ebiggers@google.com> wrote:
> > 
> > This makes the return value match the comment.  Previously it would
> > actually return 0 if encryption was successful.  No callers currently
> > care, but this change should reduce the chance of future bugs.
> 
> This may be introducing a subtle bug in fscrypt_fname_usr_to_disk(), since
> that function returns the status from fname_encrypt() directly and now it
> returns the name length instead of 0 on success:
> 

fscrypt_fname_usr_to_disk() already returned a length in the "." and ".." cases.
So any caller which assumed it returned 0 on success would have already been
buggy.  Fortunately, there aren't any such callers currently.

> 
> This percolates further up to some of the callers, but in the cases that I
> saw the check is "if (err < 0)" and the positive value is either ignored
> or overwritten before being returned further up the call chain.  However,
> that could be easily missed in the future and somewhere up the call chain
> doing "if (rc)" would suddenly start to fail.
> 
> Since both "struct fscrypt_str" and "struct qstr" already hold the length
> I don't think there is any benefit to returning the length to the caller.
> Since (IMHO) this creates a non-trivial chance of introducing bugs in the
> future it makes more sense to just change the function comment to match the
> actual behaviour.
> 

I agree that the return value is redundant and somewhat error prone.  However,
this style is already being used for fscrypt_fname_disk_to_usr(),
fscrypt_fname_usr_to_disk(), and fname_decrypt().  My patch was primarily
intended to make things more consistent by updating fname_encrypt(), which was
the odd one out.  If you'd prefer, I can instead do a patch to make all these
related functions return 0 on success, rather than a length.  That would be a
somewhat larger patch.

Eric
