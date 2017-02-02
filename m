From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: move halfmd4 into hash.c directly
Date: Thu, 2 Feb 2017 11:54:09 -0500
Message-ID: <20170202165409.nwzvgdev2veh36hj@thunk.org>
References: <20170110000701.19472-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170110000701.19472-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 10, 2017 at 01:07:01AM +0100, Jason A. Donenfeld wrote:
> The "half md4" transform should not be used by any new code. And
> fortunately, it's only used now by ext4. Since ext4 supports several
> hashing methods, at some point it might be desirable to move to
> something like SipHash. As an intermediate step, remove half md4 from
> cryptohash.h and lib, and make it just a local function in ext4's
> hash.c. There's precedent for doing this; the other function ext can use
> for its hashes -- TEA -- is also implemented in the same place. Also, by
> being a local function, this might allow gcc to perform some additional
> optimizations.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Cc: Theodore Ts'o <tytso@mit.edu>

Thanks, applied.

						- Ted
