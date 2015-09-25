From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Fri, 25 Sep 2015 09:49:09 +0300
Message-ID: <1443163749.19983.254.camel@gmail.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
	 <1434495193-31182-3-git-send-email-tj@kernel.org>
	 <20150722035620.GD2944@thunk.org> <1443012552.19983.209.camel@gmail.com>
	 <20150923180934.GE26647@mtj.duckdns.org>
	 <20150923185137.GJ26647@mtj.duckdns.org>
	 <20150923210729.GA23180@mtj.duckdns.org>
	 <1443082186.19983.234.camel@gmail.com>
	 <20150924204529.GF25415@mtj.duckdns.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150924204529.GF25415@mtj.duckdns.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2015-09-24 at 16:45 -0400, Tejun Heo wrote:
> Hello, Artem.
>=20
> On Thu, Sep 24, 2015 at 11:09:46AM +0300, Artem Bityutskiy wrote:
> > On Wed, 2015-09-23 at 17:07 -0400, Tejun Heo wrote:
> > > So, this should make the regression go away.  It doesn't fix the
> > > underlying bugs but they shouldn't get triggered by people not
> > > experimenting with cgroup.
> >=20
> > this hits the nail on the head and makes the problem go away.
>=20
> Yeah but there still is an underlying problem here.  I've been going
> through the sync path today but can't trigger or spot anything wrong.
> Can you please apply the patch at the end of this mail, trigger the
> failure and report the kernel log?
>=20
> Thanks a lot.

Does not compile with multiple errors like

linux/fs/fs-writeback.c:799:10: error: =E2=80=98struct bdi_writeback=E2=
=80=99 has no member named =E2=80=98last_comp_gen=E2=80=99
   bdi->wb.last_comp_gen =3D bdi->wb.comp_gen;
          ^



--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
