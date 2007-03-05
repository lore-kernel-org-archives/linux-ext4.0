From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Mon, 5 Mar 2007 15:35:35 +0000
Message-ID: <20070305153535.GA23524@infradead.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk> <45EB4A55.3060908@redhat.com> <8A8B28AA-3481-4CFF-AEAA-0CB4CCDFF9F9@cam.ac.uk> <20070305143703.GF26781@thunk.org> <45EC3415.6000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com
To: Ulrich Drepper <drepper@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52938 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbXCEPgL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2007 10:36:11 -0500
Content-Disposition: inline
In-Reply-To: <45EC3415.6000307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 05, 2007 at 07:15:33AM -0800, Ulrich Drepper wrote:
> Theodore Tso wrote:
> > Given that glibc already has to support this for older kernels, I
> > would argue that there's no point putting in generic support for
> > filesystem that can't support a more advanced way of doing things.
> 
> Well, I'm sure the kernel can do better than the code we have in libc
> now.  The kernel has access to the bitmasks which say which blocks have
> already been allocated.

The layer of the kernel where a totally generic fallback would be
implemented does not have access to this information.  We could do
a mostly generic helper for block filesystems that allows to implement
fallocate this way without a lot of their own code.
