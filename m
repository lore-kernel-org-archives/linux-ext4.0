From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypt: eliminate ->prepare_context() operation
Date: Thu, 16 Mar 2017 11:18:31 -0400
Message-ID: <20170316151831.l6hzeszqwzwqzsjl@thunk.org>
References: <20170222212514.61919-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170222212514.61919-1-ebiggers3@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 22, 2017 at 01:25:14PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The only use of the ->prepare_context() fscrypt operation was to allow
> ext4 to evict inline data from the inode before ->set_context().
> However, there is no reason why this cannot be done as simply the first
> step in ->set_context(), and in fact it makes more sense to do it that
> way because then the policy modes and flags get validated before any
> real work is done.  Therefore, merge ext4_prepare_context() into
> ext4_set_context(), and remove ->prepare_context().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
