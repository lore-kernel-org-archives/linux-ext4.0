From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: start seraching for the right extent from the	goal
 group.
Date: Fri, 02 May 2008 11:53:19 -0700
Message-ID: <20080502185319.GG2950@webber.adilger.int>
References: <1209554186-6251-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <48186CFB.8050206@redhat.com> <20080501153747.GA7005@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	cmm@us.ibm.com, tytso@mit.edu
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62361 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbYEBSxX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 May 2008 14:53:23 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m42IrMtU002431
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 11:53:22 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K0900M018C2O800@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 02 May 2008 11:53:22 -0700 (PDT)
In-reply-to: <20080501153747.GA7005@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 01, 2008  21:07 +0530, Aneesh Kumar K.V wrote:
> On Wed, Apr 30, 2008 at 07:58:35AM -0500, Eric Sandeen wrote:
> > Aneesh Kumar K.V wrote:
> > > With mballoc we search for the best extent using different
> > > criteria. We should always use the goal group when we are
> > > starting with a new criteria.
> > 
> > Aneesh, is there any testcase etc that will demonstrate the resulting
> > difference in layout?
> > 
> > It's not clear to me from this changelog (without looking at a lot more
> > context) exactly what you're changing and why...
> 
> I don't have any specific test case.  With mballoc depending on the
> request size we follow different criteria to allocate blocks. For
> example if the size is stripe size multiple we use criteria 1 and start
> searching for the right blocks from block group starting with goal
> group. If we don't find right count of blocks, we use criteria 2 and start
> searching from the group block 0. I guess with criteria 2 also, we should start
> searching from the goal group so that when we find the right count of
> blocks we find them close to the goal group.

This makes sense to me.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

