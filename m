From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 11:01:53 -0500
Message-ID: <20070305160153.GI26781@thunk.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <8A8B28AA-3481-4CFF-AEAA-0CB4CCDFF9F9@cam.ac.uk> <20070305143703.GF26781@thunk.org> <45EC3415.6000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Ulrich Drepper <drepper@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51012 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933589AbXCEQCz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2007 11:02:55 -0500
Content-Disposition: inline
In-Reply-To: <45EC3415.6000307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 05, 2007 at 07:15:33AM -0800, Ulrich Drepper wrote:
> Well, I'm sure the kernel can do better than the code we have in libc
> now.  The kernel has access to the bitmasks which say which blocks have
> already been allocated.  The libc code does not and we have to be very
> simple-minded and simply touch every block.  And this means reading it
> and then writing it back.  The kernel would know when the reading part
> is not necessary.  Add to then the block granularity (we use f_bsize as
> returned from fstatfs but that's not the best value in some cases) and
> you have compelling data to have generic code in the kernel.  Then libc
> implementation can then go away completely which is a good thing.

You have a very good point; indeed since we don't export an interface
which allows userspace to determine whether or not a block is in use,
that does mean a huge amount of churn in the page cache.  So maybe it
would be worth doing in the kernel as a result, although the libc
implementation still wouldn't be able to go away for long time due to
the need to be backwards compatible with older kernels that didn't
have this support.

Regards,

						- Ted
