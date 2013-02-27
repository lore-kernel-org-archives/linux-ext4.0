From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Wed, 27 Feb 2013 18:45:53 +0100
Message-ID: <20130227174553.GA224@x4>
References: <nsxr4k2kdwv.fsf@closure.thunk.org>
 <20130227124727.GA225@x4>
 <20130227153435.GB5609@thunk.org>
 <20130227154450.GA23402@x4>
 <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013.02.28 at 01:38 +0800, gnehzuil.liu wrote:
> =E5=9C=A8 2013-2-28=EF=BC=8C=E4=B8=8A=E5=8D=881:22=EF=BC=8CMarkus Tri=
ppelsdorf <markus@trippelsdorf.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> > On 2013.02.28 at 01:10 +0800, gnehzuil.liu wrote:
> >> =E5=9C=A8 2013-2-28=EF=BC=8C=E4=B8=8A=E5=8D=881:01=EF=BC=8CMarkus =
Trippelsdorf <markus@trippelsdorf.de> =E5=86=99=E9=81=93=EF=BC=9A
> >>=20
> >>> On 2013.02.27 at 16:44 +0100, Markus Trippelsdorf wrote:
> >>>> On 2013.02.27 at 10:34 -0500, Theodore Ts'o wrote:
> >>>>> On Wed, Feb 27, 2013 at 01:47:27PM +0100, Markus Trippelsdorf w=
rote:
> >>>>>> Just booted todays Linux tree and got the following errors:
> >>>>>>=20
> >>>>>> ...
> >>>>>> Feb 27 13:33:31 x4 kernel: EXT4-fs (sda): mounted filesystem w=
ith ordered data mode. Opts: (null)
> >>>>>> ...
> >>>>>> Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_fi=
nd_dest_de:1657: inode #70647809: block 14164000: comm cupsd: bad entry=
 in directory: rec_len % 4 !=3D 0 - offset=3D0(0), inode=3D2569822761, =
rec_len=3D3837, name_len=3D1
> >>>>>> Feb 27 13:33:32 x4 kernel: EXT4-fs error (device sda): ext4_fi=
nd_dest_de:1657: ignore#70911401: block 15213579: comm pdnsd: bad entry=
 in directory: rec_len % 4 !=3D 0 - offset=3D0(0), inode=3D2000846358, =
rec_len=3D36782, name_len=3D120
> >>>>>=20
> >>>>> Is this reproducible?=20
> >>>=20
> >>> The issue is caused by:
> >>>=20
> >>> commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
> >>> Author: Zheng Liu <wenqing.lz@taobao.com>
> >>> Date:   Mon Feb 18 00:29:59 2013 -0500
> >>>=20
> >>>   ext4: lookup block mapping in extent status tree
> >>=20
> >> Thanks for the report.  I am very sorry about that.  Now I am tryi=
ng to fix it.
> >>=20
> > Thank you.
> >=20
> > Please note that if I run a kernel build with:=20
> > "git reset --hard f7fec032aa782d3fd7e51fbdf08aa3a296c01500"=20
> > (the commit before d100eef24) I get a different but similar error:
> >=20
> >  EXT4-fs (sda): error count: 4
> >  EXT4-fs (sda): initial error at 1361983458: ext4_find_dest_de:1657=
: inode 70911401: block 15213579=20
> >  EXT4-fs (sda): last error at 1361983663: ext4_find_dest_de:1658: i=
node 70647809: block 14164000
>=20
> Yup, thanks for the note.  Could you please revert to this commit
> a25a4e1a5d5dc0f97dddbca44e695c532d8228c1 (the commit before f7fec032)=
?
> I suspect that commit f7fec032 is the root cause.  Thanks for your
> help.=20

git revert 06b0c886214a223dde7b21cbfc3008fd20a8ce16..74cd15cd02708c7188=
581f279f33a98b2ae8d322
fixes all issues...

--=20
Markus
