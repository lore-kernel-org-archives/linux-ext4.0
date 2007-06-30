From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: fallocate support for bitmap-based files
Date: Sat, 30 Jun 2007 10:31:45 -0400
Message-ID: <1183213905.9505.29.camel@localhost.localdomain>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org>
	 <20070629205525.GD32178@thunk.org>
	 <20070629214615.GB5026@schatzie.adilger.int> <46858716.2050901@google.com>
	 <20070630051436.GB5535@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mike Waychison <mikew@google.com>, Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34517 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006AbXF3Obv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Jun 2007 10:31:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5UEX0r3003560
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 10:33:00 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5UEVo8A511604
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 10:31:50 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5UEVnlX017614
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 10:31:50 -0400
In-Reply-To: <20070630051436.GB5535@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-06-30 at 01:14 -0400, Andreas Dilger wrote:
> On Jun 29, 2007  18:26 -0400, Mike Waychison wrote:
> > Andreas Dilger wrote:
> > >I don't think ext2 is safe for > 8TB filesystems anyways, so this
> > >isn't a huge loss.
> > 
> > This is reference to the idea of overloading the high-bit and not 
> > related to the >PAGE_SIZE blocks correct?
> 
> Correct - just that the high-bit use wouldn't unduely impact the
> already-existing 8TB limit of ext2.
> 

The 8TB limit on mainline ext2 was simplely caused by kernel block
variable type bugs. The bug fixes were ported back from ext3 to ext2,
when reservation+simple-multiple-balloc were backported from ext3 to
ext2. I believe ext2 in mm tree is able to address 16TB in the kernel
side.  Not sure if there are remaining work to be done in e2fsck to
handle 16TB ext2, but I assume it's not huge work.

Mingming
