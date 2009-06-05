From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] [PATCH] ext4: Add inode to the orphan list during
	block allocation failure
Date: Sat, 6 Jun 2009 01:42:39 +0200
Message-ID: <20090605234238.GF11650@duck.suse.cz>
References: <20090331044544.GB5979@skywalker> <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090405031116.GG7553@mit.edu> <20090406100509.GB31189@duck.suse.cz> <20090605043117.GB4046@mit.edu> <20090605062234.GA27217@mit.edu> <20090605072417.GA8236@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbZFEXmj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2009 19:42:39 -0400
Content-Disposition: inline
In-Reply-To: <20090605072417.GA8236@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 05-06-09 03:24:17, Theodore Tso wrote:
> On Fri, Jun 05, 2009 at 02:22:34AM -0400, Theodore Tso wrote:
> > I've tried applying these two patches to the ext4 patch queue.  On a
> > metadata-heavy workload (specifically, fsx), it causes a 5%
> > degradation in the wall clock run-time of the fsx run-time.
> 
> I just did some more timing tests, and it looks like I can't confirm
> it.  The test times are noisy enough I need to run some more under very
> controlled circumsntances.  So ignore this for now, it might not be a
> problem after all.
  It would be strange if the patches caused a measurable slowdown. They
change something only in the failure path where we fail to allocate some
blocks or fail to copy in all the data and these should better be
exceptional cases...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
