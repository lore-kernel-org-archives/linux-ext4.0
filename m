From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
Date: Thu, 28 Mar 2013 18:56:37 +0400
Message-ID: <87ppyjd13u.fsf@openvz.org>
References: <863434221.7624846.1364452822093.JavaMail.root@redhat.com> <356372233.7624880.1364452833412.JavaMail.root@redhat.com> <20130328120517.GB5737@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, CAI Qian <caiqian@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130328120517.GB5737@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 28 Mar 2013 08:05:17 -0400, Theodore Ts'o <tytso@mit.edu> wrote=
:
> On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> > System hung when running xfstests-dev 013 test case on an s390x gue=
st. Never saw
> > this on 3.9-rc3 before but need to double-check. Any idea?
> >=20
> > =C3=9D 1113.795759=C2=A8 ------------=C3=9D cut here =C2=A8--------=
----
> > =C3=9D 1113.795771=C2=A8 kernel BUG at fs/ext4/inode.c:1591!
>=20
> thanks for the report.  What kernel version did this come from?  Was
> it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).
>=20
> If it is indeed 3.9-rc4, it would be helpful, since you can reproduce
> the problem, to insert a debugging printk which fires when
> bh->b_blocknr !=3D pblock before the BUG_ON, and have it print the
> b_blocknr and pblock values.
I've triggered this bug on before at the time i've worked on
e4defrag functionality, but AFAIK all related issues was aready fixed
and 013 has nothing with e4defrag.
But still bh->b_blocknr under us. So other obvious place I suspect is
puch_hole but this also not true because 013 use fsstress
test in vegetarian mode: "-f rmdir=3D10 -f link=3D10 -f creat=3D10 -f m=
kdir=3D10
-f rename=3D30 -f stat=3D30 -f unlink=3D30 -f truncate=3D20"
So the only place I suspect is some unknown bug in extent status tree
Can you please enable ES_AGGRESSIVE_TEST and rerun xfstest.
>=20
> Thanks,
>=20
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
