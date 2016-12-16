From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Creating a mailing list, git tree, and patchwork project for
 fscrypt
Date: Fri, 16 Dec 2016 17:04:19 -0500
Message-ID: <20161216220419.znasf5wjkpb7qazr@thunk.org>
References: <20161216203732.g65wjf2wgc6rsijy@thunk.org>
 <20161216205330.GB14264@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org,
        ebiggers@google.com, mhalcrow@google.com, richard@nod.at,
        linux-ext4@vger.kernel.org, linux-f2fs@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161216205330.GB14264@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 16, 2016 at 12:53:30PM -0800, Eric Biggers wrote:
> Sounds great!
> 
> I guess it will be "fscrypt" and not "fscrypto"?  There has been some confusion
> about which term to use but it seems to be settling on "fscrypt".

It was originally fscrypt, but then fscrypto crept in when we
refactored the out to the fs/crypto directory from fs/ext4.  I was
planning on cleaning that up before we had too many file systems users
of fscrypt that we would need to synchronzie with, but it'll be easier
to do this as a separate git tree.  We can either do it at the very
beginning of the merge window (and have all of the file systems pull
the change into fs/crypt), or I can work with Linus to do it right
after the next next merge window closes.

My preferences would be for the former, given where we are in the
development cycle.

Any objections?

					- Ted
