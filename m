From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4 compile bench is slower
Date: Fri, 25 Jul 2008 17:58:57 -0700
Message-ID: <1217033937.6394.7.camel@mingming-laptop>
References: <20080709165655.GB29109@skywalker>
	 <20080709215728.GD6239@webber.adilger.int>
	 <20080710042453.GA6764@skywalker> <20080714144442.GA1041@skywalker>
	 <20080714100153.0f9756e3@ichigo> <20080721222357.56471dd5@gara>
	 <20080723005850.GF19325@webber.adilger.int> <20080723083033.4bdddf08@gara>
	 <20080725215901.GA3181@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:33453 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYGZA7I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2008 20:59:08 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6Q0x7gT017713
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 20:59:07 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6Q0x7CW035730
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 18:59:07 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6Q0x6C6005116
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 18:59:06 -0600
In-Reply-To: <20080725215901.GA3181@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-25=E4=BA=94=E7=9A=84 18:00 -0400=EF=BC=8CAndreas Dilg=
er=E5=86=99=E9=81=93=EF=BC=9A
> On Jul 23, 2008  08:30 -0500, Jose R. Santos wrote:
> > On Tue, 22 Jul 2008 18:58:50 -0600
> > Andreas Dilger <adilger@sun.com> wrote:
> > > Jose, do you have ext3 results on the same system
> > > for the benchmarks you ran?  That would tell us how much improvem=
ent we
> > > get from other ext4 features (e.g. extents vs. block allocation) =
and how
> > > much from flex_bg.
> >=20
> > No I dont, I tried doing some runs yesterday but after updating the
> > kernel, the results flex_bg are about the same as without it and ex=
t3
> > is a lot faster than ext4.  Im investigating to see if I messed up =
the
> > kernel build somehow or if we have a regression.
>=20
> There was another report that the current ext4 code is no longer fast=
er
> at compilebench than ext3.
>=20
> > Valerie did a very comprehensive set of comparisons that could be
> > useful for the presentation.  I'll try to see if I can recreate thi=
s
> > once I figure out the regression im seeing but would this work for =
now?
> >=20
> > http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-r=
c2.html
>=20

Between 2.6.26-rc2 to now the biggest change is the locking ordering
change (page lock and transaction) and the new ordered mode, and the
delalloc get updated to adopt the new locking order. I wonder if that's
the  cause....

Mingming
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
