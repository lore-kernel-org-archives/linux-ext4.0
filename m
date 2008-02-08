From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Fri, 8 Feb 2008 08:44:08 +0530
Message-ID: <20080208031408.GA7111@skywalker>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice> <20080204060055.GC7494@skywalker> <1202335188.6886.15.camel@norville.austin.ibm.com> <20080207125548.GA8701@skywalker> <1202434248.3840.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-ext4@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:56627 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbYBHDOO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2008 22:14:14 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m183E0px011992
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 14:14:00 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m183Ho2L287242
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 14:17:50 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m183EEMo006797
	for <linux-ext4@vger.kernel.org>; Fri, 8 Feb 2008 14:14:15 +1100
Content-Disposition: inline
In-Reply-To: <1202434248.3840.22.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 07, 2008 at 05:30:48PM -0800, Mingming Cao wrote:
> On Thu, 2008-02-07 at 18:25 +0530, Aneesh Kumar K.V wrote:
> 
> > ext4: Don't panic in case of corrupt bitmap
> > 
> > From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > Multiblock allocator was calling BUG_ON in many case if the free and used
> > blocks count obtained looking at the bitmap is different from what
> > the allocator internally accounted for. Use ext4_error in such case
> > and don't panic the system.
> > 
> 
> There seems a lot of BUG_ON() and BUG() in mballoc code, other than this
> case. Should it always panic the whole system in those cases? Perhaps
> replacing with ext4_error() or some cases just WARN_ON is enough.
> 

I had looked at the BUG_ON in mballoc code and found them very useful
while stabilizing the mballoc code. It helped to catch wrong usage of
functions. Most of the BUG_ON are there to make sure we call the API
with the lock held or the API should not return value greater than 'x'
Should not call the function with a particular argument as NULL ...etc
kind of thing. So i would suggest to keep them as such.


-aneesh
