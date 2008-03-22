From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
Date: Sat, 22 Mar 2008 18:38:47 +0100
Message-ID: <1206207527.6437.83.camel@lappy>
References: <200803221437.m2MEbO5H003869@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Erez Zadok <ezk@cs.sunysb.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46055 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbYCVRjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Mar 2008 13:39:41 -0400
In-Reply-To: <200803221437.m2MEbO5H003869@agora.fsl.cs.sunysb.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-03-22 at 10:37 -0400, Erez Zadok wrote:
> I was building a kernel using "make -j 4" inside a unionfs, mounted on top
> of ext3.  The kernel is vanilla 2.6.25-rc6 plus unionfs patches.  At some
> point I forced a cache flush using "echo 3 > /proc/sys/vm/drop_caches" and I
> got the lockdep warning below.  Note that unionfs doesn't appear to be
> involved in this lockdep warning at all, so I suspect this is probably an
> issue between jbd and ext3 directly.

Known issue, drop_caches isn't production quality.

