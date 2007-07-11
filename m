From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Wed, 11 Jul 2007 05:14:46 -0600
Message-ID: <20070711111446.GO6417@schatzie.adilger.int>
References: <1183275416.4010.125.camel@localhost.localdomain> <20070710163027.1bf7e94e.akpm@linux-foundation.org> <1184119241.20193.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:43192 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbXGKLOt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 07:14:49 -0400
Content-Disposition: inline
In-Reply-To: <1184119241.20193.27.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  22:00 -0400, Mingming Cao wrote:
> On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> > On Sun, 01 Jul 2007 03:36:56 -0400
> > Mingming Cao <cmm@us.ibm.com> wrote:
> > 
> > > This patch is a spinoff of the old nanosecond patches.
> > 
> > I don't know what the "old nanosecond patches" are.  A link to a suitable
> > changlog for those patches would do in a pinch.  Preferable would be to
> > write a proper changelog for this patch.
> > 
> I found the original patch
> http://marc.info/?l=linux-ext4&m=115091699809181&w=2
> 
> Andreas or Kalpak, is changelog from the original patch is accurate to
> apply here?

Mostly, yes, but the name of the feature flag has changed.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
