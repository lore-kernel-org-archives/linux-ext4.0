From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: uninit block group/mballoc and fsstress
Date: Wed, 10 Oct 2007 22:46:41 -0600
Message-ID: <20071011044641.GD8122@schatzie.adilger.int>
References: <470CFFE3.7080101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:41022 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbXJKGpk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 02:45:40 -0400
Content-Disposition: inline
In-Reply-To: <470CFFE3.7080101@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 10, 2007  22:07 +0530, Aneesh Kumar K.V wrote:
> I am hitting this with  the below config
> 
> mke2fs -j -I 256 -O lazy_bg $dev

Note that "-O lazy_bg" has nothing really to do with the uninit_groups
feature.  Also, if you don't have the CFS e2fsprogs patches for
uninit_groups then mke2fs creates an invalid filesystem if the journal is
large (this was an unrelated bug we fixed while testing uninit_groups).
Try running e2fsck right after the above mke2fs and you will likely
see errors.

> jbd2_journal_bmap: journal block not found at offset 31780 on sda7

The problem is that lazy_bg allocates the journal blocks incorrectly, IIRC.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
