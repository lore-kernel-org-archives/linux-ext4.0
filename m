From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 13:18:42 +0000
Message-ID: <20070305131842.GC1312@infradead.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200703032345.33137.arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 03, 2007 at 11:45:32PM +0100, Arnd Bergmann wrote:
> > I'd be more happy to have the write out zeroes loop in glibc. ?And
> > glibc needs to have it anyway, for older kernels.
> 
> A generic_fallocate makes sense to me iff we can do it in the kernel
> more significantly more efficiently than in glibc, e.g. by using only
> a single page in page cache instead of one for each page to be preallocated.

We can't do that with the current page cache interfaces.  But what
might make sense is to have a block_dump_prealloc that takes a get_block
callback to do what you propose.  It still wouldn't be entirely generic,
but would allow block based filesystems to do a not entirely dumb
implementation.
