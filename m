From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: allow to assign gfp_t for __crypto_alloc_tfm
Date: Tue, 19 May 2015 13:49:45 +0800
Message-ID: <20150519054945.GA28060@gondor.apana.org.au>
References: <1432014416-39326-1-git-send-email-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ecryptfs@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <ecryptfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432014416-39326-1-git-send-email-jaegeuk@kernel.org>
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 18, 2015 at 10:46:56PM -0700, Jaegeuk Kim wrote:
> This patch adds a parameter, gfp_t, for __crypto_alloc_tfm.
> Now EXT4 and F2FS use the crypto engine to encrypt a page when writing it to the
> disk.
> That happens during ->writepage and it needs to allocate memory with
> GFP_NOFS.
> 
> Otherwise, in the f2fs case, kernel reports such the following warning.

Normally crypto structures should only be allocated on control
paths where sleeping or swapping is not an issue.  Why is ext4
doing crypto allocations on the data path?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
