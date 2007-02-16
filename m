From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: booked-page-flag.patch
Date: Fri, 16 Feb 2007 05:17:38 -0700
Message-ID: <20070216121738.GR10715@schatzie.adilger.int>
References: <20070215004504.023a90f0.akpm@linux-foundation.org> <45D495EA.3060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, Alex Tomas <alex@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:60363 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXBPMRj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Feb 2007 07:17:39 -0500
Content-Disposition: inline
In-Reply-To: <45D495EA.3060200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 15, 2007  09:18 -0800, Eric Sandeen wrote:
> This was for the delayed allocation patchset, right; and by managing 
> this at the page level that means we can't do this for block size < page 
> size, I think...

We could always disable delayed allocation in the PAGE_SIZE != blocksize
case.  It would be no worse than what we have now, and for IO performance
you need larger blocksize anyways.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
