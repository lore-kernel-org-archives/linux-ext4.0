From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V2 4/5] ext4: Use both hi and lo bits of the group
	desc values.
Date: Sun, 23 Nov 2008 20:21:13 -0500
Message-ID: <20081124012113.GA2163@mit.edu>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926F00D.6030403@redhat.com> <20081121174110.GH11212@skywalker> <4926F599.5040605@redhat.com> <20081123040939.GU3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Coly Li <coyli@suse.de>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40694 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbYKXB03 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 20:26:29 -0500
Content-Disposition: inline
In-Reply-To: <20081123040939.GU3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 22, 2008 at 10:09:39PM -0600, Andreas Dilger wrote:
> On Nov 21, 2008  11:53 -0600, Eric Sandeen wrote:
> > Ok, and for the rest?  (free_blocks, free_inodes) - I guess these are
> > only needed for > 2^32 block filesystems?
> 
> Actually, since this is a per-group number, I'm not sure why this is
> needed at all.  I don't object to keeping the helper functions though.

For most systems, it wn't be needed at all.  However, for filesystems
with block sizes >= 8k, we run into a limit where the maximum number
of blocks and inodes we can support per block group is 65528 (we can't
support 65536 since that would cause bg_free_blocks_count and/or
bg_free_blocks_count, which are both __u16 types, to overflow).  So on
systems with a page size > 4k, or if Christoph's patch to support fs
block sizes > page size ever makes it into mainline, this support
could be useful.

						- Ted
