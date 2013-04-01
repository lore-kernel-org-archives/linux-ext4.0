From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
Date: Mon, 01 Apr 2013 10:07:35 +0400
Message-ID: <87ip46ss0o.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:38937 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab3DAGHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2013 02:07:41 -0400
In-Reply-To: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 29 Mar 2013 05:27:02 -0400 (EDT), CAI Qian <caiqian@redhat.com>=
 wrote:
>=20
I've spent a half of weekend by trying to create s390x guest image,
without any success. Can you please share it.
>=20
> ----- Original Message -----
> > From: "Theodore Ts'o" <tytso@mit.edu>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-s390" <linux-s390=
@vger.kernel.org>, "Steve Best"
> > <sbest@redhat.com>, linux-ext4@vger.kernel.org
> > Sent: Thursday, March 28, 2013 8:05:17 PM
> > Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
> >=20
> > On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> > > System hung when running xfstests-dev 013 test case on an s390x
> > > guest. Never saw
> > > this on 3.9-rc3 before but need to double-check. Any idea?
> > >=20
> > > =C3=9D 1113.795759=C2=A8 ------------=C3=9D cut here =C2=A8------=
------
> > > =C3=9D 1113.795771=C2=A8 kernel BUG at fs/ext4/inode.c:1591!
> >=20
> > thanks for the report.  What kernel version did this come from?  Wa=
s
> > it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).
> Yes, the lastest mainline.
> >=20
> > If it is indeed 3.9-rc4, it would be helpful, since you can reprodu=
ce
> > the problem, to insert a debugging printk which fires when
> > bh->b_blocknr !=3D pblock before the BUG_ON, and have it print the
> > b_blocknr and pblock values.
> bh->b_blocknr=3D100346
> pblock=3D66797
>=20
> Bisecting results so far,
> git bisect start
> # good: [a937536b868b8369b98967929045f1df54234323] Linux 3.9-rc3
> git bisect good a937536b868b8369b98967929045f1df54234323
> # bad: [9064171268d838b8f283fe111ef086b9479d059a] Merge tag 'for-linu=
s' of git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes
> git bisect bad 9064171268d838b8f283fe111ef086b9479d059a
> # bad: [38d78e587d4960d0db94add518d27ee74bad2301] mqueue: sys_mq_open=
: do not call mnt_drop_write() if read-only
> git bisect bad 38d78e587d4960d0db94add518d27ee74bad2301
> # good: [e7489622d3603b7d161b484dcd340d9f678b0c7a] Merge tag 'arm64-f=
ixes' of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-a=
arch64
> git bisect good e7489622d3603b7d161b484dcd340d9f678b0c7a
> # good: [172a271b5e090da7468c66b9ccbcdb3d929eed75] Merge branch 'drm-=
fixes' of git://people.freedesktop.org/~airlied/linux
> git bisect good 172a271b5e090da7468c66b9ccbcdb3d929eed75
> # good: [0a7e453103b9718d357688b83bb968ee108cc874] Merge branch 'next=
' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux
> git bisect good 0a7e453103b9718d357688b83bb968ee108cc874
> # bad: [0e401101db49959f5783f6ee9e676124b5a183ac] ext4: fix memory le=
akage in mext_check_coverage
> git bisect bad 0e401101db49959f5783f6ee9e676124b5a183ac
> CAI Qian
> >=20
> > Thanks,
> >=20
> > 						- Ted
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
