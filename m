From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] ext4 crypto: testing the wrong variable
Date: Wed, 8 Apr 2015 15:22:51 +0300
Message-ID: <20150408122251.GJ10964@mwanda>
References: <20150408085338.GA8837@mwanda>
 <alpine.DEB.2.10.1504081150401.9503@hadrien>
 <5525162C.3020808@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Julia Lawall <julia.lawall@lip6.fr>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Michael Halcrow <mhalcrow@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: walter harms <wharms@bfs.de>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5525162C.3020808@bfs.de>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 08, 2015 at 01:51:08PM +0200, walter harms wrote:
> 
> 
> Am 08.04.2015 11:51, schrieb Julia Lawall:
> >>  void ext4_fname_crypto_free_buffer(void **buf)
> >>  {
> >> -	if (*buf == NULL || IS_ERR(buf))
> >> +	if (*buf == NULL || IS_ERR(*buf))
> > 
> > Why not use IS_ERR_OR_NULL?
> > 
> > julia
> 
> 
> why test *buf == NULL ? xfree() can handle this.
> 
> the question is do programm depend on *buf=NULL.
> In case of IS_ERR(*buf) *buf will be left unchanged
> and later prgramms may things there is a buffer
> available ?

Good point.  That IS_ERR() check is going to cause all kinds of future
bugs.

regards,
dan carpenter
