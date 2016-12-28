From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/5] fscrypt: use ENOKEY when file cannot be created
 w/o key
Date: Tue, 27 Dec 2016 21:28:14 -0500
Message-ID: <20161228022814.7xrkhfp4mr5f4mgo@thunk.org>
References: <1480965168-38747-1-git-send-email-ebiggers@google.com>
 <1480965168-38747-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480965168-38747-2-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 05, 2016 at 11:12:44AM -0800, Eric Biggers wrote:
> As part of an effort to clean up fscrypt-related error codes, make
> attempting to create a file in an encrypted directory that hasn't been
> "unlocked" fail with ENOKEY.  Previously, several error codes were used
> for this case, including ENOENT, EACCES, and EPERM, and they were not
> consistent between and within filesystems.  ENOKEY is a better choice
> because it expresses that the failure is due to lacking the encryption
> key.  It also matches the error code returned when trying to open an
> encrypted regular file without the key.
> 
> I am not aware of any users who might be relying on the previous
> inconsistent error codes, which were never documented anywhere.
> 
> This failure case will be exercised by an xfstest.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to the fscrypt branch, thanks.

						- Ted
