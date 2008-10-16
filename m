From: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: Possible ext3 corruption with 1K block size
Date: Thu, 16 Oct 2008 16:40:44 +0200
Message-ID: <1224168044.11578.15.camel@plop>
References: <200810150724.42180.arvidjaar@mail.ru>
	 <48F5E6D4.8080603@redhat.com> <200810151824.36119.arvidjaar@mail.ru>
	 <48F601A5.1050405@redhat.com> <1224164860.11578.14.camel@plop>
	 <48F751E9.8070705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, pterjan@mandriva.org,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756498AbYJPOlC@vger.kernel.org>
In-Reply-To: <48F751E9.8070705@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Le jeudi 16 octobre 2008 =E0 09:38 -0500, Eric Sandeen a =E9crit :
> Pascal Terjan wrote:
> > Le mercredi 15 octobre 2008 =E0 09:43 -0500, Eric Sandeen a =E9crit=
 :
> >> Andrey Borzenkov wrote:
> >>> On Wednesday 15 October 2008, Eric Sandeen wrote:
> >>
> >>>> My kingdom for a testcase... does anyone have simple steps to re=
produce
> >>>> this?  Or do they all start with "install mandriva on a 1k block=
 size
> >>>> system?"  :)
> >>>>
> >>> May be RH will do? :)
> >> I did try a 1k-block root fs Fedora install, and didn't see any pr=
oblems...
> >>
> >>> As indicated by last comment, Pascal has some ways to trigger it;=
 I
> >>> forgot to Cc to him initially; doing it now.
> >> Ok, good deal.
> >>
> >=20
> > On my test machine I reproduce it easily : rpm --rebuilddb and if t=
he db
> > is not detected to be corrupted yet it will be after installing a f=
ew
> > packages (tested again with 2.6.27).
> >=20
> > If I do the rebuilddb on a 2.6.17 and then reboot on a recent kerne=
l,
> > then I can install/uninstall thousands of packages without any
> > corruption.
>=20
> so it seems to be the database rebuilding, under a recent kernel, whi=
ch
> causes the problem?  installing under a recent kernel is ok, as long =
as
> the db was created on an older kernel?

Yes
