From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 compile bench is slower
Date: Fri, 25 Jul 2008 18:00:16 -0400
Message-ID: <20080725215901.GA3181@webber.adilger.int>
References: <20080709165655.GB29109@skywalker>
 <20080709215728.GD6239@webber.adilger.int> <20080710042453.GA6764@skywalker>
 <20080714144442.GA1041@skywalker> <20080714100153.0f9756e3@ichigo>
 <20080721222357.56471dd5@gara> <20080723005850.GF19325@webber.adilger.int>
 <20080723083033.4bdddf08@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36730 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYGYWAi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2008 18:00:38 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6PM0P5r010485
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 15:00:36 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4L00C0113B4N00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 25 Jul 2008 15:00:25 -0700 (PDT)
In-reply-to: <20080723083033.4bdddf08@gara>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 23, 2008  08:30 -0500, Jose R. Santos wrote:
> On Tue, 22 Jul 2008 18:58:50 -0600
> Andreas Dilger <adilger@sun.com> wrote:
> > Jose, do you have ext3 results on the same system
> > for the benchmarks you ran?  That would tell us how much improvement we
> > get from other ext4 features (e.g. extents vs. block allocation) and how
> > much from flex_bg.
> 
> No I dont, I tried doing some runs yesterday but after updating the
> kernel, the results flex_bg are about the same as without it and ext3
> is a lot faster than ext4.  Im investigating to see if I messed up the
> kernel build somehow or if we have a regression.

There was another report that the current ext4 code is no longer faster
at compilebench than ext3.

> Valerie did a very comprehensive set of comparisons that could be
> useful for the presentation.  I'll try to see if I can recreate this
> once I figure out the regression im seeing but would this work for now?
> 
> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

