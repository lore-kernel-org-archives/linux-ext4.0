From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] crypto: allow to assign gfp_t for __crypto_alloc_tfm
Date: Tue, 19 May 2015 10:14:30 -0400
Message-ID: <20150519141430.GD20421@thunk.org>
References: <1432014416-39326-1-git-send-email-jaegeuk@kernel.org>
 <20150519054945.GA28060@gondor.apana.org.au>
 <20150519062430.GA39588@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519063211.GA28347@gondor.apana.org.au>
 <20150519065812.GA40012@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519065929.GA28610@gondor.apana.org.au>
 <20150519071317.GB40012@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519071521.GA28862@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ecryptfs@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <ecryptfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519071521.GA28862@gondor.apana.org.au>
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 19, 2015 at 03:15:21PM +0800, Herbert Xu wrote:
> On Tue, May 19, 2015 at 12:13:17AM -0700, Jaegeuk Kim wrote:
> >
> > The key generation is done by ext4_generate_encryption_key in
> > fs/ext4/crypto_key.c.
> > And, ext4_file_mmap and ext4_file_open trigger it.
> 
> Well that's where you should be doing crypto_alloc_ablkcipher
> and crypto_ablkcipher_setkey.
> 
> The whole point of a crypto tfm is to represent a key so any time
> you get one you should create a crypto tfm.  Carrying around a raw
> key is just wrong.

There can be multiple reads going on in parallel, so we're currently
creating tfm's as necessary.  In fact one of the things that we've
talked about doing is since there are some ARM cores where their
"hardware acceleration" is slower than optimized software (sigh), and
there are some Android applications (such as Facebook) that read
*vast* quantities of data from flash on startup before painting a
single pixel, that we might want to consider in some cases,
parallelizing the decryption across multiple ARM cores.  Figuring out
when to do this, both in terms of the workload, how many cores to use
to balance off against power utilization, how much (if ever) to use
the hardware "accelerator", and just plain lack of time caused us not
to go down that particular path.

We do have a tfm pointer hanging off the inode (currently only used
for directories and file name encryption, where i_mutex is serializing
us anyway), and in theory we could use that for the data path as well.
We'd have to serialize access to it, which could be performance
problem, and if the tfm is significantly larger than the raw key, we'd
need to know when we should nuke the tfm.

After all, we don't want to have users waiting for their Facebook app
to launch.  :-)

					- Ted
