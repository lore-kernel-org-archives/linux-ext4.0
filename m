From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4 crypto: testing the wrong variable
Date: Sat, 11 Apr 2015 09:48:11 -0400
Message-ID: <20150411134811.GI6540@thunk.org>
References: <20150408085338.GA8837@mwanda>
 <alpine.DEB.2.10.1504081150401.9503@hadrien>
 <5525162C.3020808@bfs.de>
 <20150408122251.GJ10964@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: walter harms <wharms@bfs.de>, Julia Lawall <julia.lawall@lip6.fr>,
	Michael Halcrow <mhalcrow@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150408122251.GJ10964@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 08, 2015 at 03:22:51PM +0300, Dan Carpenter wrote:
> > why test *buf == NULL ? xfree() can handle this.
> > 
> > the question is do programm depend on *buf=NULL.
> > In case of IS_ERR(*buf) *buf will be left unchanged
> > and later prgramms may things there is a buffer
> > available ?
> 
> Good point.  That IS_ERR() check is going to cause all kinds of future
> bugs.

Yes, it's not needed at all, so I'll just remove it.  I'm also going
to be fixing the whole fname_crypto_alloc_buffer() and
fname_crypto_free_buffer() so the calling convention isn't as
horrendous.  So basically, instead of

int ext4_fname_crypto_alloc_buffer(struct ext4_fname_crypto_ctx *ctx,
				   unsigned char **obuf, u32 *olen, u32 ilen);
void ext4_fname_crypto_free_buffer(void **buf);

it will be:

int ext4_fname_crypto_alloc_buffer(struct ext4_fname_crypto_ctx *ctx,
				   struct ext4_str *crypto_str, u32 ilen);
void ext4_fname_crypto_free_buffer(struct ext4_str *crypto_str);

(And BTW, this isn't appropriate for kernel-janitors since this code
isn't upstream yet)

							- Ted
