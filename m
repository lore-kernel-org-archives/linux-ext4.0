From: Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: Re: [LTP] Lustre basic tests script
Date: Tue, 23 Jun 2009 20:20:45 +0530
Message-ID: <1245768646.4860.93.camel@subratamodak.linux.ibm.com>
References: <20090522213639.GC13578@webber.adilger.int>
	 <bb33bcf20905230403n2e959d8fg1f463539b7cdb445@mail.gmail.com>
	 <20090621111911.GB11977@webber.adilger.int>
Reply-To: subrata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Subrata Modak <tosubrata@gmail.com>,
	LTP <ltp-list@lists.sourceforge.net>, linux-ext4@vger.kernel.org,
	Eric Sandeen <esandeen@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35730 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbZFWPNw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Jun 2009 11:13:52 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5NFGtaH015253
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 11:16:55 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5NFDnjb1134742
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 11:13:49 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5NFDme7007205
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2009 09:13:48 -0600
In-Reply-To: <20090621111911.GB11977@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2009-06-21 at 13:19 +0200, Andreas Dilger wrote: 
> On May 23, 2009  16:33 +0530, Subrata Modak wrote:
> > On Sat, May 23, 2009 at 3:06 AM, Andreas Dilger <adilger@sun.com> wrote:
> > 
> > > Below are included some of the tests from the Lustre "sanity.sh" script,
> > > which tests filesystem behaviour in a variety of ways.  Some of them are
> > > very simple and might concievably be removed, but are not necessarily bad.
> > > I've removed the tests that depend on Lustre-specific behaviour.
> > >
> > > It probably isn't useful to use this test script directly, since it
> > > depends on a number of helper functions, but it is definitely useful
> > > as a starting point for adding new tests to xfstests.
> > >
> > > Unfortunately, a bunch of tests had to be removed since they depend on
> > > Lustre's fault-injection code, but they would be useful for testing
> > > generic filesystem behaviour (e.g. ENOMEM or ENOSPC handling).  There
> > > is also a helper program we use "multiop" which is a toolbox program
> > > that I could supply separately, if you want.
> > 
> > 
> > How about understanding these and find out if they can be made part of LTP
> > as well  ? Any objection(s) ?
> 
> Sorry for the late response.  No objection to using these tests in LTP.

Thanks Andreas. When ready we will send you the integration patch for
your review.

Regards--
Subrata

> I've separatel posted the "multiop" program to this list so that you
> can better understand what the tests are doing.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> 
> ------------------------------------------------------------------------------
> Are you an open source citizen? Join us for the Open Source Bridge conference!
> Portland, OR, June 17-19. Two days of sessions, one day of unconference: $250.
> Need another reason to go? 24-hour hacker lounge. Register today!
> http://ad.doubleclick.net/clk;215844324;13503038;v?http://opensourcebridge.org
> _______________________________________________
> Ltp-list mailing list
> Ltp-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ltp-list

