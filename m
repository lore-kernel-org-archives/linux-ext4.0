From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Online defragmentation
Date: Wed, 30 May 2007 08:10:34 -0600
Message-ID: <20070530141034.GL5181@schatzie.adilger.int>
References: <465D2202.60600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Takashi Sato <sho@tnes.nec.co.jp>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:59614 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbXE3OKh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2007 10:10:37 -0400
Content-Disposition: inline
In-Reply-To: <465D2202.60600@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 30, 2007  12:34 +0530, Aneesh Kumar K.V wrote:
> I haven't tested the defrag code. This came up when i was doing the 
> online migration. With large file having large number of fragmented 
> blocks I was getting the below error during the iput of the temporary 
> inode.
> 
> "ext4_free_blocks Freeing blocks not in datazone ...."

This shouldn't happen regardless of whether you are doing defrag or not,
since it will cause the filesystem to go read-only.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
