From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [patch 1/8] ext4: fix MB_DEBUG format warnings
Date: Fri, 30 Nov 2007 17:20:22 -0800
Message-ID: <1196472022.11479.30.camel@localhost.localdomain>
References: <200711292052.lATKqmNQ006825@imap1.linux-foundation.org>
	 <1196468252.11479.19.camel@localhost.localdomain>
	 <20071130162232.f4ce14c4.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44195 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbXLABUZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2007 20:20:25 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB11KOgn002477
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2007 20:20:24 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB11KOLw138432
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2007 20:20:24 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB11KNj0024004
	for <linux-ext4@vger.kernel.org>; Fri, 30 Nov 2007 20:20:24 -0500
In-Reply-To: <20071130162232.f4ce14c4.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-11-30 at 16:22 -0800, Andrew Morton wrote:
> On Fri, 30 Nov 2007 16:17:32 -0800
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Thanks for resending the patches. The first three patches in this series
> > were missed in the ext4 patch queue, the rest of them are already queued
> > there.  They are all in ext4 patch queue now. I will check other ext4
> > patches you plan to merge to mm tree and get them sync in ext4 tree.
> > 
> > http://repo.or.cz/w/ext4-patch-queue.git
> > git://repo.or.cz/ext4-patch-queue.git
> 
> What's all this about?  
That is the latest ext4 patch queue ( quilt format patches, not full
ext4 source tree).

> I've always been pulling
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/
> (and continuously fixing the same rejects each time).
> 
> 
Ted periodically pull patches from the latest ext4 patch queue on
repo.or.cz, after they had survive fs tests, then, release the ext4
patches on kernel.org (the one you pulled from). I believe Ted is on
vacation now.....

Mingming
