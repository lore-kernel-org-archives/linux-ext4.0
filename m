From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 3/8][e2fsprogs] add new -D <desc-size> option to mkfs
Date: Tue, 4 Sep 2007 00:29:23 -0600
Message-ID: <20070904062923.GZ5377@schatzie.adilger.int>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <1188488221.15770.46.camel@ext1.frec.bull.fr> <1188501151.6594.32.camel@localhost.localdomain> <20070830205145.GK5377@schatzie.adilger.int> <1188606300.15123.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:51790 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbXIDG3A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2007 02:29:00 -0400
Content-Disposition: inline
In-Reply-To: <1188606300.15123.9.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 31, 2007  17:25 -0700, Mingming Cao wrote:
> On Thu, 2007-08-30 at 14:51 -0600, Andreas Dilger wrote:
> > we will only have a single tool "mke2fs", and it should be able
> > to format filesystems for all kernels.
> 
> I agree. I was wondering why not make the 64bytes block group descriptor
> for ext4 as default. So by default we don't need to specify the size
> when creating ext4 fs.

Sure, this can be the default for ext4 (as with all the other ext4 features
like INCOMPAT_64BIT INCOMPAT_EXTENTS, UNINIT_GROUPS, etc).

> > Also, it may be desirable to make the descriptor larger for whatever
> > reason (e.g. testing some new feature).
> > 
> Okay, that could be useful for ext4. Don't feel ext2/3 needs that option.

It can't hurt anything.  At worst it means INCOMPAT_64BIT is enabled at
mke2fs time and the mount will immediately fail with ext2/ext3.  Users
shouldn't mess with options they don't understand.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
