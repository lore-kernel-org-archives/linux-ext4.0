From: David Chinner <dgc@sgi.com>
Subject: Re: iov_iter_fault_in_readable fix
Date: Fri, 15 Jun 2007 08:21:09 +1000
Message-ID: <20070614222109.GF86004887@sgi.com>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613135759.GD13815@localhost.sw.ru> <20070614173153.GA14771@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, npiggin@suse.de,
	mark.fasheh@oracle.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37206 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465AbXFNWVd (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2007 18:21:33 -0400
Content-Disposition: inline
In-Reply-To: <20070614173153.GA14771@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 14, 2007 at 06:31:53PM +0100, Christoph Hellwig wrote:
> On Wed, Jun 13, 2007 at 05:57:59PM +0400, Dmitriy Monakhov wrote:
> >  	Function prerform check for signgle region, with out respect to
> >  	segment nature of iovec, For example writev no longer works :)
> 
> Btw, could someone please start to collect all sniplets like this in
> a nice simple regression test suite?  If no one wants to start a new
> one we should probably just put it into xfsqa (which should be useable
> for other filesystems aswell despite the name)

Yeah, it can run a subset of the tests on NFS and UDF filesystems as well and
there are some specific UDF-only tests in it too.  I think the NFS test group
is mostly generic tests that don't use or test specific XFS features.

I'd be happy to accumulate tests like these in xfsqa...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
