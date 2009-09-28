From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: avoid multiple quota reservation when retry
	block reservation for delalloc
Date: Mon, 28 Sep 2009 10:49:27 -0400
Message-ID: <20090928144927.GE17514@mit.edu>
References: <1253551950.9099.10.camel@mingming-laptop> <20090921181527.GA27777@duck.suse.cz> <1253575082.9099.14.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43164 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbZI1Ota (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2009 10:49:30 -0400
Content-Disposition: inline
In-Reply-To: <1253575082.9099.14.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 21, 2009 at 04:18:02PM -0700, Mingming wrote:
> On Mon, 2009-09-21 at 20:15 +0200, Jan Kara wrote:
> > On Mon 21-09-09 09:52:30, Mingming wrote:
> > > Ext4: release reserved quota before block reservation for delalloc retry
> > > 
> > > ext4_da_reserve_space() can reserve quota blocks multiple times if
> > > ext4_claim_free_blocks() fail and we retry the allocation. We should
> > > release the quota reservation before restarting.
> > > 
> > > Bug found be Jan Kara.
> >             ^^ by
> 
> attached is the updated patch with this typo fixed.

Added to the ext4 patch queue, thanks.

						- Ted
