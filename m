From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 3/8][e2fsprogs] add new -D <desc-size> option to mkfs
Date: Fri, 31 Aug 2007 17:25:00 -0700
Message-ID: <1188606300.15123.9.camel@localhost.localdomain>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
	 <1188488221.15770.46.camel@ext1.frec.bull.fr>
	 <1188501151.6594.32.camel@localhost.localdomain>
	 <20070830205145.GK5377@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60459 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXIAAYr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2007 20:24:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l810Oj78027759
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2007 20:24:46 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l810OjT1617272
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2007 20:24:45 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l810Oj4A008889
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2007 20:24:45 -0400
In-Reply-To: <20070830205145.GK5377@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-08-30 at 14:51 -0600, Andreas Dilger wrote:
> On Aug 30, 2007  12:12 -0700, Mingming Cao wrote:
> > On Thu, 2007-08-30 at 17:37 +0200, Valerie Clement wrote:
> > > This patch adds a new option -D <descriptor-size> to mkfs to allow creating
> > > ext4 filesystems with larger group descriptor size.
> > > 
> > > By default, the group descriptor size is 32 bytes.
> > > To support 64-bit physical block numbers and thus to be able to use filesystems
> > >  > 16TB, the group descriptor size must be increased to 64 bytes.
> > 
> > Could you explain a bit more why we need this option? It seems to me we
> > could make the block group descriptor size to 64bytes whenever creating
> > a ext4 filesystem by default. Is there any case we need to create ext4
> > with old 32 bytes block group descriptors?
> 
> Because we will only have a single tool "mke2fs", and it should be able
> to format filesystems for all kernels.

I agree. I was wondering why not make the 64bytes block group descriptor
for ext4 as default. So by default we don't need to specify the size
when creating ext4 fs.

> Also, it may be desirable to
> make the descriptor larger for whatever reason (e.g. testing some new
> feature).
> 
Okay, that could be useful for ext4. Don't feel ext2/3 needs that
option.

Regards,

Mingming
