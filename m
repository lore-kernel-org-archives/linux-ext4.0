From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/5] Add helper function for blkdev_issue_zeroout
Date: Thu, 9 Sep 2010 13:11:07 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009091303210.2889@dhcp-lab-213.englab.brq.redhat.com>
References: <1283965160-31597-1-git-send-email-lczerner@redhat.com> <1283965160-31597-2-git-send-email-lczerner@redhat.com> <60EEB7F1-715A-4952-87ED-DFEE46B0C0D0@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, sandeen@redhat.com, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0IILLN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Sep 2010 07:11:13 -0400
In-Reply-To: <60EEB7F1-715A-4952-87ED-DFEE46B0C0D0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 8 Sep 2010, Andreas Dilger wrote:

> On 2010-09-08, at 10:59, Lukas Czerner wrote:
> > +static inline int sb_issue_zeroout(struct super_block *sb,
> > +				   sector_t block, sector_t nr_blocks)
> > +{
> > +	block <<= (sb->s_blocksize_bits - 9);
> > +	nr_blocks <<= (sb->s_blocksize_bits - 9);
> > +	return blkdev_issue_zeroout(sb->s_bdev, block, nr_blocks, GFP_KERNEL,
> > +				   BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
> > +}
> 
> While I can understand that we might need a barrier for this (to avoid
> it being reordered with later writes that are using these blocks), I'm
> not sure it needs to wait for previous IO to complete.

We are waiting for submitted bios to finish. Especially in my patch it
is needed, because I need to know how long it takes to get this IO on
disk do determine next schedule time, depending on the IO load. I am not
sure about this, but when it would not wait it will complete fairly
quickly and my "IO throttling" code would be useless.

And if I am wrong, and you are really convinced that it should not wait,
what about sb_issue_discard(), it is also waiting for completion, is it
ok?

Regards.
-Lukas

> 
> Cheers, Andreas
> 
