From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fscrypto: rename completion callbacks to reflect usage
Date: Thu, 15 Sep 2016 16:56:03 -0400
Message-ID: <20160915205603.3ckpnm4d425kgs35@thunk.org>
References: <1473886634-24627-3-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473886634-24627-3-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 14, 2016 at 01:57:14PM -0700, Eric Biggers wrote:
> fscrypt_complete() was used only for data pages, not for all
> encryption/decryption.  Rename it to page_crypt_complete().
> 
> dir_crypt_complete() was used for filename encryption/decryption for
> both directory entries and symbolic links.  Rename it to
> fname_crypt_complete().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
