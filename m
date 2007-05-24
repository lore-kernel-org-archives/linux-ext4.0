From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] store RAID stride in superblock
Date: Thu, 24 May 2007 05:44:42 -0600
Message-ID: <20070524114442.GA12526@schatzie.adilger.int>
References: <20070512020248.GQ6375@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:52877 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbXEXLoo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 May 2007 07:44:44 -0400
Content-Disposition: inline
In-Reply-To: <20070512020248.GQ6375@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 22, 2007  01:22 +0530, Kalpak Shah wrote:
>         __u16   s_raid_stride;          /* RAID stride */
> -       __u16   s_pad;                  /* Padding */
> +       __u16   s_mmp_interval;         /* Wait for # seconds in MMP
> checking */
> +       __u64   s_mmp_block;            /* Block for multi-mount protection
> */

Ted, I just noticed this updated patch w.r.t. your recent s_raid_stride
addition.  I also want to have a separate parameter for "s_raid_stripe_width"
which is normally N * s_raid_stride, where N is the number of disks in a
RAID 5 N+1 (or RAID 6 N+2) parity stripe.  This is for delalloc+mballoc to
allow it to align and size new allocations so that writes do not impose
read-modify-write overhead on the RAID stripes.

My understanding from the code is that s_raid_stride is to put the bitmaps
for different groups on different disks to avoid always having a single
disk busy with bitmap updates.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
