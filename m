From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Thu, 31 May 2007 14:19:02 -0600
Message-ID: <20070531201902.GF5181@schatzie.adilger.int>
References: <20070512020248.GQ6375@schatzie.adilger.int> <20070524114442.GA12526@schatzie.adilger.int> <46559E04.5060002@clusterfs.com> <20070531162109.GA23591@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rupesh Thakare <rupesh@clusterfs.com>, linux-ext4@vger.kernel.org,
	Kalpak Shah <kalpak@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:42739 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbXEaUTI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 May 2007 16:19:08 -0400
Content-Disposition: inline
In-Reply-To: <20070531162109.GA23591@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 31, 2007  12:21 -0400, Theodore Tso wrote:
> On Thu, May 24, 2007 at 07:45:32PM +0530, Rupesh Thakare wrote:
> > I've added "s_raid_stripe_width" parameter in superblock.
> > I've also incorporated "s_raid_stride" and "s_raid_stripe_width" 
> > parameters in tune2fs.
> > The new options can be specified using  '-E options' in both mke2fs and 
> > tune2fs.
> > Both the Man pages (mke2fs and tune2fs) are updated accordingly.
> > Patch is attached herewith.
> 
> Thanks.  I've used a different offset for the raid_stripe_width, to
> avoid conflicting with Kalpak's mmp patch.  

Ah, we've been doing it the other way around here.  It makes sense to keep
the s_raid_stripe_width fields together.  I think this code is preliminary
enough that nobody has actually started using it yet.  Can you please post
what the end of ext2_super_block looks like (whether you decide to reorder
the fields or not).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
