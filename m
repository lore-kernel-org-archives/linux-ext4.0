From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Tue, 1 May 2007 15:32:36 -0700
Message-ID: <20070501223236.GM5722@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1177994346.3362.5.camel@entropy> <20070501142049.GG77450368@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nicholas Miell <nmiell@comcast.net>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:60176 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbXEAWcm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 May 2007 18:32:42 -0400
Content-Disposition: inline
In-Reply-To: <20070501142049.GG77450368@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 02, 2007  00:20 +1000, David Chinner wrote:
> My point was that there is a difference between specification and
> implementation - if the specification says something is compulsory,
> then they must be implemented in the filesystem. This is easy
> enough to ensure by code review - we don't need additional interface
> complexity for this....

What you seem to be missing about my proposal is that the FLAG_INCOMPAT
is for future use by that part of the specification we haven't thought
of yet...  Having COMPAT/INCOMPAT flags has been very useful for ext2/3/4,
and is much better than having version numbers for the interface.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
