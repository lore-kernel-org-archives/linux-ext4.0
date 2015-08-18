From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Please revert 08439fec266c3cc5702953b4f54bdf5649357de0
Date: Mon, 17 Aug 2015 20:54:37 -0400
Message-ID: <20150818005437.GA7535@thunk.org>
References: <20150817194502.GC16201@saruman.tx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, Nishanth Menon <nm@ti.com>
To: Felipe Balbi <balbi@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150817194502.GC16201@saruman.tx.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 17, 2015 at 02:45:03PM -0500, Felipe Balbi wrote:
> Hi Theodore,
> 
> as you already know, commit 08439fec266c (ext4: remove
> block_device_ejected) caused a regression for (at least) USB attached
> storage devices.
> 
> You provided a fix for the regression by reverting that commit in
> b9e43f49f672 (Revert "ext4: remove block_device_ejected"). This
> revert is, currently, on linux-next but broken commit is part of
> v4.1-final and, thus, part of v4.1 LTS.
> 
> Could you please mark your revert for v4.1+ stable ? If it's not too
> late to get it in v4.2-final, that would be great, otherwise we a Cc
> stable would suffice anyway.
> 
> In summary, commit 08439fec266c needs to be reverted on both v4.1-stable
> and v4.2.

Already done.  See the latest version of the dev branch.  I noticed
this morning that I needed to mark it for stable, and took care of it.

     	     	    	      	      - Ted
