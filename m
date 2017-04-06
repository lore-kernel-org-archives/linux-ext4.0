From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking
 infrastructure and convert ext4 to use it
Date: Thu, 6 Apr 2017 06:31:03 -0700
Message-ID: <20170406133103.GC31725@bombadil.infradead.org>
References: <87h924kh6t.fsf@notabene.neil.brown.name>
 <20170404115358.GH30811@bombadil.infradead.org>
 <1491308268.20445.4.camel@redhat.com>
 <20170404161247.GJ30811@bombadil.infradead.org>
 <1491323146.309.1.camel@redhat.com>
 <20170404170909.GK30811@bombadil.infradead.org>
 <1491421792.18658.20.camel@redhat.com>
 <87efx6tnbr.fsf@notabene.neil.brown.name>
 <20170406025530.GB31725@bombadil.infradead.org>
 <87inmi15md.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu, jack@suse.cz
To: NeilBrown <neilb@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48017 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933707AbdDFNbG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Apr 2017 09:31:06 -0400
Content-Disposition: inline
In-Reply-To: <87inmi15md.fsf@notabene.neil.brown.name>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 06, 2017 at 03:12:42PM +1000, NeilBrown wrote:
> On Wed, Apr 05 2017, Matthew Wilcox wrote:
> 
> > On Thu, Apr 06, 2017 at 10:02:48AM +1000, NeilBrown wrote:
> >> If you are concerned about space in 'struct address_space', just prune
> >> some wastage.
> >
> > I'm trying to (via wlists).  still buggy though.
> 
> Cool.
> (I wonder what a wlist is.... weighted list?)

A homonym ;-)  Waitlists.  Yet Another Variation of a doubly linked list.
This variation has only a single head pointer (like the hlist), allows
O(1) deletion from any point in the list (but requires that you know the
head of the list).  The tail of the list is pointed to by head->prev.

http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/wlist

It also needs updating to the latest tree; WW locks got revamped.
