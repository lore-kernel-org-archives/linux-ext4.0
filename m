From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] uninitialized groups ported - e2fsprogs
Date: Thu, 7 Jun 2007 15:59:38 -0600
Message-ID: <20070607215938.GY5181@schatzie.adilger.int>
References: <1181065735.5219.10.camel@mathur-dsktp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:41262 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966148AbXFGV7k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jun 2007 17:59:40 -0400
Content-Disposition: inline
In-Reply-To: <1181065735.5219.10.camel@mathur-dsktp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 05, 2007  10:48 -0700, Avantika Mathur wrote:
> Below is the uninitialized block group e2fsprogs patch, ported to
> e2fsprogs-1.39-tyt3.

I had a look through this, and didn't see much different than the patch
I posted a couple of days ago in reply to Eric's question about this feature.
The one noticable difference is that this patch is missing the check/fix
for fixing an group with BLOCK_UNINIT as the last group in the fs.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
