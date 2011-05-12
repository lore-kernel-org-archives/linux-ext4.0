From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Date: Thu, 12 May 2011 14:21:12 -0500
Message-ID: <1305228072.2575.67.camel@mulgrave.site>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	 <1305127773-10570-4-git-send-email-mgorman@suse.de>
	 <alpine.DEB.2.00.1105120942050.24560@router.home>
	 <1305213359.2575.46.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121024350.26013@router.home>
	 <1305214993.2575.50.camel@mulgrave.site> <1305215742.27848.40.camel@jaguar>
	 <1305225467.2575.66.camel@mulgrave.site>
	 <alpine.DEB.2.00.1105121345450.29359@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Lameter <cl@linux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50924 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692Ab1ELTVQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2011 15:21:16 -0400
In-Reply-To: <alpine.DEB.2.00.1105121345450.29359@router.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2011-05-12 at 13:46 -0500, Christoph Lameter wrote:
> On Thu, 12 May 2011, James Bottomley wrote:
> 
> > On Thu, 2011-05-12 at 18:55 +0300, Pekka Enberg wrote:
> > > On Thu, 2011-05-12 at 10:43 -0500, James Bottomley wrote:
> > > > However, since you admit even you see problems, let's concentrate on
> > > > fixing them rather than recriminations?
> > >
> > > Yes, please. So does dropping max_order to 1 help?
> > > PAGE_ALLOC_COSTLY_ORDER is set to 3 in 2.6.39-rc7.
> >
> > Just booting with max_slab_order=1 (and none of the other patches
> > applied) I can still get the machine to go into kswapd at 99%, so it
> > doesn't seem to make much of a difference.
> 
> slub_max_order=1 right? Not max_slab_order.

Yes.

James


