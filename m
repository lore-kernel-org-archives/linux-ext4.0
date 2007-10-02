From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (October 1, 2007)
Date: Mon, 1 Oct 2007 23:58:31 -0600
Message-ID: <20071002055831.GH5702@schatzie.adilger.int>
References: <47017053.9060005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:47271 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXJBF6h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 01:58:37 -0400
Content-Disposition: inline
In-Reply-To: <47017053.9060005@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 01, 2007  15:10 -0700, Avantika Mathur wrote:
> Delayed Allocation:
> - There has been an lkml thread about these patches.
> - We have and approach that works for ext4, implemented at the vfs 
> level, but unless we can prove it can work for other filesystems, it 
> will not be accepted.  
> - Christoph Hellwig has commented that these patches will not work for 
> XFS.  

Hmm, but I thought that Christoph also agreed that it would be OK to
get the ext4 delalloc code merged separately, so long as it doesn't
need big/any changes to the VFS to implement it.  It might be that the
ext4 and XFS code is different enough that they cannot share the
delayed allocation code.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
