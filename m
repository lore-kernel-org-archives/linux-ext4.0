From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do not unnecessarily null-terminate encrypted
 symlink data
Date: Fri, 30 Sep 2016 01:45:28 -0400
Message-ID: <20160930054528.rc4a45gkeelhdyjp@thunk.org>
References: <1474576309-86917-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474576309-86917-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 22, 2016 at 01:31:47PM -0700, Eric Biggers wrote:
> Null-terminating the fscrypt_symlink_data on read is unnecessary because
> it is not string data --- it contains binary ciphertext.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
