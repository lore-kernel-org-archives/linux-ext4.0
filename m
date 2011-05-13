From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Date: Fri, 13 May 2011 10:49:58 +0100
Message-ID: <20110513094958.GA3569@suse.de>
References: <alpine.DEB.2.00.1105121024350.26013@router.home>
 <1305214993.2575.50.camel@mulgrave.site>
 <20110512154649.GB4559@redhat.com>
 <1305216023.2575.54.camel@mulgrave.site>
 <alpine.DEB.2.00.1105121121120.26013@router.home>
 <1305217843.2575.57.camel@mulgrave.site>
 <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com>
 <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com>
 <alpine.DEB.2.00.1105121232110.28493@router.home>
 <20110512180018.GN11579@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Dave Jones <davej@redhat.com>,
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
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36157 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804Ab1EMJuG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2011 05:50:06 -0400
Content-Disposition: inline
In-Reply-To: <20110512180018.GN11579@random.random>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 12, 2011 at 08:00:18PM +0200, Andrea Arcangeli wrote:
> <SNIP>
>
> BTW, it comes to mind in patch 2, SLUB should clear __GFP_REPEAT too
> (not only __GFP_NOFAIL). Clearing __GFP_WAIT may be worth it or not
> with COMPACTION=y, definitely good idea to clear __GFP_WAIT unless
> lumpy is restricted to __GFP_REPEAT|__GFP_NOFAIL.

This is in V2 (unreleased, testing in progress and was running
overnight). I noticed that clearing __GFP_REPEAT is required for
reclaim/compaction if direct reclaimers from SLUB are to return false in
should_continue_reclaim() and bail out from high-order allocation
properly. As it is, there is a possibility for slub high-order direct
reclaimers to loop in reclaim/compaction for a long time. This is
only important when CONFIG_COMPACTION=y.

-- 
Mel Gorman
SUSE Labs
