From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 15:02:42 -0700
Message-ID: <1219269762.7895.52.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
	 <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
	 <1219265808.7895.14.camel@mingming-laptop> <20080820215542.GD16634@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49479 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbYHTWDa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 18:03:30 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KM5Rp9005421
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 18:05:27 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KM2g1a238566
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 18:02:42 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KM2gwL010416
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 18:02:42 -0400
In-Reply-To: <20080820215542.GD16634@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 17:55 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Wed, Aug 20, 2008 at 01:56:48PM -0700, Mingming Cao wrote:
> > > BTW, I was looking at the percpu_counter interface, and I'm confu=
sed
> > > why we have percpu_counter_sum_and_set() and percpu_counter_sum()=
=2E  If
> > > we're taking the fbc->lock to calculate the precise value of the
> > > counter, why not simply set fbc->count? =20
> >=20
> > I added the percpu_count_sum_and _set() interface, when addingdelal=
loc
> > block reservation. I agree it make sense to clean up current all th=
e
> > user of percpu_counter_sum() and replace with
> > percpu_counter_sum_and_set(), just hasn't get chance to clean up ye=
t.
>=20
> Why not make percpu_counter_sum() always do sum_and_set, and change
> the ext4 calls to use percpu_counter_sum()?  In fact, I'm wondering

I will clean this up.
> why you didn't do that in the first place?  Was that your trying to b=
e
> as conservative as possible with respect to not changing things?

Yeah, I think I am being over cautious, try not to impact to other user
of percpu_counter_sum()... no more excuse:)


Mingming
>=20
>    		   	    	 	    - Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
