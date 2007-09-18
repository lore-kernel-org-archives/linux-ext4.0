From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] JBD slab cleanups
Date: Tue, 18 Sep 2007 09:35:47 -0700
Message-ID: <1190133347.3819.6.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
	 <20070902152801.GA19962@infradead.org>
	 <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
	 <20070903134043.GB28962@infradead.org>
	 <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
	 <20070903193308.GA7771@infradead.org>
	 <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
	 <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	 <1190069851.6725.6.camel@localhost.localdomain>
	 <20070918090407.GA671@infradead.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070918090407.GA671@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-09-18 at 10:04 +0100, Christoph Hellwig wrote:
> On Mon, Sep 17, 2007 at 03:57:31PM -0700, Mingming Cao wrote:
> > Here is the incremental small cleanup patch. 
> > 
> > Remove kamlloc usages in jbd/jbd2 and consistently use jbd_kmalloc/jbd2_malloc.
> 
> Shouldn't we kill jbd_kmalloc instead?
> 

It seems useful to me to keep jbd_kmalloc/jbd_free. They are central
places to handle memory (de)allocation(<page size) via kmalloc/kfree, so
in the future if we need to change memory allocation in jbd(e.g. not
using kmalloc or using different flag), we don't need to touch every
place in the jbd code calling jbd_kmalloc.

Regards,
Mingming

