From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Fri, 15 Sep 2006 10:18:16 -0600
Message-ID: <20060915161816.GG6441@schatzie.adilger.int>
References: <20060913164202.GA14838@openx1.frec.bull.fr> <20060913193130.GJ6441@schatzie.adilger.int> <20060914132154.GB28663@openx1.frec.bull.fr> <20060914210147.GY6441@schatzie.adilger.int> <20060915101933.GA7254@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:998 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751662AbWIOQSX
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 12:18:23 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060915101933.GA7254@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 15, 2006  12:19 +0200, Alexandre Ratchov wrote:
> BTW, note that when we'll add support for nanosecond time-stamps, we still
> have the same problem, because with a very high clock and time-stamp
> resolutions, we'll have to update the inode on every change.

If we have a journal commit callback, then even if the in-core inode ctime
is changed continually, the on-disk inode will be updated exactly once per
jbd transaction.  The problem as it stands now is that the ext3/VFS code
doesn't know where a transaction boundary is, so it has to continually
update the on-disk inode to make sure that the changes are in the relevant
transaction.

I recall a long time ago that Andrew got significant improvement from
reducing the number of mark_inode_dirty() calls in ext3, just because of
avoiding the repeated core->disk inode packing.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

