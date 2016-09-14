From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: make fname_encrypt() actually return length of
 ciphertext
Date: Wed, 14 Sep 2016 16:00:35 -0700
Message-ID: <20160914230035.GB32159@google.com>
References: <1473886634-24627-1-git-send-email-ebiggers@google.com>
 <1473886634-24627-2-git-send-email-ebiggers@google.com>
 <F8E95FD1-D51F-44B5-95C1-253FE9156816@dilger.ca>
 <20160914215704.GA32159@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu,
        jaegeuk@kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160914215704.GA32159@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 14, 2016 at 02:57:04PM -0700, Eric Biggers wrote:
> I agree that the return value is redundant and somewhat error prone.  However,
> this style is already being used for fscrypt_fname_disk_to_usr(),
> fscrypt_fname_usr_to_disk(), and fname_decrypt().  My patch was primarily
> intended to make things more consistent by updating fname_encrypt(), which was
> the odd one out.  If you'd prefer, I can instead do a patch to make all these
> related functions return 0 on success, rather than a length.  That would be a
> somewhat larger patch.
> 

To see more concretely what it looks like, I went ahead and wrote the "make the
functions return 0" version of the patch.  I'm sending it to be considered as
well.

In theory I think it's better, though it's a larger patch.
