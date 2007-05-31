From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Fri, 01 Jun 2007 02:32:29 +0530
Message-ID: <1180645351.3922.1.camel@garfield>
References: <20070512020248.GQ6375@schatzie.adilger.int>
	 <20070524114442.GA12526@schatzie.adilger.int>
	 <46559E04.5060002@clusterfs.com> <20070531162109.GA23591@thunk.org>
	 <20070531201902.GF5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Rupesh Thakare <rupesh@clusterfs.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:44778 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbXEaU6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 May 2007 16:58:55 -0400
In-Reply-To: <20070531201902.GF5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-05-31 at 14:19 -0600, Andreas Dilger wrote:
> On May 31, 2007  12:21 -0400, Theodore Tso wrote:
> > On Thu, May 24, 2007 at 07:45:32PM +0530, Rupesh Thakare wrote:
> > > I've added "s_raid_stripe_width" parameter in superblock.
> > > I've also incorporated "s_raid_stride" and "s_raid_stripe_width" 
> > > parameters in tune2fs.
> > > The new options can be specified using  '-E options' in both mke2fs and 
> > > tune2fs.
> > > Both the Man pages (mke2fs and tune2fs) are updated accordingly.
> > > Patch is attached herewith.
> > 
> > Thanks.  I've used a different offset for the raid_stripe_width, to
> > avoid conflicting with Kalpak's mmp patch.  
> 
> Ah, we've been doing it the other way around here.  It makes sense to keep
> the s_raid_stripe_width fields together.  I think this code is preliminary
> enough that nobody has actually started using it yet.  Can you please post
> what the end of ext2_super_block looks like (whether you decide to reorder
> the fields or not).

I can update the MMP patches when I actually send them for inclusion. So
I think it makes sense to keep the s_raid_* fields together.

Thanks,
Kalpak.

> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
