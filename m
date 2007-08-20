From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: Patches for patch queue
Date: Mon, 20 Aug 2007 15:21:58 +0000
Message-ID: <1187623318.6471.4.camel@norville.austin.ibm.com>
References: <46C3FA2D.9050200@linux.vnet.ibm.com>
	 <1187279120.6811.15.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37912 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759146AbXHTPWG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Aug 2007 11:22:06 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7KFM5wH029225
	for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2007 11:22:05 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7KFM3JX310108
	for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2007 11:22:03 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7KFM2tU019837
	for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2007 11:22:03 -0400
In-Reply-To: <1187279120.6811.15.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-08-16 at 10:45 -0500, Dave Kleikamp wrote:
> On Thu, 2007-08-16 at 12:48 +0530, Aneesh Kumar K.V wrote:
> > Hi,
> > 
> > Can we get the below patches in patch queue.
> > 
> > 
> > http://www.radian.org/~kvaneesh/ext4/patch-series/ext-truncate-mutex.patch
> > http://www.radian.org/~kvaneesh/ext4/patch-series/ext3-4-migrate.patch
> > http://www.radian.org/~kvaneesh/ext4/patch-series/new-extent-function.patch
> > http://www.radian.org/~kvaneesh/ext4/patch-series/mballoc-core.patch
> > http://www.radian.org/~kvaneesh/ext4/patch-series/mballoc-fixup.patch
> 
> scripts/checkpatch.pl spits out a lot of warnings against these patches.
> Do you think you can clean them up first?

As we discussed, I checked these into the patch queue.  That way they
can be more easily tested in the short term.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
