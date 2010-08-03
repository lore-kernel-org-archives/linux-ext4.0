From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Tue, 3 Aug 2010 05:01:52 -0400
Message-ID: <20100803090152.GA6676@infradead.org>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <20100504154553.GA22777@infradead.org>
 <20100630124832.GA1333@thunk.org>
 <4C2B44C0.3090002@redhat.com>
 <20100630134429.GE1333@thunk.org>
 <20100721171609.GC1215@atrey.karlin.mff.cuni.cz>
 <20100803000939.GA2109@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab0HCJB4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Aug 2010 05:01:56 -0400
Content-Disposition: inline
In-Reply-To: <20100803000939.GA2109@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 02, 2010 at 05:09:39PM -0700, Darrick J. Wong wrote:
> Well... on my fsync-happy workloads, this seems to cut the barrier count down
> by about 20%, and speeds it up by about 20%.

Care to share the test case for this?  I'd be especially interesting on
how it behaves with non-draining barriers / cache flushes in fsync.

