From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Gluster-devel] regressions due to 64-bit ext4 directory cookies
Date: Thu, 14 Feb 2013 16:32:15 +1100
Message-ID: <20130214053215.GK26694@dastard>
References: <20130212202841.GC10267@fieldses.org>
 <511AAC89.3060409@itwm.fraunhofer.de>
 <20130212210054.GF10267@fieldses.org>
 <20130213133133.GB23233@ndevos-laptop.usersys.redhat.com>
 <511BB3F3.7010608@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Niels de Vos <ndevos@redhat.com>,
	"J. Bruce Fields" <bfields@fieldses.org>, sandeen@redhat.com,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	gluster-devel@nongnu.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36762 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126Ab3BNFcf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2013 00:32:35 -0500
Content-Disposition: inline
In-Reply-To: <511BB3F3.7010608@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 13, 2013 at 04:40:35PM +0100, Bernd Schubert wrote:
> >The general advise (even before this Bug) is that XFS should be used,
> >which is not affected with this problem (yet?).
> 
> Hmm, well, always depends on the workload.

XFS won't suffer from this collision bug, for 2 reasons. The first
is that XFS uses a virtual mapping for directory data and uses an
encoded index into that virtual mapping as the cookie data. You
can't have 2 entries at the same index, so you cannot get cookie
collisions.

The second is that the virtual mapping is for a 32GB data segment,
(2^35 bytes) and, like so much of XFS, the cookie is made up of
bitfields that encode a specific location. The high bits are the
virtual block offset into the directory data segment, the low bits
the offset into the directory block. Given that directory entries
are aligned to 8 bytes, the offset into the directory block can have
3 bits compressed out and hence we end up with only 32 bits being
needed to address the entire 32GB directory data segment.

So, there are no collisions or 32/64 bit issues with XFS directory
cookies regardless of the workload.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
