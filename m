From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH] JBD slab cleanups
Date: Mon, 17 Sep 2007 15:01:06 -0700
Message-ID: <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
References: <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
	 <1188605538.3837.51.camel@localhost.localdomain>
	 <20070901183922.GA12907@infradead.org>
	 <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
	 <20070902152801.GA19962@infradead.org>
	 <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
	 <20070903134043.GB28962@infradead.org>
	 <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
	 <20070903193308.GA7771@infradead.org>
	 <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:32897 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbXIQV6Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2007 17:58:16 -0400
In-Reply-To: <1190057391.3845.22.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-09-17 at 12:29 -0700, Mingming Cao wrote:
> On Fri, 2007-09-14 at 11:53 -0700, Mingming Cao wrote:
> > jbd/jbd2: Replace slab allocations with page cache allocations
> > 
> > From: Christoph Lameter <clameter@sgi.com>
> > 
> > JBD should not pass slab pages down to the block layer.
> > Use page allocator pages instead. This will also prepare
> > JBD for the large blocksize patchset.
> > 
> 
> Currently memory allocation for committed_data(and frozen_buffer) for
> bufferhead is done through jbd slab management, as Christoph Hellwig
> pointed out that this is broken as jbd should not pass slab pages down
> to IO layer. and suggested to use get_free_pages() directly.
> 
> The problem with this patch, as Andreas Dilger pointed today in ext4
> interlock call, for 1k,2k block size ext2/3/4, get_free_pages() waste
> 1/3-1/2 page space. 
> 
> What was the originally intention to set up slabs for committed_data(and
> frozen_buffer) in JBD? Why not using kmalloc?
> 
> Mingming

Looks good. Small suggestion is to get rid of all kmalloc() usages and
consistently use jbd_kmalloc() or jbd2_kmalloc().

Thanks,
Badari
