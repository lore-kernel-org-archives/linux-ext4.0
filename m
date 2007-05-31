From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] store RAID stride in superblock
Date: Thu, 31 May 2007 12:21:09 -0400
Message-ID: <20070531162109.GA23591@thunk.org>
References: <20070512020248.GQ6375@schatzie.adilger.int> <20070524114442.GA12526@schatzie.adilger.int> <46559E04.5060002@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: Rupesh Thakare <rupesh@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34390 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbXEaQVL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2007 12:21:11 -0400
Content-Disposition: inline
In-Reply-To: <46559E04.5060002@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 24, 2007 at 07:45:32PM +0530, Rupesh Thakare wrote:
> Hello,
> I've added "s_raid_stripe_width" parameter in superblock.
> I've also incorporated "s_raid_stride" and "s_raid_stripe_width" 
> parameters in tune2fs.
> The new options can be specified using  '-E options' in both mke2fs and 
> tune2fs.
> Both the Man pages (mke2fs and tune2fs) are updated accordingly.
> Patch is attached herewith.

Thanks.  I've used a different offset for the raid_stripe_width, to
avoid conflicting with Kalpak's mmp patch.  

Could you send me a signed-off-by for your patch?

Thanks,

						- Ted
