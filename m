From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-33.diff>
Date: Tue, 29 May 2007 18:20:09 -0400
Message-ID: <20070529222009.GA669@thunk.org>
References: <200702100211.l1A2BTRb007321@igsi.llnl.gov> <465C75A8.5080506@redhat.com> <20070529205141.GB5181@schatzie.adilger.int> <465C938C.3060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	"Brian D. Behlendorf" <behlendorf1@llnl.gov>,
	linux-ext4@vger.kernel.org, wartens2@llnl.gov
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52961 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbXE2WUO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2007 18:20:14 -0400
Content-Disposition: inline
In-Reply-To: <465C938C.3060101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 29, 2007 at 03:56:44PM -0500, Eric Sandeen wrote:
> >I still have it in my "apply atop 1.39-WIP" series, so it appears not
> >to have made it into Ted's repo.  I'm including the patch again for
> >posterity.
> 
> Thanks Andreas - near as I can tell, it never made it to the list.

Yeah, I wondered about that numbering discontinuity --- but IIRC it
wasn't the only one.  I had assumed that the "missing" cid's were ones
were human examination of the Coverity report lead to the conclusion
that it really wasn't a problem....

					- Ted
