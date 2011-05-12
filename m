From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Date: Thu, 12 May 2011 12:38:34 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1105121232110.28493@router.home>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de> <1305127773-10570-4-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1105120942050.24560@router.home> <1305213359.2575.46.camel@mulgrave.site> <alpine.DEB.2.00.1105121024350.26013@router.home>
 <1305214993.2575.50.camel@mulgrave.site> <20110512154649.GB4559@redhat.com> <1305216023.2575.54.camel@mulgrave.site> <alpine.DEB.2.00.1105121121120.26013@router.home> <1305217843.2575.57.camel@mulgrave.site> <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com>
 <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Colin King <colin.king@canonical.com>,
	Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:46105 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758008Ab1ELRil (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2011 13:38:41 -0400
In-Reply-To: <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 12 May 2011, Pekka Enberg wrote:

> On Thu, May 12, 2011 at 8:06 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > On Thu, May 12, 2011 at 7:30 PM, James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:
> >> So suggest an alternative root cause and a test to expose it.
> >
> > Is your .config available somewhere, btw?
>
> If it's this:
>
> http://pkgs.fedoraproject.org/gitweb/?p=kernel.git;a=blob_plain;f=config-x86_64-generic;hb=HEAD
>
> I'd love to see what happens if you disable
>
> CONFIG_TRANSPARENT_HUGEPAGE=y
>
> because that's going to reduce high order allocations as well, no?

I dont think that will change much since huge pages are at MAX_ORDER size.
Either you can get them or not. The challenge with the small order
allocations is that they require contiguous memory. Compaction is likely
not as effective as the prior mechanism that did opportunistic reclaim of
neighboring pages.

