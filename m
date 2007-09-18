From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] JBD slab cleanups
Date: Tue, 18 Sep 2007 10:04:08 +0100
Message-ID: <20070918090407.GA671@infradead.org>
References: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com> <20070902152801.GA19962@infradead.org> <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com> <20070903134043.GB28962@infradead.org> <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com> <20070903193308.GA7771@infradead.org> <1189796027.3841.6.camel@localhost.localdomain> <1190057391.3845.22.camel@localhost.localdomain> <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com> <1190069851.6725.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1190069851.6725.6.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Sep 17, 2007 at 03:57:31PM -0700, Mingming Cao wrote:
> Here is the incremental small cleanup patch. 
> 
> Remove kamlloc usages in jbd/jbd2 and consistently use jbd_kmalloc/jbd2_malloc.

Shouldn't we kill jbd_kmalloc instead?

