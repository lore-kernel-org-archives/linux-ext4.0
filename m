From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 12:54:05 -0400
Message-ID: <20080909165405.GQ21071@mit.edu>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080909114647.GA14052@infradead.org> <20080909134347.GB21071@mit.edu> <20080909165005.GA24816@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59139 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbYIIQyP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 12:54:15 -0400
Content-Disposition: inline
In-Reply-To: <20080909165005.GA24816@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 12:50:05PM -0400, Christoph Hellwig wrote:
> Well, if you think setting a flag is a good interface to convert to
> extents, then do it all the way and allow setting the extent
> flag in the kernel through FS_IOC_SETFLAGS instead of having an
> interface schism.

Thanks, that's a good idea.  It won't help people on older kernels,
but it probably is the right answer.

Regards,

					- Ted
