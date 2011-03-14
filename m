From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30872] Calling kfree() for uninitialized pointer in
 ext4_mb_init_backend()
Date: Mon, 14 Mar 2011 14:23:31 GMT
Message-ID: <201103141423.p2EENVBC005287@demeter1.kernel.org>
References: <bug-30872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56551 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1CNOXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 10:23:32 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2EENVWS005288
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2011 14:23:32 GMT
In-Reply-To: <bug-30872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D30872


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |sandeen@redhat.com




--- Comment #2 from Eric Sandeen <sandeen@redhat.com>  2011-03-14 14:23=
:29 ---
(In reply to comment #1)

=2E..

> > If ext4_mb_add_groupinfo() fails for some reason (e.g. if memory al=
location at
> > line 2296 fails), ext4_mb_init_backend() tries to call kfree() for =
each
> > element in sbi->s_group_info array, including the ones that have no=
t been
> > initialized yet:
> >
> > fs/ext4/mballoc.c:2414:
> > err_freebuddy:
> > =C2=A0 =C2=A0cachep =3D get_groupinfo_cache(sb->s_blocksize_bits);
> > =C2=A0 =C2=A0while (i-- > 0)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0kmem_cache_free(cachep, ext4_get_group_i=
nfo(sb, i));
> > =C2=A0 =C2=A0i =3D num_meta_group_infos;
> > =C2=A0 =C2=A0while (i-- > 0)
>=20
> literally understand, should be
> while (--i >=3D 0)
>=20
> Could you try with above?

Hm, that probably is the most direct fix.

I sent a patch here:
http://marc.info/?l=3Dlinux-ext4&m=3D129979820301087&w=3D2
which initializes all the pointers to NULL and only frees if they are n=
on-NULL,=20
which may be more foolproof, but might also be overkill.

-Eric

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
