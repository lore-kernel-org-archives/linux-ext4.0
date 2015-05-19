From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: allow to assign gfp_t for __crypto_alloc_tfm
Date: Tue, 19 May 2015 22:27:55 +0800
Message-ID: <20150519142755.GB32663@gondor.apana.org.au>
References: <1432014416-39326-1-git-send-email-jaegeuk@kernel.org>
 <20150519054945.GA28060@gondor.apana.org.au>
 <20150519062430.GA39588@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519063211.GA28347@gondor.apana.org.au>
 <20150519065812.GA40012@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519065929.GA28610@gondor.apana.org.au>
 <20150519071317.GB40012@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519071521.GA28862@gondor.apana.org.au>
 <20150519141430.GD20421@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>
To: Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ecryptfs@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519141430.GD20421@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 19, 2015 at 10:14:30AM -0400, Theodore Ts'o wrote:
> 
> There can be multiple reads going on in parallel, so we're currently
> creating tfm's as necessary.  In fact one of the things that we've

A single tfm is fully-reentrant (as long as you don't change the
key).  So multiple reads/writes on a single file can all use one
tfm with no locking at all.

There should be a single tfm per key.  As your code appears to use
one key per inode, that translates to one tfm per inode.

> talked about doing is since there are some ARM cores where their
> "hardware acceleration" is slower than optimized software (sigh), and
> there are some Android applications (such as Facebook) that read
> *vast* quantities of data from flash on startup before painting a
> single pixel, that we might want to consider in some cases,
> parallelizing the decryption across multiple ARM cores.  Figuring out
> when to do this, both in terms of the workload, how many cores to use
> to balance off against power utilization, how much (if ever) to use
> the hardware "accelerator", and just plain lack of time caused us not
> to go down that particular path.

We already have some support for such parallelisation in the form of
pcrypt.  It has been used on IPsec and I believe dmcrypt.

> We do have a tfm pointer hanging off the inode (currently only used
> for directories and file name encryption, where i_mutex is serializing
> us anyway), and in theory we could use that for the data path as well.
> We'd have to serialize access to it, which could be performance
> problem, and if the tfm is significantly larger than the raw key, we'd
> need to know when we should nuke the tfm.

As long as an inode only has one key, you don't need any
serialisation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
