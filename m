From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC error returned too late
Date: Mon, 18 Aug 2008 09:44:53 -0700
Message-ID: <1219077893.8135.0.camel@mingming-laptop>
References: <E1KUhkt-0003yw-Sf@closure.thunk.org>
	 <20080818093026.GA7808@skywalker> <20080818105140.GB7808@skywalker>
	 <20080818133046.GA8184@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60957 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbYHRQoz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Aug 2008 12:44:55 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7IGisd3024226
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 12:44:54 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7IGisQw202726
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 12:44:54 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7IGirxQ014115
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 12:44:53 -0400
In-Reply-To: <20080818133046.GA8184@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-18=E4=B8=80=E7=9A=84 09:30 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Mon, Aug 18, 2008 at 04:21:40PM +0530, Aneesh Kumar K.V wrote:
> > --- a/fs/ext4/balloc.c
> > +++ b/fs/ext4/balloc.c
> > @@ -1628,6 +1628,9 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4=
_sb_info *sbi,
> >  		free_blocks =3D
> >  			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
> >  #endif
> > +	if (free_blocks <=3D root_blocks)
> > +		/* we don't have free space */
> > +		return 0;
> >  	if (free_blocks - root_blocks < nblocks)
> >  		return free_blocks - root_blocks;
> >  	return nblocks;
>=20
> Thanks, I'll try it out.  Given that ext4_fsblk_t is an unsigned long
> (BTW, this is one of the reasons why the common coding style guide
> dislikes typedefs; it hides this kind of errors), it's obviously a
> good patch to add regardless of whether it solves are problem, since
> if freeblocks < root_blocks, the following condition is going to do
> the Wrong Thing.
>=20

Thanks for catching this Aneesh, agreed.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>=20
> 						- Ted
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
