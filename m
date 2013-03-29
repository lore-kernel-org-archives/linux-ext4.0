From: CAI Qian <caiqian@redhat.com>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
Date: Fri, 29 Mar 2013 05:27:02 -0400 (EDT)
Message-ID: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com>
References: <20130328120517.GB5737@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130328120517.GB5737@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



----- Original Message -----
> From: "Theodore Ts'o" <tytso@mit.edu>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-s390" <linux-s390@v=
ger.kernel.org>, "Steve Best"
> <sbest@redhat.com>, linux-ext4@vger.kernel.org
> Sent: Thursday, March 28, 2013 8:05:17 PM
> Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
>=20
> On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> > System hung when running xfstests-dev 013 test case on an s390x
> > guest. Never saw
> > this on 3.9-rc3 before but need to double-check. Any idea?
> >=20
> > =C3=9D 1113.795759=C2=A8 ------------=C3=9D cut here =C2=A8--------=
----
> > =C3=9D 1113.795771=C2=A8 kernel BUG at fs/ext4/inode.c:1591!
>=20
> thanks for the report.  What kernel version did this come from?  Was
> it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).
Yes, the lastest mainline.
>=20
> If it is indeed 3.9-rc4, it would be helpful, since you can reproduce
> the problem, to insert a debugging printk which fires when
> bh->b_blocknr !=3D pblock before the BUG_ON, and have it print the
> b_blocknr and pblock values.
bh->b_blocknr=3D100346
pblock=3D66797

Bisecting results so far,
git bisect start
# good: [a937536b868b8369b98967929045f1df54234323] Linux 3.9-rc3
git bisect good a937536b868b8369b98967929045f1df54234323
# bad: [9064171268d838b8f283fe111ef086b9479d059a] Merge tag 'for-linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes
git bisect bad 9064171268d838b8f283fe111ef086b9479d059a
# bad: [38d78e587d4960d0db94add518d27ee74bad2301] mqueue: sys_mq_open: =
do not call mnt_drop_write() if read-only
git bisect bad 38d78e587d4960d0db94add518d27ee74bad2301
# good: [e7489622d3603b7d161b484dcd340d9f678b0c7a] Merge tag 'arm64-fix=
es' of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aar=
ch64
git bisect good e7489622d3603b7d161b484dcd340d9f678b0c7a
# good: [172a271b5e090da7468c66b9ccbcdb3d929eed75] Merge branch 'drm-fi=
xes' of git://people.freedesktop.org/~airlied/linux
git bisect good 172a271b5e090da7468c66b9ccbcdb3d929eed75
# good: [0a7e453103b9718d357688b83bb968ee108cc874] Merge branch 'next' =
of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
git bisect good 0a7e453103b9718d357688b83bb968ee108cc874
# bad: [0e401101db49959f5783f6ee9e676124b5a183ac] ext4: fix memory leak=
age in mext_check_coverage
git bisect bad 0e401101db49959f5783f6ee9e676124b5a183ac
CAI Qian
>=20
> Thanks,
>=20
> 						- Ted
>=20
