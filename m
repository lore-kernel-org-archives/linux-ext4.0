From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (May 7, 2007)
Date: Wed, 9 May 2007 12:10:38 -0700
Message-ID: <20070509191038.GR6375@schatzie.adilger.int>
References: <4641FE96.6010603@linux.vnet.ibm.com> <20070509173740.GQ6375@schatzie.adilger.int> <1178734232.3815.25.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34142 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401AbXEITKl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 15:10:41 -0400
Content-Disposition: inline
In-Reply-To: <1178734232.3815.25.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 09, 2007  11:10 -0700, Mingming Cao wrote:
> On Wed, 2007-05-09 at 10:37 -0700, Andreas Dilger wrote:
> > That means it is virtually impossible to allow the group metadata to move
> > under the META_BG feature.
> 
> Understand it's not straightforward to turn on this feature by default.
> Just try to understand, why the kernel and e2fsprogs issues you
> mentioned above are not possible to fix to support full META_BG
> feature? 

Because older kernels and e2fsprogs will think they understand META_BG,
and will consider the filesystem corrupt due to "badly placed" bitmaps
and itable.  That is exactly what FEATURE flags are supposed to protect
against, so we can't change the semantics of the META_BG feature at this
time.  I understand that we WANTED to have META_BG have different
semantics, but the implementation didn't follow the design for this flag.

> >   It might be possible to predicate this change
> > under both 64BIT and META_BG, though this is somewhat non-standard.
> > 
> > Alternately, we could allow the relocation of bitmaps and itables under
> > BIG_BG, which is itself covers the relocation aspects and also allows
> > the ability to change the group size.
> > 
> 
> Well, I think the previous discussion about BIG_BG feature leads us to
> believe that turn on META_BG feature is good enough to support larger fs
> and reduce fragmentation(which is the new BIG_BG feature is trying to
> address).  After all the relocation of metadata (bitmaps, itables and
> group descriptors) is what META_BG feature means.

That is what we WANTED the META_BG feature to mean.  What was implemented
in both ext2/3/4 and e2fsck is that META_BG means "group descriptor backups
are in 1st, 2nd, last group in metagroup" and nothing else.  At least the
code is consistent between the two.

So that leaves us in the position that we either need to create a new
INCOMPAT feature flag to allow relocation of bitmaps/itable, OR we
need to make this conditional upon both META_BG and 64BIT being set.
The latter is a bit confusing and is subject to error if only one or
the other flag is checked by accident.  If we make a new INCOMPAT flag
then could almost as easily implement BIG_BG and give us more flexibility
for the future, though I haven't looked at that code in a while.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
