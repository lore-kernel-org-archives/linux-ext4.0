From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [ltt-dev] LTTng 0.74 for Linux 2.6.28 (ext4 tracepoints)
	(fixed in LTTng 0.78)
Date: Wed, 14 Jan 2009 22:20:14 -0500
Message-ID: <20090115032014.GA10229@Krystal>
References: <20090109235449.GA21999@Krystal> <20090110161137.GA20526@Krystal> <2f11576a0901131433h31056e34n82588a9c643224de@mail.gmail.com> <20090113225827.GA5791@Krystal> <20090114001346.GB14730@mit.edu> <20090115014521.GG7458@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Tso <tytso@mit.edu>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts25.bellnexxia.net ([209.226.175.188]:53419 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050AbZAODUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 22:20:17 -0500
Content-Disposition: inline
In-Reply-To: <20090115014521.GG7458@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Theodore Tso (tytso@mit.edu) wrote:
> > On Tue, Jan 13, 2009 at 05:58:27PM -0500, Mathieu Desnoyers wrote:
> > > >=20
> > > > -ECANTBUILD
> > > >=20
> > > Thanks for the report. This should be fixed in LTTng 0.78 now.
> >=20
> > Out of curiosity, do you maintain a branch of LTTNG versus any of t=
he
> > -rc kernels, or do you only track the stable kernels?  I tried pull=
ing
> > LTTNG 0.78 against the most recent Linus mainline and got a whole p=
ile
> > of conflicts.
> >=20
> > I then tried building LTTng 0.78 and got build failures:
> >=20
> >   CC      arch/x86/kernel/init_task.o
> > distcc[27501] ERROR: compile /var/cache/ccache/init_task.tmp.closur=
e.27497.i on localhost failed
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: unk=
nown field =E2=80=98user_markers_mutex=E2=80=99 specified in initialize=
r
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: warning: b=
races around scalar initializer
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: warning: (=
near initialization for =E2=80=98init_task.latency_record_count=E2=80=99=
)
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: fie=
ld name not in record or union initializer
> > /usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: (ne=
ar initialization for =E2=80=98init_task.latency_record_count=E2=80=99)
> >=20
> > Looks like CONFIG_MARKERS_USERSPAC is busted....
> >=20
>=20
> Hi Ted,
>=20
> I'm currently integrating Lai's work to the 2.6.28 lttng branch (asci=
i
> output !) :) and the next step will be to move to 2.6.29-rc1. I'll ke=
ep
> you posted. Note that you can just leave the=20
>=20
> #New revamped userspace markers
>=20
> markers-userspace.patch
> markers-userspace-x86.patch
> markers-userspace-x86_64.patch
> sparc64-support-userspace-tracing.patch
>=20
> Out of the patchset and it should not hurt the kernel tracing part at
> all.=C2=A0Note that these 4 patches are planned to be heavily reworke=
d before
> lkml submission.
>

Actually, the x86_32 2.6.28 build was broken because of a bad patch
hunk which caused this problem. I fixed it in lttng 0.81. The port to
2.6.29-rc1 should some in a few days.

Thanks for the report,

Mathieu

> Mathieu
>=20
> > 						- Ted
> >=20
>=20
> --=20
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BA=
E 9A68
>=20
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev

--=20
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE =
9A68
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
