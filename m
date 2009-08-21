From: Andreas Dilger <adilger@sun.com>
Subject: Re: RFC: guard against more "dangerous" userspace options
Date: Fri, 21 Aug 2009 10:08:06 -0600
Message-ID: <20090821160806.GT5931@webber.adilger.int>
References: <4A81D7EC.2060706@redhat.com>
 <20090820062730.GA23232@skywalker.linux.vnet.ibm.com>
 <4A8D6228.1070006@redhat.com>
 <20090821070252.GA17871@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54476 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbZHUQIE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Aug 2009 12:08:04 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7LG84gR008583
	for <linux-ext4@vger.kernel.org>; Fri, 21 Aug 2009 09:08:05 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOQ00300HOBUV00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Fri,
 21 Aug 2009 09:08:04 -0700 (PDT)
In-reply-to: <20090821070252.GA17871@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 21, 2009  12:32 +0530, Aneesh Kumar wrote:
> On Thu, Aug 20, 2009 at 09:48:08AM -0500, Eric Sandeen wrote:
> > Aneesh Kumar K.V wrote:
> > > On Tue, Aug 11, 2009 at 03:43:24PM -0500, Eric Sandeen wrote:
> > >> I'll keep it short and sweet:
> > >>
> > >> Can we add a consistent "--eatmydata" type of hurdle to jump over before
> > >> people are allowed to use either the so-far-less-tested tools and/or
> > >> options therein?
> > >>
> > >> I'm thinking of, so far:
> > > ......
> > >> tune2fs -I <bigger>
> > > 
> > > I have sent patches which should make this better. Any chance to get
> > > that reviwed and applied
> > 
> > Better, or _safe_?  :)
> > 
> > No offense and I certainly appreciate that work.  If you feel it's
> > robust enough now to safely unleash on users, I'll drop it from my list.  :)
> 
> I am interested in the test results. Getting more users to test would always
> be nice. But it still would help to get a through review.

Adding an inode resize operation into the f_random_corruption test, or
into a similar test that runs with random mkfs parameters, would help
exercise the functionality in ways that a static test does not.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

