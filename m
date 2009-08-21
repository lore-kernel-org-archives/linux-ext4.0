From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: RFC: guard against more "dangerous" userspace options
Date: Fri, 21 Aug 2009 12:32:52 +0530
Message-ID: <20090821070252.GA17871@skywalker.linux.vnet.ibm.com>
References: <4A81D7EC.2060706@redhat.com> <20090820062730.GA23232@skywalker.linux.vnet.ibm.com> <4A8D6228.1070006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:55631 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZHUHCz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Aug 2009 03:02:55 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp01.in.ibm.com (8.14.3/8.13.1) with ESMTP id n7L72sej030890
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2009 12:32:54 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7L72sXo2535620
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2009 12:32:54 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n7L72swO028510
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2009 17:02:54 +1000
Content-Disposition: inline
In-Reply-To: <4A8D6228.1070006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 20, 2009 at 09:48:08AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > On Tue, Aug 11, 2009 at 03:43:24PM -0500, Eric Sandeen wrote:
> >> I'll keep it short and sweet:
> >>
> >> Can we add a consistent "--eatmydata" type of hurdle to jump over before
> >> people are allowed to use either the so-far-less-tested tools and/or
> >> options therein?
> >>
> >> I'm thinking of, so far:
> > ......
> >> tune2fs -I <bigger>
> > 
> > I have sent patches which should make this better. Any chance to get that reviwed and
> > applied
> > 
> > -aneesh
> 
> Better, or _safe_?  :)
> 
> No offense and I certainly appreciate that work.  If you feel it's
> robust enough now to safely unleash on users, I'll drop it from my list.  :)

I am interested in the test results. Getting more users to test would always
be nice. But it still would help to get a through review.


-aneesh
