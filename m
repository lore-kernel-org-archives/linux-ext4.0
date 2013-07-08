From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: Try to better reuse recently freed space
Date: Mon, 8 Jul 2013 13:59:51 +0200
Message-ID: <20130708115951.GC5988@quack.suse.cz>
References: <alpine.LFD.2.00.1307041730590.30302@localhost.localdomain>
 <1373269107-9678-1-git-send-email-lczerner@redhat.com>
 <20130708085603.GB5988@quack.suse.cz>
 <alpine.LFD.2.00.1307081108380.1843@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab3GHL7y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jul 2013 07:59:54 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1307081108380.1843@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-07-13 11:24:01, Luk=C3=A1=C5=A1 Czerner wrote:
> On Mon, 8 Jul 2013, Jan Kara wrote:
>=20
> > Date: Mon, 8 Jul 2013 10:56:03 +0200
> > From: Jan Kara <jack@suse.cz>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
> >     Andreas Dilger <adilger.kernel@dilger.ca>
> > Subject: Re: [PATCH v2] ext4: Try to better reuse recently freed sp=
ace
> >=20
> > On Mon 08-07-13 09:38:27, Lukas Czerner wrote:
> > > Currently if the block allocator can not find the goal to allocat=
e we
> > > would use global goal for stream allocation. However the global g=
oal
> > > (s_mb_last_group and s_mb_last_start) will move further every tim=
e such
> > > allocation appears and never move backwards.
> > >=20
> > > This causes several problems in certain scenarios:
> > >=20
> > > - the goal will move further and further preventing us from reusi=
ng
> > >   space which might have been freed since then. This is ok from t=
he file
> > >   system point of view because we will reuse that space eventuall=
y,
> > >   however we're allocating block from slower parts of the spinnin=
g disk
> > >   even though it might not be necessary.
> > > - The above also causes more serious problem for example for thin=
ly
> > >   provisioned storage (sparse images backed storage as well), bec=
ause
> > >   instead of reusing blocks which are already provisioned we woul=
d try
> > >   to use new blocks. This would unnecessarily drain storage free =
blocks
> > >   pool.
> > > - This will also cause blocks to be allocated further from the gi=
ven
> > >   goal than it's necessary. Consider for example truncating, or r=
emoving
> > >   and rewriting the file in the loop. This workload will never re=
use
> > >   freed blocks until we continually claim and free all the block =
in the
> > >   file system.
> > >=20
> > > Note that file systems like xfs, ext3, or btrfs does not have thi=
s
> > > problem. This is simply caused by the notion of global pool.
> > >=20
> > > Fix this by changing the global goal to be goal per inode. This w=
ill
> > > allow us to invalidate the goal every time the inode has been tru=
ncated,
> > > or newly created, so in those cases we would try to use the prope=
r more
> > > specific goal which is based on inode position.
> >   When looking at your patch for second time, I started wondering, =
whether
> > we need per-inode stream goal at all. We already do set goal in the
> > allocation request for mballoc (ar->goal) e.g. in ext4_ext_find_goa=
l().
> > It seems strange to then reset it inside mballoc and I don't even t=
hink
> > mballoc will change it to something else now when the goal is per-i=
node and
> > not global.
>=20
> Yes, we do set the goal in the allocation request and it is supposed
> to be the "best" goal. However sometimes it can not be fulfilled
> because we do not have any free block at "goal".
>=20
> That's when the global (or per-inode) goal comes into play. I suppose
> that there was several reasons for that. First of all it makes it
> easier for allocator, because it can directly jump at the point
> where we allocated last time and it is likely that there is some
> free space to allocate from - so the benefit is that we do not have
> to walk all the space in between which is likely to be allocated.
  Yep, but my question is: If we have per-inode streaming goal, can you
show an example when the "best" goal will be different from the "stream=
ing"
goal? Because from a (I admit rather quick) look at how each of these i=
s
computed, it seems that both will point after the next allocated block =
in
case of streaming IO.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
