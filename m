From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V2 4/5] ext4: Use both hi and lo bits of the group
	desc values.
Date: Sun, 23 Nov 2008 21:13:02 -0500
Message-ID: <20081124021302.GB2163@mit.edu>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926F00D.6030403@redhat.com> <20081121174110.GH11212@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Coly Li <coyli@suse.de>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46235 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbYKXCPd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 21:15:33 -0500
Content-Disposition: inline
In-Reply-To: <20081121174110.GH11212@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 11:11:10PM +0530, Aneesh Kumar K.V wrote:
> On Fri, Nov 21, 2008 at 11:29:49AM -0600, Eric Sandeen wrote:
> > Aneesh Kumar K.V wrote:
> > > Rename the lower bits with suffix _lo and add helper
> > > to access the values. Also rename bg_itable_unused_hi
> > > to bg_pad as in e2fsprogs. bg_itable_unused_hi is never
> > > used before
> > 
> > Maybe you can add info about under which circumstances (what sort of
> > fielsystem geometry) the hi bits are needed?  And the failure mode when
> > we don't use them, if that's known?
> 
> Coly actually said it was added for inode reservation. But he agreed to
> drop the high bits now and add them later once the performance issue
> with the patch is addressed.

The bg_itable_unused field is used for the lazy initialization of
inodes.  If the units of this field was blocks was blocks, we wouldn't
need bg_itable_unused_hi for quite a larger set of blocks.

I don't think we should nuke bg_itable_unused_hi, especially given
that we have a patch to support the kernel initializing the inodes
(yet to be reviewed).  As near as I can tell at the time when the
fields were added to e2fsprogs, we hadn't yet assigned the pad field
to bg_itable_unused_hi, but it's clearly needed if we want to support
a larger number of blocks or inodes per block group.

Instead we should create the helper functions for bg_itable_unused,
and update e2fsprogs to also support these fields.  Adding e2fsprogs
for large block groups is lower priority than large block numbers,
though.

						- Ted
