From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 01/15 v2] mm: add invalidatepage_range address space
 operation
Date: Fri, 14 Sep 2012 09:21:19 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1209140919580.2455@dhcp-196-88.bos.redhat.com>
References: <1346451711-1931-1-git-send-email-lczerner@redhat.com> <1346451711-1931-2-git-send-email-lczerner@redhat.com> <20120904164316.6e058cbe.akpm@linux-foundation.org> <alpine.LFD.2.00.1209051002310.509@new-host-2> <20120905155648.GA15985@infradead.org>
 <alpine.LFD.2.00.1209051234570.18459@new-host-2>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463810303-1375738350-1347628884=:2455"
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	tytso@mit.edu, hughd@google.com, linux-mm@kvack.org
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1209051234570.18459@new-host-2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463810303-1375738350-1347628884=:2455
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 5 Sep 2012, Luká¨ Czerner wrote:

> Date: Wed, 5 Sep 2012 12:42:54 -0400 (EDT)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Christoph Hellwig <hch@infradead.org>
> Cc: Luk?? Czerner <lczerner@redhat.com>,
>     Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
>     linux-mm@kvack.org
> Subject: Re: [PATCH 01/15 v2] mm: add invalidatepage_range address space
>     operation
> 
> On Wed, 5 Sep 2012, Christoph Hellwig wrote:
> 
> > Date: Wed, 5 Sep 2012 11:56:48 -0400
> > From: Christoph Hellwig <hch@infradead.org>
> > To: Luk?? Czerner <lczerner@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
> >     linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
> >     linux-mm@kvack.org
> > Subject: Re: [PATCH 01/15 v2] mm: add invalidatepage_range address space
> >     operation
> > 
> > On Wed, Sep 05, 2012 at 10:36:00AM -0400, Luk?? Czerner wrote:
> > > However if we would want to keep ->invalidatepage_range() and
> > > ->invalidatepage() completely separate then we would have to have
> > > separate truncate_inode_pages_range() and truncate_pagecache_range()
> > > as well for the separation to actually matter. And IMO this would be
> > > much worse...
> > 
> > What's the problem with simply changing the ->invalidatepage prototype
> > to always pass the range and updating all instances for it?
> > 
> 
> The problem is that it would require me to implement this
> functionality for _all_ the file systems, because it is not just
> about changing the prototype, but also changing the implementation to
> be able to handle unaligned end of the range. This change would
> involve 20 file systems.
> 
> It is not impossible though... so if people think that it's the
> right way to go, then I guess it can be done.
> 
> -Lukas

Are there still any objections or comments about this ?

-Lukas
---1463810303-1375738350-1347628884=:2455--
