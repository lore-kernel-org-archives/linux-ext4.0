From: Hugh Dickins <hughd@google.com>
Subject: Re: Best way to pin a page in ext4?
Date: Wed, 17 Sep 2014 13:37:40 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1409171328002.7181@eggly.anvils>
References: <20140915185102.0944158037A@closure.thunk.org> <36321733-F488-49E3-8733-C6758F83DFA1@dilger.ca> <20140916180759.GI6205@thunk.org> <alpine.LSU.2.11.1409161555120.5144@eggly.anvils> <alpine.DEB.2.11.1409162230160.12769@gentwo.org>
 <20140917135719.GK2840@worktop.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Lameter <cl@linux.com>, Hugh Dickins <hughd@google.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-mm <linux-mm@kvack.org>, linux-ext4@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45892 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbaIQUjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2014 16:39:24 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq14so2838329pab.25
        for <linux-ext4@vger.kernel.org>; Wed, 17 Sep 2014 13:39:23 -0700 (PDT)
In-Reply-To: <20140917135719.GK2840@worktop.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 17 Sep 2014, Peter Zijlstra wrote:
> On Tue, Sep 16, 2014 at 10:31:24PM -0500, Christoph Lameter wrote:
> > On Tue, 16 Sep 2014, Hugh Dickins wrote:
> > 
> > > On the page migration issue: it's not quite as straightforward as
> > > Christoph suggests.  He and I agree completely that mlocked pages
> > > should be migratable, but some real-time-minded people disagree:
> > > so normal compaction is still forbidden to migrate mlocked pages in
> > > the vanilla kernel (though we in Google patch that prohibition out).
> > > So pinning by refcount is no worse for compaction than mlocking,
> > > in the vanilla kernel.
> > 
> > Note though that compaction is not the only mechanism that uses page
> > migration.

True: offhand, I think memory hotremove, and CMA, and explicit mempolicy
changes, are all (for good reason) allowed to migrate mlocked pages; but
the case which most interests many is migration for compaction.

> 
> Agreed, and not all migration paths check for mlocked iirc. ISTR it is
> very much possible for mlocked pages to get migrated in mainline.

I think all the checks are for unevictable; and certainly we permit
races whereby an mlocked page may miss the unevictable LRU, until
subsequent reclaim corrects the omission.  But I think that's the
extent to which mlocked pages might be migrated for compaction at
present.

Hugh
