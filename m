From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 13:03:40 -0500
Message-ID: <20080716130340.4a9646a5@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
	<87ej5ugcn2.fsf@frosties.localdomain>
	<20080716091846.44174452@ichigo>
	<877ibl97jy.fsf@frosties.localdomain>
	<20080716110242.7cffffa5@ichigo>
	<20080716171824.GE2167@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60487 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYGPSDq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2008 14:03:46 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GI3hsb025460
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 14:03:43 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GI3g5U205906
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 14:03:42 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GI3g8V003088
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 14:03:42 -0400
In-Reply-To: <20080716171824.GE2167@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jul 2008 13:18:24 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Jul 16, 2008 at 11:02:42AM -0500, Jose R. Santos wrote:
> > > PS: Should functions that chop off upper bits like that make sure they
> > > are 0?
> > 
> > I think this is something that need to be cheched at fsck since having
> > these be non-zero on a non-64-bit FS should be pointing to file system
> > corruption.  Not sure if its something that need to be done every time
> > we set a value on the lower bit only though.
> 
> Well, to quote Postel's law (also known as the robustness principle):
> "Be conservative in what you do; be liberal in what you accept from
> others."  
> 
> This is a generalization from what Jon Postel wrote in RFC 793: "TCP
> implementations will follow a general principle of robustness: be
> conservative in what you do, be liberal in what you accept from
> others," but it applies here as well.  So yes, the library code should
> clear the upper bits even if 64-bit feature flag is not set.  However,
> we should not depend on the upper bits being zero if the 64-bit
> feature flag is not set.
> 
> Does that make sense?

Set it; don't check it.  Got it.

I'll just check for large descriptors instead of the 64-bit feature
flag.  That should set the upper bit regardless of whether we use a
64bit fs or not.

> 
> 					- Ted
> 

-JRS
