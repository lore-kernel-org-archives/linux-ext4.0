From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 086/104] ext4: fix initialization of UNINIT
	bitmap blocks
Date: Fri, 5 Dec 2008 10:36:13 -0800
Message-ID: <20081205183613.GB2144@kroah.com>
References: <20081203193901.715896543@mini.kroah.org> <20081203195618.GI8950@kroah.com> <20081204041016.GA13887@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:49013 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752198AbYLESip (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Dec 2008 13:38:45 -0500
Content-Disposition: inline
In-Reply-To: <20081204041016.GA13887@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 03, 2008 at 11:10:16PM -0500, Theodore Tso wrote:
> On Wed, Dec 03, 2008 at 11:56:18AM -0800, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> Turns out this patch introduces a worse regression than it fixes.  The
> bug that the patches fixes is that on-line resizes of filesystems with
> a 1k blocksize will usually fail.  The regression is that when a
> filesystem with 1k blocksize is stressed, the filesystem can get
> corrupted.  On balance, on-line resizing failing is less of a disaster
> than corrupting the filesystem when its stressed.  Fortunately, it's
> only an issue when the filesystem blocksize is less than the page
> size, which isn't the common case at least for the x86.  
> 
> There are patches queued up to address this, but they haven't hit
> mainline yet.  Probably best to pull this from the stable tree for
> now.

Thanks for letting me know, I've now dropped it from this release.

greg k-h
