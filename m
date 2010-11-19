From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 09:54:24 -0500
Message-ID: <20101119145423.GA27919@infradead.org>
References: <1290102098.3041.77.camel@mulgrave.site>
 <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
 <4CE59E57.2090009@teksavvy.com>
 <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
 <4CE5C616.7070706@teksavvy.com>
 <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com>
 <20101119115516.GA1152@infradead.org>
 <4CE6831E.4020606@teksavvy.com>
 <20101119140639.GA25488@infradead.org>
 <4CE68E2C.9070101@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39413 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0KSOyq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:54:46 -0500
Content-Disposition: inline
In-Reply-To: <4CE68E2C.9070101@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 09:48:12AM -0500, Mark Lord wrote:
> I'm not sure about the issues on "adapting the block layer" ?
> For FITRIM, the blocks being trimmed would be reserved at the fs level,
> before issuing the discard for them.  So ordering through the block layer
> shouldn't matter much for it.  Does that simplify things?
> 
> I see FITRIM just allocating a page to hold the ranges (for the >1 case)
> and passing that page down through the layers to libata (or any other
> LLD that supports >1 ranges).

Ordering should not be an issue.  What were problems when I tried this
before is that we currently assume in the block layer that discard
bios have a valid bi_sector/bi_size, which is already needed e.g. for
the trivial remapping use for partitions and that they don't have
a payload.  You'd need to teach various places that discard payloads
may have a payload, which contains multiple ranges that have a
sector/len tuple that needs to be remapped and checked in various
places.

