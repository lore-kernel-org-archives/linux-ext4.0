From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 4/5] fscrypt: remove user-triggerable warning messages
Date: Tue, 27 Dec 2016 22:14:52 -0500
Message-ID: <20161228031452.wtntenkejo43mbw2@thunk.org>
References: <1480965168-38747-1-git-send-email-ebiggers@google.com>
 <1480965168-38747-5-git-send-email-ebiggers@google.com>
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
In-Reply-To: <1480965168-38747-5-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 05, 2016 at 11:12:47AM -0800, Eric Biggers wrote:
> Several warning messages were not rate limited and were user-triggerable
> from FS_IOC_SET_ENCRYPTION_POLICY.  These shouldn't really have been
> there in the first place, but either way they aren't as useful now that
> the error codes have been improved.  So just remove them.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

					- Ted
