From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Fri, 25 Jul 2008 12:38:45 -0700
Message-ID: <1217014725.6322.32.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723011802.GB20749@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:44386 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYGYTjB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2008 15:39:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6PJcoaB015892
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 15:38:50 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6PJcngb027978
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 13:38:49 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6PJcmwe005444
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 13:38:49 -0600
In-Reply-To: <20080723011802.GB20749@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-22=E4=BA=8C=E7=9A=84 19:18 -0600=EF=BC=8CAndreas Dilg=
er=E5=86=99=E9=81=93=EF=BC=9A
> On Jul 22, 2008  17:51 -0700, Mingming Cao wrote:
> > + * Calulate the total number of credits to reserve to fit
> > + * the modification of @num pages into a single transaction
> > + */
> > +int ext4_writepages_trans_blocks(struct inode *inode, int num)
> > +{
> > +	int bpp =3D ext4_journal_blocks_per_page(inode);
> > +	int nrblocks =3D num * bpp;
> > +
> > +	if (!EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> > +		return ext4_writepages_trans_blocks_old(inode, nrblocks);
>=20
> This should be "if (!(EXT4_I(inode)->i_flags & EXT_EXTENTS_FL))",
Thanks for catching this.

Mingming


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
