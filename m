From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 patch queue updated(2.6.23-rc6)
Date: Fri, 14 Sep 2007 16:54:38 -0600
Message-ID: <20070914225438.GK5377@schatzie.adilger.int>
References: <1189643439.4935.30.camel@localhost.localdomain> <46E95011.7040309@bull.net> <1189717301.3751.11.camel@localhost.localdomain> <1189796613.3841.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>, tytso@mit.edu
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:39026 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbXINWyO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2007 18:54:14 -0400
Content-Disposition: inline
In-Reply-To: <1189796613.3841.14.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 14, 2007  12:03 -0700, Mingming Cao wrote:
> Ted, could you please update the ext4 git tree with the patches before
> the "unstable" mark, so we could get more air time in mm tree for
> testing?
> 
> Thanks,
> Mingming
> 
> current patch series
> 
> # Rebased the patches to 2.6.23-rc6
> jbd_slab_cleanup.patch
> sparse-fix.patch
> 
> # Add journal checksums
> ext4-journal_chksum-2.6.20.patch
> ext4-journal-chksum-review-fix.patch

Actually, the journal checksum patches should probably be moved into
the "unstable" part of the series, given the number of problems reported
on them (also in more heavy testing at CFS).  These are also not in use
in production anywhere, unlike e.g. uninit_groups which have 6 months *
50 servers of testing or more.

> #########
> #FLEX_BG
> ########
> flex_bg_kernel.patch

This should probably go into the "stable" part of the patches - it
is a conceptually simple patch, and the sooner INCOMPAT_FLEX_BG gets
upstream the better.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
