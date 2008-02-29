From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Fri, 29 Feb 2008 17:49:53 -0500
Message-ID: <20080229224953.GK8968@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080229195948.GN2997@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59660 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbYB2Wt6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 17:49:58 -0500
Content-Disposition: inline
In-Reply-To: <20080229195948.GN2997@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 29, 2008 at 11:59:48AM -0800, Andreas Dilger wrote:
> Does this test case have both flexbg and uninit_groups?  Alternately,
> maybe some part of the e2fsck fixup code is allocating blocks in the
> group, but doesn't know that the UNINIT flag needs to be cleared.

Yes, it does include both; this describes what was going on in the
'pu' branch.

						- Ted
