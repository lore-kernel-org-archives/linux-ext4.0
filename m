From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix use-after-iput when fscrypt contexts are
 inconsistent
Date: Wed, 1 Feb 2017 21:17:36 -0500
Message-ID: <20170202021736.fslzccfvp54dus6s@thunk.org>
References: <20170124233700.115669-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170124233700.115669-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 24, 2017 at 03:37:00PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In the case where the child's encryption context was inconsistent with
> its parent directory, we were using inode->i_sb and inode->i_ino after
> the inode had already been iput().  Fix this by doing the iput() in the
> correct places.
> 
> Note: only ext4 had this bug, not f2fs and ubifs.
> 
> Fixes: d9cdc9033181 ("ext4 crypto: enforce context consistency")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
