From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 3/8][e2fsprogs] add new -D <desc-size> option to mkfs
Date: Thu, 30 Aug 2007 14:51:45 -0600
Message-ID: <20070830205145.GK5377@schatzie.adilger.int>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <1188488221.15770.46.camel@ext1.frec.bull.fr> <1188501151.6594.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:53839 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXH3UvW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 16:51:22 -0400
Content-Disposition: inline
In-Reply-To: <1188501151.6594.32.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 30, 2007  12:12 -0700, Mingming Cao wrote:
> On Thu, 2007-08-30 at 17:37 +0200, Valerie Clement wrote:
> > This patch adds a new option -D <descriptor-size> to mkfs to allow creating
> > ext4 filesystems with larger group descriptor size.
> > 
> > By default, the group descriptor size is 32 bytes.
> > To support 64-bit physical block numbers and thus to be able to use filesystems
> >  > 16TB, the group descriptor size must be increased to 64 bytes.
> 
> Could you explain a bit more why we need this option? It seems to me we
> could make the block group descriptor size to 64bytes whenever creating
> a ext4 filesystem by default. Is there any case we need to create ext4
> with old 32 bytes block group descriptors?

Because we will only have a single tool "mke2fs", and it should be able
to format filesystems for all kernels.  Also, it may be desirable to
make the descriptor larger for whatever reason (e.g. testing some new
feature).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
