From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: add a variable to record the value of
 map->m_flags in tracepoint
Date: Tue, 16 Oct 2012 18:56:31 +0800
Message-ID: <20121016105631.GA22759@gmail.com>
References: <1350372294-17939-1-git-send-email-wenqing.lz@taobao.com>
 <1350372294-17939-2-git-send-email-wenqing.lz@taobao.com>
 <alpine.LFD.2.00.1210161235530.20184@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40115 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab2JPKp3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2012 06:45:29 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so5790073pad.19
        for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2012 03:45:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1210161235530.20184@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2012 at 12:41:33PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Tue, 16 Oct 2012, Zheng Liu wrote:
>=20
> > Date: Tue, 16 Oct 2012 15:24:54 +0800
> > From: Zheng Liu <gnehzuil.liu@gmail.com>
> > To: linux-ext4@vger.kernel.org
> > Cc: Zheng Liu <wenqing.lz@taobao.com>
> > Subject: [PATCH 2/2] ext4: add a variable to record the value of ma=
p->m_flags
> >     in tracepoint
> >=20
> > From: Zheng Liu <wenqing.lz@taobao.com>
> >=20
> > When we use trace_ext4_ext/ind_map_blocks_exit, we will print the v=
alue of
> > map->m_flags in order that we can understand what currently status =
is.
> >=20
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/extents.c           |  2 +-
> >  fs/ext4/indirect.c          |  4 ++--
> >  include/trace/events/ext4.h | 18 ++++++++++--------
> >  3 files changed, 13 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 4ecc210..204bafa 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4250,7 +4250,7 @@ out2:
> >  	}
> > =20
> >  	trace_ext4_ext_map_blocks_exit(inode, map->m_lblk,
> > -		newblock, map->m_len, err ? err : allocated);
> > +		newblock, map->m_len, map->m_flags, err ? err : allocated);
> > =20
> >  	return err ? err : allocated;
> >  }
> > diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> > index 792e388..a22d296 100644
> > --- a/fs/ext4/indirect.c
> > +++ b/fs/ext4/indirect.c
> > @@ -755,8 +755,8 @@ cleanup:
> >  		partial--;
> >  	}
> >  out:
> > -	trace_ext4_ind_map_blocks_exit(inode, map->m_lblk,
> > -				map->m_pblk, map->m_len, err);
> > +	trace_ext4_ind_map_blocks_exit(inode, map->m_lblk, map->m_pblk,
> > +					map->m_len, map->m_flags, err);
> >  	return err;
> >  }
> > =20
> > diff --git a/include/trace/events/ext4.h b/include/trace/events/ext=
4.h
> > index 66d78dc..680c249b 100644
> > --- a/include/trace/events/ext4.h
> > +++ b/include/trace/events/ext4.h
> > @@ -1520,9 +1520,9 @@ DEFINE_EVENT(ext4__map_blocks_enter, ext4_ind=
_map_blocks_enter,
> > =20
> >  DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
> >  	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> > -		 ext4_fsblk_t pblk, unsigned int len, int ret),
> > +		 ext4_fsblk_t pblk, unsigned int len, int flags, int ret),
>=20
> What about the whole struct ext4_map_blocks instead of m_lblk, m_len
> and m_flags separately ?

Agree.  I will fix it.

>=20
> > =20
> > -	TP_ARGS(inode, lblk, pblk, len, ret),
> > +	TP_ARGS(inode, lblk, pblk, len, flags, ret),
> > =20
> >  	TP_STRUCT__entry(
> >  		__field(	dev_t,		dev		)
> > @@ -1530,6 +1530,7 @@ DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
> >  		__field(	ext4_fsblk_t,	pblk		)
> >  		__field(	ext4_lblk_t,	lblk		)
> >  		__field(	unsigned int,	len		)
> > +		__field(	int,		flags		)
>=20
> map->m_flags is unsigned int.

Oops, I will fix it in second version.
>=20
> >  		__field(	int,		ret		)
> >  	),
> > =20
> > @@ -1539,28 +1540,29 @@ DECLARE_EVENT_CLASS(ext4__map_blocks_exit,
> >  		__entry->pblk	=3D pblk;
> >  		__entry->lblk	=3D lblk;
> >  		__entry->len	=3D len;
> > +		__entry->flags	=3D flags;
> >  		__entry->ret	=3D ret;
> >  	),
> > =20
> > -	TP_printk("dev %d,%d ino %lu lblk %u pblk %llu len %u ret %d",
> > +	TP_printk("dev %d,%d ino %lu lblk %u pblk %llu len %u flags %x re=
t %d",
>=20
> It's better to be consistent. If we agree that using %x for flags is
> better format then be it, but change the first patch as well.

Yes, %x is better.  I will fix it in first patch.

Regards,
Zheng

>=20
> Thanks!
> -Lukas
>=20
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >  		  (unsigned long) __entry->ino,
> >  		  __entry->lblk, __entry->pblk,
> > -		  __entry->len, __entry->ret)
> > +		  __entry->len, __entry->flags, __entry->ret)
> >  );
> > =20
> >  DEFINE_EVENT(ext4__map_blocks_exit, ext4_ext_map_blocks_exit,
> >  	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> > -		 ext4_fsblk_t pblk, unsigned len, int ret),
> > +		 ext4_fsblk_t pblk, unsigned len, int flags, int ret),
> > =20
> > -	TP_ARGS(inode, lblk, pblk, len, ret)
> > +	TP_ARGS(inode, lblk, pblk, len, flags, ret)
> >  );
> > =20
> >  DEFINE_EVENT(ext4__map_blocks_exit, ext4_ind_map_blocks_exit,
> >  	TP_PROTO(struct inode *inode, ext4_lblk_t lblk,
> > -		 ext4_fsblk_t pblk, unsigned len, int ret),
> > +		 ext4_fsblk_t pblk, unsigned len, int flags, int ret),
> > =20
> > -	TP_ARGS(inode, lblk, pblk, len, ret)
> > +	TP_ARGS(inode, lblk, pblk, len, flags, ret)
> >  );
> > =20
> >  TRACE_EVENT(ext4_ext_load_extent,
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
