From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-33.diff>
Date: Thu, 31 May 2007 11:43:06 -0400
Message-ID: <20070531154306.GC19088@thunk.org>
References: <200702100211.l1A2BTRb007321@igsi.llnl.gov> <465C75A8.5080506@redhat.com> <20070529205141.GB5181@schatzie.adilger.int> <465C938C.3060101@redhat.com> <20070529222009.GA669@thunk.org> <20070529231025.GH5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Brian D. Behlendorf" <behlendorf1@llnl.gov>,
	linux-ext4@vger.kernel.org, wartens2@llnl.gov
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36792 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXEaPnK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2007 11:43:10 -0400
Content-Disposition: inline
In-Reply-To: <20070529231025.GH5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 29, 2007 at 05:10:25PM -0600, Andreas Dilger wrote:
> I also have another outstanding patch:
> 
> ===========================================================================
> Coverity ID: 6: Forward Null
> 
> At the second conditional iter->file could still be NULL. We need to
> check for it again.

Also applied.

						- Ted
