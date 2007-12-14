From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] [PATCH] Flex_BG ialloc awareness V2.
Date: Fri, 14 Dec 2007 10:01:06 -0700
Message-ID: <20071214170106.GQ3214@webber.adilger.int>
References: <20071206161045.1054bbe7@gara> <20071207101428.GE3214@webber.adilger.int> <20071207095212.037ca68a@gara> <20071211110033.GQ3214@webber.adilger.int> <20071211100812.557b923b@gara> <20071211231528.GS3214@webber.adilger.int> <20071213095112.100b3d9e@gara> <20071213225857.GK3214@webber.adilger.int> <20071213203611.69525e6c@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48545 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbXLNRBI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Dec 2007 12:01:08 -0500
Content-Disposition: inline
In-Reply-To: <20071213203611.69525e6c@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 13, 2007  20:36 -0600, Jose R. Santos wrote:
> ... if the value in the super block is corrupted and
> does not represent the actual flexbg size, the inode allocation will
> behave in weird unexpected ways.  Just as we check that the bitmaps are
> within the block group range (when not using flexbg), we should
> probably sanity check the size of the flexbg as reported in the super
> block.
> 
> Or do you believe the check is unnecessary?

Well, I can imagine in some cases that the flexbg will not be completely
contiguous on disk (e.g. after a filesystem resize, if there are bad
blocks, etc).  As long as the group descriptors themselves are correct
(i.e. referencing valid bitmaps/itable) then it shouldn't cause a mount
failure if the per-group data isn't strictly aligned according to the
superblock flexbg count.

We would need to validate the group descriptor separately though (e.g.
group checksums).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
