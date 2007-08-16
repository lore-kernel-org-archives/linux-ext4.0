From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: Patches for patch queue
Date: Thu, 16 Aug 2007 10:45:20 -0500
Message-ID: <1187279120.6811.15.camel@norville.austin.ibm.com>
References: <46C3FA2D.9050200@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51709 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbXHPPpX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Aug 2007 11:45:23 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7GFjMBQ009913
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 11:45:22 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7GFjMHj375804
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 11:45:22 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7GFjLxK021486
	for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2007 11:45:22 -0400
In-Reply-To: <46C3FA2D.9050200@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-08-16 at 12:48 +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> Can we get the below patches in patch queue.
> 
> 
> http://www.radian.org/~kvaneesh/ext4/patch-series/ext-truncate-mutex.patch
> http://www.radian.org/~kvaneesh/ext4/patch-series/ext3-4-migrate.patch
> http://www.radian.org/~kvaneesh/ext4/patch-series/new-extent-function.patch
> http://www.radian.org/~kvaneesh/ext4/patch-series/mballoc-core.patch
> http://www.radian.org/~kvaneesh/ext4/patch-series/mballoc-fixup.patch

scripts/checkpatch.pl spits out a lot of warnings against these patches.
Do you think you can clean them up first?

Thanks,
Shaggy

> # This series applies on GIT commit 39d3520c92cf7a28c07229ca00cc35a1e8026c77
> ext4-journal_chksum-2.6.20.patch
> ext4-journal-chksum-review-fix.patch
> 64-bit-i_version.patch
> i_version_hi.patch
> ext4_i_version_hi_2.patch
> i_version_update_ext4.patch
> jbd-stats-through-procfs
> jbd-stats-through-procfs_fix.patch
> delalloc-vfs.patch
> delalloc-ext4.patch
> ext-truncate-mutex.patch
> ext3-4-migrate.patch
> new-extent-function.patch
> mballoc-core.patch
> mballoc-fixup.patch
> 
> 
> I have added then towards the end of the series based on the comment from Alex
> that mballoc need further cleanup and he likes to finish with delayed allocation first.
> 
> 
> -aneesh 
-- 
David Kleikamp
IBM Linux Technology Center
