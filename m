From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: Re: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Wed, 24 Sep 2008 14:57:28 +0200
Message-ID: <1222261048.3511.23.camel@frecb007923.frec.bull.fr>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
	 <1221481007.6733.32.camel@frecb007923.frec.bull.fr>
	 <20080915133604.GA6548@skywalker>
	 <1221489026.6733.36.camel@frecb007923.frec.bull.fr>
	 <1221745514.3550.83.camel@frecb007923.frec.bull.fr>
	 <20080921004451.GA15402@mit.edu>
	 <1222070998.3581.25.camel@frecb007923.frec.bull.fr>
	 <20080922084721.GA6691@skywalker>
	 <1222075960.3581.33.camel@frecb007923.frec.bull.fr>
	 <20080923231346.GT10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47620 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIXM4I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Sep 2008 08:56:08 -0400
In-Reply-To: <20080923231346.GT10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le mardi 23 septembre 2008 =C3=A0 17:13 -0600, Andreas Dilger a =C3=A9c=
rit :
> On Sep 22, 2008  11:32 +0200, Fr=EF=BF=BDd=EF=BF=BDric Boh=EF=BF=BD w=
rote:
> > Le lundi 22 septembre 2008 =C3=A0 14:17 +0530, Aneesh Kumar K.V a =C3=
=A9crit :
> > > What you can do is make ext4_group_info generic for both mballoc =
and
> > > oldalloc. We can then add bg_flag to the in memory ext4_group_inf=
o
> > > that would indicate whether the group is initialized or not. Here
> > > initialized for an UNINIT_GROUP indicate we have done
> > > ext4_init_block_bitmap on the buffer_head. Then=20
> > > instead of depending on the buffer_head uptodate flag we can chec=
k
> > > for the ext4_group_info bg_flags and decided whether the block/in=
ode
> > > bitmap need to be initialized.
> >=20
> > That makes sense ! I agree with you, we need an additional in-memor=
y
> > flag to know whether buffers are initialized or not. Anyway, making
> > ext4_group_info generic will lead to unneeded memory consumption fo=
r
> > oldalloc. Maybe a simple independent bits array could do the trick.=
 Is
> > there any advantage to re-use ext4_group_info ?
>=20
> For ext4 I think 99% of users will use mballoc, and the reduction in =
code
> complexity is itself useful.  I don't think the in-memory overhead is=
 very
> much, maybe 1 MB per TB of filesystem space.
>=20

You are right ext4_group_info structure was not as big as I thought.
Do you mean that making ext4_group_info generic for both mballoc and
oldalloc will reduce the code complexity ?

> Also, if you are considering this approach (to initialize the in-memo=
ry
> bitmaps at mount time) they should be written to disk even if unused.
> Please also consider doing the inode table zeroing at the same time.
> This would allow uninit_bg to avoid doing it at mke2fs time.

In fact, I was not considering doing this at mount time, but it could b=
e
a good approach.
Anyway, I don't understand why we should write bitmaps to disk after
that, and why we should zeroing the inode table.  Don't we end up with =
a
fast mkfs and a slow mount doing all the stuff older mkfs was doing ?
The UNINIT feature would become less interesting.

Regards,
=46rederic



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
