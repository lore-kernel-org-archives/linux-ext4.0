From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: uninit block group/mballoc and fsstress
Date: Thu, 11 Oct 2007 01:45:04 -0600
Message-ID: <20071011074504.GN8122@schatzie.adilger.int>
References: <470CFFE3.7080101@linux.vnet.ibm.com> <20071011044641.GD8122@schatzie.adilger.int> <470DC928.7000609@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:46558 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbXJKHpH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 03:45:07 -0400
Content-Disposition: inline
In-Reply-To: <470DC928.7000609@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 11, 2007  12:26 +0530, Aneesh Kumar K.V wrote:
> Andreas Dilger wrote:
> >On Oct 10, 2007  22:07 +0530, Aneesh Kumar K.V wrote:
> >>I am hitting this with  the below config
> >>
> >>mke2fs -j -I 256 -O lazy_bg $dev
> >
> >Note that "-O lazy_bg" has nothing really to do with the uninit_groups
> >feature.  Also, if you don't have the CFS e2fsprogs patches for
> >uninit_groups then mke2fs creates an invalid filesystem if the journal is
> >large (this was an unrelated bug we fixed while testing uninit_groups).
> >Try running e2fsck right after the above mke2fs and you will likely
> >see errors.
> >
> 
> e2fsprogs found at  
> 
> ftp://ftp.clusterfs.com/pub/lustre/other/e2fsprogs
> 
> sets unint with -O lazy_bg. Is there any other option that i can use to set
> the uninit block group feature ?

Yes, "-O uninit_groups".  Note that while "-O lazy_bg" does set the UNINIT
flags on the groups (this is a COMPAT feature that marks all of the groups
full in the group descriptors), it does NOT handle the inode high watermark
or in-kernel initialization of the bitmaps.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
