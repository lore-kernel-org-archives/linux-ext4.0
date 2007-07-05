From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [PATCH] speed up statfs
Date: Wed, 04 Jul 2007 20:51:07 -0700
Message-ID: <1183607467.29435.6.camel@dyn9047017100.beaverton.ibm.com>
References: <20070704222344.GA5135@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60599 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbXGEDtc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jul 2007 23:49:32 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l653nU1M007544
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 23:49:30 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l653nU2B168222
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 21:49:30 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l653nTdk012217
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jul 2007 21:49:30 -0600
In-Reply-To: <20070704222344.GA5135@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-07-04 at 16:23 -0600, Andreas Dilger wrote:
> Hi,
> this is a patch we are currently using that speeds up statfs.
> It is very simple - the "overhead" calculation, which takes a
> huge amount of time for large filesystems, never changes unless
> the size of the filesystem itself changes.  That means we can
> store it in memory and only recalculate if the filesystem has
> been resized (almost never).
> 
> It is based on ext3 but is trivally updated to ext4.  It also
> fixes a minor problem that we never update the on-disk superblock
> free blocks/inodes counts until the filesystem is unmounted.
> While not fatal, we may as well update that on disk when we have
> the information, and it makes things like debugfs and dumpe2fs
> report a bit more accurate info.
> 
> I'd be happy if someone could update this to the latest kernel and
> for ext2 and ext4 also.
> 

I forward ported it to latest + did the same for ext2 and ext4 also.
Compiles fine. I will post them tomorrow after little testing.

Thanks,
Badaru
