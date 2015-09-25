From: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Fri, 25 Sep 2015 13:50:22 +0300
Message-ID: <1443178222.10230.10.camel@gmail.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
	 <1434495193-31182-3-git-send-email-tj@kernel.org>
	 <20150722035620.GD2944@thunk.org> <1443012552.19983.209.camel@gmail.com>
	 <20150923180934.GE26647@mtj.duckdns.org>
	 <20150923185137.GJ26647@mtj.duckdns.org>
	 <20150923210729.GA23180@mtj.duckdns.org>
	 <1443082186.19983.234.camel@gmail.com>
	 <20150924204529.GF25415@mtj.duckdns.org>
	 <1443163749.19983.254.camel@gmail.com>
Reply-To: dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org,
	kernel-team-b10kYP2dOMg@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443163749.19983.254.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2015-09-25 at 09:49 +0300, Artem Bityutskiy wrote:
> On Thu, 2015-09-24 at 16:45 -0400, Tejun Heo wrote:
> > Hello, Artem.
> >=20
> > On Thu, Sep 24, 2015 at 11:09:46AM +0300, Artem Bityutskiy wrote:
> > > On Wed, 2015-09-23 at 17:07 -0400, Tejun Heo wrote:
> > > > So, this should make the regression go away.  It doesn't fix
> > > > the
> > > > underlying bugs but they shouldn't get triggered by people not
> > > > experimenting with cgroup.
> > >=20
> > > this hits the nail on the head and makes the problem go away.
> >=20
> > Yeah but there still is an underlying problem here.  I've been
> > going
> > through the sync path today but can't trigger or spot anything
> > wrong.
> > Can you please apply the patch at the end of this mail, trigger the
> > failure and report the kernel log?
> >=20
> > Thanks a lot.
>=20
> Does not compile with multiple errors like
>=20
> linux/fs/fs-writeback.c:799:10: error: =E2=80=98struct bdi_writeback=E2=
=80=99 has no
> member named =E2=80=98last_comp_gen=E2=80=99
>    bdi->wb.last_comp_gen =3D bdi->wb.comp_gen;

I tried to extend your patch with these fields, but I am not sure I got
it right, so please, send a new patch, I'll run the reboot corruption
test with your patch.

Please, note, because this test is about reboots, I'll probably output
everything to the serial console. Therefore, please, do not print too
much data. Otherwise I'd have to modify my scripts to collect dmesg
before restarting, which is more work.

Artem.
