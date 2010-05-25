From: Greg KH <gregkh@suse.de>
Subject: Re: [04/24] ext4: Make sure all the block allocation paths reserve
 blocks
Date: Tue, 25 May 2010 09:45:26 -0700
Message-ID: <20100525164526.GA8999@suse.de>
References: <20100524223544.GA13721@kroah.com>
 <20100524223014.777274118@clark.site>
 <5humv51rdjr8vl3c7qlroekj2k004gl665@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	"Jayson R. King" <dev@jaysonking.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Grant Coady <gcoady.lk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab0EYQuc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 12:50:32 -0400
Content-Disposition: inline
In-Reply-To: <5humv51rdjr8vl3c7qlroekj2k004gl665@4ax.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 05:21:43PM +1000, Grant Coady wrote:
> On Mon, 24 May 2010 15:28:00 -0700, you wrote:
> 
> >2.6.27-stable review patch.  If anyone has any objections, please let us know.
> >
> >------------------
> >
> >
> >From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> >
> >commit a30d542a0035b886ffaafd0057ced0a2b28c3a4f upstream.
> >
> >With delayed allocation we need to make sure block are reserved before
> >we attempt to allocate them. Otherwise we get block allocation failure
> >(ENOSPC) during writepages which cannot be handled. This would mean
> >silent data loss (We do a printk stating data will be lost). This patch
> >updates the DIO and fallocate code path to do block reservation before
> >block allocation. This is needed to make sure parallel DIO and fallocate
> >request doesn't take block out of delayed reserve space.
> >
> >When free blocks count go below a threshold we switch to a slow patch
> 
> s/patch/path/ ??
> 
> Or, are these patch comments locked in stone for -stable?

Yes, I like to keep the changelog identical to what is in Linus's tree
as well.

thanks,

greg k-h
