From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 23:53:05 -0600
Message-ID: <20061006055305.GG22010@schatzie.adilger.int>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005205526.7fe744f5.akpm@osdl.org> <20061005215442.310b7792.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:23209 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S932605AbWJFFxH
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Oct 2006 01:53:07 -0400
To: Randy Dunlap <rdunlap@xenotime.net>
Content-Disposition: inline
In-Reply-To: <20061005215442.310b7792.rdunlap@xenotime.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 05, 2006  21:54 -0700, Randy Dunlap wrote:
> On Thu, 5 Oct 2006 20:55:26 -0700 Andrew Morton wrote:
> > If you then mount this filesystem with `-t ext4dev -o extents', it becomes
> > incompatible with the ext3 driver.  Yes?
> 
> I thought we s/ext4dev/ext4/ ??

No, we want to leave it at ext4dev for a while, to make it very clear
that this is still under development.  We want to get the existing
patches upstream so they don't become completely unwieldy, and earlier
testing is also good, but it is not yet feature complete.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

