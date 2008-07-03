From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
Date: Fri, 4 Jul 2008 08:11:33 +1000
Message-ID: <20080703221133.GA29319@disturbed>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080701105251.GC22522@agk.fab.redhat.com> <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp> <20080703124709.GI22522@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Takashi Sato <t-sato@yk.jp.nec.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, viro
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:3337 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbYGCWLj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2008 18:11:39 -0400
Content-Disposition: inline
In-Reply-To: <20080703124709.GI22522@agk.fab.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 03, 2008 at 01:47:10PM +0100, Alasdair G Kergon wrote:
> On Thu, Jul 03, 2008 at 09:11:05PM +0900, Takashi Sato wrote:
> > If the freezer accesses the frozen filesystem and causes a deadlock,
> > the above ideas can't solve it
> 
> But you could also say that if the 'freezer' process accesses the frozen
> filesystem and deadlocks then that's just a bug and that userspace code
> should be fixed and there's no need to introduce the complexity of a
> timeout parameter.

Seconded - that was also my primary objection to the timeout code.

> The point I'm trying to make here is:
>   Under what real-world circumstances might multiple concurrent freezing
>   attempts occur, and which of A, B or C (or other variations) would be
>   the most appropriate way of handling such situations?
> 
> A common example is people running xfs_freeze followed by an lvm command
> which also attempts to freeze the filesystem.

Yes, I've seen that reported a number of times.

> I can see a case for B or C, but personally I prefer A:
> 
> > > 1 succeeds, freezes
> > > 2 succeeds, remains frozen
> > > 3 succeeds, remains frozen
> > > 4 succeeds, thaws

Agreed, though I'd modify the definition of that case to be "remain
frozen until the last thaw occurs". That has the advantage that
it's relatively simple to implement with just a counter...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
