From: Andreas Dilger <adilger@sun.com>
Subject: Re: Lustre basic tests script
Date: Sun, 21 Jun 2009 13:19:11 +0200
Message-ID: <20090621111911.GB11977@webber.adilger.int>
References: <20090522213639.GC13578@webber.adilger.int>
 <bb33bcf20905230403n2e959d8fg1f463539b7cdb445@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org,
	LTP <ltp-list@lists.sourceforge.net>
To: Subrata Modak <tosubrata@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43282 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZFULTt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jun 2009 07:19:49 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5LBJZcd028153
	for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2009 04:19:50 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KLL0020062E9Y00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sun,
 21 Jun 2009 04:19:35 -0700 (PDT)
In-reply-to: <bb33bcf20905230403n2e959d8fg1f463539b7cdb445@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 23, 2009  16:33 +0530, Subrata Modak wrote:
> On Sat, May 23, 2009 at 3:06 AM, Andreas Dilger <adilger@sun.com> wrote:
> 
> > Below are included some of the tests from the Lustre "sanity.sh" script,
> > which tests filesystem behaviour in a variety of ways.  Some of them are
> > very simple and might concievably be removed, but are not necessarily bad.
> > I've removed the tests that depend on Lustre-specific behaviour.
> >
> > It probably isn't useful to use this test script directly, since it
> > depends on a number of helper functions, but it is definitely useful
> > as a starting point for adding new tests to xfstests.
> >
> > Unfortunately, a bunch of tests had to be removed since they depend on
> > Lustre's fault-injection code, but they would be useful for testing
> > generic filesystem behaviour (e.g. ENOMEM or ENOSPC handling).  There
> > is also a helper program we use "multiop" which is a toolbox program
> > that I could supply separately, if you want.
> 
> 
> How about understanding these and find out if they can be made part of LTP
> as well  ? Any objection(s) ?

Sorry for the late response.  No objection to using these tests in LTP.
I've separatel posted the "multiop" program to this list so that you
can better understand what the tests are doing.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

