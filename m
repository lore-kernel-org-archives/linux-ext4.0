From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] JBD slab cleanups
Date: Wed, 19 Sep 2007 19:28:46 +0000
Message-ID: <1190230126.6504.5.camel@norville.austin.ibm.com>
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
	 <1190133347.3819.6.camel@localhost.localdomain>
	 <1190138690.6528.23.camel@norville.austin.ibm.com>
	 <1190163601.3819.15.camel@localhost.localdomain>
	 <20070918191920.a2130a3c.akpm@linux-foundation.org>
	 <1190229352.4318.12.camel@localhost.localdomain>
	 <1190229991.6504.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1190229991.6504.3.camel@norville.austin.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-09-19 at 14:26 -0500, Dave Kleikamp wrote:
> On Wed, 2007-09-19 at 12:15 -0700, Mingming Cao wrote:
> 
> > Here is the patch to clean up __GFP_NOFAIL flag in jbd/jbd2. In all
> > cases except one handles memory allocation failure so I get rid of those
> > GFP_NOFAIL flags.
> > 
> > Also, shouldn't we use GFP_KERNEL instead of GFP_NOFS flag for kmalloc
> > in jbd/jbd2? I will send a separate patch to cleanup that.
> 
> No.  GFP_NOFS avoids deadlock.  It prevents the allocation from making
> recursive calls back into the file system that could end up blocking on
> jbd code.

Oh, I see your patch now.  You mean use GFP_NOFS instead of
GFP_KERNEL.  :-)  OK then.

> Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

