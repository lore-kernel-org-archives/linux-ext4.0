From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Fri, 3 Oct 2008 09:43:09 +1000
Message-ID: <20081002234309.GH30001@disturbed>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com> <20081002181856.GB29613@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:52536 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbYJBXnP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2008 19:43:15 -0400
Content-Disposition: inline
In-Reply-To: <20081002181856.GB29613@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 02, 2008 at 11:48:56PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> > On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > For a 4.5GB streaming buffered write, this printk inside
> > ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> > 
> 
> Part of that can happen due to shrink_page_list -> pageout -> writepagee
> call back with lots of unallocated buffer_heads(blocks).

Quite frankly, a simple streaming buffered write should *never*
trigger writeback from the LRU in memory reclaim. That indicates
that some feedback loop has broken down and we are not cleaning
pages fast enough or perhaps in the correct order. Page reclaim in
this case should be reclaiming clean pages (those that have already
been written back), not writing back random dirty pages.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
