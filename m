From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Add EXT4_IOC_MIGRATE ioctl
Date: Tue, 12 Jun 2007 03:24:29 -0600
Message-ID: <20070612092429.GK5181@schatzie.adilger.int>
References: <20070612064757.GA12991@skywalker.home.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:35207 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbXFLJYa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 05:24:30 -0400
Content-Disposition: inline
In-Reply-To: <20070612064757.GA12991@skywalker.home.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 12, 2007  12:17 +0530, Aneesh Kumar K.V wrote:
> The below patch add ioctl for migrating ext3 indirect block mapped inode
> to ext4 extent mapped inode.

How does this relate to the migrate ioctl used by Takashi in the current
ext4 defragmenter patch series?  Ideally, the code shouldn't really care
whether it is migrating from/to a block-mapped or extent-mapped file.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
