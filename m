From: Greg KH <gregkh@suse.de>
Subject: Re: [10/24] vfs: Add no_nrwrite_index_update writeback control flag
Date: Tue, 25 May 2010 09:58:26 -0700
Message-ID: <20100525165825.GB9154@suse.de>
References: <20100524223544.GA13721@kroah.com>
 <20100524223016.208581966@clark.site>
 <20100525111208.GA8779@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	"Jayson R. King" <dev@jaysonking.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37525 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab0EYRDX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 13:03:23 -0400
Content-Disposition: inline
In-Reply-To: <20100525111208.GA8779@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 07:12:08AM -0400, Christoph Hellwig wrote:
> On Mon, May 24, 2010 at 03:28:06PM -0700, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> NACK.  This has been shown to cause severe writeback regression for
> other filesystems and is beeing reverted in mianline.

Ok, I've dropped this one, and the two ext4 patches after this one as
well.  If someone wants them back, please feel free to redo them so that
they apply to the .27 tree now.

thanks,

greg k-h
