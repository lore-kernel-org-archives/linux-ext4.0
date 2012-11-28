From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] ext4: Convert unwritten extents during end_io
 processing
Date: Wed, 28 Nov 2012 09:34:05 -0500
Message-ID: <20121128143405.GB23743@infradead.org>
References: <20121123075502.307482760@bombadil.infradead.org>
 <20121123075916.375908616@bombadil.infradead.org>
 <x49a9u3f276.fsf@segfault.boston.devel.redhat.com>
 <20121128002656.GC4321@blackbox.djwong.org>
 <20121128003027.GA14500@infradead.org>
 <20121128080254.GB11869@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59915
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab2K1OeK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2012 09:34:10 -0500
Content-Disposition: inline
In-Reply-To: <20121128080254.GB11869@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2012 at 12:02:54AM -0800, Darrick J. Wong wrote:
> Here's a lightly tested (it passed enough of xfstests and an aio+dio+osync
> tester on ext4 on x64...) patch that rips out the whole wq mess to convert
> unwritten extents from endio processing.  This has the effect that unwritten
> extents are now converted as part of writeback, not fsync/truncate/punch_hole.
> I have a suspicion that the reason why ext4 had that behavior was to reduce
> churn in the extent tree if one writes a bunch of adjacent sections of hole.
> Oh well.  I haven't seen any huge regressions yet, but then I'm really just
> posting this early to see if anyone spots obvious bugs.
> 
> Christoph, was this what you had in mind?

Can you actually call ext4_convert_unwritten_extents from irq context
safely for the buffered I/O case?  At least for the XFS equivalent we
need user context, which is why we have these workqueues in the first
place.

But what we're doing is to make sure unwritten extent conversion happens
before marking the page writeback complete, so that
filemap_write_and_wait and friends implicitly wait for this conversion
when waiting for page I/O to complete, and thus removing the need for
all the explicit flushing infrastructure.

