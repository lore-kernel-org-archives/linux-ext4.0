From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH v2 3/3] ext4: add dio overwrite nolock
Date: Fri, 15 Jun 2012 19:02:20 +0800
Message-ID: <20120615110219.GA8395@gmail.com>
References: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
 <1339644730-6204-4-git-send-email-wenqing.lz@taobao.com>
 <CAFZ0FUXyxKT0cAUzkaMkE+PmoaErikcQDfL4Z_624BeqBR2WGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Tao Ma <tm@tao.ma>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34519 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab2FOKya (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2012 06:54:30 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so3879069dad.19
        for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2012 03:54:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAFZ0FUXyxKT0cAUzkaMkE+PmoaErikcQDfL4Z_624BeqBR2WGw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 15, 2012 at 06:16:29PM +0800, Robin Dong wrote:
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* 'err=3D=3D=
len' means that all of blocks has been preallocated no
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* matter t=
hey are initialized or not. =C2=A0For excluding
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* uninitia=
lized extents, we need to check m_flags. =C2=A0There are
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* two cond=
itions that indicate for initialized extents.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* 1) If we=
 hit extent cache, EXT4_MAP_MAPPED flag is returned;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* 2) If we=
 do a real lookup, non-flags are returned.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* So we sh=
ould check these two conditions.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err =3D=3D l=
en && (!map.m_flags ||
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0map.m_flags & EXT4_=
MAP_MAPPED))
>=20
> If we do a real lookup in ext4_map_blocks, it also return with
> EXT4_MAP_MAPPED flag, the condition should be:
>=20
>                      if (err =3D=3D len && (map.m_flags & EXT4_MAP_MA=
PPED))

Yes, you are right.  I will fix it in next version.

Regards,
Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
